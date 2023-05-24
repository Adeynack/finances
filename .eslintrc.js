module.exports = {
  env: {
    browser: true,
    es2021: true,
  },
  plugins: ["react", "@typescript-eslint", "react-hooks"],
  extends: [
    "plugin:react/recommended",
    "standard-with-typescript",
    "plugin:prettier/recommended",
  ],
  overrides: [],
  parserOptions: {
    ecmaVersion: "latest",
    sourceType: "module",
    project: "./tsconfig.json",
  },
  ignorePatterns: ["node_modules/"],
  rules: {
    "react/react-in-jsx-scope": "off",
    "react/jsx-uses-vars": "error",
    "react/jsx-uses-react": "error",
    "no-console": 2,
    "@typescript-eslint/explicit-function-return-type": [
      "error",
      {
        allowExpressions: true,
      },
    ],
    "@typescript-eslint/no-confusing-void-expression": [
      "error",
      {
        ignoreArrowShorthand: true,
      },
    ],
    "react/display-name": 0,
    "react/prop-types": 0,
    "react-hooks/rules-of-hooks": "error", // Checks rules of Hooks
    eqeqeq: 2,
    "@typescript-eslint/ban-types": 0,
  },
  settings: {
    react: {
      version: "detect",
    },
  },
};
