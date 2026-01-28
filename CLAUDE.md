# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a personal finance management application built with:
- **Backend**: Ruby 3.4.8 + Rails 8.1.2 with GraphQL API (using graphql-ruby)
- **Frontend**: React + TypeScript with Vite, Apollo Client, and Ant Design
- **Database**: PostgreSQL with UUID primary keys
- **Development**: VS Code Dev Container setup with Overmind for process management

The application manages Books (financial accounts), Registers (accounts and categories in a tree structure), Exchanges (transactions), Splits (transaction line items), Reminders (recurring transactions), and Tags.

## Development Commands

### Starting the Development Environment

```bash
bin/dev
```

Starts all services via Overmind (Rails server on port 30001, Vite dev server on port 30002, GraphQL code generation watcher).

### Running Tests

```bash
# Run all Ruby tests
bin/rspec

# Run a single test file
bin/rspec spec/path/to/file_spec.rb

# Run a specific test by line number
bin/rspec spec/path/to/file_spec.rb:42
```

### Code Quality & Linting

```bash
# Full check suite (database reset, annotate, sorbet, rubocop, rspec, graphql codegen, yarn lint & test)
bin/check

# Ruby linting
bin/rubocop

# Ruby auto-fix
bin/rubocop -a

# Sorbet type checking
bin/sorbet

# TypeScript/React linting
yarn lint              # All linting checks
yarn lint:types        # TypeScript type checking
yarn lint:style        # ESLint
yarn lint:format       # Prettier format checking
```

### Database Operations

```bash
# Full database reset (drop, create, migrate, load fixtures, seed)
bin/rails db:reset:full

# Standard migrations
bin/rails db:migrate
bin/rails db:rollback
```

### GraphQL Code Generation

```bash
# Generate TypeScript types from GraphQL schema
yarn gql:gen

# Watch mode (runs automatically via bin/dev)
yarn gql:gen --watch
```

The schema is introspected from the running Rails server (port 30001) and saved to `schema.generated.graphql`. Generated TypeScript types go to `client/src/__generated__/`.

### Annotations

```bash
# Annotate models with schema information
bin/annotaterb

# Annotate routes in controllers
bin/chusaku
```

### Sorbet Type Checking

This project uses Sorbet for static type checking. See comprehensive guides in `docs/sorbet/`.

```bash
# Check types
bin/sorbet

# Generate gem RBIs (after bundle install/update)
bin/tapioca gem --all

# Generate DSL RBIs (after modifying models/DSL)
bin/tapioca dsl

# Regenerate all RBIs
bin/rake sorbet:regenerate

# Verify RBIs are up to date
bin/rake sorbet:verify_rbis
```

**Quick Reference for Adding Type Signatures:**

When creating or modifying Ruby files:

1. Add strictness sigil at top: `# typed: true`
2. Add `extend T::Sig` to class/module
3. Add signatures to public methods:
```ruby
sig { params(name: String).returns(String) }
def greet(name)
  "Hello, #{name}"
end
```

See `docs/sorbet/TYPING_PATTERNS.md` for comprehensive examples.

**Strictness Levels:**
- `# typed: false` - Opt out (legacy code)
- `# typed: true` - Basic checking (most code)
- `# typed: strict` - All methods need sigs (critical code)
- `# typed: strong` - No T.untyped (library code)

See `docs/sorbet/MIGRATION_ROADMAP.md` for the gradual adoption plan.

## Architecture

### Domain Model

The core entities follow a double-entry accounting structure:

- **Book**: Top-level container for a set of financial accounts, owned by a User
- **Register**: Hierarchical structure (using closure_tree) representing either:
  - **Accounts**: Where money is held (bank accounts, cash, credit cards)
  - **Categories**: Classification of transactions (income, expenses)
