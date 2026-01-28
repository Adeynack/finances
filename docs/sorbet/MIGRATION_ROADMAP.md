# Sorbet Migration Roadmap

This document outlines the phased approach for gradually adopting Sorbet static type checking across the codebase.

## Overview

The migration follows an 8-phase approach over approximately 11+ weeks, starting with foundational setup and progressively increasing strictness levels. Each phase has clear success criteria and builds on the previous phase.

## Strictness Levels

Sorbet supports multiple strictness levels via the `# typed:` sigil at the top of each file:

| Level | Description | When to Use |
|-------|-------------|-------------|
| `# typed: false` | No type checking | Legacy code, test files, or temporary opt-out |
| `# typed: true` | Basic type checking | Most application code (default target) |
| `# typed: strict` | All methods need sigs | Critical business logic, core domain models |
| `# typed: strong` | No `T.untyped` allowed | Library code, shared utilities |

## Phase 1: Foundation Setup (Weeks 1-2)

**Goal**: Get Sorbet running with all files at `typed: false`

### Tasks

1. ✅ Add Sorbet gems to Gemfile
2. ✅ Run `bundle install`
3. ✅ Create configuration files (`sorbet/config`, `sorbet/tapioca/config.yml`)
4. ✅ Create manual RBIs for gems (closure_tree, acts_as_list, etc.)
5. ⬜ Initialize Tapioca: `bin/tapioca init`
6. ⬜ Generate gem RBIs: `bin/tapioca gem --all`
7. ⬜ Generate DSL RBIs: `bin/tapioca dsl`
8. ⬜ Verify Sorbet runs: `bin/sorbet`
9. ⬜ Update `bin/check` to include Sorbet
10. ⬜ Create rake tasks (`lib/tasks/sorbet.rake`)

### Success Criteria

- ✅ `bin/sorbet` runs without errors
- ✅ All RBIs generated successfully
- ✅ Sorbet integrated into `bin/check`
- ✅ Documentation created in `docs/sorbet/`

### Estimated Time

2 weeks (includes learning curve and documentation)

---

## Phase 2: Core Models (Weeks 3-4)

**Goal**: Type core domain models at `typed: true`

### Priority Order

Type these files in order (each builds on the previous):

1. `app/models/application_record.rb` - Base class for all models
2. `app/models/user.rb` - Simple model, good starting point
3. `app/models/api_session.rb` - Simple model with bcrypt
4. `app/models/import_origin.rb` - Simple model, referenced by others
5. `app/models/concerns/currencyable.rb` - Core concern (already has manual RBI)
6. `app/models/book.rb` ⭐ **CRITICAL** - Uses Currencyable, complex associations
7. `app/models/register.rb` ⭐ **CRITICAL** - Uses closure_tree, complex hierarchy
8. `app/models/exchange.rb` - References Register, has enums
9. `app/models/split.rb` - Uses acts_as_list, references Register and Exchange
10. `app/models/reminder.rb` - Uses montrose, complex recurrence logic
11. `app/models/reminder_split.rb` - References Reminder and Register

### Pattern for Each File

```ruby
# typed: true
# frozen_string_literal: true

class Book < ApplicationRecord
  extend T::Sig

  # Association types
  sig { returns(User) }
  attr_reader :owner

  sig { returns(ActiveRecord::Associations::CollectionProxy[Register]) }
  def registers; end

  # Public method signatures
  sig { returns(String) }
  def debug_registers_tree
    # ... implementation
  end

  sig { params(fast: T::Boolean).void }
  def destroy!(fast: false)
    # ... implementation
  end
end
```

### Success Criteria

- ✅ All core models type-check at `typed: true`
- ✅ Association return types defined
- ✅ Method signatures for all public methods
- ✅ Zero test failures
- ✅ `bin/sorbet` passes

### Estimated Time

2 weeks (1-2 models per day)

---

## Phase 3: Concerns & Validators (Week 5)

