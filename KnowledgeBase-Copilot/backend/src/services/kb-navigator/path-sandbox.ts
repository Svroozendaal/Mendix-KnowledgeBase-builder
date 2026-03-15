import { resolve, relative, isAbsolute, normalize } from 'node:path';
import { realpath } from 'node:fs/promises';

export class PathTraversalError extends Error {
  constructor() {
    super('Access denied: path is outside the knowledge base.');
    this.name = 'PathTraversalError';
  }
}

/**
 * Validate that a relative path resolves inside the KB root.
 * Returns the resolved absolute path or throws PathTraversalError.
 */
export async function validatePath(kbRoot: string, relativePath: string): Promise<string> {
  // Reject null bytes
  if (relativePath.includes('\0')) {
    throw new PathTraversalError();
  }

  // Reject absolute paths in the relative portion
  if (isAbsolute(relativePath)) {
    throw new PathTraversalError();
  }

  // Normalise kbRoot (resolve to absolute, follow symlinks)
  const resolvedRoot = await realpath(resolve(kbRoot)).catch(() => resolve(kbRoot));

  // Resolve the target path
  const target = resolve(resolvedRoot, normalize(relativePath));

  // Follow symlinks on the target to catch symlink escapes
  let resolvedTarget: string;
  try {
    resolvedTarget = await realpath(target);
  } catch {
    // File may not exist yet — use the resolved (non-symlink) path
    resolvedTarget = target;
  }

  // Verify the resolved path is within the root
  const rel = relative(resolvedRoot, resolvedTarget);
  if (rel.startsWith('..') || isAbsolute(rel)) {
    throw new PathTraversalError();
  }

  return resolvedTarget;
}
