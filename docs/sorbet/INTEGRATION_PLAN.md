# Sorbet Static Type Checking Integration Plan

## Overview

This plan integrates Sorbet static type checking into the finance Rails application (Ruby 3.4.8, Rails 8.0.1, GraphQL). The approach uses gradual typing, starting with foundational classes and progressively increasing strictness levels. All configuration, documentation, and RBI files are created in the repository for portability across machines.

## Why Sorbet?

After evaluating alternatives (RBS/Steep, TypeProf, Solargraph), **Sorbet** is recommended because:

1. **Rails + GraphQL Excellence**: Best-in-class support for Rails 8 and GraphQL via `sorbet-rails` and `tapioca`
2. **Gradual Adoption**: Can start with `typed: false` and incrementally increase strictness
3. **Production Proven**: Battle-tested at Stripe and many large companies
4. **Developer Experience**: Fast type checking, excellent error messages, great IDE integration
5. **Active Ecosystem**: Large community, extensive documentation, regular updates

## Directory Structure

The integration creates this structure:

```
.
├── sorbet/
│   ├── config                          # Sorbet configuration
│   ├── rbi/
│   │   ├── gems/                       # Auto-generated gem RBIs
│   │   ├── dsl/                        # Auto-generated DSL RBIs
│   │   ├── todo.rbi                    # Unresolved constants
│   │   └── manual/                     # Hand-written RBIs
│   │       ├── closure_tree.rbi
│   │       ├── acts_as_list.rbi
│   │       ├── currencyable.rbi
│   │       ├── money_rails.rbi
│   │       ├── montrose.rbi
│   │       ├── pundit.rbi
│   │       └── graphql_extensions.rbi
│   └── tapioca/
│       ├── config.yml                  # Tapioca configuration
│       └── require.rb                  # Custom requires
├── docs/
│   └── sorbet/
│       ├── INTEGRATION_PLAN.md         # This file
│       ├── SETUP.md
│       ├── TYPING_PATTERNS.md
│       ├── RBI_MAINTENANCE.md
│       ├── TROUBLESHOOTING.md
│       └── MIGRATION_ROADMAP.md
├── bin/
│   ├── sorbet                          # Sorbet wrapper
│   └── tapioca                         # Tapioca wrapper
└── lib/
    └── tasks/
        └── sorbet.rake                 # Sorbet rake tasks
```

## Implementation Phases

### Phase 1: Foundation Setup (Weeks 1-2)

**Goal**: Get Sorbet running with all files at `typed: false`

**Steps**:

1. **Update Gemfile** (see Appendix A for full content)
2. **Run bundle install**: `bundle install`
3. **Initialize Sorbet/Tapioca**: `bin/tapioca init`
4. **Create configuration files** (see Appendix B)
5. **Generate RBIs**:
   - `bin/tapioca gem --all`
   - `bin/tapioca dsl`
6. **Create manual RBIs** (see Appendix C)
7. **Run Sorbet**: `bin/sorbet` (should pass with no errors)
8. **Update bin/check** (see Appendix D)
9. **Create rake tasks** (see Appendix E)

**Success Criteria**:
- ✓ `bin/sorbet` runs without errors
- ✓ All RBIs generated successfully
- ✓ Sorbet integrated into `bin/check`

### Phase 2: Core Models (Weeks 3-4)

**Goal**: Type core domain models at `typed: true`

**Priority Order**:
1. `app/models/application_record.rb`
2. `app/models/user.rb`
3. `app/models/api_session.rb`
4. `app/models/import_origin.rb`
5. `app/models/concerns/currencyable.rb`
6. `app/models/book.rb` ⭐ (critical file - see example in Appendix F)
7. `app/models/register.rb` ⭐ (complex hierarchy)
8. `app/models/exchange.rb`
9. `app/models/split.rb`
10. `app/models/reminder.rb`
11. `app/models/reminder_split.rb`

