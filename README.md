# Finances (working name)

## Dev Ops

### Basic Development Workflow

This project is equipped with a [Visual Studio Code development container](https://code.visualstudio.com/docs/devcontainers/containers)
setup, along with a lunch configuration. After opening the project within its
container, start debugging on the _Run app_ configuration. All necessary elements
will start and you're goog to go.

| URL                             | Description                                |
| ------------------------------- | ------------------------------------------ |
| http://localhost:30001/graphiql | Rails server, hosting a _GraphiQL_ client. |
| http://localhost:30002          | Web client development server (_Vite_).    |

### Commands at a glance

| Title               | Command                   | Details                                                  |
| ------------------- | ------------------------- | -------------------------------------------------------- |
| Ruby Tests          | `bin/rspec`               |                                                          |
| Full Database Reset | `bin/rails db:reset:full` | See `lib/tasks/db.rake` for list of operation performed. |

### Ruby Code Coverage

Coverage is automatically detected and reported.

| ENV        | Effect                                                                                                            |
| ---------- | ----------------------------------------------------------------------------------------------------------------- |
| `COVERAGE` | When set, coverage will be skipped.                                                                               |
| `CI`       | When set, no HTML report will be generated.                                                                       |
| `MIN_COV`  | When set (or `CI` is), the test run fails if coverage is under a minimum (see `spec/spec_helpler.rb` for values). |
