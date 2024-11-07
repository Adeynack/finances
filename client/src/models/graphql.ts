import {
  ApolloClient,
  ApolloLink,
  InMemoryCache,
  createHttpLink,
} from "@apollo/client";
import { setContext } from "@apollo/client/link/context";
import { loadSessionOrDefault } from "./session";

const httpLink = createHttpLink({
  uri: "http://localhost:30001/graphql",
});

export const apolloClient = new ApolloClient({
  link: generateApolloClientLink(loadSessionOrDefault().apiToken),
  headers: {},
  cache: new InMemoryCache({
    // possibleTypes: // TODO: Consider graphql-codegen/fragment-matcher (https://the-guild.dev/blog/graphql-codegen-and-apollo-client-3)
  }),
  devtools: {
    enabled: true,
  },
});

function generateApolloClientLink(apiToken: string | null): ApolloLink {
  const authLink = setContext((_operation, { headers }) => {
    return {
      headers: {
        ...headers,
        Authorization: apiToken ? `Bearer ${apiToken}` : "",
      },
    };
  });

  return authLink.concat(httpLink);
}

export function changeApolloClientSession(
  apolloClient: ApolloClient<object>,
  apiToken: string | null,
) {
  console.log("[changeApolloClientSession]", { apiToken, apolloClient });
  apolloClient.clearStore();
  apolloClient.setLink(generateApolloClientLink(apiToken));
}

// function createApolloClient(apiToken: string | null) {
//   const auth = apiToken && apiToken.length > 0 ? `Bearer ${apiToken}` : "";
//   const errorLink = onError(({ networkError }) => {
//     if (networkError) {
//       console.log("[onErrorLink] networkError", { networkError });
//       if (Object.keys(networkError).includes("statusCode")) {
//         const serverError = networkError as ServerError;
//         if (serverError.statusCode === 401) {
//           // updateSession({ apiToken: null, isLoggedIn: false, user: null });
//         }
//       }
//     }
//   });
//   const httpLink = new HttpLink({
//     uri: "http://localhost:30001/graphql",
//     headers: {
//       Authorization: auth,
//     },
//   });
//   return new ApolloClient({
//     cache: new InMemoryCache(),
//     link: from([errorLink, httpLink]),
//     defaultOptions: {
//       mutate: {
//         errorPolicy: "all",
//       },
//     },
//   });
// }

// export default App;
