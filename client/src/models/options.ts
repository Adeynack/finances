import { theme, ThemeConfig } from "antd";

export type Options = {
  theme: "light" | "dark";
};

function determineDefaultTheme(): Options["theme"] {
  return window.matchMedia("(prefers-color-scheme: dark)").matches
    ? "dark"
    : "light";
}

export function defaultOptions(): Options {
  return {
    theme: determineDefaultTheme(),
  };
}

export function themeFromOptions(optionTheme: Options["theme"]): ThemeConfig {
  return {
    algorithm:
      optionTheme === "dark" ? theme.darkAlgorithm : theme.defaultAlgorithm,
  };
}