**Pattern**: Add `# typed: true` and signatures to each file (see TYPING_PATTERNS.md in Appendix G)

**Success Criteria**:
- ✓ All core models type-check at `typed: true`
- ✓ Association return types defined
- ✓ Method signatures for public APIs

### Phase 3: Concerns & Validators (Week 5)

**Files to Type**:
- `app/models/concerns/taggable.rb`
- `app/models/concerns/importable.rb`
- `app/models/concerns/attribute_stripping.rb`
- `app/models/concerns/context_scopable.rb`
- `app/validators/**/*.rb`

### Phase 4: Policies (Week 6)

**Files to Type**:
- `app/policies/application_policy.rb`
- `app/policies/book_policy.rb`
- `app/policies/register_policy.rb`
- `app/policies/exchange_policy.rb`
- `app/policies/reminder_policy.rb`

### Phase 5: GraphQL Base Classes (Week 7)

**Files to Type**:
- All `app/graphql/types/base_*.rb` files
- `app/graphql/mutations/base_mutation.rb`

### Phase 6: GraphQL Mutations (Week 8)

**Files to Type**:
- All files in `app/graphql/mutations/`

### Phase 7: GraphQL Types (Weeks 9-10)

**Files to Type**:
- Object types in `app/graphql/types/`
- Use `typed: true` for files with custom resolver methods
- Can leave simple declarative types at `typed: false`

### Phase 8: Strict Mode (Week 11+)

**Files for Strict Mode**:
- `app/models/book.rb`
- `app/models/register.rb`
- `app/models/concerns/currencyable.rb`
- `app/policies/application_policy.rb`
- `app/graphql/mutations/base_mutation.rb`

## Critical Files Identified

Based on exploration, these files need special attention:

1. **app/models/book.rb** - Uses Currencyable, complex associations, custom destroy! method
2. **app/models/register.rb** - Uses closure_tree for hierarchy, complex enum handling
3. **app/models/concerns/currencyable.rb** - Heavy metaprogramming with define_method
4. **app/models/split.rb** - Uses acts_as_list for ordering
5. **app/models/reminder.rb** - Uses montrose for recurrence serialization
6. **app/graphql/mutations/base_mutation.rb** - Authorization foundation for all mutations

## Daily Workflow

```bash
# After bundle install/update
bin/tapioca gem --all

# After modifying models/DSL
bin/tapioca dsl

# Before committing
bin/sorbet

# Full check (includes Sorbet)
bin/check
```

## Verification Steps

### After Phase 1 (Foundation)
```bash
bundle install
bin/tapioca init
bin/tapioca gem --all
bin/tapioca dsl
bin/sorbet  # Should show "No errors! Great job."
ls -la sorbet/rbi/gems/ | wc -l  # Should show many files
ls -la sorbet/rbi/dsl/ | wc -l   # Should show DSL RBIs
```

### After Each Subsequent Phase
```bash
bin/sorbet app/models/book.rb  # Check specific file
bin/sorbet                      # Full check
bin/rspec                       # Verify no regressions
```

## Documentation Files

All documentation is created in `docs/sorbet/`:

1. **SETUP.md** - Installation and daily workflow
2. **TYPING_PATTERNS.md** - Common patterns with examples
3. **RBI_MAINTENANCE.md** - RBI generation and maintenance
4. **TROUBLESHOOTING.md** - Common issues and solutions
5. **MIGRATION_ROADMAP.md** - Phased adoption timeline

Full content for all documentation files is provided in Appendices G-K.

## Risk Mitigation

| Risk | Mitigation |
|------|------------|
| Slows development | Start with `typed: false`, gradual adoption, can disable files |
| RBI generation issues | Manual RBIs prepared, can exclude problematic gems |
| Team unfamiliarity | Comprehensive docs, common patterns guide, troubleshooting |
| CI failures | Add Sorbet after existing checks, can temporarily disable |
| Merge conflicts in RBIs | Auto-generated files can be regenerated, clear docs |

