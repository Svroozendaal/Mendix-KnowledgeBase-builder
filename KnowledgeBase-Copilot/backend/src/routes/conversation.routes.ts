import { Router } from 'express';
import { ConversationStore } from '../services/conversation-store/index.js';
import { ConfigService } from '../services/config/index.js';

const router = Router();
const store = new ConversationStore();
const configService = new ConfigService();

router.get('/', async (_req, res, next) => {
  try {
    const list = await store.listConversations();
    res.json(list);
  } catch (err) {
    next(err);
  }
});

router.get('/:id', async (req, res, next) => {
  try {
    const conv = await store.loadConversation(req.params.id);
    res.json(conv);
  } catch (err) {
    if ((err as NodeJS.ErrnoException).code === 'ENOENT') {
      res.status(404).json({ error: 'Conversation not found.' });
      return;
    }
    next(err);
  }
});

router.post('/', async (req, res, next) => {
  try {
    const { kbRoot } = req.body as { kbRoot?: string };
    let root = kbRoot;
    if (!root) {
      const config = await configService.loadConfig();
      root = config.lastKbRoot ?? '';
    }
    const conv = await store.createConversation(root);
    res.status(201).json(conv);
  } catch (err) {
    next(err);
  }
});

router.delete('/:id', async (req, res, next) => {
  try {
    await store.deleteConversation(req.params.id);
    res.status(204).end();
  } catch (err) {
    if ((err as NodeJS.ErrnoException).code === 'ENOENT') {
      res.status(404).json({ error: 'Conversation not found.' });
      return;
    }
    next(err);
  }
});

router.patch('/:id', async (req, res, next) => {
  try {
    const { title } = req.body as { title: string };
    await store.updateTitle(req.params.id, title);
    res.json({ ok: true });
  } catch (err) {
    next(err);
  }
});

export default router;
