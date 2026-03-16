import { Router } from 'express';
import { ConfigService } from '../services/config/index.js';
import { AIProviderService } from '../services/ai-provider/index.js';
import type { CopilotConfig } from '@kb-copilot/shared';

const router = Router();
const configService = new ConfigService();
const providerService = new AIProviderService();

router.get('/', async (_req, res, next) => {
  try {
    const config = await configService.loadConfig();
    res.json(config);
  } catch (err) {
    next(err);
  }
});

router.put('/', async (req, res, next) => {
  try {
    const incoming = req.body as CopilotConfig;
    await configService.saveConfig(incoming);
    const saved = await configService.loadConfig();
    res.json(saved);
  } catch (err) {
    next(err);
  }
});

router.post('/validate-provider', async (_req, res, next) => {
  try {
    const config = await configService.loadConfig();
    const result = await providerService.validateProvider(config.aiSettings);
    res.json(result);
  } catch (err) {
    next(err);
  }
});

router.post('/detect-cli', async (req, res, next) => {
  try {
    const { type } = req.body as { type: 'claude' | 'codex' };
    const result = providerService.detectCli(type);
    res.json(result);
  } catch (err) {
    next(err);
  }
});

export default router;
