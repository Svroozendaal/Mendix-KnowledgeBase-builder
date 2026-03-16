export class ProviderError extends Error {
  readonly code: number;
  constructor(message: string, code = 1) {
    super(message);
    this.name = 'ProviderError';
    this.code = code;
  }
}

export class CliNotFoundError extends ProviderError {
  constructor(cli: string) {
    super(`${cli} CLI not found. Ensure it is installed and available on PATH.`, 2);
    this.name = 'CliNotFoundError';
  }
}

export class AuthenticationError extends ProviderError {
  constructor(provider: string) {
    super(`Authentication failed for ${provider}. Check your credentials.`, 3);
    this.name = 'AuthenticationError';
  }
}

