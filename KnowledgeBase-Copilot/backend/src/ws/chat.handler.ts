import { WebSocketServer, WebSocket } from 'ws';
import type { Server } from 'node:http';
import type { WSClientMessage, WSServerEvent } from '@kb-copilot/shared';
import { ConversationService } from '../services/conversation/index.js';
import { ConversationStore } from '../services/conversation-store/index.js';
import { ConfigService } from '../services/config/index.js';
import { CliNotFoundError, AuthenticationError, ApiError } from '../services/ai-provider/index.js';

const conversationService = new ConversationService();
const conversationStore = new ConversationStore();
const configService = new ConfigService();

export function setupWebSocket(server: Server): void {
  const wss = new WebSocketServer({ server, path: '/ws' });

  wss.on('connection', (ws) => {
    let abortController: AbortController | null = null;

    ws.on('message', async (raw) => {
      let msg: WSClientMessage;
      try {
        msg = JSON.parse(raw.toString()) as WSClientMessage;
      } catch {
        sendEvent(ws, { type: 'error', message: 'Invalid message format.' });
        return;
      }

      if (msg.type === 'cancel') {
        if (abortController) {
          abortController.abort();
          abortController = null;
        }
        return;
      }

      if (msg.type === 'message') {
        abortController = new AbortController();

        try {
          const config = await configService.loadConfig();
          const conversation = await conversationStore.loadConversation(msg.conversationId);

          const kbRoot = conversation.kbRoot || config.lastKbRoot || '';
          if (!kbRoot) {
            sendEvent(ws, { type: 'error', message: 'No knowledge base configured.', code: 'NO_KB' });
            sendEvent(ws, { type: 'done', conversationId: msg.conversationId });
            return;
          }

          await conversationService.processMessage(
            config.aiSettings,
            kbRoot,
            conversation,
            msg.content,
            (event) => sendEvent(ws, event),
            abortController.signal,
          );

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
        } catch (err) {
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
  if (err instanceof ApiError) {
    return { type: 'error', message: err.message, code: 'API_ERROR' };
  }
  if (err instanceof Error && err.name === 'AbortError') {
    return { type: 'done', conversationId };
  }
  console.error('[WS Error]', err);
  return { type: 'error', message: 'An unexpected error occurred.' };
}
