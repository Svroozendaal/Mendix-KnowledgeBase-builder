import type { Request, Response, NextFunction } from 'express';
import { PathTraversalError } from '../services/kb-navigator/path-sandbox.js';
import { FileNotFoundError } from '../services/kb-navigator/index.js';

export class ValidationError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'ValidationError';
  }
}

export function errorHandler(
  err: Error,
  _req: Request,
  res: Response,
  _next: NextFunction,
): void {
  console.error(`[Error] ${err.name}: ${err.message}`);

  if (err instanceof FileNotFoundError) {
    res.status(404).json({ error: err.message });
    return;
  }

  if (err instanceof PathTraversalError) {
    res.status(403).json({ error: err.message });
    return;
  }

  if (err instanceof ValidationError) {
    res.status(400).json({ error: err.message });
    return;
  }

  res.status(500).json({ error: 'Internal server error.' });
}
