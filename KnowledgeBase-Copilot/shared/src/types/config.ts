import type { AiSettings } from './ai-provider.js';

export interface CopilotConfig {
  aiSettings: AiSettings;
  lastKbRoot: string | null;
}
