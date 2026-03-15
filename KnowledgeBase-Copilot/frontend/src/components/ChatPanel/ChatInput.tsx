import { useState, useRef, useCallback, type KeyboardEvent } from 'react';
import styles from './ChatInput.module.css';

interface ChatInputProps {
  onSend: (content: string) => void;
  onCancel: () => void;
  isStreaming: boolean;
  disabled: boolean;
}

export function ChatInput({ onSend, onCancel, isStreaming, disabled }: ChatInputProps) {
  const [text, setText] = useState('');
  const textareaRef = useRef<HTMLTextAreaElement>(null);

  const handleSend = useCallback(() => {
    const trimmed = text.trim();
    if (!trimmed) return;
    onSend(trimmed);
    setText('');
    if (textareaRef.current) {
      textareaRef.current.style.height = 'auto';
    }
  }, [text, onSend]);

  const handleKeyDown = useCallback(
    (e: KeyboardEvent<HTMLTextAreaElement>) => {
      if (e.key === 'Enter' && !e.shiftKey) {
        e.preventDefault();
        handleSend();
      }
    },
    [handleSend],
  );

  const handleInput = useCallback(() => {
    const el = textareaRef.current;
    if (!el) return;
    el.style.height = 'auto';
    el.style.height = `${Math.min(el.scrollHeight, 150)}px`;
  }, []);

  return (
    <div className={styles.inputBar}>
      <textarea
        ref={textareaRef}
        className={styles.textarea}
        value={text}
        onChange={(e) => setText(e.target.value)}
        onKeyDown={handleKeyDown}
        onInput={handleInput}
        placeholder="Ask about your Mendix application..."
        disabled={disabled || isStreaming}
        rows={1}
      />
      {isStreaming ? (
        <button className={styles.stopBtn} onClick={onCancel}>
          Stop
        </button>
      ) : (
        <button
          className={styles.sendBtn}
          onClick={handleSend}
          disabled={disabled || !text.trim()}
        >
          Send
        </button>
      )}
    </div>
  );
}
