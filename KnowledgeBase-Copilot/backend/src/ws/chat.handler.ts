import { WebSocketServer, WebSocket } from 'ws';
import type { Server } from 'node:http';
import type { WSClientMessage, WSServerEvent } from '@kb-copilot/shared';
import { ConversationService } from '../services/conversation/index.js';
import { ConversationStore } from '../services/conversation-store/index.js';
import { ConfigService } from '../services/config/index.js';
import { CliNotFoundError, AuthenticationError, ProviderError } from '../services/ai-provider/index.js';
import { createLogger } from '../logger.js';

const log = createLogger('WebSocket');

const conversationService = new ConversationService();
const conversationStore = new ConversationStore();
const configService = new ConfigService();

export function setupWebSocket(server: Server): void {
  const wss = new WebSocketServer({ server, path: '/ws' });

  wss.on('connection', (ws) => {
    log.info(`New WebSocket connection established`);
    let abortController: AbortController | null = null;

    ws.on('close', (code, reason) => {
      log.info(`WebSocket connection closed`, { code, reason: reason.toString() });
      // Abort any in-flight request when the client disconnects
      if (abortController) {
        log.warn(`Client disconnected while request was in-flight — aborting`);
        abortController.abort();
        abortController = null;
      }
    });

    ws.on('error', (err) => {
      log.error(`WebSocket error`, { error: err.message });
    });

    ws.on('message', async (raw) => {
      let msg: WSClientMessage;
      try {
        msg = JSON.parse(raw.toString()) as WSClientMessage;
      } catch {
        log.warn(`Received invalid message format`);
        sendEvent(ws, { type: 'error', message: 'Invalid message format.' });
        return;
      }

      log.info(`Received WS message`, { type: msg.type, conversationId: msg.type === 'message' ? msg.conversationId : undefined });

      if (msg.type === 'cancel') {
        if (abortController) {
          log.info(`Cancelling in-flight request`);
          abortController.abort();
          abortController = null;
        }
        return;
      }

      if (msg.type === 'message') {
        abortController = new AbortController();
        const startTime = Date.now();
        let conversation: Awaited<ReturnType<typeof conversationStore.loadConversation>> | null = null;

        try {
          const config = await configService.loadConfig();
          log.debug(`Config loaded`, { provider: config.aiSettings.provider });
          conversation = await conversationStore.loadConversation(msg.conversationId);
          log.debug(`Conversation loaded`, { id: conversation.id, messageCount: conversation.messages.length });

          const kbRoot = conversation.kbRoot || config.lastKbRoot || '';
          if (!kbRoot) {
            log.warn(`No knowledge base configured`);
            sendEvent(ws, { type: 'error', message: 'No knowledge base configured.', code: 'NO_KB' });
            sendEvent(ws, { type: 'done', conversationId: msg.conversationId });
            return;
          }

          log.info(`Starting processMessage`, { kbRoot, provider: config.aiSettings.provider });

          await conversationService.processMessage(
            config.aiSettings,
            kbRoot,
            conversation,
            msg.content,
            (event) => {
              log.debug(`Sending WS event`, { type: event.type });
              sendEvent(ws, event);
            },
            abortController.signal,
          );

          const elapsed = Date.now() - startTime;
          log.info(`processMessage completed in ${elapsed}ms`);

          // Auto-title after first AI response
          if (conversation.title === 'New conversation' && conversation.messages.length >= 2) {
            const firstUserMsg = conversation.messages.find((m) => m.role === 'user');
            if (firstUserMsg) {
              const text = firstUserMsg.content
                .filter((b) => b.type === 'text')
                .map((b) => (b as { type: 'text'; text: string }).text)
                .join(' ');
              const title = text.slice(0, 60) + (text.length > 60 ? '...' : '');
              conversation.title = title;
            }
          }

          await conversationStore.saveConversation(conversation);
          log.info(`Conversation saved`);
        } catch (err) {
          const elapsed = Date.now() - startTime;
          log.error(`processMessage FAILED after ${elapsed}ms`, {
            error: (err as Error).message,
            name: (err as Error).name,
            stack: (err as Error).stack?.split('\n').slice(0, 5).join(' | '),
          });

          // Save conversation even on error so messages are not lost
          if (conversation) {
            try {
              await conversationStore.saveConversation(conversation);
              log.info(`Conversation saved after error`);
            } catch (saveErr) {
              log.error(`Failed to save conversation after error`, { error: (saveErr as Error).message });
            }
          }

          const event = mapErrorToEvent(err, msg.conversationId);
          sendEvent(ws, event);
          sendEvent(ws, { type: 'done', conversationId: msg.conversationId });
        } finally {
          abortController = null;
        }
      }
    });
  });
}

function sendEvent(ws: WebSocket, event: WSServerEvent): void {
  if (ws.readyState === WebSocket.OPEN) {
    ws.send(JSON.stringify(event));
  }
}

function mapErrorToEvent(err: unknown, conversationId: string): WSServerEvent {
  if (err instanceof CliNotFoundError) {
    return { type: 'error', message: err.message, code: 'CLI_NOT_FOUND' };
  }
  if (err instanceof AuthenticationError) {
    return { type: 'error', message: err.message, code: 'AUTH_FAILED' };
  }
  if (err instanceof ProviderError) {
    return { type: 'error', message: err.message, code: 'PROVIDER_ERROR' };
  }
  if (err instanceof Error && err.name === 'AbortError') {
    return { type: 'done', conversationId };
  }
  console.error('[WS Error]', err);
  return { type: 'error', message: 'An unexpected error occurred.' };
}
