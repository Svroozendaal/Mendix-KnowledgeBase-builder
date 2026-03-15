import { useState } from 'react';
import { AppProvider, useApp } from './context/AppContext';
import { ConversationSidebar } from './components/ConversationSidebar/ConversationSidebar';
import { ChatPanel } from './components/ChatPanel/ChatPanel';
import { SettingsPanel } from './components/SettingsPanel/SettingsPanel';
import { KBPicker } from './components/KBPicker/KBPicker';
import styles from './App.module.css';

function AppContent() {
  const { currentConversation, kbInfo } = useApp();
  const [showSettings, setShowSettings] = useState(false);
  const [showKBPicker, setShowKBPicker] = useState(false);
  const [sidebarOpen, setSidebarOpen] = useState(true);

  return (
    <div className={styles.shell}>
      {/* Sidebar */}
      {sidebarOpen && (
        <ConversationSidebar onClose={() => setSidebarOpen(false)} />
      )}

      {/* Main area */}
      <div className={styles.main}>
        {/* Top bar */}
        <div className={styles.topBar}>
          <button
            className={styles.menuBtn}
            onClick={() => setSidebarOpen(!sidebarOpen)}
            title="Toggle sidebar"
          >
            &#9776;
          </button>
          <span className={styles.brand}>KB Copilot</span>
          <div className={styles.topActions}>
            <button className={styles.topBtn} onClick={() => setShowKBPicker(true)}>
              {kbInfo ? `KB: ${kbInfo.appName}` : 'Select KB'}
            </button>
            <button className={styles.topBtn} onClick={() => setShowSettings(true)}>
              Settings
            </button>
          </div>
        </div>

        {/* Chat or empty state */}
        <div className={styles.chatArea}>
          {currentConversation && kbInfo ? (
            <ChatPanel
              conversationId={currentConversation.id}
              kbInfo={kbInfo}
            />
          ) : (
            <div className={styles.emptyState}>
              {!kbInfo && (
                <p>
                  Select a knowledge base to get started.{' '}
                  <button className={styles.link} onClick={() => setShowKBPicker(true)}>
                    Open KB Picker
                  </button>
                </p>
              )}
              {kbInfo && !currentConversation && (
                <p>Create a new conversation from the sidebar to start chatting.</p>
              )}
            </div>
          )}
        </div>
      </div>

      {/* Modals */}
      {showSettings && <SettingsPanel onClose={() => setShowSettings(false)} />}
      {showKBPicker && <KBPicker onClose={() => setShowKBPicker(false)} />}
    </div>
  );
}

export function App() {
  return (
    <AppProvider>
      <AppContent />
    </AppProvider>
  );
}
