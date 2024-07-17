import { ConfigProvider, App as AntApp } from 'antd'
import './App.css'
import { useMemo, useState } from 'react'
import { defaultOptions, Options, OptionsContext, OptionsSetterContext, themeFromOptions } from './components/core/options'
import { BodyStyler } from './components/core/BodyStyler'
import MainLayout from './components/core/MainLayout'

function App() {
  const [options, setOptions] = useState(defaultOptions());
  const themeConfig = useMemo(() =>
    themeFromOptions(options.theme),
    [options.theme]
  );

  const changeOptions = (o: Partial<Options>) => setOptions({ ...options, ...o });

  return (
    <>
      <ConfigProvider theme={themeConfig}>
        <AntApp>
          <BodyStyler />
          <OptionsContext.Provider value={options}>
            <OptionsSetterContext.Provider value={{ changeOptions }}>
              <MainLayout />
            </OptionsSetterContext.Provider>
          </OptionsContext.Provider>
        </AntApp>
      </ConfigProvider>
    </>
  )
}

export default App