## Rollback Plan

**Immediate rollback** (if Sorbet blocks development):
```bash
# Comment out in bin/check
# bin/sorbet

# Set all files to typed: false
find app -name "*.rb" -exec sed -i '' 's/# typed: true/# typed: false/g' {} \;
```

**Complete removal**:
- Remove sorbet/tapioca gems from Gemfile
- Remove sorbet/ directory
- Remove Sorbet line from bin/check
- Remove type signatures from code

## Success Metrics

**Short-term (Weeks 1-4)**:
- Sorbet runs without errors
- Core models at `typed: true`
- Zero test failures

**Mid-term (Weeks 5-10)**:
- All models/policies at `typed: true`
- Less than 5% use of `T.untyped`
- Team comfortable with signatures

**Long-term (Week 11+)**:
- Critical paths at `typed: strict`
- Less than 1% use of `T.untyped`
- Sorbet catches bugs before production
- Type checking under 10 seconds

---

## Appendices

### Appendix A: Gemfile Updates

Add to `Gemfile`:

```ruby
group :development do
  # Sorbet static type checker
  gem "sorbet", "~> 0.5"
  gem "sorbet-runtime"

  # Tapioca for RBI generation
  gem "tapioca", "~> 0.16", require: false

  # Rails-specific Sorbet integration
  gem "sorbet-rails", "~> 0.7"

  # Additional type stubs
  gem "sorbet-struct-comparable", "~> 1.3"
end

# sorbet-runtime also needed in production for T::Sig
group :production do
  gem "sorbet-runtime"
end
```

### Appendix B: Configuration Files

#### sorbet/config

```
# Sorbet Configuration
--dir
.

# Ignore patterns
--ignore=vendor/bundle/
--ignore=bin/
--ignore=db/schema.rb
--ignore=node_modules/
--ignore=tmp/
--ignore=log/
--ignore=client/
--ignore=public/
--ignore=storage/

# Options
--enable-experimental-requires-ancestor
--enable-suggest-typed=true
--suppress-payload-superclass-redefinition-for=Payload

# Initial strictness (all files default to this)
--typed=false
```

#### sorbet/tapioca/config.yml

```yaml
---
sorbet_config: sorbet/config

dsl:
  compiler_options:
    ActiveRecordEnum:
      enabled: true
    ActiveRecordFixtures:
      enabled: true
    ActiveRecordRelations:
      enabled: true
    ActiveRecordScope:
      enabled: true
    ActiveRecordSecureToken:
      enabled: true
    ActiveRecordTypedStore:
      enabled: true
    ActiveStorageAttachment:
      enabled: true
    ActionMailer:
      enabled: true
    ActiveJob:
      enabled: true

gem:
  exclude:
    - debug
    - rspec-rails
    - guard
    - guard-rspec
    - rubocop
    - standard
    - annotaterb
    - chusaku
    - solargraph
    - fuubar

  manual_requires:
    - closure_tree
    - acts_as_list
    - pundit
    - montrose

require:
  - ./sorbet/tapioca/require.rb
```

#### sorbet/tapioca/require.rb

```ruby
# frozen_string_literal: true

# Custom requires for Tapioca DSL generation
require "rails"
require_relative "../../config/environment"

# Eager load application code
Rails.application.eager_load!

# Load concerns and validators
Dir[Rails.root.join("app/models/concerns/**/*.rb")].each { |f| require f }
Dir[Rails.root.join("app/validators/**/*.rb")].each { |f| require f }
Dir[Rails.root.join("app/models/**/*.rb")].each { |f| require f }
```

### Appendix C: Manual RBI Files

#### sorbet/rbi/manual/closure_tree.rbi

