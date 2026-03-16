import { appendFileSync, mkdirSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const LOG_DIR = resolve(__dirname, '../../logs');
const LOG_FILE = resolve(LOG_DIR, 'copilot.log');

// Ensure log directory exists
try { mkdirSync(LOG_DIR, { recursive: true }); } catch { /* ok */ }

type LogLevel = 'DEBUG' | 'INFO' | 'WARN' | 'ERROR';

function formatTimestamp(): string {
  return new Date().toISOString();
}

function write(level: LogLevel, tag: string, message: string, data?: unknown): void {
  const ts = formatTimestamp();
  const dataStr = data !== undefined ? ` | ${JSON.stringify(data, null, 0)}` : '';
  const line = `[${ts}] ${level} [${tag}] ${message}${dataStr}\n`;

  // Console output (colored)
  const color = level === 'ERROR' ? '\x1b[31m'
    : level === 'WARN' ? '\x1b[33m'
    : level === 'DEBUG' ? '\x1b[90m'
    : '\x1b[36m';
  process.stderr.write(`${color}[${tag}]\x1b[0m ${message}${dataStr ? ` ${dataStr}` : ''}\n`);

  // File output
  try { appendFileSync(LOG_FILE, line); } catch { /* ignore */ }
}

export function createLogger(tag: string) {
  return {
    debug: (msg: string, data?: unknown) => write('DEBUG', tag, msg, data),
    info:  (msg: string, data?: unknown) => write('INFO',  tag, msg, data),
    warn:  (msg: string, data?: unknown) => write('WARN',  tag, msg, data),
    error: (msg: string, data?: unknown) => write('ERROR', tag, msg, data),
  };
}

export const LOG_FILE_PATH = LOG_FILE;
