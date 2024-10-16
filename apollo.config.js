module.exports = {
  client: {
    service: {
      name: "Finances",
      localSchemaFile: "./schema.generated.graphql",
      // url: "http://localhost:30001/graphql",
    },
    includes: ["client/src/**/*.ts", "client/src/**/*.tsx"],
    excludes: ["**/node_modules/**", "**/__generated__/**"],
  },
};
