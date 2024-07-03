import { ConfigProvider, App as AntApp, Switch } from 'antd'
import './App.css'
import BookList from './BookList'
import { useMemo, useState } from 'react'
import { defaultOptions, Options, OptionsContext, OptionsSetterContext, themeFromOptions } from './components/core/options'
import { BodyStyler } from './components/core/BodyStyler'
import { ThemeSwitch } from './components/core/ThemeSwitch'

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
        <BodyStyler />
        <AntApp>
          <OptionsContext.Provider value={options}>
            <OptionsSetterContext.Provider value={{ changeOptions }}>
              <ThemeSwitch />
              <BookList />
            </OptionsSetterContext.Provider>
          </OptionsContext.Provider>
        </AntApp>
      </ConfigProvider>
    </>
  )
}

export default App
