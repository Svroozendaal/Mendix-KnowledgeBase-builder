import {
  createContext,
  useContext,
  useState,
  useEffect,
  useCallback,
  type ReactNode,
} from 'react';
import type {
  CopilotConfig,
  KBInfo,
  Conversation,
  ConversationMeta,
} from '@kb-copilot/shared';
import * as api from '../services/api';

interface AppContextValue {
  config: CopilotConfig | null;
  kbInfo: KBInfo | null;
  currentConversation: Conversation | null;
  conversations: ConversationMeta[];
  updateConfig: (config: CopilotConfig) => Promise<void>;
  selectConversation: (id: string) => Promise<void>;
  createConversation: () => Promise<Conversation>;
  deleteConversation: (id: string) => Promise<void>;
  setKbRoot: (path: string) => Promise<{ valid: boolean; error?: string }>;
  refreshConversations: () => Promise<void>;
  setKbInfo: (info: KBInfo | null) => void;
}

const AppContext = createContext<AppContextValue | null>(null);

export function AppProvider({ children }: { children: ReactNode }) {
  const [config, setConfig] = useState<CopilotConfig | null>(null);
  const [kbInfo, setKbInfo] = useState<KBInfo | null>(null);
  const [currentConversation, setCurrentConversation] = useState<Conversation | null>(null);
  const [conversations, setConversations] = useState<ConversationMeta[]>([]);

  // Load config and conversations on mount; auto-discover KB when running as extension
  useEffect(() => {
    api.getConfig().then(setConfig).catch(console.error);
    api.getConversations().then(setConversations).catch(console.error);

    // Try cached KB first, then auto-discover from appRoot query param (Mendix extension)
    api.getKbInfo()
      .then(setKbInfo)
      .catch(() => {
        const params = new URLSearchParams(window.location.search);
        const appRoot = params.get('appRoot');
        if (appRoot) {
          api.discoverKb(appRoot)
            .then((result) => {
              if (result.valid && result.info) {
                setKbInfo(result.info);
              }
            })
            .catch(() => {});
        }
      });
  }, []);

  const updateConfig = useCallback(async (newConfig: CopilotConfig) => {
    const saved = await api.saveConfig(newConfig);
    setConfig(saved);
  }, []);

  const refreshConversations = useCallback(async () => {
    const list = await api.getConversations();
    setConversations(list);
  }, []);

  const selectConversation = useCallback(async (id: string) => {
    const conv = await api.getConversation(id);
    setCurrentConversation(conv);
  }, []);

  const createConversationFn = useCallback(async () => {
    const conv = await api.createConversation(kbInfo?.kbRoot);
    setCurrentConversation(conv);
    await refreshConversations();
    return conv;
  }, [kbInfo, refreshConversations]);

  const deleteConversationFn = useCallback(async (id: string) => {
    await api.deleteConversation(id);
    if (currentConversation?.id === id) {
      setCurrentConversation(null);
    }
    await refreshConversations();
  }, [currentConversation, refreshConversations]);

  const setKbRoot = useCallback(async (path: string) => {
    const result = await api.validateKb(path);
    if (result.valid && result.info) {
      setKbInfo(result.info);
      if (config) {
        await updateConfig({ ...config, lastKbRoot: path });
      }
    }
    return { valid: result.valid, error: result.error };
  }, [config, updateConfig]);

  return (
    <AppContext.Provider
      value={{
        config,
        kbInfo,
        currentConversation,
        conversations,
        updateConfig,
        selectConversation,
        createConversation: createConversationFn,
        deleteConversation: deleteConversationFn,
        setKbRoot,
        refreshConversations,
        setKbInfo,
      }}
    >
      {children}
    </AppContext.Provider>
  );
}

export function useApp(): AppContextValue {
  const ctx = useContext(AppContext);
  if (!ctx) throw new Error('useApp must be used within AppProvider');
  return ctx;
}
