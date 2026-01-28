# Sorbet Integration for Finance Application

## Overview

This directory contains documentation and configuration for the Sorbet static type checking integration.

## Current Status: ✅ Phase 2 Complete (Phase 1 Partially Complete)

### ✅ What's Implemented

**Infrastructure:**
- ✅ Sorbet and Tapioca gems added to Gemfile
- ✅ All configuration files created
  - `sorbet/config` - Sorbet configuration
  - `sorbet/tapioca/config.yml` - Tapioca configuration
  - `sorbet/tapioca/require.rb` - Custom requires for DSL generation
- ✅ Manual RBI files created for key gems:
  - `closure_tree.rbi` - Hierarchical model methods
  - `acts_as_list.rbi` - Ordered list methods
  - `currencyable.rbi` - Custom currency concern
  - `money_rails.rbi` - Money::Currency types
  - `montrose.rbi` - Recurrence scheduling
  - `pundit.rbi` - Authorization
  - `graphql_extensions.rbi` - GraphQL types and mutations
- ✅ bin/sorbet wrapper created and working
- ✅ bin/tapioca wrapper created (not functional due to Ruby 3.4 issue)
- ✅ Rake tasks created (`lib/tasks/sorbet.rake`)
- ✅ .gitignore updated
- ✅ CLAUDE.md updated with Sorbet instructions
- ✅ bin/check updated (Sorbet temporarily disabled)

**Documentation:**
- ✅ SETUP.md - Installation and daily workflow
- ✅ TYPING_PATTERNS.md - Comprehensive typing examples
- ✅ RBI_MAINTENANCE.md - RBI generation and maintenance
- ✅ TROUBLESHOOTING.md - Common issues and solutions
- ✅ MIGRATION_ROADMAP.md - 8-phase adoption plan
- ✅ RUBY_3_4_COMPATIBILITY.md - Known issues and workarounds

### ⚠️ Known Issues

**Critical Blocker: Tapioca + Ruby 3.4 Incompatibility**

Tapioca 0.16.11 has a compatibility issue with Ruby 3.4.8:
```
undefined method 'new' for module T::Module (NoMethodError)
```

**Impact:**
- ❌ Cannot run `bin/tapioca init`
- ❌ Cannot run `bin/tapioca gem --all` (gem RBI generation)
- ❌ Cannot run `bin/tapioca dsl` (DSL RBI generation)

**Workaround:**
- Manual RBIs created for critical gems
- Sorbet type checking still works (with expected errors due to missing gem RBIs)
- Waiting for Tapioca fix for Ruby 3.4

See [RUBY_3_4_COMPATIBILITY.md](RUBY_3_4_COMPATIBILITY.md) for details.

### ⏳ What's Pending

**Phase 1 Completion:**
- ⏳ Tapioca compatibility fix for Ruby 3.4
- ⏳ Generate gem RBIs: `bin/tapioca gem --all`
- ⏳ Generate DSL RBIs: `bin/tapioca dsl`
- ⏳ Enable Sorbet in `bin/check`
- ⏳ Verify zero type errors with generated RBIs

**Phase 2-8:**
- ⏳ Type core models (Book, Register, Exchange, etc.)
- ⏳ Type concerns and validators
- ⏳ Type policies
- ⏳ Type GraphQL base classes and mutations
- ⏳ Type GraphQL types
- ⏳ Increase strictness to `typed: strict` for critical files

## Documentation

### Quick Start Guides
- **[SETUP.md](SETUP.md)** - Installation, configuration, and daily workflow
- **[TYPING_PATTERNS.md](TYPING_PATTERNS.md)** - Common patterns with code examples

### Maintenance Guides
- **[RBI_MAINTENANCE.md](RBI_MAINTENANCE.md)** - RBI file management
- **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - Common issues and solutions

### Planning and Strategy
- **[MIGRATION_ROADMAP.md](MIGRATION_ROADMAP.md)** - 8-phase adoption plan (11+ weeks)
- **[RUBY_3_4_COMPATIBILITY.md](RUBY_3_4_COMPATIBILITY.md)** - Ruby 3.4 issues and workarounds

## Quick Reference

### When Tapioca is Fixed

Once Tapioca is compatible with Ruby 3.4:

```bash
# Initialize Tapioca
bin/tapioca init

# Generate all RBIs
bin/tapioca gem --all
bin/tapioca dsl

# Enable Sorbet in bin/check
# Uncomment the Sorbet lines in bin/check

# Run type checking
bin/sorbet

# Continue with Phase 2 of migration
# Start typing core models
```

### Current Workflow (Manual RBIs Only)