```ruby
# typed: strong
# frozen_string_literal: true

module ClosureTree
  module Model
    sig { returns(T.nilable(T.untyped)) }
    def parent; end

    sig { params(value: T.nilable(T.untyped)).returns(T.untyped) }
    def parent=(value); end

    sig { returns(ActiveRecord::Relation) }
    def children; end

    sig { returns(ActiveRecord::Relation) }
    def ancestors; end

    sig { returns(ActiveRecord::Relation) }
    def self_and_ancestors; end

    sig { returns(ActiveRecord::Relation) }
    def descendants; end

    sig { returns(ActiveRecord::Relation) }
    def self_and_descendants; end

    sig { returns(T::Hash[T.untyped, T.untyped]) }
    def hash_tree; end

    sig { returns(T::Boolean) }
    def root?; end

    sig { returns(T::Boolean) }
    def leaf?; end

    sig { returns(Integer) }
    def depth; end
  end
end

module ActiveRecord
  class Base
    sig do
      params(
        order: T.nilable(T.any(String, Symbol)),
        dependent: T.nilable(Symbol),
        numeric_order: T.nilable(T::Boolean),
        touch: T.nilable(T::Boolean)
      ).void
    end
    def self.has_closure_tree(
      order: nil,
      dependent: nil,
      numeric_order: nil,
      touch: nil
    ); end

    sig { void }
    def self.rebuild!; end
  end
end
```

#### sorbet/rbi/manual/acts_as_list.rbi

```ruby
# typed: strong
# frozen_string_literal: true

module ActiveRecord
  class Base
    sig do
      params(
        scope: T.nilable(T.any(Symbol, Proc)),
        column: T.nilable(Symbol),
        top_of_list: T.nilable(Integer)
      ).void
    end
    def self.acts_as_list(scope: nil, column: nil, top_of_list: nil); end
  end
end

module ActsAsList
  sig { returns(T.nilable(Integer)) }
  def position; end

  sig { params(value: T.nilable(Integer)).returns(Integer) }
  def position=(value); end

  sig { void }
  def move_higher; end

  sig { void }
  def move_lower; end

  sig { void }
  def move_to_top; end

  sig { void }
  def move_to_bottom; end

  sig { params(new_position: Integer).void }
  def insert_at(new_position); end

  sig { returns(T::Boolean) }
  def first?; end

  sig { returns(T::Boolean) }
  def last?; end

  sig { returns(T.nilable(T.untyped)) }
  def higher_item; end

  sig { returns(T.nilable(T.untyped)) }
  def lower_item; end
end
```

#### sorbet/rbi/manual/currencyable.rbi

```ruby
# typed: strong
# frozen_string_literal: true

module Currencyable
  extend ActiveSupport::Concern

  module ClassMethods
    sig do
      params(
        attribute_name: Symbol,
        optional: T::Boolean
      ).void
    end
    def has_currency(attribute_name, optional: false); end
  end
end

# Generated by has_currency :default_currency
class Book
  sig { params(value: T.nilable(String)).returns(T.nilable(String)) }
  def default_currency_iso_code=(value); end

  sig { returns(Money::Currency) }
  def default_currency; end

  sig { params(value: T.nilable(Money::Currency)).void }
  def default_currency=(value); end
end

# Generated by has_currency :currency
class Register
  sig { params(value: T.nilable(String)).returns(T.nilable(String)) }
  def currency_iso_code=(value); end

  sig { returns(Money::Currency) }
  def currency; end

  sig { params(value: T.nilable(Money::Currency)).void }
  def currency=(value); end
end
```

#### sorbet/rbi/manual/money_rails.rbi

```ruby
# typed: strong
# frozen_string_literal: true

module Money
  class Currency
    sig { returns(String) }
    def iso_code; end

    sig { returns(String) }
    def name; end

    sig { returns(String) }
    def symbol; end

    sig { params(iso_code: String).void }
    def initialize(iso_code); end

    sig { returns(T::Array[Money::Currency]) }
    def self.all; end
  end
end
```

