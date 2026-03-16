import { useState, useEffect, useCallback, useRef } from 'react';
import type { Message, WSServerEvent } from '@kb-copilot/shared';
import { useWebSocket } from './useWebSocket';
import * as api from '../services/api';

const WS_URL = `ws://${window.location.host}/ws`;

export function useConversation(conversationId: string | null) {
  const [messages, setMessages] = useState<Message[]>([]);
  const [isStreaming, setIsStreaming] = useState(false);
  const { connected, sendMessage: wsSend, cancel: wsCancel, onEvent } = useWebSocket(WS_URL);
  const streamingMsgRef = useRef<Message | null>(null);

  // Load messages when conversation changes
  useEffect(() => {
    if (!conversationId) {
      setMessages([]);
      return;
    }
    api.getConversation(conversationId)
      .then((conv) => setMessages(conv.messages))
      .catch(console.error);
  }, [conversationId]);

  // Handle incoming events
  useEffect(() => {
    onEvent((event: WSServerEvent) => {
      switch (event.type) {
        case 'text_delta': {
          setMessages((prev) => {
            const updated = [...prev];
            const last = updated[updated.length - 1];
            if (last?.role === 'assistant') {
              const lastContent = last.content[last.content.length - 1];
              if (lastContent?.type === 'text') {
                lastContent.text += event.content;
              } else {
                last.content.push({ type: 'text', text: event.content });
              }
              return [...updated];
            }
            // New assistant message
            const msg: Message = {
              id: crypto.randomUUID(),
              role: 'assistant',
              content: [{ type: 'text', text: event.content }],
              timestamp: new Date().toISOString(),
            };
            streamingMsgRef.current = msg;
            return [...updated, msg];
          });
          break;
        }

        case 'tool_call': {
          setMessages((prev) => {
            const updated = [...prev];
            const last = updated[updated.length - 1];
            if (last?.role === 'assistant') {
              last.content.push({
                type: 'tool_use',
                toolCall: {
                  id: event.id,
                  name: event.name,
                  arguments: event.arguments,
                },
              });
              return [...updated];
            }
            return updated;
          });
          break;
        }

        case 'tool_result': {
          setMessages((prev) => {
            const updated = [...prev];
            // Add tool result as a separate entry for display
            const last = updated[updated.length - 1];
            if (last?.role === 'assistant') {
              last.content.push({
                type: 'tool_result',
                toolResult: {
                  toolCallId: event.toolCallId,
                  content: event.content,
                  isError: event.isError,
                },
              });
              return [...updated];
            }
            return updated;
          });
          break;
        }

        case 'done': {
          setIsStreaming(false);
          streamingMsgRef.current = null;
          // Reload from server, but filter out internal tool-result-only messages
          if (conversationId) {
            api.getConversation(conversationId)
              .then((conv) => {
                const filtered = conv.messages.filter((m) => {
                  // Keep all assistant and genuine user messages
                  // Skip user-role messages that only contain tool_result blocks
                  // (these are internal API round-trips, not user input)
                  if (m.role === 'user' && m.content.every((b) => b.type === 'tool_result')) {
                    return false;
                  }
                  return true;
                });
                setMessages(filtered);
              })
              .catch(console.error);
          }
          break;
        }

        case 'rate_limit': {
          // Show rate-limit notice — backend is auto-retrying, keep streaming
          setMessages((prev) => {
            const updated = [...prev];
            const last = updated[updated.length - 1];
            if (last?.role === 'assistant') {
              // Append to current assistant message
              last.content.push({ type: 'text', text: `\n\n_${event.message}_\n\n` });
              return [...updated];
            }
            // No assistant message yet — create one
            return [
              ...updated,
              {
                id: crypto.randomUUID(),
                role: 'assistant',
                content: [{ type: 'text', text: `_${event.message}_` }],
                timestamp: new Date().toISOString(),
              },
            ];
          });
          break;
        }

        case 'error': {
          setMessages((prev) => [
            ...prev,
            {
              id: crypto.randomUUID(),
              role: 'assistant',
              content: [{ type: 'text', text: `**Error:** ${event.message}` }],
              timestamp: new Date().toISOString(),
            },
          ]);
          break;
        }
      }
    });
  }, [onEvent, conversationId]);

  const sendMessage = useCallback(
    (content: string) => {
      if (!conversationId || !content.trim()) return;

      // Optimistically add user message
      const userMsg: Message = {
        id: crypto.randomUUID(),
        role: 'user',
        content: [{ type: 'text', text: content }],
        timestamp: new Date().toISOString(),
      };
      setMessages((prev) => [...prev, userMsg]);
      setIsStreaming(true);

      wsSend({
        type: 'message',
        conversationId,
        content,
      });
    },
    [conversationId, wsSend],
  );

  const cancel = useCallback(() => {
    wsCancel();
    setIsStreaming(false);
  }, [wsCancel]);

  return { messages, isStreaming, connected, sendMessage, cancel };
}
