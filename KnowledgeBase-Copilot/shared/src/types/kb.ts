export interface KBFileEntry {
  name: string;
  path: string;
  type: 'file' | 'directory';
  size: number;
}

export interface KBSearchResult {
  file: string;
  lineNumber: number;
  content: string;
}

export interface KBInfo {
  appName: string;
  kbRoot: string;
  hasReader: boolean;
  hasRouting: boolean;
  moduleCount: number;
}
