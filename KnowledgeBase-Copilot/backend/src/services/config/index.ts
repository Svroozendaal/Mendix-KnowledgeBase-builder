import { readFile, writeFile, mkdir } from 'node:fs/promises';
import { join, dirname } from 'node:path';
import { AiProvider } from '@kb-copilot/shared';
import type { CopilotConfig } from '@kb-copilot/shared';

const CONFIG_PATH = join(process.cwd(), 'copilot-config.json');

const DEFAULT_CONFIG: CopilotConfig = {
  aiSettings: {
    provider: AiProvider.ClaudeCli,
    claudeCliPath: null,
    codexCliPath: null,
  },
  lastKbRoot: null,
};

export class ConfigService {
  async loadConfig(): Promise<CopilotConfig> {
    try {
      const raw = await readFile(CONFIG_PATH, 'utf-8');
      return { ...DEFAULT_CONFIG, ...JSON.parse(raw) };
    } catch {
      return { ...DEFAULT_CONFIG };
    }
  }

  async saveConfig(config: CopilotConfig): Promise<void> {
    await mkdir(dirname(CONFIG_PATH), { recursive: true });
    await writeFile(CONFIG_PATH, JSON.stringify(config, null, 2), 'utf-8');
  }
}
