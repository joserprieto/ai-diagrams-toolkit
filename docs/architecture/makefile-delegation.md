# ADR: Makefile Delegation Pattern

_Created: 2025-11-12 | Status: Accepted | Version: 1.0.0_

## Decision

Use **delegated Makefiles** in subdomains (`scripts/`, `tests/`) with root Makefile delegating via pattern matching (`scripts/%`, `tests/%`).

---

## Context and Problem

### Problem

Root Makefile was growing with mixed concerns:

```makefile
# Root Makefile (before)
release              # Project-level
check/deps           # Project-level
install              # Commands-level
test/commands        # Commands-level
scripts/test         # Scripts-level  ← Growing
scripts/tdd/colors   # Scripts-level  ← Would grow further
scripts/lint         # Scripts-level  ← Would grow further
```

**Issues**:
- ❌ **Mixing concerns**: Project, commands, scripts operations in one file
- ❌ **Scalability**: Adding script targets pollutes root Makefile
- ❌ **Locality**: Developer in `scripts/` must go to root for operations
- ❌ **Maintenance**: Root Makefile changes frequently

### Requirements

- ✅ Separate concerns by domain
- ✅ Enable local development workflows
- ✅ Apply SOLID principles where applicable
- ✅ Maintain backward compatibility
- ✅ Keep paradigm consistency

---

## Decision Rationale

### Open/Closed Principle (SOLID)

**Definition**: Software entities should be **open for extension**, but **closed for modification**.

**Application**:

```makefile
# Root Makefile - CLOSED for modification
.PHONY: scripts/%
scripts/%:
	@$(MAKE) -C scripts $*

# When you add new target in scripts/Makefile:
# - Root Makefile DOES NOT change (CLOSED)
# - Functionality extends (OPEN)
```

**How it works**:

```makefile
# scripts/Makefile - OPEN for extension
.PHONY: tdd/colors
tdd/colors:
	@bash ../tests/scripts/lib/test-colors.sh

# Add new target (NO root modification needed)
.PHONY: tdd/validation  # ← NEW
tdd/validation:
	@bash ../tests/scripts/lib/test-validation.sh
```

**Validation**: **YES**, we correctly apply Open/Closed:
- ✅ Root Makefile stable (closed for modification)
- ✅ System extensible (open via delegated Makefiles)
- ✅ New functionality added without changing existing code

---

### Additional Benefits

#### 1. Separation of Concerns

Each domain manages its own operations:

```
Makefile              # Project orchestration
scripts/Makefile      # Script development
tests/Makefile        # Test operations (future)
.ai/Makefile          # AI commands (future)
```

#### 2. Locality of Behavior

Developer working in `scripts/` has local tools:

```bash
cd scripts/

# All operations local
make test           # Test scripts
make tdd/colors     # TDD cycle
make lint           # Lint scripts
make help           # Show local targets
```

**No need** to navigate to root for script-specific operations.

#### 3. Consistent Paradigm

All Makefiles follow same pattern:

- Color definitions
- Helper functions (`print_header`, `print_success`)
- Structured targets with comments
- Help command with formatted output

**Benefit**: Developer knows what to expect, easy to contribute.

#### 4. Flexible Invocation

Works from anywhere:

```bash
# From root (delegation)
make scripts/test
make scripts/tdd/colors

# From scripts/ (direct)
cd scripts/
make test
make tdd/colors

# Both produce identical results
```

---

## Alternatives Considered

### Alternative 1: Single Root Makefile

**Approach**: Keep all targets in root Makefile

```makefile
# Root Makefile
scripts/test:
	@bash tests/scripts/run-all.sh

scripts/tdd/colors:
	@bash tests/scripts/lib/test-colors.sh

scripts/tdd/validation:
	@bash tests/scripts/lib/test-validation.sh

# ... grows to 20+ script targets
```

**Pros**:
- ✅ Single file (simpler navigation)
- ✅ All targets in one place

