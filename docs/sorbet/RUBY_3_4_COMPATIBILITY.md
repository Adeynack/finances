# Ruby 3.4 Compatibility Issues

## Known Issue: Tapioca and Ruby 3.4.8

There is a known compatibility issue between Tapioca 0.16.x and Ruby 3.4.x related to `Module.new` usage in Sorbet's runtime trackers.

### Error Message

```
undefined method 'new' for module T::Module (NoMethodError)
```

### Status

This issue is being tracked in the Tapioca repository. As of January 2025:
- **Tapioca version**: 0.16.11 (latest)
- **Ruby version**: 3.4.8
- **Issue**: https://github.com/Shopify/tapioca/issues (check for latest updates)

### Workarounds

#### Option 1: Wait for Tapioca Fix (Recommended)

Monitor the Tapioca repository for a fix. Once available:

```bash
bundle update tapioca
bin/tapioca init
bin/tapioca gem --all
bin/tapioca dsl
```

#### Option 2: Downgrade Ruby (Not Recommended)

If Sorbet is critical and Tapioca doesn't get fixed soon:

```bash
# Switch to Ruby 3.3.x
rbenv install 3.3.6
echo "3.3.6" > .ruby-version
bundle install
bin/tapioca init
```

**Note**: This defeats the purpose of staying on the latest Ruby version.

#### Option 3: Skip Tapioca, Use Sorbet Manually (Current Approach)

Generate RBI files manually or use Sorbet without Tapioca for now:

```bash
# Sorbet can still run type checking
bin/sorbet

# Create manual RBIs as needed in sorbet/rbi/manual/
```

**Limitations**:
- No automatic DSL RBI generation (must create manually)
- No automatic gem RBI generation (must create manually)
- More maintenance burden

#### Option 4: Fork and Patch Tapioca (Advanced)

If you're comfortable with Ruby internals, you could fork Tapioca and apply the Module.new fix yourself.

### Current Implementation Status

**What's Working**:
- ✅ Sorbet runtime installed
- ✅ Sorbet configuration created
- ✅ Manual RBI files created for key gems
- ✅ bin/sorbet wrapper created
- ✅ bin/tapioca wrapper created (but not functional)
- ✅ Documentation complete

**What's Not Working**:
- ❌ `bin/tapioca init`
- ❌ `bin/tapioca gem --all`
- ❌ `bin/tapioca dsl`

**Impact**:
- Cannot automatically generate RBI files for gems
- Cannot automatically generate RBI files for Rails DSLs (models, etc.)
- Must manually create all RBI files (already started in `sorbet/rbi/manual/`)

### Recommendation

**For now**: Continue with Phase 1 of the migration plan using manual RBIs only.

The manual RBIs we've created cover the most important gems:
- ✅ closure_tree
- ✅ acts_as_list
- ✅ currencyable
- ✅ money_rails
- ✅ montrose
- ✅ pundit
- ✅ graphql_extensions

**When Tapioca is fixed**: Run the commands to generate the remaining RBIs:

```bash
bin/tapioca init
bin/tapioca gem --all
bin/tapioca dsl
```

### Testing Workaround

Until Tapioca is fixed, you can still use Sorbet for type checking:

```bash
# Add typed: true to a file
echo "# typed: true" | cat - app/models/user.rb > temp && mv temp app/models/user.rb

# Run Sorbet
bin/sorbet app/models/user.rb
```

### Checking for Updates

Periodically check if the issue is resolved:

```bash
# Check for new Tapioca version
bundle outdated tapioca

# Try updating
bundle update tapioca

# Test if it works
bin/tapioca --version
```

### Alternative: Use sorbet-rails Generators

The `sorbet-rails` gem provides some alternative RBI generation:

```bash
# Generate RBIs for models (alternative to tapioca dsl)
bin/rails generate sorbet:model Book
bin/rails generate sorbet:model Register
# ... etc
```

This is more manual but might work as a temporary solution.

## Summary

**Phase 1 Status**: ⚠️ **Partially Complete**

We have:
- ✅ All configuration files
- ✅ All documentation
- ✅ Manual RBIs for critical gems
- ✅ Sorbet installed and ready
- ❌ Tapioca blocked by Ruby 3.4 compatibility

**Next Steps**:
1. Monitor Tapioca for Ruby 3.4 fix
2. Continue manually creating RBIs as needed
3. Use Sorbet for type checking with manual RBIs
4. Once Tapioca is fixed, regenerate all RBIs automatically

**Alternative Path**:
- Proceed with manual typing using the manual RBIs we've created
- Add more manual RBIs as needed for associations and DSLs
- Once Tapioca is fixed, switch to automatic generation

The infrastructure is in place; we're just waiting on the Tapioca fix to complete automation.
