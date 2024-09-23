import { ConfigProvider, App as AntApp } from "antd";
import "./App.css";
import { useEffect, useState } from "react";
import { themeFromOptions } from "./models/options";
import { BodyStyler } from "./components/core/BodyStyler";
import { ApolloClient, ApolloProvider, InMemoryCache } from "@apollo/client";
import { AppRouter } from "./AppRouter";
import {
  loadSessionOrDefault,
  performSessionUpdate,
  Session,
  SessionContext,
  SessionSetterContext,
} from "./models/session";

function App() {
  const [session, setSession] = useState<Session>(() => loadSessionOrDefault());

  const [themeConfig, setThemeConfig] = useState(() =>
    themeFromOptions(session.options.theme),
  );
  useEffect(
    () => setThemeConfig(themeFromOptions(session.options.theme)),
    [session.options.theme],
  );

  const [apiToken, setApiToken] = useState(session.apiToken);
  console.log("[App] apiToken", apiToken);

  const [client, setClient] = useState(() => createApolloClient(""));
  useEffect(() => {
    console.log("[App][setClient]", { apiToken });
    const auth = apiToken && apiToken.length > 0 ? `Bearer ${apiToken}` : "";
    const newClient = createApolloClient(auth);
    setClient(newClient);
    return () => {
      console.log("[App][setClient] stopping existing client");
      newClient.stop();
    };
  }, [apiToken]);

  const updateSession = (changes: Partial<Session>) =>
    performSessionUpdate(changes, session, setApiToken, setSession);

  return (
    <AntApp>
      <ConfigProvider theme={themeConfig}>
        <BodyStyler />
        <ApolloProvider client={client}>
          <SessionContext.Provider value={session}>
            <SessionSetterContext.Provider value={{ updateSession }}>
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
    defaultOptions: {
      mutate: {
        errorPolicy: "all",
      },
    },
  });
}

export default App;
