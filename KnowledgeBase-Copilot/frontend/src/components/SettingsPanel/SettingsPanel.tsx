import { useState, useEffect } from 'react';
import { AiProvider } from '@kb-copilot/shared';
import type { CopilotConfig } from '@kb-copilot/shared';
import { useApp } from '../../context/AppContext';
import * as api from '../../services/api';
import styles from './SettingsPanel.module.css';

interface SettingsPanelProps {
  onClose: () => void;
}

export function SettingsPanel({ onClose }: SettingsPanelProps) {
  const { config, updateConfig } = useApp();
  const [draft, setDraft] = useState<CopilotConfig | null>(null);
  const [testResult, setTestResult] = useState<string | null>(null);
  const [cliStatus, setCliStatus] = useState<string | null>(null);

  useEffect(() => {
    if (config) setDraft({ ...config, aiSettings: { ...config.aiSettings } });
  }, [config]);

  if (!draft) return null;

  const provider = draft.aiSettings.provider;

  const handleSave = async () => {
    await updateConfig(draft);
    onClose();
  };

  const handleTestConnection = async () => {
    setTestResult('Testing...');
    // Save first so the backend uses the new settings
    await updateConfig(draft);
    const result = await api.validateProvider();
    setTestResult(result.valid ? 'Connection successful!' : `Failed: ${result.error}`);
  };

  const handleDetectCli = async (type: 'claude' | 'codex') => {
    setCliStatus('Detecting...');
    const result = await api.detectCli(type);
    if (result.found && result.path) {
      setCliStatus(`Found: ${result.path}`);
      setDraft({
        ...draft,
        aiSettings: {
          ...draft.aiSettings,
          ...(type === 'claude' ? { claudeCliPath: result.path } : { codexCliPath: result.path }),
        },
      });
    } else {
      setCliStatus('Not found');
    }
  };

  return (
    <div className={styles.overlay} onClick={onClose}>
      <div className={styles.modal} onClick={(e) => e.stopPropagation()}>
        <h2 className={styles.title}>Settings</h2>

        <fieldset className={styles.fieldset}>
          <legend>AI Provider</legend>
          {Object.values(AiProvider).map((p) => (
            <label key={p} className={styles.radio}>
              <input
                type="radio"
                name="provider"
                checked={provider === p}
                onChange={() =>
                  setDraft({ ...draft, aiSettings: { ...draft.aiSettings, provider: p } })
                }
              />
              {p === AiProvider.ClaudeCli && 'Claude CLI'}
              {p === AiProvider.CodexCli && 'Codex CLI'}
            </label>
          ))}
        </fieldset>

        {provider === AiProvider.ClaudeCli && (
          <div className={styles.providerPanel}>
            <label className={styles.label}>
              CLI Path
              <input
                type="text"
                className={styles.input}
                value={draft.aiSettings.claudeCliPath ?? ''}
                onChange={(e) =>
                  setDraft({ ...draft, aiSettings: { ...draft.aiSettings, claudeCliPath: e.target.value || null } })
                }
                placeholder="Auto-detect or enter path"
              />
            </label>
            <button className={styles.detectBtn} onClick={() => handleDetectCli('claude')}>
              Auto detect
            </button>
            {cliStatus && <span className={styles.statusText}>{cliStatus}</span>}
          </div>
        )}

        {provider === AiProvider.CodexCli && (
          <div className={styles.providerPanel}>
            <label className={styles.label}>
              CLI Path
              <input
                type="text"
                className={styles.input}
                value={draft.aiSettings.codexCliPath ?? ''}
                onChange={(e) =>
                  setDraft({ ...draft, aiSettings: { ...draft.aiSettings, codexCliPath: e.target.value || null } })
                }
                placeholder="Auto-detect or enter path"
              />
            </label>
            <button className={styles.detectBtn} onClick={() => handleDetectCli('codex')}>
              Auto detect
            </button>
            {cliStatus && <span className={styles.statusText}>{cliStatus}</span>}
          </div>
        )}

        <button className={styles.testBtn} onClick={handleTestConnection}>
          Test connection
        </button>
        {testResult && (
          <span className={`${styles.statusText} ${testResult.startsWith('Failed') ? styles.errorText : ''}`}>
            {testResult}
          </span>
        )}

        <div className={styles.actions}>
          <button className={styles.cancelBtn} onClick={onClose}>Cancel</button>
          <button className={styles.saveBtn} onClick={handleSave}>Save</button>
        </div>
      </div>
    </div>
  );
}