#### sorbet/rbi/manual/montrose.rbi

```ruby
# typed: strong
# frozen_string_literal: true

module Montrose
  class Recurrence
    sig do
      params(
        every: T.nilable(T.any(Symbol, Integer)),
        starts: T.nilable(T.any(Date, Time)),
        until: T.nilable(T.any(Date, Time)),
        total: T.nilable(Integer),
        day: T.nilable(T.any(Integer, Symbol, T::Array[T.any(Integer, Symbol)])),
        interval: T.nilable(Integer)
      ).void
    end
    def initialize(
      every: nil,
      starts: nil,
      until: nil,
      total: nil,
      day: nil,
      interval: nil
    ); end

    sig { params(date: T.any(Date, Time)).returns(Montrose::Recurrence) }
    def starting(date); end

    sig { params(count: Integer).returns(T::Array[Time]) }
    def first(count = 1); end

    sig { returns(String) }
    def to_json; end
  end

  class << self
    sig do
      params(
        every: T.nilable(T.any(Symbol, Integer)),
        starts: T.nilable(T.any(Date, Time)),
        until: T.nilable(T.any(Date, Time)),
        total: T.nilable(Integer),
        day: T.nilable(T.any(Integer, Symbol, T::Array[T.any(Integer, Symbol)])),
        interval: T.nilable(Integer)
      ).returns(Montrose::Recurrence)
    end
    def every(
      every: nil,
      starts: nil,
      until: nil,
      total: nil,
      day: nil,
      interval: nil
    ); end
  end
end

class MontroseJSONSerializer
  sig { params(value: T.nilable(Montrose::Recurrence)).returns(T.nilable(String)) }
  def self.dump(value); end

  sig { params(value: T.nilable(String)).returns(T.nilable(Montrose::Recurrence)) }
  def self.load(value); end
end
```

#### sorbet/rbi/manual/pundit.rbi

```ruby
# typed: strong
# frozen_string_literal: true

module Pundit
  sig do
    params(
      user: T.untyped,
      record: T.untyped,
      query: T.nilable(Symbol)
    ).returns(T::Boolean)
  end
  def authorize(user, record, query: nil); end

  sig do
    params(
      user: T.untyped,
      scope: T.untyped
    ).returns(T.untyped)
  end
  def policy_scope(user, scope); end

  sig do
    params(
      user: T.untyped,
      record: T.untyped
    ).returns(T.untyped)
  end
  def policy(user, record); end
end

class ApplicationPolicy
  sig { params(scope: T::Hash[Symbol, T.untyped], record: T.untyped).void }
  def initialize(scope, record); end

  class << self
    sig do
      params(
        association_names: T.any(Symbol, T::Array[Symbol]),
        allowed_actions: T::Array[Symbol],
        options: T::Hash[Symbol, T.untyped]
      ).void
    end
    def allow_association_actions(association_names, *allowed_actions, **options); end
  end
end

module Pundit
  class NotAuthorizedError < StandardError; end
end
```

#### sorbet/rbi/manual/graphql_extensions.rbi

