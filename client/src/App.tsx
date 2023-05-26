import './App.scss';
import 'antd/dist/reset.css';
import {
  type Options,
  OptionsContext,
  OptionsSetterContext,
  defaultOptions,
} from './core/options';
import { useMemo, useState } from 'react';
import { ConfigProvider, type ThemeConfig, theme, App as AntApp } from 'antd';
import { BodyStyler } from './core/BodyStyler';
import { RouterProvider } from 'react-router-dom';
import { router } from './core/router';

export function App(): JSX.Element {
  const [options, setOptions] = useState(defaultOptions);
  const themeConfig = useMemo(
    () => themeFromOptions(options.theme),
    [options.theme]
  );

  return (
    <ConfigProvider theme={themeConfig}>
      <BodyStyler />
      <AntApp>
        <OptionsContext.Provider value={options}>
          <OptionsSetterContext.Provider
            value={{
              changeOptions: (o) => setOptions({ ...options, ...o }),
              setOptions,
            }}
          >
            <div className="App">
              <RouterProvider router={router} />
            </div>
          </OptionsSetterContext.Provider>
        </OptionsContext.Provider>
      </AntApp>
    </ConfigProvider>
  );
}

function themeFromOptions(optionTheme: Options['theme']): ThemeConfig {
  return {
    algorithm:
      optionTheme === 'dark' ? theme.darkAlgorithm : theme.defaultAlgorithm,
  };
}
