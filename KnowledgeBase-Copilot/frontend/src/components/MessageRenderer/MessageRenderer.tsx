import Markdown from 'react-markdown';
import remarkGfm from 'remark-gfm';
import type { Role } from '@kb-copilot/shared';
import styles from './MessageRenderer.module.css';

interface MessageRendererProps {
  role: Role;
  text: string;
}

export function MessageRenderer({ role, text }: MessageRendererProps) {
  if (role === 'user') {
    return (
      <div className={styles.userBubble}>
        <p>{text}</p>
      </div>
    );
  }

  return (
    <div className={styles.assistantBubble}>
      <Markdown
        remarkPlugins={[remarkGfm]}
        components={{
          code({ className, children, ...props }) {
            const match = /language-(\w+)/.exec(className ?? '');
            const isBlock = String(children).includes('\n');
            if (isBlock || match) {
              return (
                <pre className={styles.codeBlock}>
                  <code className={className} {...props}>{children}</code>
                </pre>
              );
            }
            return <code className={styles.inlineCode} {...props}>{children}</code>;
          },
        }}
      >
        {text}
      </Markdown>
    </div>
  );
}
