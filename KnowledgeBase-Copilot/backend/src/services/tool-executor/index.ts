import type { ToolCall, ToolResult } from '@kb-copilot/shared';
import { KBNavigator, FileNotFoundError, PathTraversalError } from '../kb-navigator/index.js';

const kbNavigator = new KBNavigator();

export class ToolExecutor {
  async executeTool(kbRoot: string, toolCall: ToolCall): Promise<ToolResult> {
    try {
      const args = toolCall.arguments;

      switch (toolCall.name) {
        case 'read_file': {
          const filePath = String(args.path ?? '');
          const content = await kbNavigator.readFile(kbRoot, filePath);
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
          return { toolCallId: toolCall.id, content: formatted || '(empty directory)', isError: false };
        }

        case 'search_content': {
          const query = String(args.query ?? '');
          const searchPath = args.path ? String(args.path) : undefined;
          const results = await kbNavigator.searchContent(kbRoot, query, searchPath);
          if (results.length === 0) {
            return { toolCallId: toolCall.id, content: `No results found for "${query}".`, isError: false };
          }
          const formatted = results
            .map((r) => `${r.file}:${r.lineNumber} — ${r.content}`)
            .join('\n');
          return { toolCallId: toolCall.id, content: formatted, isError: false };
        }

        default:
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
