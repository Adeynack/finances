import { ConfigProvider, App as AntApp } from 'antd'
import './App.css'
import { useMemo, useState } from 'react'
import { defaultOptions, Options, OptionsContext, OptionsSetterContext, themeFromOptions } from './components/core/options'
import { BodyStyler } from './components/core/BodyStyler'
import MainLayout from './components/core/MainLayout'
import { ApolloClient, ApolloProvider, InMemoryCache } from '@apollo/client'
import { createBrowserRouter, RouterProvider } from 'react-router-dom'
import { ThemeSwitch } from './components/core/ThemeSwitch'
import { BookList } from './BookList'

const router = createBrowserRouter([
  {
    path: "/",
    element: <ThemeSwitch />
  },
  {
    path: "/books",
    element: <BookList />
  }
]);

function App() {
  const [options, setOptions] = useState(() => defaultOptions());
  const themeConfig = useMemo(() => themeFromOptions(options.theme), [options.theme]);
  const changeOptions = (o: Partial<Options>) => setOptions({ ...options, ...o });
  const [apiToken] = useState<string>(() => "")
  const client = useMemo(() => createApolloClient(apiToken), [apiToken]);

  return (
    <ApolloProvider client={client}>
      <ConfigProvider theme={themeConfig}>
        <AntApp>
          <BodyStyler />
          <OptionsContext.Provider value={options}>
            <OptionsSetterContext.Provider value={{ changeOptions }}>
              <RouterProvider router={router}>
                <MainLayout />
              </RouterProvider>
            </OptionsSetterContext.Provider>
          </OptionsContext.Provider>
        </AntApp>
      </ConfigProvider>
    </ApolloProvider>
  )
}

function createApolloClient(apiToken: string) {
  return new ApolloClient({
    uri: 'http://localhost:30001/graphql',
    cache: new InMemoryCache(),
    headers: {
      "Authorization": apiToken
    }
  });
}

export default App
