import { useState } from 'react';
import styles from './ToolCallRenderer.module.css';

interface ToolCallRendererProps {
  name: string;
  args: Record<string, unknown>;
  state: 'loading' | 'done' | 'error';
  result?: string;
}

export function ToolCallRenderer({ name, args, state, result }: ToolCallRendererProps) {
  const [expanded, setExpanded] = useState(state === 'error');

  const primaryArg = String(args.path ?? args.query ?? '');
  const headerText = name
    ? `${name}${primaryArg ? ` \u2014 ${primaryArg}` : ''}`
    : 'Tool result';

  return (
    <div className={`${styles.wrapper} ${state === 'error' ? styles.error : ''}`}>
      <button
        className={styles.header}
        onClick={() => setExpanded(!expanded)}
        type="button"
      >
        <span className={styles.icon}>
          {state === 'loading' ? '\u23F3' : state === 'error' ? '\u274C' : '\u2705'}
        </span>
        <span className={styles.label}>
          {state === 'loading' ? `Reading ${primaryArg}...` : headerText}
        </span>
        <span className={styles.chevron}>{expanded ? '\u25B2' : '\u25BC'}</span>
      </button>
      {expanded && result && (
        <pre className={styles.resultBody}>{result}</pre>
      )}
    </div>
  );
}
