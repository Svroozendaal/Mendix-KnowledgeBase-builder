import { execSync } from 'node:child_process';
import { existsSync } from 'node:fs';
import { join } from 'node:path';

const isWindows = process.platform === 'win32';

function whichCommand(name: string): string | null {
  try {
    const cmd = isWindows ? `where ${name}` : `which ${name}`;
    const result = execSync(cmd, { encoding: 'utf-8', timeout: 5000 }).trim();
    // `where` on Windows may return multiple lines — take the first
    const firstLine = result.split(/\r?\n/)[0]?.trim();
    if (firstLine && existsSync(firstLine)) {
      return firstLine;
    }
  } catch {
    // not found on PATH
  }
  return null;
}

export function resolveClaudeCliPath(explicitPath?: string | null): string | null {
  // 1. Explicit path from config
  if (explicitPath) {
    const trimmed = explicitPath.trim().replace(/^"|"$/g, '');
    if (existsSync(trimmed)) return trimmed;
  }

  // 2. PATH lookup
  const onPath = whichCommand('claude');
  if (onPath) return onPath;

  // 3. Common locations (Windows)
  if (isWindows) {
    const localAppData = process.env.LOCALAPPDATA ?? '';
    const appData = process.env.APPDATA ?? '';
    const candidates = [
      join(localAppData, 'Programs', 'claude', 'claude.exe'),
      join(appData, 'npm', 'claude.cmd'),
      join(localAppData, 'Microsoft', 'WinGet', 'Links', 'claude.exe'),
    ];
    for (const c of candidates) {
      if (c && existsSync(c)) return c;
    }
  }

  return null;
}

export function resolveCodexCliPath(explicitPath?: string | null): string | null {
  // 1. Explicit path from config
  if (explicitPath) {
    const trimmed = explicitPath.trim().replace(/^"|"$/g, '');
    if (existsSync(trimmed)) return trimmed;
  }

  // 2. PATH lookup
  const onPath = whichCommand('codex');
  if (onPath) return onPath;

  // 3. Common locations (Windows)
  if (isWindows) {
    const appData = process.env.APPDATA ?? '';
    const candidates = [
      join(appData, 'npm', 'codex.cmd'),
    ];
    for (const c of candidates) {
      if (c && existsSync(c)) return c;
    }
  }

  return null;
}
