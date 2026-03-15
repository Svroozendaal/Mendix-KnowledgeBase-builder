import { useRef, useState, useEffect, useCallback } from 'react';
import type { WSClientMessage, WSServerEvent } from '@kb-copilot/shared';

type EventHandler = (event: WSServerEvent) => void;

export function useWebSocket(url: string) {
  const wsRef = useRef<WebSocket | null>(null);
  const handlerRef = useRef<EventHandler | null>(null);
  const [connected, setConnected] = useState(false);
  const retriesRef = useRef(0);
  const maxRetries = 5;

  const connect = useCallback(() => {
    if (wsRef.current?.readyState === WebSocket.OPEN) return;

    const ws = new WebSocket(url);
    wsRef.current = ws;

    ws.onopen = () => {
      setConnected(true);
      retriesRef.current = 0;
    };

    ws.onclose = () => {
      setConnected(false);
      wsRef.current = null;
      if (retriesRef.current < maxRetries) {
        const delay = Math.min(1000 * 2 ** retriesRef.current, 16000);
        retriesRef.current++;
        setTimeout(connect, delay);
      }
    };

    ws.onerror = () => {
      ws.close();
    };

    ws.onmessage = (evt) => {
      try {
        const event = JSON.parse(evt.data) as WSServerEvent;
        handlerRef.current?.(event);
      } catch {
        // ignore malformed messages
      }
    };
  }, [url]);

  useEffect(() => {
    connect();
    return () => {
      wsRef.current?.close();
      wsRef.current = null;
    };
  }, [connect]);

  const sendMessage = useCallback((msg: WSClientMessage) => {
    if (wsRef.current?.readyState === WebSocket.OPEN) {
      wsRef.current.send(JSON.stringify(msg));
    }
  }, []);

  const cancel = useCallback(() => {
    sendMessage({ type: 'cancel' });
  }, [sendMessage]);

  const onEvent = useCallback((handler: EventHandler) => {
    handlerRef.current = handler;
  }, []);

  return { connected, sendMessage, cancel, onEvent };
}
