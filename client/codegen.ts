import { CodegenConfig } from "@graphql-codegen/cli";

const SCHEMA_PATH = process.env.SCHEMA_PATH || "http://localhost:30001/graphql";

const clientConfig: CodegenConfig["generates"] = {
  "./client/src/__generated__/": {
    preset: "client",
    plugins: [],
    presetConfig: {
      gqlTagName: "gql",
    },
  },
};

// If we are loading the schema from a server, save a local
// copy as a `.graphql` file, so the CI can use it for to
// speed up tests & lint.
if (SCHEMA_PATH.startsWith("http://")) {
  clientConfig["./schema.generated.graphql"] = {
    // documents: ["app/graphql/**/*.rb"],

    plugins: [
      "schema-ast",
      {
        add: {
          content: [
            "# THIS FILE IS AUTO-GENERATED, DO NOT MODIFY.",
            "# The source of truth is the API server",
            "# To re-generate, ensure the server is running on port 30001",
            "# and execute: yarn gql-compile",
            "#",
          ],
        },
      },
    ],
    config: {
      includeDirectives: true,
      commentDescriptions: true,
    },
  };
}

const config: CodegenConfig = {
  schema: SCHEMA_PATH,
  documents: {
    "client/src/**/*.{ts,tsx}": {},
    "app/graphql/**/*.rb": { require: false },
  },
  generates: clientConfig,
  ignoreNoDocuments: true,
};

export default config;
