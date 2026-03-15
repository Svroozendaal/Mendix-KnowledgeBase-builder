import { createServer } from 'node:http';
import express from 'express';
import cors from 'cors';
import configRoutes from './routes/config.routes.js';
import kbRoutes from './routes/kb.routes.js';
import conversationRoutes from './routes/conversation.routes.js';
import { errorHandler } from './middleware/error-handler.js';
import { setupWebSocket } from './ws/chat.handler.js';

const app = express();
const PORT = parseInt(process.env.PORT ?? '3001', 10);

app.use(cors({ origin: 'http://localhost:5173' }));
app.use(express.json());

// Health check
app.get('/api/health', (_req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Routes
app.use('/api/config', configRoutes);
app.use('/api/kb', kbRoutes);
app.use('/api/conversations', conversationRoutes);

// Error handler (must be last)
app.use(errorHandler);

// Create HTTP server and attach WebSocket
const server = createServer(app);
setupWebSocket(server);

server.listen(PORT, () => {
  console.log(`KB Copilot backend running on port ${PORT}`);
});
