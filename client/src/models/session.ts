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
      console.log("[generateDefaultSession#isLoggedIn]", { this: this });
      return !!this.apiToken;
    },
  };
}

export const SessionContext = createContext(generateDefaultSession());

export const SessionSetterContext = createContext({
  updateSession: (_session: Partial<Session>): void => {}, // eslint-disable-line @typescript-eslint/no-unused-vars
});

export function useSession(): Session {
  return useContext(SessionContext);
}

export function loadSessionOrDefault(): Session {
  const defaultSession = generateDefaultSession();

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

export function performSessionUpdate(
  changes: Partial<Session>,
  session: Session,
  setApiToken: (_: string | null) => void,
  setSession: (_: Session) => void,
) {
  // If the token changes, we need to set it using its prop, so the
  // Apollo client prop get updated.
  if (changes.apiToken !== undefined && changes.apiToken !== session.apiToken) {
    setApiToken(changes.apiToken || null);
  }

  // Set the new session's prop.
  const updatedSession = merge.withOptions(
    { mergeArrays: false },
    session,
    changes as Session,
  );
  setSession(updatedSession);

  // Save the session to the browser's storage.
  window.localStorage.setItem(
    STORAGE_SESSION_KEY,
    JSON.stringify(updatedSession),
  );
}
