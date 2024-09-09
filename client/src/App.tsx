import { ConfigProvider, App as AntApp } from "antd";
import "./App.css";
import { useEffect, useState } from "react";
import { themeFromOptions } from "./models/options";
import { BodyStyler } from "./components/core/BodyStyler";
import { ApolloClient, ApolloProvider, InMemoryCache } from "@apollo/client";
import { AppRouter } from "./AppRouter";
import {
  defaultSession,
  Session,
  SessionContext,
  SessionSetterContext,
} from "./models/session";

function App() {
  const [session, setSession] = useState<Session>(() => defaultSession());

  const [themeConfig, setThemeConfig] = useState(() =>
    themeFromOptions(session.options.theme),
  );
  useEffect(
    () => setThemeConfig(themeFromOptions(session.options.theme)),
    [session.options.theme],
  );

  const changeSession = (o: Partial<Session>) =>
    setSession({ ...session, ...o });

  const [client, setClient] = useState(() => createApolloClient(""));
  useEffect(
    () => setClient(createApolloClient(session?.apiToken || "")),
    [session?.apiToken],
  );

  return (
    <AntApp>
      <ConfigProvider theme={themeConfig}>
        <BodyStyler />
        <ApolloProvider client={client}>
          <SessionContext.Provider value={session}>
            <SessionSetterContext.Provider value={{ changeSession }}>
              <AppRouter />
            </SessionSetterContext.Provider>
          </SessionContext.Provider>
        </ApolloProvider>
      </ConfigProvider>
    </AntApp>
  );
}

function createApolloClient(apiToken: string) {
  return new ApolloClient({
    uri: "http://localhost:30001/graphql",
    cache: new InMemoryCache(),
    headers: {
      Authorization: apiToken,
    },
  });
}

export default App;
