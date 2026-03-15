import { Router } from 'express';
import { stat, readFile, readdir } from 'node:fs/promises';
import { join } from 'node:path';
import type { KBInfo } from '@kb-copilot/shared';
import { ConfigService } from '../services/config/index.js';

const router = Router();
const configService = new ConfigService();

let cachedKbInfo: KBInfo | null = null;

router.post('/validate', async (req, res, next) => {
  try {
    const { path: kbPath } = req.body as { path: string };

    if (!kbPath) {
      res.json({ valid: false, error: 'No path provided.' });
      return;
    }

    // Check directory exists
    try {
      const s = await stat(kbPath);
      if (!s.isDirectory()) {
        res.json({ valid: false, error: 'Path is not a directory.' });
        return;
      }
    } catch {
      res.json({ valid: false, error: 'Directory does not exist.' });
      return;
    }

    // Check READER.md
    const hasReader = await fileExists(join(kbPath, 'READER.md'));
    if (!hasReader) {
      res.json({ valid: false, error: 'READER.md not found. This does not appear to be a valid knowledge base.' });
      return;
    }

    // Check ROUTING.md
    const hasRouting = await fileExists(join(kbPath, 'ROUTING.md'));

    // Count modules
    let moduleCount = 0;
    try {
      const modulesDir = join(kbPath, 'modules');
      const entries = await readdir(modulesDir, { withFileTypes: true });
      moduleCount = entries.filter((e) => e.isDirectory()).length;
    } catch { /* no modules dir */ }

    // Try to extract app name from READER.md
    let appName = 'Unknown';
    try {
      const readerContent = await readFile(join(kbPath, 'READER.md'), 'utf-8');
      const match = readerContent.match(/application\s+`([^`]+)`/i)
        ?? readerContent.match(/# .*?([A-Z][a-zA-Z0-9_]+)/);
      if (match?.[1]) appName = match[1];
    } catch { /* ignore */ }

    const info: KBInfo = {
      appName,
      kbRoot: kbPath,
      hasReader,
      hasRouting,
      moduleCount,
    };

    cachedKbInfo = info;
    res.json({ valid: true, info });
  } catch (err) {
    next(err);
  }
});

router.get('/info', async (_req, res, next) => {
  try {
    if (cachedKbInfo) {
      res.json(cachedKbInfo);
      return;
    }

    const config = await configService.loadConfig();
    if (!config.lastKbRoot) {
      res.status(404).json({ error: 'No knowledge base configured.' });
      return;
    }

    res.status(404).json({ error: 'Knowledge base not yet validated.' });
  } catch (err) {
    next(err);
  }
});

async function fileExists(path: string): Promise<boolean> {
  try {
    await stat(path);
    return true;
  } catch {
    return false;
  }
}

export default router;