**Cons**:
- ❌ Mixes concerns (project + scripts)
- ❌ Root Makefile grows unbounded
- ❌ No locality (must go to root)
- ❌ Violates Open/Closed

**Decision**: **Rejected** - Does not scale

---

### Alternative 2: Scripts Without Makefile

**Approach**: Use shell scripts only, no Make

```bash
# scripts/test.sh
bash ../tests/scripts/run-all.sh

# scripts/tdd-colors.sh
bash ../tests/scripts/lib/test-colors.sh
```

**Pros**:
- ✅ No Makefile needed
- ✅ Simple shell scripts

**Cons**:
- ❌ No standardized interface
- ❌ No help system
- ❌ No consistent paradigm
- ❌ Harder to discover

**Decision**: **Rejected** - Loses Make benefits

---

### Alternative 3: External Tool (invoke, just, etc.)

**Approach**: Use Python `invoke` or `just` instead of Make

**Pros**:
- ✅ Modern alternatives
- ✅ Better syntax (Python/TOML)

**Cons**:
- ❌ New dependency
- ❌ Team must learn new tool
- ❌ Not ubiquitous like Make
- ❌ Breaks existing paradigm

**Decision**: **Rejected** - Make is ubiquitous and established

---

## Implementation

### Structure

```
ai-diagrams-toolkit/
├── Makefile                      # Project orchestration (delegates)
│
├── scripts/
│   ├── Makefile                  # Script operations (extends)
│   ├── bin/
│   ├── lib/
│   └── ...
│
└── tests/
    └── Makefile                  # Test operations (future)
```

---

### Delegation Pattern

**Root Makefile**:

```makefile
# Delegate all scripts/* targets to scripts/Makefile
.PHONY: scripts/%
scripts/%:
	@$(MAKE) -C scripts $*

# Delegate all tests/* targets to tests/Makefile
.PHONY: tests/%
tests/%:
	@$(MAKE) -C tests $*
```

**How it works**:

```bash
# User runs
make scripts/test

# Make expands to
make -C scripts test

# Executes
cd scripts && make test
```

---

### scripts/Makefile Targets

**Testing**:
- `test` - Run all script tests
- `test/single` - Run single test (TEST=test-colors)
- `test/lib` - Run only library tests
- `test/bin` - Run only executable tests

**TDD Workflow**:
- `tdd/colors` - TDD cycle for colors.sh
- `tdd/setup` - TDD cycle for setup.sh
- `tdd/validation` - TDD cycle for validation.sh
- `tdd/extraction` - TDD cycle for extraction.sh
- `tdd/teardown` - TDD cycle for teardown.sh

**Refactoring Helpers**:
- `refactor/status` - Show progress (refactored vs remaining)
- `refactor/next` - Show next script to refactor
- `refactor/list-old` - List scripts in old location

**Quality**:
- `lint` - Shellcheck all scripts
- `lint/single` - Lint single script (SCRIPT=path)
- `check/shellcheck` - Verify shellcheck installed

**Info**:
- `info` - Show directory information
- `help` - Show all targets

---

### Invocation Examples

**From root** (delegation):

```bash
make scripts/test               # Delegates to scripts/Makefile
make scripts/tdd/colors         # Delegates to scripts/Makefile
make scripts/refactor/status    # Delegates to scripts/Makefile
make scripts/lint               # Delegates to scripts/Makefile
```

