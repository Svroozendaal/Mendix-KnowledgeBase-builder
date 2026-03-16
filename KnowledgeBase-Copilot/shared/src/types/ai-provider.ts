export enum AiProvider {
  ClaudeCli = 'ClaudeCli',
  CodexCli = 'CodexCli',
}

export interface AiSettings {
  provider: AiProvider;
  claudeCliPath: string | null;
  codexCliPath: string | null;
}