**Goal**: Type all concerns and validators at `typed: true`

### Files to Type

**Concerns** (`app/models/concerns/`):
- `taggable.rb` - Polymorphic association concern
- `importable.rb` - Import tracking concern
- `attribute_stripping.rb` - String normalization
- `context_scopable.rb` - Scoping by context

**Validators** (`app/validators/`):
- All validator files (if any)

### Pattern for Concerns

```ruby
# typed: true
module Taggable
  extend T::Sig
  extend ActiveSupport::Concern

  sig { returns(T::Array[String]) }
  def tag_names
    tags.map(&:name)
  end

  sig { params(name: String).void }
  def add_tag(name)
    tags << Tag.find_or_create_by(name: name)
  end
end
```

### Success Criteria

- ✅ All concerns at `typed: true`
- ✅ All validators at `typed: true`
- ✅ Zero test failures

### Estimated Time

1 week

---

## Phase 4: Policies (Week 6)

**Goal**: Type all Pundit policies at `typed: true`

### Files to Type

1. `app/policies/application_policy.rb` - Base policy
2. `app/policies/book_policy.rb`
3. `app/policies/register_policy.rb`
4. `app/policies/exchange_policy.rb`
5. `app/policies/reminder_policy.rb`
6. Any other policy files

### Pattern for Policies

```ruby
# typed: true
class BookPolicy < ApplicationPolicy
  extend T::Sig

  sig { returns(T::Boolean) }
  def show?
    owner? || shared_with_user?
  end

  sig { returns(T::Boolean) }
  def update?
    owner?
  end

  private

  sig { returns(T::Boolean) }
  def owner?
    scope[:current_user] == record.owner
  end
end
```

### Success Criteria

- ✅ All policies at `typed: true`
- ✅ Authorization methods properly typed
- ✅ Zero test failures

### Estimated Time

1 week

---

## Phase 5: GraphQL Base Classes (Week 7)

**Goal**: Type all GraphQL base classes at `typed: true`

### Files to Type

1. `app/graphql/types/base_object.rb`
2. `app/graphql/types/base_enum.rb`
3. `app/graphql/types/base_field.rb`
4. `app/graphql/types/base_input_object.rb`
5. `app/graphql/types/base_interface.rb`
6. `app/graphql/types/base_scalar.rb`
7. `app/graphql/types/base_union.rb`
8. `app/graphql/mutations/base_mutation.rb` ⭐ **CRITICAL**

### Pattern for Base Classes

```ruby
# typed: true
module Types
  class BaseObject < GraphQL::Schema::Object
    extend T::Sig

    sig { returns(T.nilable(ApiSession)) }
    def current_api_session
      context[:current_api_session]
    end

    sig { returns(T.nilable(User)) }
    def current_user
      current_api_session&.user
    end
  end
end
```

### Success Criteria

- ✅ All base classes at `typed: true`
- ✅ Helper methods properly typed
- ✅ Zero test failures
- ✅ GraphQL introspection still works

### Estimated Time

1 week

---

## Phase 6: GraphQL Mutations (Week 8)

**Goal**: Type all GraphQL mutations at `typed: true`

### Files to Type

All files in `app/graphql/mutations/`:
- Create mutations
- Update mutations
- Delete mutations
- Custom mutations

### Pattern for Mutations

```ruby
# typed: true
module Mutations
  class CreateBook < BaseMutation
    extend T::Sig

    argument :name, String, required: true
    argument :default_currency_iso_code, String, required: true

    field :book, Types::BookType, null: true
    field :errors, [String], null: false

    sig do
      params(
        name: String,
        default_currency_iso_code: String
      ).returns(T::Hash[Symbol, T.untyped])
    end
    def resolve(name:, default_currency_iso_code:)
      authorize(current_user, :create_book?)

      book = current_user.books.create(
        name: name,
        default_currency_iso_code: default_currency_iso_code
      )

      if book.persisted?
        { book: book, errors: [] }
      else
        { book: nil, errors: book.errors.full_messages }
      end
    end
  end
end
```

