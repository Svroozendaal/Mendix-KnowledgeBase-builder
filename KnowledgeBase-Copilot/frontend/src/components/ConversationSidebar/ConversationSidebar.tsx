import { useApp } from '../../context/AppContext';
import styles from './ConversationSidebar.module.css';

interface ConversationSidebarProps {
  onClose?: () => void;
}

export function ConversationSidebar({ onClose }: ConversationSidebarProps) {
  const {
    conversations,
    currentConversation,
    createConversation,
    deleteConversation,
    selectConversation,
  } = useApp();

  const handleNew = async () => {
    await createConversation();
    onClose?.();
  };

  const handleSelect = async (id: string) => {
    await selectConversation(id);
    onClose?.();
  };

  const handleDelete = async (e: React.MouseEvent, id: string) => {
    e.stopPropagation();
    if (confirm('Delete this conversation?')) {
      await deleteConversation(id);
    }
  };

  return (
    <div className={styles.sidebar}>
      <button className={styles.newBtn} onClick={handleNew}>
        + New conversation
      </button>
      <div className={styles.list}>
        {conversations.map((c) => (
          <button
            key={c.id}
            className={`${styles.item} ${currentConversation?.id === c.id ? styles.active : ''}`}
            onClick={() => handleSelect(c.id)}
          >
            <div className={styles.itemTitle}>{c.title}</div>
            <div className={styles.itemMeta}>
              {c.messageCount} messages &middot; {new Date(c.updatedAt).toLocaleDateString()}
            </div>
            <button
              className={styles.deleteBtn}
              onClick={(e) => handleDelete(e, c.id)}
              title="Delete"
            >
              &times;
            </button>
          </button>
        ))}
        {conversations.length === 0 && (
          <p className={styles.empty}>No conversations yet.</p>
        )}
      </div>
    </div>
  );
}
