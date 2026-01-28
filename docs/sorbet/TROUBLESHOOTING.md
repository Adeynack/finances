# Sorbet Troubleshooting Guide

This guide covers common issues you may encounter when using Sorbet and how to resolve them.

## Table of Contents

1. [Installation and Setup Issues](#installation-and-setup-issues)
2. [Type Checking Errors](#type-checking-errors)
3. [RBI Generation Issues](#rbi-generation-issues)
4. [Performance Issues](#performance-issues)
5. [IDE Integration Issues](#ide-integration-issues)
6. [Emergency Procedures](#emergency-procedures)

## Installation and Setup Issues

### "bin/sorbet: command not found"

**Cause**: Sorbet gem not installed or bin stubs not generated.

**Solution**:
```bash
bundle install
bundle binstubs sorbet --force
```

### "bin/tapioca: command not found"

**Cause**: Tapioca not initialized.

**Solution**:
```bash
bin/tapioca init
```

### "Sorbet configuration file not found"

**Cause**: Missing `sorbet/config` file.

**Solution**:
```bash
# Create the config file (see SETUP.md for contents)
# Or regenerate:
bin/tapioca init
```

## Type Checking Errors

### Error: "Unable to resolve constant"

**Error message**:
```
app/models/book.rb:10: Unable to resolve constant Currencyable
    10 |  include Currencyable
               ^^^^^^^^^^^^
```

**Cause**: Sorbet can't find the module/class definition.

**Solution 1** - Regenerate DSL RBIs:
```bash
bin/tapioca dsl
```

**Solution 2** - Check if the file has `# typed:` sigil:
```ruby
# typed: true  # Add this at the top
# frozen_string_literal: true
```

**Solution 3** - Create a manual RBI if it's a gem method.

### Error: "Method does not exist"

**Error message**:
```
app/models/register.rb:42: Method `parent` does not exist on `Register`
    42 |  def parent_name = parent&.name
                            ^^^^^^
```

**Cause**: DSL-generated method not in RBI files.

**Solution 1** - Regenerate DSL RBIs:
```bash
bin/tapioca dsl
```

**Solution 2** - Check if the gem needs a manual RBI:
```bash
# Example: closure_tree adds `parent` method
# Ensure sorbet/rbi/manual/closure_tree.rbi exists
```

**Solution 3** - Add the method signature manually:
```ruby
# In the model file
sig { returns(T.nilable(Register)) }
def parent
  super
end
```

### Error: "Expected type X, got type Y"

**Error message**:
```
app/models/book.rb:15: Expected `String` but got `Money::Currency` for method result type
    15 |  sig { returns(String) }
         ^^^^^^^^^^^^^^^^^^^^^^^^
```

**Cause**: Method signature doesn't match actual return type.

**Solution** - Fix the signature to match reality:
```ruby
# Change from:
sig { returns(String) }
def default_currency
  # ...
end

# To:
sig { returns(Money::Currency) }
def default_currency
  # ...
end
```

### Error: "Too many arguments"

**Error message**:
```
app/models/book.rb:20: Too many arguments provided for method `create`. Expected: `0`, got: `1`
    20 |  Book.create(name: "Test")
         ^^^^^^^^^^^^^^^^^^^^^^^^^
```

**Cause**: Signature is incorrect or missing keyword argument types.

**Solution**:
```ruby
# Add **kwargs if method accepts any keyword arguments:
sig { params(attrs: T.untyped).returns(Book) }
def self.create(**attrs)
  super
end
```

### Error: "Cannot assign to a non-nilable variable"

**Error message**:
```
app/models/book.rb:25: Cannot assign `T.nilable(User)` to variable `user` of type `User`
    25 |  user = User.find_by(id: id)
         ^^^^^^^^^^^^^^^^^^^^^^^^^^^
```

**Cause**: Variable is declared as non-nilable but can receive nil.

**Solution 1** - Make variable nilable:
```ruby
sig { returns(T.nilable(User)) }
def find_user
  User.find_by(id: id)
end
```

**Solution 2** - Use `T.must` if you're certain it's not nil:
```ruby
sig { returns(User) }
def find_user!
  T.must(User.find_by(id: id))
end
```

**Solution 3** - Use `find` instead of `find_by` (raises if not found):
```ruby
sig { returns(User) }
def find_user!
  User.find(id)
end
```

### Error: "Call to abstract method"

**Error message**:
```
app/services/base_service.rb:10: Call to abstract method `call`
    10 |  service.call
         ^^^^^^^^^^^^
```

**Cause**: Trying to call an abstract method directly.

**Solution** - Ensure you're calling on a concrete implementation:
```ruby
# Don't do this:
BaseService.new.call

# Do this:
CreateBookService.new.call
```

## RBI Generation Issues

### Tapioca DSL generation fails

**Error message**:
```
Error: Cannot load application
```

**Cause**: Rails application can't be loaded (syntax error, missing dependency).

**Solution 1** - Check if the app loads manually:
```bash
bin/rails console
```

**Solution 2** - Check for syntax errors:
```bash
bin/rubocop
```

**Solution 3** - Ensure database is set up:
```bash
bin/rails db:migrate
```

### "Conflicting definitions"

**Error message**:
```
sorbet/rbi/manual/book.rbi:5: Conflicting definition for method `default_currency`
```

**Cause**: Method defined in both manual RBI and auto-generated RBI.

**Solution** - Remove from manual RBI (let Tapioca handle it):
```bash
# Edit sorbet/rbi/manual/book.rbi and remove the duplicate
# Then regenerate:
bin/tapioca dsl
```

### Tapioca hangs or is very slow

**Cause**: Large codebase or complex dependencies.

**Solution 1** - Use parallel workers:
```bash
bin/tapioca gem --all --workers=4
```

**Solution 2** - Exclude problematic gems in `sorbet/tapioca/config.yml`:
```yaml
gem:
  exclude:
    - debug
    - problematic-gem
```

**Solution 3** - Clear Tapioca cache:
```bash
rm -rf tmp/tapioca
bin/tapioca gem --all
```

### "Cannot find constant in RBI"

**Cause**: Gem not properly loaded or excluded.

**Solution** - Check `sorbet/tapioca/config.yml` and ensure gem is not in `exclude` list:
```yaml
gem:
  exclude:
    - debug
    # - money-rails  # Remove if excluded
```

## Performance Issues

### Sorbet is slow (>30 seconds)

**Cause**: Too many files being checked or complex type inference.

**Solution 1** - Check specific files instead of everything:
```bash
bin/sorbet app/models/book.rb
```

**Solution 2** - Ignore vendor and temp directories in `sorbet/config`:
```
--ignore=vendor/
--ignore=tmp/
--ignore=node_modules/
```

**Solution 3** - Use `# typed: false` for files that don't need checking:
```ruby
# typed: false  # Opt out of type checking
```

**Solution 4** - Check if you're on the latest Sorbet version:
```bash
bundle update sorbet
```

### IDE is slow with Sorbet enabled

**Cause**: Sorbet LSP running on every keystroke.

**Solution 1** - Increase debounce time in IDE settings.

**Solution 2** - Disable Sorbet in IDE, run manually:
```bash
bin/sorbet
```

## IDE Integration Issues

### VS Code: "Sorbet executable not found"

**Cause**: Extension can't find bin/sorbet.

**Solution** - Set path in `.vscode/settings.json`:
```json
{
  "sorbet.commandPath": "${workspaceFolder}/bin/sorbet"
}
```

### VS Code: Sorbet errors not showing

**Cause**: Extension not enabled or Sorbet not running.

**Solution 1** - Enable extension:
```json
{
  "sorbet.enabled": true
}
```

**Solution 2** - Restart VS Code and Sorbet LSP:
```
CMD+Shift+P > "Reload Window"
```

**Solution 3** - Check extension logs:
```
CMD+Shift+P > "Sorbet: Show Output Channel"
```

### RubyMine: Sorbet not working

**Cause**: Sorbet support not enabled.

**Solution**:
1. Go to **Preferences > Languages & Frameworks > Ruby > Sorbet**
2. Enable "Use Sorbet type checker"
3. Set Sorbet executable to `bin/sorbet`
4. Restart RubyMine

## Rails-Specific Issues

### ActiveRecord associations not typed

**Cause**: DSL RBIs not generated for models.

**Solution**:
```bash
bin/tapioca dsl
```

### Enum methods not recognized

**Cause**: Tapioca needs to regenerate enum signatures.

**Solution**:
```bash
bin/tapioca dsl
```

### Scopes not typed

**Cause**: Scopes are complex and Tapioca may not generate perfect types.

**Solution** - Use `T.untyped` for scope return types:
```ruby
sig { returns(T.untyped) }
def self.active
  where(status: :active)
end
```

## GraphQL-Specific Issues

### "Field method not found"

**Cause**: GraphQL field resolver method not typed.

**Solution** - Add signature to resolver:
```ruby
sig { returns(String) }
def currency_code
  object.default_currency.iso_code
end
```

### "Argument type mismatch"

**Cause**: GraphQL argument type doesn't match method signature.

**Solution** - Ensure types align:
```ruby
# GraphQL definition
argument :name, String, required: true

# Method signature
sig { params(name: String).returns(Book) }
def resolve(name:)
  # ...
end
```

## Debugging Strategies

### Strategy 1: Isolate the Problem

```bash
# Check a single file
bin/sorbet app/models/book.rb

# Check a directory
bin/sorbet app/models/

# Full check
bin/sorbet
```

### Strategy 2: Increase Verbosity

```bash
# Show more details
bin/sorbet --verbose

# Show suggestions
bin/sorbet --suggest-typed
```

### Strategy 3: Check RBI Files

```bash
# Look for the method in generated RBIs
grep -r "def parent" sorbet/rbi/

# Check if class is defined
grep -r "class Register" sorbet/rbi/
```

### Strategy 4: Verify Type at Runtime

Add runtime checks to verify types:

```ruby
sig { returns(String) }
def name
  result = super
  puts "name returned: #{result.class}"  # Debug
  result
end
```

### Strategy 5: Use T.untyped as Last Resort

If you can't figure out the type:

```ruby
sig { returns(T.untyped) }
def complex_method
  # Sorbet won't check return type
end
```

Then gradually refine the type later.

## Emergency Procedures

### Emergency: Sorbet is blocking development

**Step 1** - Disable Sorbet in `bin/check`:
```bash
# Comment out in bin/check:
# echo "\n===> Sorbet Type Check\n"
# bin/sorbet --color=never
```

**Step 2** - Set problematic files to `# typed: false`:
```ruby
# typed: false  # Temporarily disable for this file
```

**Step 3** - Continue development, fix Sorbet issues later.

### Emergency: RBI files are broken

**Step 1** - Delete and regenerate:
```bash
rm -rf sorbet/rbi/gems/ sorbet/rbi/dsl/
bin/tapioca gem --all
bin/tapioca dsl
```

**Step 2** - If still broken, restore from git:
```bash
git checkout sorbet/rbi/
```

**Step 3** - If git version is also broken, disable Sorbet temporarily.

### Emergency: Sorbet crashes

**Error**: Sorbet segfaults or crashes.

**Solution 1** - Update Sorbet:
```bash
bundle update sorbet sorbet-runtime
```

**Solution 2** - Clear cache:
```bash
rm -rf tmp/cache/bootsnap*
rm -rf sorbet/rbi/todo.rbi
```

**Solution 3** - Report bug:
```bash
# Create an issue at https://github.com/sorbet/sorbet/issues
# Include the error message and a minimal reproduction
```

## Getting Help

### Resources

- **Official Docs**: https://sorbet.org/docs/overview
- **Tapioca Docs**: https://github.com/Shopify/tapioca
- **Sorbet Slack**: https://sorbet-ruby.slack.com
- **Stack Overflow**: Tag `sorbet`

### Reporting Issues

When reporting issues, include:

1. **Sorbet version**: `bundle info sorbet`
2. **Ruby version**: `ruby -v`
3. **Rails version**: `bin/rails -v`
4. **Error message**: Full output from `bin/sorbet`
5. **Minimal reproduction**: Smallest code that reproduces the issue

### Internal Help

- Check `docs/sorbet/TYPING_PATTERNS.md` for typing examples
- Check `docs/sorbet/RBI_MAINTENANCE.md` for RBI issues
- Ask team members who've worked with Sorbet before

## Common Pitfalls

### ❌ Don't fight Sorbet

If Sorbet says a value can be nil, it probably can:

```ruby
# Bad
sig { returns(User) }
def current_user
  T.must(@current_user)  # This might raise!
end

# Good
sig { returns(T.nilable(User)) }
def current_user
  @current_user
end
```

### ❌ Don't use T.untyped everywhere

It defeats the purpose:

```ruby
# Bad
sig { params(x: T.untyped).returns(T.untyped) }
def process(x)
  # ...
end

# Good
sig { params(id: String).returns(Book) }
def find_book(id)
  # ...
end
```

### ❌ Don't manually type ActiveRecord methods

Let Tapioca handle it:

```ruby
# Bad - Don't do this
sig { returns(T.nilable(Register)) }
def parent
  super
end

# Good - Let Tapioca generate it
# (Just use the method, Tapioca will create the RBI)
```

## Summary

| Issue | Quick Fix | Details |
|-------|-----------|---------|
| "Unable to resolve constant" | `bin/tapioca dsl` | [Link](#error-unable-to-resolve-constant) |
| "Method does not exist" | `bin/tapioca dsl` | [Link](#error-method-does-not-exist) |
| "Expected type X, got Y" | Fix signature | [Link](#error-expected-type-x-got-type-y) |
| Slow Sorbet | Check fewer files | [Link](#sorbet-is-slow-30-seconds) |
| Tapioca fails | Check Rails loads | [Link](#tapioca-dsl-generation-fails) |
| Conflicting definitions | Remove from manual RBI | [Link](#conflicting-definitions) |

**Golden Rule**: When in doubt, regenerate everything:

```bash
rm -rf sorbet/rbi/gems/ sorbet/rbi/dsl/
bin/tapioca gem --all
bin/tapioca dsl
bin/sorbet
```