### Success Criteria

- ✅ All mutations at `typed: true`
- ✅ `resolve` methods properly typed
- ✅ Authorization calls typed
- ✅ Zero test failures

### Estimated Time

1 week

---

## Phase 7: GraphQL Types (Weeks 9-10)

**Goal**: Type all GraphQL object types at `typed: true`

### Files to Type

All object types in `app/graphql/types/`:
- `book_type.rb`
- `register_type.rb`
- `exchange_type.rb`
- `split_type.rb`
- `reminder_type.rb`
- Enum types
- Input types

### Strategy

**For simple declarative types** (no custom resolvers):
- Can leave at `# typed: false` (optional)
- Field definitions are typed by GraphQL gem

**For types with custom resolvers**:
- Use `# typed: true`
- Add signatures to resolver methods

### Pattern for Types with Custom Resolvers

```ruby
# typed: true
module Types
  class BookType < Types::BaseObject
    extend T::Sig

    field :id, ID, null: false
    field :name, String, null: false
    field :default_currency_code, String, null: false

    # Custom resolver with signature
    sig { returns(String) }
    def default_currency_code
      object.default_currency.iso_code
    end

    # Field with authorization
    sig { returns(T::Array[Types::RegisterType]) }
    def registers
      authorize(object, :show?)
      object.registers
    end
  end
end
```

### Success Criteria

- ✅ All types with custom resolvers at `typed: true`
- ✅ Custom resolver methods properly typed
- ✅ Authorization in types properly typed
- ✅ Zero test failures
- ✅ GraphQL queries still work

### Estimated Time

2 weeks (many files, but simple changes)

---

## Phase 8: Strict Mode (Week 11+)

**Goal**: Increase strictness for critical files to `typed: strict`

### Files for Strict Mode

These files are critical and should have all methods signed:

1. `app/models/book.rb` - Core domain model
2. `app/models/register.rb` - Complex hierarchy
3. `app/models/concerns/currencyable.rb` - Currency handling
4. `app/policies/application_policy.rb` - Authorization base
5. `app/graphql/mutations/base_mutation.rb` - Mutation base

### Pattern for Strict Mode

```ruby
# typed: strict
# frozen_string_literal: true

class Book < ApplicationRecord
  extend T::Sig

  # MUST have signatures for ALL methods, including private

  sig { returns(User) }
  attr_reader :owner

  sig { returns(String) }
  def debug_registers_tree
    # ...
  end

  private

  # Even private methods need signatures in strict mode
  sig { returns(T::Boolean) }
  def valid_currency?
    Money::Currency.all.include?(default_currency)
  end
end
```

### Success Criteria

- ✅ Critical files at `typed: strict`
- ✅ All methods (including private) have signatures
- ✅ Less than 1% use of `T.untyped`
- ✅ Zero test failures
- ✅ Performance: Sorbet check under 10 seconds

### Estimated Time

Ongoing (1-2 files per week)

---

## Progress Tracking

### Metrics to Track

**Coverage**:
- % of files with `typed: true` or higher
- % of files with `typed: strict` or higher
- % of public methods with signatures

**Quality**:
- Number of `T.untyped` usages
- Number of `T.must` usages (should be minimal)
- Sorbet check time (should stay under 10 seconds)

**Safety**:
- Number of bugs caught by Sorbet before production
- Number of nil-related production errors (should decrease)

### Check Progress

```bash
# Count files by strictness level
grep -r "# typed: false" app/ | wc -l
grep -r "# typed: true" app/ | wc -l
grep -r "# typed: strict" app/ | wc -l

# Count T.untyped usages
grep -r "T.untyped" app/ | wc -l

# Sorbet check time
time bin/sorbet
```

---

## Weekly Goals

### Week 1-2: Foundation
- [ ] Install Sorbet and Tapioca
- [ ] Generate all RBIs
- [ ] Integrate into `bin/check`
- [ ] Create documentation

