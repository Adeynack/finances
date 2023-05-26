import './App.scss';
import 'antd/dist/reset.css';
import {
  OptionsContext,
  OptionsSetterContext,
  defaultOptions,
  themeFromOptions
} from './core/options';
import { useMemo, useState } from 'react';
import { ConfigProvider, App as AntApp } from 'antd';
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