- **Exchange**: A financial transaction, belongs to a Register (the source)
- **Split**: Line items of an Exchange, each pointing to a Register (destinations)
- **Reminder**: Templates for recurring transactions with scheduling (using montrose gem)
- **Tag**: Free-form labels for Exchanges via polymorphic Tagging join table

All models use UUID primary keys. Currency handling is via money-rails gem.

### GraphQL API

- Schema defined in `app/graphql/finances_schema.rb`
- Mutations in `app/graphql/mutations/`
- Types in `app/graphql/types/`
- Uses Relay-style object identification with GlobalID
- Max depth: 15, max complexity: 300, max page size: 20
- Authorization via Pundit (policies in `app/policies/`)
- Error handling: Pundit::NotAuthorizedError returns generic message for security

Key conventions:
- Input types use `_input_type` suffix (e.g., `AccountForCreateInputType`)
- Enum types use `_type` suffix (e.g., `ExchangeStatusType`)
- All GraphQL types inherit from Base classes in `app/graphql/types/base_*.rb`

### Frontend Structure

Located in `client/src/`:
- `main.tsx`: Entry point with Apollo Client setup
- `App.tsx`: Root component
- `AppRouter.tsx`: React Router routes
- `components/`: Reusable UI components
- `pages/`: Route-specific page components
- `models/`: TypeScript domain models
- `__generated__/`: Auto-generated GraphQL types (do not edit manually)

### Models and Concerns

Key concerns in `app/models/concerns/`:
- **Currencyable**: Adds currency field validation via money-rails
- **Taggable**: Polymorphic tagging support
- **Importable**: Import tracking via `import_origin` association
- **AttributeStripping**: Automatic whitespace trimming

### Testing

- RSpec for Ruby tests (configured in `spec/rails_helper.rb` and `spec/spec_helper.rb`)
- Code coverage via SimpleCov with minimum thresholds (80% line, 55% branch)
- Coverage enforced when `MIN_COV` or `CI` env var is set
- Helpers in `spec/support/` (auth_helper, request_helper)

## Configuration

### Ruby Version

Uses `.ruby-version` file (currently 3.4.8). The version is read by Gemfile.

### Code Style

- **Ruby**: Standard + RuboCop with multiple plugins (rails, performance, rspec, graphql, rake)
  - Config in `.rubocop.yml` inherits from shimmer gem's base config
  - Target Ruby version: 3.4.8
- **TypeScript/React**: ESLint 9 with TypeScript, React Hooks, Prettier integration
  - Config in `eslint.config.js`
  - Prettier for formatting
  - Type checking via TypeScript 5.8.3

### Timezone

Application timezone is set to "Berlin" in `config/application.rb`.

### Autoloading

Custom autoload paths include:
- `app/models/accounts/`
- `app/models/categories/`
- `app/models/refinements/`
- `app/validators/`

## Special Features

### Import System

The application supports importing data from MoneyDance format. Scripts are in `scripts/import/moneydance/`.

### Book Deletion

Books have a special `destroy!(fast: true)` method that uses raw SQL for performance when deleting large datasets.

### Guard

Guard is configured (in `Guardfile`) for running RSpec tests automatically during development.

## Deployment Notes

- Runs on Puma web server
- CORS configured via rack-cors gem
- Session management via api_sessions table with bcrypt for password hashing
- Docker support with Dockerfile and docker-compose setup in `.devcontainer/`

## GraphQL Endpoints

- GraphQL API: `POST /graphql`
- GraphiQL IDE: `GET /graphiql` (development only)
- Health check: `GET /up`

## Dependencies of Note

- **acts_as_list**: Ordered lists
- **closure_tree**: Hierarchical data (Register tree)
- **kaminari**: Pagination
- **pundit**: Authorization
- **montrose**: Recurring schedule management
- **iban-tools**: IBAN validation
- **shimmer**: Shared Rails configuration
- **sorbet**: Static type checking for Ruby
- **tapioca**: RBI (Ruby Interface) file generator for Sorbet
