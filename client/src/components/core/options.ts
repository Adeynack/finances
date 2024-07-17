import { theme, ThemeConfig } from "antd";
import { createContext } from "react";

export interface Options {
  theme: 'light' | 'dark';
}

function determineDefaultTheme(): Options['theme'] {
  return window.matchMedia('(prefers-color-scheme: dark)').matches
    ? 'dark'
    : 'light';
}

export function defaultOptions(): Options {
  return {
    theme: determineDefaultTheme(),
  }
}

export const OptionsContext = createContext(defaultOptions());

export const OptionsSetterContext = createContext({
  changeOptions: () => { },
});

export function themeFromOptions(optionTheme: Options['theme']): ThemeConfig {
  return {
    algorithm:
      optionTheme === 'dark' ? theme.darkAlgorithm : theme.defaultAlgorithm,
  };
}