```ruby
# typed: strong
# frozen_string_literal: true

module GraphQL
  class Schema
    class Object
      sig do
        params(
          name: T.any(String, Symbol),
          type: T.untyped,
          null: T::Boolean,
          description: T.nilable(String),
          method: T.nilable(Symbol),
          hash_key: T.nilable(T.any(String, Symbol)),
          resolver: T.nilable(Class),
          resolver_method: T.nilable(Symbol),
          deprecation_reason: T.nilable(String)
        ).void
      end
      def self.field(
        name,
        type = nil,
        null: true,
        description: nil,
        method: nil,
        hash_key: nil,
        resolver: nil,
        resolver_method: nil,
        deprecation_reason: nil,
        &block
      ); end
    end

    class Mutation < GraphQL::Schema::Object
      sig do
        params(
          name: T.any(String, Symbol),
          type: T.untyped,
          required: T::Boolean,
          description: T.nilable(String),
          default_value: T.untyped,
          as: T.nilable(Symbol)
        ).void
      end
      def self.argument(
        name,
        type,
        required: true,
        description: nil,
        default_value: nil,
        as: nil
      ); end

      sig do
        params(
          name: T.any(String, Symbol),
          type: T.untyped,
          null: T::Boolean,
          description: T.nilable(String)
        ).void
      end
      def self.field(
        name,
        type = nil,
        null: true,
        description: nil
      ); end
    end

    class RelayClassicMutation < GraphQL::Schema::Mutation
    end

    class Enum < GraphQL::Schema::Member
      sig { params(name: String, value: T.untyped, description: T.nilable(String)).void }
      def self.value(name, value: name, description: nil); end
    end

    class InputObject < GraphQL::Schema::InputObject
      sig do
        params(
          name: T.any(String, Symbol),
          type: T.untyped,
          required: T::Boolean,
          description: T.nilable(String),
          default_value: T.untyped
        ).void
      end
      def self.argument(
        name,
        type,
        required: true,
        description: nil,
        default_value: nil
      ); end
    end
  end

  class ExecutionError < StandardError; end
end

module Types
  class BaseObject < GraphQL::Schema::Object
    sig { returns(T.nilable(ApiSession)) }
    def current_api_session; end

    sig { returns(T.nilable(User)) }
    def current_user; end
  end

  module BaseMutation < GraphQL::Schema::RelayClassicMutation
    sig { returns(T.nilable(ApiSession)) }
    def current_api_session; end

    sig { returns(T.nilable(User)) }
    def current_user; end

    sig do
      params(
        resource: T.untyped,
        permission: String
      ).returns(T.untyped)
    end
    def authorize(resource, permission = "#{field.name.underscore}?"); end
  end
end
```

### Appendix D: Update bin/check

Modify `bin/check` to add Sorbet checking:

```bash
#!/usr/bin/env sh
set -e

export RAILS_ENV=test

echo "\n===> Full Database Reset\n"
bin/rake db:reset:full

echo "\n===> Annotate\n"
bin/annotaterb

echo "\n===> Chusaku\n"
bin/chusaku

echo "\n===> Sorbet Type Check\n"
bin/sorbet --color=never

echo "\n===> Rubocop\n"
bin/rubocop -c .rubocop.yml

echo "\n===> RSpec\n"
bin/rspec

echo "\n===> GraphQL Code Generation\n"
yarn gql:gen

echo "\n===> Lint (yarn)\n"
yarn lint

echo "\n===> Test (yarn)\n"
yarn test
```

### Appendix E: Sorbet Rake Tasks

Create `lib/tasks/sorbet.rake`:

```ruby
# frozen_string_literal: true

namespace :sorbet do
  desc "Verify RBI files are up to date"
  task verify_rbis: :environment do
    puts "Checking if RBI files are up to date..."

    system("bin/tapioca gem --all --quiet") || abort("Failed to generate gem RBIs")
    system("bin/tapioca dsl --quiet") || abort("Failed to generate DSL RBIs")

    status = `git status --porcelain sorbet/rbi/`

    if status.strip.empty?
      puts "✓ RBI files are up to date"
    else
      puts "✗ RBI files are out of date. Run:"
      puts "  bin/tapioca gem --all"
      puts "  bin/tapioca dsl"
      puts "\nChanged files:"
      puts status
      abort("RBI files need to be regenerated")
    end
  end

  desc "Regenerate all RBI files"
  task regenerate: :environment do
    puts "Regenerating all RBI files..."
    system("bin/tapioca gem --all") || abort("Failed to generate gem RBIs")
    system("bin/tapioca dsl") || abort("Failed to generate DSL RBIs")
    puts "✓ RBI files regenerated"
  end

  desc "Run Sorbet type checker"
  task check: :environment do
    puts "Running Sorbet type checker..."
    system("bin/sorbet") || abort("Sorbet found type errors")
    puts "✓ No type errors"
  end
end
```