```bash
# Check types (will show errors due to missing gem RBIs)
bin/sorbet

# Add type signatures to files
# 1. Add: # typed: true
# 2. Add: extend T::Sig
# 3. Add method signatures

# Create manual RBIs as needed
# Edit files in sorbet/rbi/manual/
```

## Directory Structure

```
sorbet/
├── config                          # Sorbet configuration ✅
├── rbi/
│   ├── gems/                       # Auto-generated gem RBIs ⏳ (blocked)
│   ├── dsl/                        # Auto-generated DSL RBIs ⏳ (blocked)
│   ├── todo.rbi                    # Unresolved constants (gitignored)
│   └── manual/                     # Hand-written RBIs ✅
│       ├── closure_tree.rbi
│       ├── acts_as_list.rbi
│       ├── currencyable.rbi
│       ├── money_rails.rbi
│       ├── montrose.rbi
│       ├── pundit.rbi
│       └── graphql_extensions.rbi
└── tapioca/
    ├── config.yml                  # Tapioca configuration ✅
    └── require.rb                  # Custom requires ✅
```

## Migration Plan Summary

### Phase 1: Foundation Setup (Weeks 1-2) - ⚠️ PARTIALLY COMPLETE
- ✅ Install gems
- ✅ Create configuration
- ✅ Create manual RBIs
- ⏳ Generate gem/DSL RBIs (blocked by Tapioca issue)
- ⏳ Verify Sorbet runs cleanly

### Phase 2: Core Models (Weeks 3-4) - ✅ COMPLETE
- ✅ ApplicationRecord, User, ApiSession
- ✅ ImportOrigin
- ✅ Currencyable concern
- ✅ Book, Register (critical)
- ✅ Exchange, Split, Reminder, ReminderSplit

### Phase 3: Concerns & Validators (Week 5) - ⏳ PENDING
- Currencyable, Taggable, Importable
- All validators

### Phase 4: Policies (Week 6) - ⏳ PENDING
- ApplicationPolicy, BookPolicy, etc.

### Phase 5: GraphQL Base Classes (Week 7) - ⏳ PENDING
- All base GraphQL classes

### Phase 6: GraphQL Mutations (Week 8) - ⏳ PENDING
- All mutations

### Phase 7: GraphQL Types (Weeks 9-10) - ⏳ PENDING
- All object types with custom resolvers

### Phase 8: Strict Mode (Week 11+) - ⏳ PENDING
- Critical files to `typed: strict`

## Next Steps

### Immediate (When Tapioca is Fixed)

1. **Test Tapioca**:
   ```bash
   bundle update tapioca
   bin/tapioca --version
   ```

2. **Generate RBIs**:
   ```bash
   bin/tapioca init
   bin/tapioca gem --all
   bin/tapioca dsl
   ```

3. **Verify Sorbet**:
   ```bash
   bin/sorbet
   # Should show significantly fewer errors
   ```

4. **Enable in CI**:
   ```bash
   # Uncomment Sorbet in bin/check
   bin/check
   ```

5. **Start Phase 2**:
   ```bash
   # Begin typing core models
   # See MIGRATION_ROADMAP.md for file order
   ```

### Alternative: Proceed with Manual RBIs

If Tapioca fix takes too long:

1. **Continue adding manual RBIs** as needed for models
2. **Type core models** using manual RBIs
3. **Switch to automatic generation** once Tapioca is fixed

## Resources

### External Links
- **Sorbet Official Docs**: https://sorbet.org/docs/overview
- **Tapioca GitHub**: https://github.com/Shopify/tapioca
- **sorbet-rails GitHub**: https://github.com/chanzuckerberg/sorbet-rails
- **Sorbet Slack**: https://sorbet-ruby.slack.com

### Internal Links
- **Project CLAUDE.md**: [../CLAUDE.md](../../CLAUDE.md) - Updated with Sorbet instructions
- **Rake Tasks**: [../../lib/tasks/sorbet.rake](../../lib/tasks/sorbet.rake)
- **bin/sorbet**: [../../bin/sorbet](../../bin/sorbet)
- **bin/check**: [../../bin/check](../../bin/check)

## Support

For issues or questions:
1. Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
2. Check [RUBY_3_4_COMPATIBILITY.md](RUBY_3_4_COMPATIBILITY.md)
3. Review [Sorbet documentation](https://sorbet.org)
4. Create an issue in the project repository

## Contributing

When updating Sorbet integration:
- Update relevant documentation
- Add examples to TYPING_PATTERNS.md
- Update MIGRATION_ROADMAP.md progress
- Document any new issues in TROUBLESHOOTING.md

---

**Last Updated**: 2025-01-28
**Status**: Phase 1 partially complete, blocked by Tapioca Ruby 3.4 compatibility
**Next Milestone**: Complete Phase 1 once Tapioca is fixed
