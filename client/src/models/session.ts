import { createContext, useContext } from "react";
import { defaultOptions, Options } from "./options";
import { merge } from "ts-deepmerge";

const STORAGE_SESSION_KEY = "app-session";

export interface LoggedInUser {
  displayName: string;
  email: string;
}

export interface Session {
  apiToken: string | null;
  user: LoggedInUser | null;
  options: Options;
  isLoggedIn(): boolean;
}

function generateDefaultSession(): Session {
  return {
    apiToken: null,
    user: null,
    options: defaultOptions(),

    isLoggedIn() {
      return !!this.apiToken;
    },
  };
}

export const SessionContext = createContext(generateDefaultSession());

export const SessionSetterContext = createContext({
  changeSession: (_session: Partial<Session>): void => {}, // eslint-disable-line @typescript-eslint/no-unused-vars
});

export function useSession(): Session {
  return useContext(SessionContext);
}

export function loadSessionOrDefault(): Session {
  const defaultSession = generateDefaultSession();

  // Attempt to load the last locally stored session.
  const rawSessionFromStorage =
    window.sessionStorage.getItem(STORAGE_SESSION_KEY);
  console.log("loadSessionOrDefault", { rawSessionFromStorage });
  if (rawSessionFromStorage) {
    // Merging default and whatever is stored, to ensure some requirements.
    return { ...defaultSession, ...JSON.parse(rawSessionFromStorage) };
  }

  // No stored session. Using the default.
  return defaultSession;
}

export function performSessionChange(
  changes: Partial<Session>,
  session: Session,
  setApiToken: (_: string) => void,
  setSession: (_: Session) => void,
) {
  // If the token changes, we need to set it
  // using its prop, so the Apollo client prop
  // get updated.
  if (changes.apiToken != session.apiToken) {
    setApiToken(changes.apiToken ? `Bearer ${changes.apiToken}` : "");
  }

  // Set the new session's prop.
  const updatedSession = merge.withOptions(
    { mergeArrays: false },
    session,
    changes as Session,
  );
  setSession(updatedSession);

  // Save the session to the browser's storage.
  window.sessionStorage.setItem(
    STORAGE_SESSION_KEY,
    JSON.stringify(updatedSession),
  );
}