### Week 3: Core Models (Part 1)
- [x] ApplicationRecord, User, ApiSession
- [x] ImportOrigin
- [x] Currencyable concern

### Week 4: Core Models (Part 2)
- [x] Book (critical)
- [x] Register (critical)
- [x] Exchange

### Week 5: Core Models (Part 3) + Concerns
- [x] Split, Reminder, ReminderSplit
- [ ] All other concerns and validators

### Week 6: Policies
- [ ] ApplicationPolicy
- [ ] All domain policies

### Week 7: GraphQL Bases
- [ ] All base GraphQL classes
- [ ] BaseMutation (critical)

### Week 8: GraphQL Mutations
- [ ] All create mutations
- [ ] All update mutations
- [ ] All delete mutations

### Week 9-10: GraphQL Types
- [ ] All object types with custom resolvers
- [ ] Enum types
- [ ] Input types

### Week 11+: Strict Mode
- [ ] Book → strict
- [ ] Register → strict
- [ ] Currencyable → strict
- [ ] Other critical files → strict

---

## Risk Mitigation

### If Sorbet Blocks Development

1. **Temporary disable**: Set file to `# typed: false`
2. **Comment out in bin/check**: Skip Sorbet in CI temporarily
3. **Use T.untyped**: Temporarily use untyped for complex cases
4. **Ask for help**: Check TROUBLESHOOTING.md or ask team

### If RBI Generation Fails

1. **Exclude problematic gem**: Add to `sorbet/tapioca/config.yml`
2. **Create manual RBI**: Write types manually for the gem
3. **Skip DSL generation**: Comment out in `tapioca/require.rb`

### If Types Are Wrong

1. **Fix the RBI**: Update manual RBI or regenerate DSL RBIs
2. **Report to Tapioca**: Create issue if DSL generation is wrong
3. **Use T.untyped temporarily**: Fix later when you understand the type

---

## Rollback Plan

### Immediate Rollback (Blocks Development)

```bash
# 1. Disable in bin/check
# Comment out: bin/sorbet --color=never

# 2. Set all files to typed: false
find app -name "*.rb" -exec sed -i '' 's/# typed: true/# typed: false/g' {} \;
find app -name "*.rb" -exec sed -i '' 's/# typed: strict/# typed: false/g' {} \;
```

### Complete Removal

```bash
# 1. Remove gems
# Edit Gemfile: Remove sorbet, tapioca, sorbet-rails lines
bundle install

# 2. Remove files
rm -rf sorbet/
rm -rf docs/sorbet/
rm lib/tasks/sorbet.rake

# 3. Remove from bin/check
# Delete Sorbet section

# 4. Remove type signatures (optional)
# Can leave signatures in code, they're just comments without sorbet-runtime
```

---

## Success Criteria (Overall)

**Short-term** (Weeks 1-4):
- ✅ Sorbet runs without errors
- ✅ Core models at `typed: true`
- ✅ Zero test failures
- ✅ Team comfortable with basic signatures

**Mid-term** (Weeks 5-10):
- ✅ All models/policies at `typed: true`
- ✅ All mutations at `typed: true`
- ✅ Less than 5% use of `T.untyped`
- ✅ Team comfortable with complex signatures

**Long-term** (Week 11+):
- ✅ Critical paths at `typed: strict`
- ✅ Less than 1% use of `T.untyped`
- ✅ Sorbet catches bugs before production
- ✅ Type checking under 10 seconds
- ✅ Team prefers typed code

---

## Next Steps

1. **Complete Phase 1**: Run `bundle install` and generate RBIs
2. **Start Phase 2**: Begin typing core models
3. **Track progress**: Create a dashboard or spreadsheet to track coverage
4. **Review weekly**: Check progress against this roadmap
5. **Adjust as needed**: This is a living document, update based on learnings

Good luck! 🚀
