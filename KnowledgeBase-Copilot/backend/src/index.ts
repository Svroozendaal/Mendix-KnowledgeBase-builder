import { createServer } from 'node:http';
import { existsSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import express from 'express';
import cors from 'cors';
import configRoutes from './routes/config.routes.js';
import kbRoutes from './routes/kb.routes.js';
import conversationRoutes from './routes/conversation.routes.js';
import { errorHandler } from './middleware/error-handler.js';
import { setupWebSocket } from './ws/chat.handler.js';
import { createLogger, LOG_FILE_PATH } from './logger.js';

const log = createLogger('Server');

const __dirname = dirname(fileURLToPath(import.meta.url));

const app = express();
const PORT = parseInt(process.env.PORT ?? '3001', 10);

// In production, allow same-origin requests; in dev, allow Vite dev server
const isDev = process.env.NODE_ENV !== 'production';
if (isDev) {
  app.use(cors({ origin: 'http://localhost:5173' }));
} else {
  app.use(cors());
}
app.use(express.json());

// Health check
app.get('/api/health', (_req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Routes
app.use('/api/config', configRoutes);
app.use('/api/kb', kbRoutes);
app.use('/api/conversations', conversationRoutes);

// In production, serve the built frontend files
const frontendDist = resolve(__dirname, '../../frontend/dist');
if (!isDev && existsSync(frontendDist)) {
  app.use(express.static(frontendDist));
  // SPA fallback — serve index.html for any non-API route
  app.get('*', (_req, res) => {
    res.sendFile(resolve(frontendDist, 'index.html'));
  });
}

// Error handler (must be last)
app.use(errorHandler);

// Create HTTP server and attach WebSocket
const server = createServer(app);
setupWebSocket(server);

server.listen(PORT, () => {
  log.info(`KB Copilot backend running on port ${PORT}`);
  log.info(`Log file: ${LOG_FILE_PATH}`);
  if (!isDev && existsSync(frontendDist)) {
    log.info(`Frontend served from ${frontendDist}`);
    log.info(`Open http://localhost:${PORT} in your browser`);
  }
});
