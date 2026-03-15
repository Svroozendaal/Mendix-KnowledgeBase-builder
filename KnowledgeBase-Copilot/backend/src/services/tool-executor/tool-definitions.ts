import type { ToolDefinition } from '../ai-provider/types.js';

export const KB_TOOLS: ToolDefinition[] = [
  {
    name: 'read_file',
    description:
      'Read a file from the knowledge base. Use relative paths from the KB root (e.g., "ROUTING.md", "modules/Budget/README.md", "routes/by-flow.md").',
    input_schema: {
      type: 'object',
      properties: {
        path: {
          type: 'string',
          description: 'Relative path to the file within the knowledge base',
        },
      },
      required: ['path'],
    },
  },
  {
    name: 'list_files',
    description:
      'List files and directories at a path in the knowledge base. Returns names, types, and sizes. Useful for exploring the KB structure.',
    input_schema: {
      type: 'object',
      properties: {
        path: {
          type: 'string',
          description:
            'Relative path to the directory (empty string or "/" for KB root)',
        },
      },
      required: ['path'],
    },
  },
  {
    name: 'search_content',
    description:
      'Search for text content across knowledge base markdown files. Returns matching lines with file paths and line numbers. Use this to find specific entities, flows, or concepts.',
    input_schema: {
      type: 'object',
      properties: {
        query: {
          type: 'string',
          description: 'Text to search for (case-insensitive)',
        },
        path: {
          type: 'string',
          description:
            'Optional: restrict search to this subdirectory (e.g., "modules/Budget")',
        },
      },
      required: ['query'],
    },
  },
];
