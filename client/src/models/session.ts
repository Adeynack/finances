import { createContext, useContext } from "react";
import { defaultOptions, Options } from "./options";

export interface Session {
  apiToken: string | null;
  options: Options;
  isLoggedIn(): boolean;
}

export function defaultSession(): Session {
  return {
    apiToken: null,
    options: defaultOptions(),

    isLoggedIn() {
      return !!this.apiToken;
    },
  };
}

export const SessionContext = createContext(defaultSession());

export const SessionSetterContext = createContext({
  changeSession: (_session: Partial<Session>) => {}, // eslint-disable-line @typescript-eslint/no-unused-vars
});

export function useSession(): Session {
  return useContext(SessionContext);
}