**From scripts/** (direct):

```bash
cd scripts/

make test                       # Direct invocation
make tdd/colors                 # Direct invocation
make refactor/status            # Direct invocation
make help                       # Shows local targets
```

**Both produce identical results**.

---

## Benefits

### For Developers

- ✅ **Local tools** - Everything needed in `scripts/` directory
- ✅ **TDD workflow** - `make tdd/colors` runs test cycle
- ✅ **Quick feedback** - Refactor → Test in one command
- ✅ **Discoverability** - `make help` shows script-specific targets
- ✅ **Consistent UX** - Same paradigm as root Makefile

### For Project

- ✅ **Scalability** - Add targets without growing root
- ✅ **Maintainability** - Each Makefile focused on its domain
- ✅ **Testability** - Scripts have dedicated test infrastructure
- ✅ **Flexibility** - Can invoke from root or locally

### For Architecture

- ✅ **Open/Closed** - Extends without modifying root
- ✅ **Single Responsibility** - Each Makefile has one domain
- ✅ **DRY** - Helper functions in each Makefile (no duplication via delegation)
- ✅ **Consistency** - Same paradigm everywhere

---

## Trade-offs

### Advantages

1. **Clear separation** - Project vs scripts vs tests operations
2. **Local development** - Tools where you need them
3. **Scalability** - Pattern repeats for any subdomain
4. **Stability** - Root Makefile changes less frequently

### Disadvantages

1. **More files** - Multiple Makefiles to maintain
2. **Learning curve** - Developers must know structure
3. **Documentation** - Need to explain delegation pattern

### Mitigation

- **Documentation**: Explain in `docs/conventions/makefile.md`
- **README**: Add `scripts/README.md` mentioning Makefile
- **Help**: Root `make help` shows delegation examples
- **Consistency**: Same paradigm makes learning easy

---

## Validation

### Open/Closed Verification

**Test**: Add new target to scripts/Makefile

**Before** (root Makefile):
```makefile
# (no tdd/validation target)
```

**Action**: Add to `scripts/Makefile`:
```makefile
.PHONY: tdd/validation
tdd/validation:
	@bash ../tests/scripts/lib/test-validation.sh
```

**After** (root Makefile):
```makefile
# (still no changes - delegation handles it)
```

**Result**: ✅ Root Makefile **NOT modified** (CLOSED), functionality **extended** (OPEN)

---

### Invocation Verification

**Test delegation**:

```bash
# From root
$ make scripts/help
# Output: scripts/Makefile help (delegation works ✅)

$ make scripts/test
# Output: Runs all script tests (delegation works ✅)

$ make scripts/tdd/colors
# Output: Runs colors.sh test (delegation works ✅)
```

**Test direct invocation**:

```bash
# From scripts/
$ cd scripts/
$ make help
# Output: scripts/Makefile help (direct works ✅)

$ make test
# Output: Runs all script tests (direct works ✅)
```

**Result**: ✅ Both invocation methods work correctly

---

## Future Extensions

### Potential Additional Makefiles

Following same pattern:

```
tests/Makefile        # Test operations
.ai/Makefile          # AI command operations (if needed)
docs/Makefile         # Doc generation (if needed)
```

**Criteria for new Makefile**:
- Domain has **significant operations** (not just 1-2 targets)
- Operations are **domain-specific** (not project-wide)
- Benefits **outweigh** cost of additional file

---

## Related Decisions

- [Orchestration Decision](./orchestration.md) - Why Makefile as main orchestrator
- [Makefile Design Decisions](./makefile-design-decisions.md) - Variable naming, fail-fast
- [Testing Strategy](./testing-strategy.md) - TDD approach for scripts

---

## References

### Internal

- Root `Makefile` - Project orchestration
- `scripts/Makefile` - Script development operations
- `docs/conventions/makefile.md` - Makefile usage guide

### External

- [GNU Make Manual](https://www.gnu.org/software/make/manual/)
- [Make Delegation Pattern](https://www.gnu.org/software/make/manual/html_node/MAKE-Variable.html)
- [Open/Closed Principle](https://en.wikipedia.org/wiki/Open%E2%80%93closed_principle)

---

## Conclusion

Delegated Makefiles with pattern matching (`scripts/%`) provide **clear separation of concerns** while applying **Open/Closed Principle**. Root Makefile remains stable (CLOSED) while subdomains extend independently (OPEN).

**Rating**: 9.5/10 - Excellent architectural decision

**Status**: **Accepted** and **Implemented** (2025-11-12)

---

_ADR: Makefile Delegation Pattern - Applying Open/Closed Principle_
