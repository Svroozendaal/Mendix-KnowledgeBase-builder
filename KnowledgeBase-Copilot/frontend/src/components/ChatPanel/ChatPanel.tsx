import { useConversation } from '../../hooks/useConversation';
import { MessageList } from './MessageList';
import { ChatInput } from './ChatInput';
import type { KBInfo } from '@kb-copilot/shared';
import styles from './ChatPanel.module.css';

interface ChatPanelProps {
  conversationId: string;
  kbInfo: KBInfo;
}

export function ChatPanel({ conversationId, kbInfo }: ChatPanelProps) {
  const { messages, isStreaming, connected, sendMessage, cancel } =
    useConversation(conversationId);

  return (
    <div className={styles.panel}>
      <div className={styles.header}>
        <span className={styles.appName}>{kbInfo.appName}</span>
        <span className={`${styles.status} ${connected ? styles.connected : styles.disconnected}`}>
          {connected ? 'Connected' : 'Reconnecting...'}
        </span>
      </div>
      <MessageList messages={messages} isStreaming={isStreaming} />
      <ChatInput
        onSend={sendMessage}
        onCancel={cancel}
        isStreaming={isStreaming}
        disabled={!connected}
      />
    </div>
  );
}
