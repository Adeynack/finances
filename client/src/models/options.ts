import { theme, ThemeConfig } from "antd";
import { useEffect, useState } from "react";

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

export function useThemeConfig(theme: Options["theme"]): ThemeConfig {
  const [themeConfig, setThemeConfig] = useState(() => themeFromOptions(theme));
  useEffect(() => setThemeConfig(themeFromOptions(theme)), [theme]);

  return themeConfig;
}
