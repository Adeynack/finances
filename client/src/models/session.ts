import {
  createContext,
  Dispatch,
  SetStateAction,
  useCallback,
  useContext,
  useState,
} from "react";
import { defaultOptions, Options } from "./options";
import { merge } from "ts-deepmerge";
import { ApolloClient } from "@apollo/client";
import { changeApolloClientSession } from "./graphql";

const STORAGE_SESSION_KEY = "app-session";

export interface LoggedInUser {
  displayName: string;
  email: string;
}

export interface Session {
  apiToken: string | null;
  user: LoggedInUser | null;
  options: Options;
  isLoggedIn: boolean;
}

const defaultSession: Session = {
  apiToken: null,
  user: null,
  options: defaultOptions(),
  isLoggedIn: false,
};

export const SessionContext = createContext(defaultSession);

export const SessionSetterContext = createContext({
  updateSession: (_session: Partial<Session>): void => {}, // eslint-disable-line @typescript-eslint/no-unused-vars
});

export function useSession(): Session {
  return useContext(SessionContext);
}

export function loadSessionOrDefault(): Session {
  // Attempt to load the last locally stored session.
  const rawSessionFromStorage =
    window.localStorage.getItem(STORAGE_SESSION_KEY);
  if (rawSessionFromStorage) {
    // Merging default and whatever is stored, to ensure some requirements.
    return merge.withOptions(
      { mergeArrays: false },
      defaultSession,
      JSON.parse(rawSessionFromStorage) as Session,
    );
  }

  // No stored session. Using the default.
  return defaultSession;
}

function performSessionUpdate(
  changes: Partial<Session>,
  setSession: Dispatch<SetStateAction<Session>>,
  apolloClient: ApolloClient<object>,
) {
  setSession((previous) => {
    console.log("[performSessionUpdate][setSession]", { previous, changes });
    // Set the new session's prop.
    const updatedSession = merge.withOptions(
      { mergeArrays: false },
      previous,
      changes as Session,
    );

    // Save the session to the browser's storage.
    window.localStorage.setItem(
      STORAGE_SESSION_KEY,
      JSON.stringify(updatedSession),
    );

    // If the session changed, clear the Apollo client's cache.
    if (Object.keys(changes).includes("apiToken")) {
      changeApolloClientSession(apolloClient, changes.apiToken || null);
    }

    return updatedSession;
  });
}

export function useSessionInitializer(
  apolloClient: ApolloClient<object>,
): [Session, (changes: Partial<Session>) => void] {
  const [session, setSession] = useState<Session>(() => loadSessionOrDefault());
  const updateSession = useCallback(
    (changes: Partial<Session>) =>
      performSessionUpdate(changes, setSession, apolloClient),
    [setSession, apolloClient],
  );

  return [session, updateSession];
}
