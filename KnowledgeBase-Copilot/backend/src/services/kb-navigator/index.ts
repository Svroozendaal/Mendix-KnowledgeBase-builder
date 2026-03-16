import { readFile as fsReadFile, readdir, stat } from 'node:fs/promises';
import { join, relative, extname } from 'node:path';
import type { KBFileEntry, KBSearchResult } from '@kb-copilot/shared';
import { validatePath, PathTraversalError } from './path-sandbox.js';

export { PathTraversalError } from './path-sandbox.js';

export class FileNotFoundError extends Error {
  constructor(relativePath: string) {
    super(`File not found: ${relativePath}`);
    this.name = 'FileNotFoundError';
  }
}

const MAX_FILE_LENGTH = 5_000;
const MAX_SEARCH_RESULTS = 20;

export class KBNavigator {
  async readFile(kbRoot: string, relativePath: string): Promise<string> {
    const absPath = await validatePath(kbRoot, relativePath);

    let content: string;
    try {
      content = await fsReadFile(absPath, 'utf-8');
    } catch (err) {
      if ((err as NodeJS.ErrnoException).code === 'ENOENT') {
        throw new FileNotFoundError(relativePath);
      }
      throw err;
    }

    if (content.length > MAX_FILE_LENGTH) {
      return content.slice(0, MAX_FILE_LENGTH) + '\n\n[truncated — use search_content to find specific sections]';
    }
    return content;
  }

  async listFiles(kbRoot: string, relativePath?: string): Promise<KBFileEntry[]> {
    const dirPath = relativePath
      ? await validatePath(kbRoot, relativePath)
      : kbRoot;

    const entries = await readdir(dirPath, { withFileTypes: true });

    const result: KBFileEntry[] = [];
    for (const entry of entries) {
      const entryPath = join(dirPath, entry.name);
      const relPath = relative(kbRoot, entryPath).replace(/\\/g, '/');
      let size = 0;
      try {
        const s = await stat(entryPath);
        size = s.size;
      } catch { /* ignore */ }

      result.push({
        name: entry.name,
        path: relPath,
        type: entry.isDirectory() ? 'directory' : 'file',
        size,
      });
    }

    // Sort: directories first, then files, alphabetically
    result.sort((a, b) => {
      if (a.type !== b.type) return a.type === 'directory' ? -1 : 1;
      return a.name.localeCompare(b.name);
    });

    return result;
  }

  async searchContent(kbRoot: string, query: string, relativePath?: string): Promise<KBSearchResult[]> {
    const searchRoot = relativePath
      ? await validatePath(kbRoot, relativePath)
      : kbRoot;

    const results: KBSearchResult[] = [];
    const lowerQuery = query.toLowerCase();

    await this.searchRecursive(kbRoot, searchRoot, lowerQuery, results);

    return results.slice(0, MAX_SEARCH_RESULTS);
  }

  private async searchRecursive(
    kbRoot: string,
    dir: string,
    lowerQuery: string,
    results: KBSearchResult[],
  ): Promise<void> {
    if (results.length >= MAX_SEARCH_RESULTS) return;

    const entries = await readdir(dir, { withFileTypes: true });

    for (const entry of entries) {
      if (results.length >= MAX_SEARCH_RESULTS) return;

      const fullPath = join(dir, entry.name);

      if (entry.isDirectory()) {
        // Skip hidden directories and node_modules
        if (entry.name.startsWith('.') || entry.name === 'node_modules') continue;
        await this.searchRecursive(kbRoot, fullPath, lowerQuery, results);
      } else if (entry.isFile() && extname(entry.name) === '.md') {
        try {
          const content = await fsReadFile(fullPath, 'utf-8');
          const lines = content.split('\n');

          for (let i = 0; i < lines.length; i++) {
            if (results.length >= MAX_SEARCH_RESULTS) return;

            if (lines[i].toLowerCase().includes(lowerQuery)) {
              results.push({
                file: relative(kbRoot, fullPath).replace(/\\/g, '/'),
                lineNumber: i + 1,
                content: lines[i].trim(),
              });
            }
          }
        } catch {
          // Skip unreadable files
        }
      }
    }
  }
}
