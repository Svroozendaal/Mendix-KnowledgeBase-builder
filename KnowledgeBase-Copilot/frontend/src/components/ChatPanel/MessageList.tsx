import { useRef, useEffect, useCallback } from 'react';
import type { Message } from '@kb-copilot/shared';
import { MessageRenderer } from '../MessageRenderer/MessageRenderer';
import { ToolCallRenderer } from '../ToolCallRenderer/ToolCallRenderer';
import styles from './MessageList.module.css';

interface MessageListProps {
  messages: Message[];
  isStreaming: boolean;
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

  return (
    <div className={styles.container} ref={containerRef} onScroll={handleScroll}>
      {messages.map((msg) => (
        <div key={msg.id} className={styles.message}>
          {msg.content.map((block, i) => {
            if (block.type === 'text') {
              return (
                <MessageRenderer
                  key={`${msg.id}-${i}`}
                  role={msg.role}
                  text={block.text}
                />
              );
            }
            if (block.type === 'tool_use') {
              return (
                <ToolCallRenderer
                  key={`${msg.id}-${i}`}
                  name={block.toolCall.name}
                  args={block.toolCall.arguments}
                  state="loading"
                />
              );
            }
            if (block.type === 'tool_result') {
              return (
                <ToolCallRenderer
                  key={`${msg.id}-${i}`}
                  name=""
                  args={{}}
                  state={block.toolResult.isError ? 'error' : 'done'}
                  result={block.toolResult.content}
                />
              );
            }
            return null;
          })}
        </div>
      ))}
      {isStreaming && <div className={styles.typing}>Thinking...</div>}
    </div>
  );
}
