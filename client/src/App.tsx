import { ConfigProvider, App as AntApp } from "antd";
import "./App.css";
import { useEffect, useState } from "react";
import { themeFromOptions } from "./models/options";
import { BodyStyler } from "./components/core/BodyStyler";
import { AppRouter } from "./AppRouter";
import {
  loadSessionOrDefault,
  performSessionUpdate,
  Session,
  SessionContext,
  SessionSetterContext,
} from "./models/session";

export function App() {
  const [session, setSession] = useState<Session>(() => loadSessionOrDefault());

  const [themeConfig, setThemeConfig] = useState(() =>
    themeFromOptions(session.options.theme),
  );
  useEffect(
    () => setThemeConfig(themeFromOptions(session.options.theme)),
    [session.options.theme],
  );

  const updateSession = (changes: Partial<Session>) =>
    performSessionUpdate(changes, session, setSession);

  return (
    <AntApp>
      <ConfigProvider theme={themeConfig}>
        <BodyStyler />
        <SessionContext.Provider value={session}>
          <SessionSetterContext.Provider value={{ updateSession }}>
            <AppRouter />
          </SessionSetterContext.Provider>
        </SessionContext.Provider>
      </ConfigProvider>
    </AntApp>
  );
}
