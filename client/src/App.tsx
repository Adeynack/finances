import { ConfigProvider, App as AntApp } from "antd";
import "./App.css";
import { useThemeConfig } from "./models/options";
import { BodyStyler } from "./components/core/BodyStyler";
import { AppRouter } from "./AppRouter";
import {
  SessionContext,
  SessionSetterContext,
  useSessionInitializer,
} from "./models/session";
import { useApolloClient } from "@apollo/client";

export function App() {
  const apolloClient = useApolloClient();
  const [session, updateSession] = useSessionInitializer(apolloClient);
  const themeConfig = useThemeConfig(session.options.theme);

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
