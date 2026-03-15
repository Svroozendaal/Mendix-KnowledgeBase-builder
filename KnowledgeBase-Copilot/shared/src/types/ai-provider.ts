export enum AiProvider {
  ClaudeCli = 'ClaudeCli',
  CodexCli = 'CodexCli',
  ClaudeApi = 'ClaudeApi',
}

export interface AiSettings {
  provider: AiProvider;
  claudeCliPath: string | null;
  codexCliPath: string | null;
  claudeApiKey: string | null;
  claudeApiModel: string | null;
}
