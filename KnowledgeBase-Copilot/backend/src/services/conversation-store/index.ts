import { readFile, writeFile, readdir, unlink, mkdir } from 'node:fs/promises';
import { join } from 'node:path';
import { randomUUID } from 'node:crypto';
import type { Conversation, ConversationMeta } from '@kb-copilot/shared';

const STORE_DIR = join(process.cwd(), 'conversations');

async function ensureDir(): Promise<void> {
  await mkdir(STORE_DIR, { recursive: true });
}

export class ConversationStore {
  async listConversations(): Promise<ConversationMeta[]> {
    await ensureDir();
    const files = await readdir(STORE_DIR);
    const jsonFiles = files.filter((f) => f.endsWith('.json'));

    const metas: ConversationMeta[] = [];
    for (const file of jsonFiles) {
      try {
        const raw = await readFile(join(STORE_DIR, file), 'utf-8');
        const conv: Conversation = JSON.parse(raw);
        metas.push({
          id: conv.id,
          title: conv.title,
          messageCount: conv.messages.length,
          createdAt: conv.createdAt,
          updatedAt: conv.updatedAt,
        });
      } catch {
        // Skip corrupt files
      }
    }

    metas.sort((a, b) => new Date(b.updatedAt).getTime() - new Date(a.updatedAt).getTime());
    return metas;
  }

  async loadConversation(id: string): Promise<Conversation> {
    await ensureDir();
    const raw = await readFile(join(STORE_DIR, `${id}.json`), 'utf-8');
    return JSON.parse(raw) as Conversation;
  }

  async saveConversation(conversation: Conversation): Promise<void> {
    await ensureDir();
    conversation.updatedAt = new Date().toISOString();
    await writeFile(
      join(STORE_DIR, `${conversation.id}.json`),
      JSON.stringify(conversation, null, 2),
      'utf-8',
    );
  }

  async createConversation(kbRoot: string): Promise<Conversation> {
    const conversation: Conversation = {
      id: randomUUID(),
      title: 'New conversation',
      messages: [],
      kbRoot,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    };
    await this.saveConversation(conversation);
    return conversation;
  }

  async deleteConversation(id: string): Promise<void> {
    await ensureDir();
    await unlink(join(STORE_DIR, `${id}.json`));
  }

  async updateTitle(id: string, title: string): Promise<void> {
    const conv = await this.loadConversation(id);
    conv.title = title;
    await this.saveConversation(conv);
  }
}
