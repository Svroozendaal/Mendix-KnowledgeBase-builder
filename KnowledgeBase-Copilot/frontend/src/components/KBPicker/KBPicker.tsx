import { useState } from 'react';
import { useApp } from '../../context/AppContext';
import styles from './KBPicker.module.css';

interface KBPickerProps {
  onClose: () => void;
}

export function KBPicker({ onClose }: KBPickerProps) {
  const { kbInfo, setKbRoot, config } = useApp();
  const [path, setPath] = useState(kbInfo?.kbRoot ?? config?.lastKbRoot ?? '');
  const [status, setStatus] = useState<'idle' | 'valid' | 'invalid'>('idle');
  const [errorMsg, setErrorMsg] = useState('');
  const [validating, setValidating] = useState(false);

  const handleValidate = async () => {
    if (!path.trim()) return;
    setValidating(true);
    setStatus('idle');
    const result = await setKbRoot(path.trim());
    if (result.valid) {
      setStatus('valid');
      setErrorMsg('');
    } else {
      setStatus('invalid');
      setErrorMsg(result.error ?? 'Invalid knowledge base.');
    }
    setValidating(false);
  };

  return (
    <div className={styles.overlay} onClick={onClose}>
      <div className={styles.modal} onClick={(e) => e.stopPropagation()}>
        <h2 className={styles.title}>Knowledge Base</h2>

        <label className={styles.label}>
          KB Folder Path
          <input
            type="text"
            className={styles.input}
            value={path}
            onChange={(e) => setPath(e.target.value)}
            placeholder="C:/path/to/knowledge-base"
          />
        </label>

        <button className={styles.validateBtn} onClick={handleValidate} disabled={validating}>
          {validating ? 'Validating...' : 'Validate'}
        </button>

        {status === 'valid' && kbInfo && (
          <div className={styles.info}>
            <span className={styles.valid}>Valid</span>
            <p><strong>App:</strong> {kbInfo.appName}</p>
            <p><strong>Modules:</strong> {kbInfo.moduleCount}</p>
            <p><strong>READER.md:</strong> {kbInfo.hasReader ? 'Yes' : 'No'}</p>
            <p><strong>ROUTING.md:</strong> {kbInfo.hasRouting ? 'Yes' : 'No'}</p>
          </div>
        )}

        {status === 'invalid' && (
          <div className={styles.info}>
            <span className={styles.invalid}>Invalid</span>
            <p>{errorMsg}</p>
          </div>
        )}

        {status === 'idle' && (
          <p className={styles.hint}>Enter a path and click Validate.</p>
        )}

        <div className={styles.actions}>
          <button className={styles.closeBtn} onClick={onClose}>Close</button>
        </div>
      </div>
    </div>
  );
}
