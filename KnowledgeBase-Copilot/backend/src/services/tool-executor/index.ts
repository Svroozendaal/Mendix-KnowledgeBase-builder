import type { ToolCall, ToolResult } from '@kb-copilot/shared';
import { KBNavigator, FileNotFoundError, PathTraversalError } from '../kb-navigator/index.js';
import { createLogger } from '../../logger.js';

const log = createLogger('ToolExecutor');

const kbNavigator = new KBNavigator();

export class ToolExecutor {
  async executeTool(kbRoot: string, toolCall: ToolCall): Promise<ToolResult> {
    const startTime = Date.now();
    log.info(`Executing tool: ${toolCall.name}`, { id: toolCall.id, args: toolCall.arguments });
    try {
      const args = toolCall.arguments;

      switch (toolCall.name) {
        case 'read_file': {
          const filePath = String(args.path ?? '');
          const content = await kbNavigator.readFile(kbRoot, filePath);
          log.info(`read_file success`, { path: filePath, contentLength: content.length, elapsed: Date.now() - startTime });
          return { toolCallId: toolCall.id, content, isError: false };
        }

        case 'list_files': {
          const dirPath = String(args.path ?? '');
          const entries = await kbNavigator.listFiles(
            kbRoot,
            dirPath && dirPath !== '/' ? dirPath : undefined,
          );
          const formatted = entries
            .map((e) => {
              const icon = e.type === 'directory' ? '📁' : '📄';
              const size = e.type === 'file' ? ` (${e.size} bytes)` : '';
              return `${icon} ${e.path}${size}`;
            })
            .join('\n');
          log.info(`list_files success`, { path: dirPath, entryCount: entries.length, elapsed: Date.now() - startTime });
          return { toolCallId: toolCall.id, content: formatted || '(empty directory)', isError: false };
        }

        case 'search_content': {
          const query = String(args.query ?? '');
          const searchPath = args.path ? String(args.path) : undefined;
          const results = await kbNavigator.searchContent(kbRoot, query, searchPath);
          log.info(`search_content`, { query, resultCount: results.length, elapsed: Date.now() - startTime });
          if (results.length === 0) {
            return { toolCallId: toolCall.id, content: `No results found for "${query}".`, isError: false };
          }
          const formatted = results
            .map((r) => `${r.file}:${r.lineNumber} — ${r.content}`)
            .join('\n');
          return { toolCallId: toolCall.id, content: formatted, isError: false };
        }

        default:
          log.warn(`Unknown tool: ${toolCall.name}`);
          return {
            toolCallId: toolCall.id,
            content: `Unknown tool: ${toolCall.name}`,
            isError: true,
          };
      }
    } catch (err) {
      let message = 'An error occurred while executing the tool.';
      if (err instanceof FileNotFoundError) {
        message = err.message;
      } else if (err instanceof PathTraversalError) {
        message = err.message;
      }
      log.error(`Tool execution failed: ${toolCall.name}`, { id: toolCall.id, error: (err as Error).message, elapsed: Date.now() - startTime });
      return { toolCallId: toolCall.id, content: message, isError: true };
    }
  }

  async executeTools(kbRoot: string, toolCalls: ToolCall[]): Promise<ToolResult[]> {
    const results: ToolResult[] = [];
    for (const tc of toolCalls) {
      results.push(await this.executeTool(kbRoot, tc));
    }
    return results;
  }
}