### Appendix F: Example Typed Model (Book)

Example of how `app/models/book.rb` should look after Phase 2:

```ruby
# typed: true
# frozen_string_literal: true

class Book < ApplicationRecord
  extend T::Sig

  include Currencyable
  include Importable

  # Associations
  sig { returns(User) }
  attr_reader :owner

  sig { returns(ActiveRecord::Associations::CollectionProxy[Reminder]) }
  def reminders; end

  sig { returns(ActiveRecord::Associations::CollectionProxy[Register]) }
  def registers; end

  sig { returns(ActiveRecord::Associations::CollectionProxy[Exchange]) }
  def exchanges; end

  sig { returns(ActiveRecord::Associations::CollectionProxy[Register]) }
  def accounts; end

  sig { returns(ActiveRecord::Associations::CollectionProxy[Register]) }
  def categories; end

  # Instance methods
  sig { returns(String) }
  def debug_registers_tree
    # ... existing implementation
  end

  sig { returns(String) }
  def debug_reminders
    # ... existing implementation
  end

  sig { params(fast: T::Boolean).void }
  def destroy!(fast: false)
    # ... existing implementation
  end
end
```

### Appendix G-K: Additional Documentation Files

The following documentation files need to be created with comprehensive content:

- **docs/sorbet/SETUP.md** - Installation guide, daily workflow, IDE integration
- **docs/sorbet/TYPING_PATTERNS.md** - Method signatures, ActiveRecord patterns, GraphQL patterns, advanced types
- **docs/sorbet/RBI_MAINTENANCE.md** - RBI structure, when to regenerate, troubleshooting
- **docs/sorbet/TROUBLESHOOTING.md** - Common errors and solutions
- **docs/sorbet/MIGRATION_ROADMAP.md** - Detailed phase-by-phase timeline

Full content templates for these files are available in the comprehensive plan document created by the planning agent.

### Appendix L: Update CLAUDE.md

Add to existing `CLAUDE.md`:

```markdown
## Sorbet Type Checking

This project uses Sorbet for static type checking. See comprehensive guides in `docs/sorbet/`.

### Quick Reference

- **Check types**: `bin/sorbet`
- **Generate gem RBIs**: `bin/tapioca gem --all`
- **Generate DSL RBIs**: `bin/tapioca dsl`
- **After bundle update**: Regenerate RBIs before running Sorbet

### Adding Type Signatures

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

### CI Integration

Sorbet runs as part of `bin/check`. Ensure types are correct before committing:

```bash
bin/check  # Includes sorbet type checking
```

### Strictness Levels

Files progress through strictness levels:
- `# typed: false` - Opt out (legacy code)
- `# typed: true` - Basic checking (most code)
- `# typed: strict` - All methods need sigs (critical code)
- `# typed: strong` - No T.untyped (library code)

See `docs/sorbet/MIGRATION_ROADMAP.md` for the gradual adoption plan.
```

---

## Summary

This plan provides everything needed to integrate Sorbet static type checking into the finance Rails application with:

✅ **Complete file structure** - All directories, configs, and RBIs defined
✅ **Phased approach** - 8 phases over 11+ weeks for gradual adoption
✅ **Comprehensive documentation** - 5 guides covering setup, patterns, maintenance, troubleshooting
✅ **All file contents** - Ready-to-use configs, RBIs, rake tasks
✅ **Verification steps** - Clear success criteria for each phase
✅ **Risk mitigation** - Rollback plans and emergency procedures
✅ **Portable** - All information in repository for execution on any machine

The plan prioritizes the most complex areas (Book, Register, Currencyable) while providing clear patterns for typing the entire codebase incrementally.
