import { type ThemeConfig, theme } from 'antd';
import { createContext } from 'react';

export interface Options {
  foo: number;
  bar: string;
  theme: 'light' | 'dark';
}

export const defaultOptions: Options = {
  foo: 1,
  bar: 'baz',
  theme: 'light',
};

export const OptionsContext = createContext(defaultOptions);

export const OptionsSetterContext = createContext({
  changeOptions: (options: Partial<Options>) => {},
});

export function themeFromOptions(optionTheme: Options['theme']): ThemeConfig {
  return {
    algorithm:
      optionTheme === 'dark' ? theme.darkAlgorithm : theme.defaultAlgorithm,
  };
}
