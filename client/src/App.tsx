import { ConfigProvider, App as AntApp } from "antd";
import "./App.css";
import { useEffect, useInsertionEffect, useState } from "react";
import { themeFromOptions } from "./models/options";
import { BodyStyler } from "./components/core/BodyStyler";
import {
  ApolloClient,
  ApolloProvider,
  from,
  HttpLink,
  InMemoryCache,
  ServerError,
} from "@apollo/client";
import { onError } from "@apollo/client/link/error";
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

  const updateSession = (changes: Partial<Session>) =>
    performSessionUpdate(changes, session, setApiToken, setSession);

  const [client, setClient] = useState(() => createApolloClient(null));

  useEffect(() => {
    const newClient = createApolloClient(apiToken);
    setClient(newClient);
    return () => {
      newClient.stop();
    };
  }, [apiToken]);

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

function createApolloClient(apiToken: string | null) {
  const auth = apiToken && apiToken.length > 0 ? `Bearer ${apiToken}` : "";
  const errorLink = onError(({ networkError }) => {
    if (networkError) {
      console.log("[onErrorLink] networkError", { networkError });
      if (Object.keys(networkError).includes("statusCode")) {
        const serverError = networkError as ServerError;
        if (serverError.statusCode === 401) {
          // updateSession({ apiToken: null, isLoggedIn: false, user: null });
        }
      }
    }
  });
  const httpLink = new HttpLink({
    uri: "http://localhost:30001/graphql",
    headers: {
      Authorization: auth,
    },
  });
  return new ApolloClient({
    cache: new InMemoryCache(),
    link: from([errorLink, httpLink]),
    defaultOptions: {
      mutate: {
        errorPolicy: "all",
      },
    },
  });
}

export default App;
