import { useRef, useEffect, useCallback } from 'react';
import type { Message, MessageContent } from '@kb-copilot/shared';
import { MessageRenderer } from '../MessageRenderer/MessageRenderer';
import { ToolCallRenderer } from '../ToolCallRenderer/ToolCallRenderer';
import styles from './MessageList.module.css';

interface MessageListProps {
  messages: Message[];
  isStreaming: boolean;
}

/**
 * Pair tool_use blocks with their tool_result blocks.
 * Within a single message's content array, a tool_result follows its tool_use.
 * We also look at the next message (tool-result-only user message) for results.
 */
function pairToolBlocks(
  content: MessageContent[],
  allMessages: Message[],
  messageIndex: number,
): Array<{ type: 'text'; text: string } | { type: 'tool'; name: string; args: Record<string, unknown>; result?: string; isError: boolean; state: 'loading' | 'done' | 'error' }> {
  const paired: ReturnType<typeof pairToolBlocks> = [];

  // Collect all tool results from this message and the next user-role tool-result message
  const resultMap = new Map<string, { content: string; isError: boolean }>();
  for (const block of content) {
    if (block.type === 'tool_result') {
      resultMap.set(block.toolResult.toolCallId, {
        content: block.toolResult.content,
        isError: block.toolResult.isError,
      });
    }
  }
  // Check next message for tool results
  const nextMsg = allMessages[messageIndex + 1];
  if (nextMsg?.role === 'user') {
    for (const block of nextMsg.content) {
      if (block.type === 'tool_result') {
        resultMap.set(block.toolResult.toolCallId, {
          content: block.toolResult.content,
          isError: block.toolResult.isError,
        });
      }
    }
  }

  for (const block of content) {
    if (block.type === 'text') {
      if (block.text.trim()) {
        paired.push({ type: 'text', text: block.text });
      }
    } else if (block.type === 'tool_use') {
      const result = resultMap.get(block.toolCall.id);
      paired.push({
        type: 'tool',
        name: block.toolCall.name,
        args: block.toolCall.arguments,
        result: result?.content,
        isError: result?.isError ?? false,
        state: result ? (result.isError ? 'error' : 'done') : 'loading',
      });
    }
    // Skip standalone tool_result blocks — they're rendered via pairing above
  }

  return paired;
}

export function MessageList({ messages, isStreaming }: MessageListProps) {
  const containerRef = useRef<HTMLDivElement>(null);
  const shouldAutoScroll = useRef(true);

  const handleScroll = useCallback(() => {
    const el = containerRef.current;
    if (!el) return;
    const atBottom = el.scrollHeight - el.scrollTop - el.clientHeight < 50;
    shouldAutoScroll.current = atBottom;
  }, []);

  useEffect(() => {
    const el = containerRef.current;
    if (el && shouldAutoScroll.current) {
      el.scrollTop = el.scrollHeight;
    }
  }, [messages]);

  if (messages.length === 0) {
    return (
      <div className={styles.container} ref={containerRef}>
        <div className={styles.empty}>
          Ask a question about your Mendix application...
        </div>
      </div>
    );
  }

  // Filter out user-role messages that only contain tool_result blocks
  const visibleMessages = messages.filter((m) => {
    if (m.role === 'user' && m.content.every((b) => b.type === 'tool_result')) {
      return false;
    }
    return true;
  });

  return (
    <div className={styles.container} ref={containerRef} onScroll={handleScroll}>
      {visibleMessages.map((msg, msgIdx) => {
        // Find original index in full messages array for tool pairing
        const originalIdx = messages.indexOf(msg);

        if (msg.role === 'user') {
          const text = msg.content
            .filter((b) => b.type === 'text')
            .map((b) => (b as { type: 'text'; text: string }).text)
            .join('\n');
          return (
            <div key={msg.id} className={styles.message}>
              <MessageRenderer role="user" text={text} />
            </div>
          );
        }

        // Assistant message — pair tool blocks
        const paired = pairToolBlocks(msg.content, messages, originalIdx);

        return (
          <div key={msg.id} className={styles.message}>
            {paired.map((block, i) => {
              if (block.type === 'text') {
                return (
                  <MessageRenderer
                    key={`${msg.id}-${i}`}
                    role="assistant"
                    text={block.text}
                  />
                );
              }
              return (
                <ToolCallRenderer
                  key={`${msg.id}-${i}`}
                  name={block.name}
                  args={block.args}
                  state={block.state}
                  result={block.result}
                />
              );
            })}
          </div>
        );
      })}
      {isStreaming && <div className={styles.typing}>Thinking...</div>}
    </div>
  );
}
