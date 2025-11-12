# Shell Scripting Conventions

_Last Updated: 2025-11-12 | Version: 1.0.0_

Complete guide to writing shell scripts for the AI Diagrams Toolkit following established conventions, namespace patterns, and testing practices.

---

## 🎯 Overview

All shell scripts in this project follow strict conventions for:

- ✅ **Namespace consistency** - No function name conflicts
- ✅ **Documentation standards** - Doxygen-style comments
- ✅ **Error handling** - Fail-fast with clear messages
- ✅ **Testing** - TDD approach with happy path minimum
- ✅ **Modularity** - Libraries vs executables clearly separated

---

## 📂 File Organization

### Directory Structure

```
scripts/
├── bin/                              # Executable entry points
│   ├── install-symlinks              # CLI tool (no .sh extension)
│   ├── install-symlinks.ps1          # PowerShell variant (keeps .ps1)
│   ├── uninstall-symlinks
│   ├── verify-installation
│   └── list-commands
│
├── lib/                              # Shared libraries (sourced, not executed)
│   ├── install/
│   │   ├── symlinks.sh              # Installation implementation
│   │   ├── uninstall.sh
│   │   └── verify.sh
│   │
│   └── tests/                        # Test utilities
│       ├── colors.sh                 # Color definitions
│       ├── setup.sh                  # Test initialization
│       ├── validation.sh             # Validation strategies
│       ├── extraction.sh             # Data extraction
│       ├── teardown.sh               # Test cleanup
│       ├── claude/                   # Claude CLI specific
│       └── mermaid/                  # Mermaid specific
│
└── tests/                            # Test runners (not libraries)
    ├── commands/                     # Command test cases
    │   └── run-all.sh
    └── scripts/                      # Script tests
        └── run-all.sh
```

### File Types

| Location | Type | Extension | Execute | Source | Example |
|----------|------|-----------|---------|--------|---------|
| `scripts/bin/` | Executable | None (or .ps1) | ✅ Direct | ❌ No | `install-symlinks` |
| `scripts/lib/` | Library | `.sh` | ❌ No | ✅ Yes | `symlinks.sh` |
| `tests/*/` | Test runner | `.sh` | ✅ Direct | ❌ No | `run-all.sh` |

### Naming Conventions

**Executables** (`bin/`):
- Use `kebab-case` (hyphens)
- No `.sh` extension (Unix convention)
- Exception: PowerShell files keep `.ps1`
- Examples: `install-symlinks`, `list-commands`, `verify-installation`

**Libraries** (`lib/`):
- Use `snake_case.sh` (underscores + extension)
- Always include `.sh` extension
- Examples: `symlinks.sh`, `colors.sh`, `validation.sh`

**Test files**:
- Prefix with `test-`: `test-colors.sh`, `test-setup.sh`
- Use `snake_case.sh`
- Mirror structure of file being tested

---

## 🏷️ Namespace Pattern

### Namespace Hierarchy

All functions and variables use **double-colon namespace** pattern:

```
adt::module::submodule::item
```

**Project namespaces**:

| Namespace | Location | Purpose | Example |
|-----------|----------|---------|---------|
| `adt::` | All scripts | Base project namespace | N/A (not used alone) |
| `adt::bin::` | `scripts/bin/` | Executable wrappers | `adt::bin::install::main()` |
| `adt::lib::` | `scripts/lib/` | Shared utilities | `adt::lib::install::symlinks::create_link()` |
| `adt::lib::tests::` | `scripts/lib/tests/` | Test utilities | `adt::lib::tests::setup::validate_repo_root()` |
| `adt::lib::install::` | `scripts/lib/install/` | Install utilities | `adt::lib::install::symlinks::main()` |
| `adt::test::framework::` | `tests/scripts/lib/` | Test framework | `adt::test::framework::assert_equals()` |

**Abbreviation**: `adt` = **A**I **D**iagrams **T**oolkit

---

### Function Naming

**Pattern**: `namespace::subnamespace::function_name()`

**Examples**:

```bash
# Library functions
adt::lib::tests::colors::red()
adt::lib::tests::setup::validate_repo_root()
adt::lib::install::symlinks::create_link()

# Executable main functions
adt::bin::install::main()
adt::bin::uninstall::main()

# Test framework
adt::test::framework::assert_equals()
adt::test::framework::assert_success()
```

**Rules**:
- Use lowercase with underscores for multi-word names
- Avoid abbreviations unless universally understood
- Be descriptive: `validate_repo_root()` not `validate()`
- Group by purpose via namespace

---

### Variable Naming

**Pattern**: `namespace__module__VARIABLE` (double underscores)

**Types**:

#### Constants (readonly)

```bash
# Color codes
readonly adt__lib__tests__colors__RED='\033[0;31m'
readonly adt__lib__tests__colors__GREEN='\033[0;32m'
readonly adt__lib__tests__colors__CHECK='✓'

# Module state
readonly adt__lib__tests__setup__LOADED=1
```

#### Module Variables (mutable)

```bash
# Counters
adt__test__framework__PASSED=0
adt__test__framework__FAILED=0
adt__test__framework__TOTAL=0
```

#### Local Variables (function scope)

```bash
# Use 'local' keyword, no namespace needed
function_name() {
    local var_name="value"
    local count=0
    local result
}
```

**Rules**:
- Constants: `readonly`, UPPER_CASE
- Module vars: No `readonly`, UPPER_CASE
- Local vars: `local` keyword, snake_case
- Always quote: `"$variable"`

---

## 📝 File Structure

### Shebang and Safety

**MANDATORY** at the start of every script:

```bash
#!/usr/bin/env bash
##
## @file filename.sh
## @brief Brief one-line description
##

set -euo pipefail
```

**Flags explained**:
- `-e` - Exit immediately if command fails
- `-u` - Exit if undefined variable referenced
- `-o pipefail` - Pipeline fails if any command fails

---

### Guard Clause Pattern

**MANDATORY** for library files (prevent double-sourcing):

```bash
#!/usr/bin/env bash
set -euo pipefail

# Guard against multiple sourcing
if [[ -n "${adt__lib__module__LOADED:-}" ]]; then
  return 0
fi
readonly adt__lib__module__LOADED=1

# Rest of file...
```

**Pattern**:
1. Check if guard variable is set
2. Return early if already loaded
3. Set guard variable as readonly
4. Continue with definitions

**Not needed** for:
- Executable scripts in `bin/` (executed, not sourced)
- Test files (executed once per test run)

---

### Import Pattern

**For library dependencies**:

```bash
#!/usr/bin/env bash
set -euo pipefail

# Guard clause
if [[ -n "${adt__lib__tests__setup__LOADED:-}" ]]; then
  return 0
fi
readonly adt__lib__tests__setup__LOADED=1

# Calculate script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Import dependencies (same directory)
source "${SCRIPT_DIR}/colors.sh"

# Import dependencies (different directory)
source "${SCRIPT_DIR}/../install/symlinks.sh"

# Rest of file...
```

**Rules**:
- Always use `${BASH_SOURCE[0]}` (not `$0`)
- Calculate `SCRIPT_DIR` before sourcing
- Use relative paths from `SCRIPT_DIR`
- Source after guard clause

---

### Executable Wrapper Pattern

**For scripts in `bin/`** (thin wrappers calling `lib/`):

```bash
#!/usr/bin/env bash
##
## @file install-symlinks
## @brief Setup AI assistant command symlinks
## @description
##   Thin wrapper around adt::lib::install::symlinks library.
##   Creates symlinks from .claude/commands and .cursor/commands
##   to centralized .ai/commands/ directory.
##
## @usage
##   ./scripts/bin/install-symlinks
##   make commands/install
##

set -euo pipefail

# Calculate paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Import library
source "${REPO_ROOT}/scripts/lib/install/symlinks.sh"

# Import colors for output (optional)
source "${REPO_ROOT}/scripts/lib/tests/colors.sh"

# Main execution - delegate to library
adt::lib::install::symlinks::main "$@"
```

**Characteristics**:
- ✅ Minimal logic (just imports + delegation)
- ✅ Calculates `REPO_ROOT` for library imports
- ✅ Passes all arguments (`"$@"`) to library function
- ✅ Exit code inherited from library function

---

## 📄 Documentation Standards

### File-Level Documentation

**MANDATORY** Doxygen-style header for ALL files:

```bash
#!/usr/bin/env bash
##
## @file colors.sh
## @brief Color definitions for test output
## @description
##   Defines ANSI color codes and symbols for consistent
##   terminal output formatting across all test scripts.
##
##   Provides readonly color variables (RED, GREEN, etc.)
##   and symbols (CHECK, CROSS, INFO, WARN) for visual feedback.
##
## @example
##   source "${REPO_ROOT}/scripts/lib/tests/colors.sh"
##   echo -e "${adt__lib__tests__colors__GREEN}Success${adt__lib__tests__colors__NC}"
##
## @author AI Diagrams Toolkit Team
## @date 2025-11-12
## @version 1.0.0
## @namespace adt::lib::tests::colors
##

set -euo pipefail
```

**Required fields**:
- `@file` - Filename
- `@brief` - One-line summary
- `@description` - Detailed explanation (multi-line OK)
- `@example` - Usage example
- `@author` - Author or team name
- `@date` - Creation date (YYYY-MM-DD)
- `@version` - SemVer version
- `@namespace` - Namespace used in file (if library)

---

### Function Documentation

**MANDATORY** for all public functions:

```bash
##
## @description Validates that REPO_ROOT environment variable is set and points to valid directory
## @noargs This function takes no arguments
## @return 0 if REPO_ROOT is valid, exits with 1 if invalid
## @exitcode 0 Success - REPO_ROOT is valid
## @exitcode 1 Error - REPO_ROOT not set or invalid directory
## @example
##   adt::lib::tests::setup::validate_repo_root
##   # Exits if REPO_ROOT not set
##
adt::lib::tests::setup::validate_repo_root() {
  if [[ -z "${REPO_ROOT:-}" ]]; then
    echo "❌ ERROR: REPO_ROOT not set"
    echo ""
    echo "This test must be executed via run-all.sh with proper context."
    exit 1
  fi

  if [[ ! -d "${REPO_ROOT}" ]]; then
    echo "❌ ERROR: REPO_ROOT is not a directory: ${REPO_ROOT}"
    exit 1
  fi

  return 0
}
```

**Fields**:
- `@description` - What function does (detailed, multi-line OK)
- `@param` - For each parameter: `@param $1 Description of first parameter`
- `@noargs` - Explicitly state if no parameters
- `@return` - Return value explanation
- `@exitcode` - Document each exit code
- `@example` - Usage example with expected behavior

**Optional fields**:
- `@see` - Reference to related functions
- `@note` - Important notes or warnings
- `@todo` - Pending improvements

---

## 🛡️ Error Handling

### Exit Codes

**Standard exit codes**:
- `0` - Success
- `1` - General error
- `2` - Misuse of command (invalid arguments)

**Usage**:

```bash
function_name() {
    if [[ $# -lt 1 ]]; then
        echo "ERROR: Missing required argument"
        return 2  # or exit 2 for scripts
    fi

    if [[ ! -f "$1" ]]; then
        echo "ERROR: File not found: $1"
        return 1
    fi

    # Success
    return 0
}
```

---

### Parameter Validation

**Pattern 1**: Parameter expansion with error message

```bash
# Fail if variable not set
: "${REPO_ROOT:?ERROR: REPO_ROOT not defined}"
: "${JQ:?ERROR: JQ not defined in ${env_file}}"

# Provide default if not set
: "${VALIDATION_STRATEGY:=mermaid}"
```

**Pattern 2**: Conditional checks

```bash
if [[ -z "${REPO_ROOT:-}" ]]; then
    echo "❌ ERROR: REPO_ROOT not set"
    echo ""
    echo "Usage: REPO_ROOT=/path/to/repo $0"
    exit 1
fi

if [[ $# -lt 1 ]]; then
    echo "❌ ERROR: Missing required argument"
    echo ""
    echo "Usage: $0 <argument>"
    exit 2
fi
```

---

### Safe Practices

**ALWAYS quote variables**:

```bash
# ✅ GOOD
if [[ -f "$file" ]]; then
    rm -f "$file"
fi

# ❌ BAD (breaks with spaces)
if [[ -f $file ]]; then
    rm -f $file
fi
```

**Use arrays for collections**:

```bash
# ✅ GOOD
files=("file1.txt" "file with spaces.txt" "file3.txt")
for file in "${files[@]}"; do
    process "$file"
done

# ❌ BAD (breaks with spaces)
files="file1.txt file with spaces.txt file3.txt"
for file in $files; do
    process "$file"
done
```

---

## 🎨 Color Output

### Standard Colors

**Defined in** `scripts/lib/tests/colors.sh`:

```bash
# ANSI color codes
readonly adt__lib__tests__colors__RED='\033[0;31m'
readonly adt__lib__tests__colors__GREEN='\033[0;32m'
readonly adt__lib__tests__colors__YELLOW='\033[1;33m'
readonly adt__lib__tests__colors__BLUE='\033[0;34m'
readonly adt__lib__tests__colors__NC='\033[0m'  # No Color

# Symbols
readonly adt__lib__tests__colors__CHECK='✓'
readonly adt__lib__tests__colors__CROSS='✗'
readonly adt__lib__tests__colors__INFO='ℹ'
readonly adt__lib__tests__colors__WARN='⚠'
```

---

### Print Functions Pattern

**Standard pattern** for output functions:

```bash
print_success() {
    echo -e "${adt__lib__tests__colors__GREEN}${adt__lib__tests__colors__CHECK}${adt__lib__tests__colors__NC} $1"
}

print_error() {
    echo -e "${adt__lib__tests__colors__RED}${adt__lib__tests__colors__CROSS}${adt__lib__tests__colors__NC} $1"
}

print_info() {
    echo -e "${adt__lib__tests__colors__BLUE}${adt__lib__tests__colors__INFO}${adt__lib__tests__colors__NC} $1"
}

print_warning() {
    echo -e "${adt__lib__tests__colors__YELLOW}${adt__lib__tests__colors__WARN}${adt__lib__tests__colors__NC} $1"
}

print_header() {
    echo -e "${adt__lib__tests__colors__BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${adt__lib__tests__colors__NC}"
    echo -e "${adt__lib__tests__colors__BLUE}  $1${adt__lib__tests__colors__NC}"
    echo -e "${adt__lib__tests__colors__BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${adt__lib__tests__colors__NC}"
    echo ""
}
```

**Usage**:

```bash
#!/usr/bin/env bash
source "${REPO_ROOT}/scripts/lib/tests/colors.sh"

print_header "Installing Symlinks"
print_info "Checking directories..."
print_success "All directories valid"
print_warning "Some optional components missing"
print_error "Critical error occurred"
```

---

## 🧪 Testing Conventions

### TDD Approach

**MANDATORY**: All scripts must follow **Test-Driven Development**:

1. **RED** - Write test that fails (function doesn't exist yet)
2. **GREEN** - Write minimum code to pass test
3. **REFACTOR** - Clean up code while keeping tests green

### Minimum Test Coverage

**Every script MUST have**:
- ✅ Guard clause test (if library)
- ✅ Function existence test
- ✅ Happy path test (basic functionality)

**Example** (`tests/scripts/lib/test-colors.sh`):

```bash
#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
source "${REPO_ROOT}/tests/scripts/lib/test-framework.sh"

##
## @description Test guard clause prevents double sourcing
##
test_colors_guard_works() {
    # First source
    source "${REPO_ROOT}/scripts/lib/tests/colors.sh"

    # Verify guard variable set
    [[ -n "${adt__lib__tests__colors__LOADED}" ]] || return 1

    # Second source (should return immediately)
    source "${REPO_ROOT}/scripts/lib/tests/colors.sh"

    return 0
}

##
## @description Test color variables are defined
##
test_colors_variables_exist() {
    source "${REPO_ROOT}/scripts/lib/tests/colors.sh"

    # Check essential variables
    [[ -n "${adt__lib__tests__colors__RED}" ]] || return 1
    [[ -n "${adt__lib__tests__colors__GREEN}" ]] || return 1
    [[ -n "${adt__lib__tests__colors__NC}" ]] || return 1

    return 0
}

##
## @description Test symbols are defined
##
test_colors_symbols_exist() {
    source "${REPO_ROOT}/scripts/lib/tests/colors.sh"

    [[ -n "${adt__lib__tests__colors__CHECK}" ]] || return 1
    [[ -n "${adt__lib__tests__colors__CROSS}" ]] || return 1

    return 0
}

# Run all tests
echo "Testing: colors.sh"
test_colors_guard_works
test_colors_variables_exist
test_colors_symbols_exist

# Use framework for summary
source "${REPO_ROOT}/tests/scripts/lib/test-framework.sh"
adt::test::framework::print_summary
```

---

### Test Framework Functions

**Location**: `tests/scripts/lib/test-framework.sh`

**Available assertions**:

```bash
# Assert equality
adt::test::framework::assert_equals "$expected" "$actual" "Description"

# Assert command succeeds
adt::test::framework::assert_success "command to run" "Description"

# Assert command fails
adt::test::framework::assert_fail "command to run" "Description"

# Assert file exists
adt::test::framework::assert_file_exists "/path/to/file" "Description"

# Assert function exists
adt::test::framework::assert_function_exists "function_name" "Description"

# Print test summary (at end)
adt::test::framework::print_summary
```

**Return codes**:
- Each assertion returns `0` (pass) or `1` (fail)
- Framework tracks passed/failed counts
- `print_summary()` returns `0` if all passed, `1` if any failed

---

### Test Naming Convention

**Pattern**: `test_module_what_it_tests()`

**Examples**:

```bash
# Good names (descriptive)
test_colors_guard_works()
test_setup_validate_repo_root_exists()
test_symlinks_create_link_success()
test_validation_graph_declaration_flowchart()

# Bad names (vague)
test_1()
test_colors()
test_works()
```

---

### Test Organization

**One test file per library file**:

```
scripts/lib/tests/colors.sh    → tests/scripts/lib/test-colors.sh
scripts/lib/tests/setup.sh     → tests/scripts/lib/test-setup.sh
scripts/lib/install/symlinks.sh → tests/scripts/lib/test-install-symlinks.sh
```

**Test runner**:

```bash
# Run all script tests
make scripts/test

# Run single test
make scripts/test/single TEST=test-colors
```

---

## 🔧 Strategy Pattern

### When to Use

Use strategy pattern when:
- Multiple implementations of same interface exist
- Behavior must be swappable at runtime
- Avoid long if/else chains for algorithm selection

### Implementation

**Example from** `scripts/lib/tests/validation.sh`:

```bash
# Default strategy
: "${VALIDATION_STRATEGY:=mermaid}"

# Load strategy implementation
source "${SCRIPT_DIR}/${VALIDATION_STRATEGY}/validation.sh"

# Delegate to strategy
adt::lib::tests::validation::graph_declaration() {
  adt::lib::tests::validation::${VALIDATION_STRATEGY}::graph_declaration "$@"
}
```

**Directory structure**:

```
scripts/lib/tests/
├── validation.sh              # Interface (delegates)
├── mermaid/
│   └── validation.sh          # Mermaid implementation
└── plantuml/                  # Future
    └── validation.sh          # PlantUML implementation
```

**Strategies available**:
- `mermaid` - Mermaid diagram validation
- Others can be added by creating subdirectory

---

## 📋 Complete Templates

### Template: Library File

```bash
#!/usr/bin/env bash
##
## @file module_name.sh
## @brief Brief one-line description
## @description
##   Detailed description of what this library provides.
##   Can span multiple lines.
##
## @example
##   source "${REPO_ROOT}/scripts/lib/module_name.sh"
##   adt::lib::module::function_name "argument"
##
## @author AI Diagrams Toolkit Team
## @date YYYY-MM-DD
## @version 1.0.0
## @namespace adt::lib::module
##

set -euo pipefail

# Guard against multiple sourcing
if [[ -n "${adt__lib__module__LOADED:-}" ]]; then
  return 0
fi
readonly adt__lib__module__LOADED=1

# Import dependencies
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/colors.sh"

# Constants
readonly adt__lib__module__DEFAULT_VALUE="default"

##
## @description Brief description of what function does
## @param $1 Description of first parameter
## @param $2 Description of second parameter (optional)
## @return 0 on success, 1 on error
## @exitcode 0 Success
## @exitcode 1 Error - with description
## @example
##   adt::lib::module::function_name "arg1" "arg2"
##
adt::lib::module::function_name() {
    local param1="$1"
    local param2="${2:-default}"

    # Validate parameters
    if [[ -z "$param1" ]]; then
        echo "ERROR: param1 required"
        return 1
    fi

    # Logic here
    echo "Processing $param1 with $param2"

    return 0
}

# Additional functions...
```

---

### Template: Executable Wrapper

```bash
#!/usr/bin/env bash
##
## @file script-name
## @brief Brief description of what script does
## @description
##   Thin wrapper around adt::lib::module::submodule library.
##   Detailed description of functionality.
##
## @usage
##   ./scripts/bin/script-name [arguments]
##   make target/name
##
## @author AI Diagrams Toolkit Team
## @date YYYY-MM-DD
## @version 1.0.0
##

set -euo pipefail

# Calculate paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Import library
source "${REPO_ROOT}/scripts/lib/module/implementation.sh"

# Import colors (optional)
source "${REPO_ROOT}/scripts/lib/tests/colors.sh"

# Main execution
adt::lib::module::implementation::main "$@"
exit $?
```

---

### Template: Test File

```bash
#!/usr/bin/env bash
##
## @file test-module-name.sh
## @brief Tests for module_name.sh library
## @description
##   Unit tests for adt::lib::module::name functions.
##   Follows TDD approach with RED-GREEN-REFACTOR cycle.
##
## @usage
##   bash tests/scripts/lib/test-module-name.sh
##   make scripts/test/single TEST=test-module-name
##
## @author AI Diagrams Toolkit Team
## @date YYYY-MM-DD
## @version 1.0.0
##

set -euo pipefail

# Get repo root
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

# Source framework
source "${REPO_ROOT}/tests/scripts/lib/test-framework.sh"

##
## @description Test guard clause prevents double sourcing
##
test_module_guard_works() {
    # First source
    source "${REPO_ROOT}/scripts/lib/module_name.sh"

    # Check guard variable set
    [[ -n "${adt__lib__module__LOADED}" ]] || {
        echo "❌ Guard variable not set"
        return 1
    }

    # Second source (should return early)
    source "${REPO_ROOT}/scripts/lib/module_name.sh"

    echo "✓ Guard clause works"
    return 0
}

##
## @description Test function exists with correct namespace
##
test_module_function_exists() {
    source "${REPO_ROOT}/scripts/lib/module_name.sh"

    adt::test::framework::assert_function_exists \
        "adt::lib::module::function_name" \
        "Function should exist"

    return $?
}

##
## @description Test basic functionality (happy path)
##
test_module_basic_functionality() {
    source "${REPO_ROOT}/scripts/lib/module_name.sh"

    # Arrange
    local input="test_value"
    local expected="expected_output"

    # Act
    local actual
    actual=$(adt::lib::module::function_name "$input")

    # Assert
    adt::test::framework::assert_equals \
        "$expected" \
        "$actual" \
        "Function should return expected value"

    return $?
}

# Run all tests
echo "Testing: module_name.sh"
echo ""

test_module_guard_works
test_module_function_exists
test_module_basic_functionality

# Print summary
echo ""
adt::test::framework::print_summary
exit $?
```

---

## 🎯 Common Patterns

### Counter Pattern

```bash
# Initialize counters
CREATED=0
SKIPPED=0
ERRORS=0

# Increment based on result
if create_symlink "$target" "$link"; then
    ((CREATED++))
else
    ((ERRORS++))
fi

# Report at end
echo "Created: $CREATED"
echo "Errors:  $ERRORS"
```

---

### Iteration with Status

```bash
for file in .ai/commands/generic/*.md; do
    if [[ ! -f "$file" ]]; then
        print_warning "File not found: $file"
        continue
    fi

    if process_file "$file"; then
        print_success "Processed: $(basename "$file")"
    else
        print_error "Failed: $(basename "$file")"
    fi
done
```

---

### Temporary Directory Pattern

```bash
# Create temp dir
tmp_dir=$(mktemp -d)

# Ensure cleanup on exit
trap "rm -rf '$tmp_dir'" EXIT

# Use temp dir
work_in_tmp() {
    cd "$tmp_dir"
    # Do work
    cd -
}

# Cleanup happens automatically via trap
```

---

## 📚 Examples

### Example 1: Simple Library

**File**: `scripts/lib/example/greeting.sh`

```bash
#!/usr/bin/env bash
##
## @file greeting.sh
## @brief Simple greeting functions
## @namespace adt::lib::example::greeting
##

set -euo pipefail

if [[ -n "${adt__lib__example__greeting__LOADED:-}" ]]; then
  return 0
fi
readonly adt__lib__example__greeting__LOADED=1

##
## @description Print greeting message
## @param $1 Name to greet
## @return 0 always
##
adt::lib::example::greeting::hello() {
    local name="$1"
    echo "Hello, $name!"
    return 0
}
```

**Test**: `tests/scripts/lib/test-example-greeting.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
source "${REPO_ROOT}/tests/scripts/lib/test-framework.sh"

test_greeting_hello_works() {
    source "${REPO_ROOT}/scripts/lib/example/greeting.sh"

    local output
    output=$(adt::lib::example::greeting::hello "World")

    adt::test::framework::assert_equals \
        "Hello, World!" \
        "$output" \
        "Should greet correctly"
}

test_greeting_hello_works
adt::test::framework::print_summary
```

---

### Example 2: Executable Wrapper

**File**: `scripts/bin/greet`

```bash
#!/usr/bin/env bash
##
## @file greet
## @brief Greet a user
## @usage ./scripts/bin/greet <name>
##

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "${REPO_ROOT}/scripts/lib/example/greeting.sh"

adt::lib::example::greeting::hello "$@"
```

---

## ❌ Anti-Patterns (Avoid)

### Don't: Global Variables Without Namespace

```bash
# ❌ BAD (can conflict with other scripts)
LOADED=1
RED='\033[0;31m'

# ✅ GOOD (namespaced, no conflicts)
readonly adt__lib__colors__LOADED=1
readonly adt__lib__colors__RED='\033[0;31m'
```

---

### Don't: Functions Without Namespace

```bash
# ❌ BAD (can conflict)
validate_input() {
    # ...
}

# ✅ GOOD (clear ownership)
adt::lib::validation::validate_input() {
    # ...
}
```

---

### Don't: Unquoted Variables

```bash
# ❌ BAD (breaks with spaces or empty)
if [ -f $file ]; then
    rm $file
fi

# ✅ GOOD (handles all cases)
if [[ -f "$file" ]]; then
    rm -f "$file"
fi
```

---

### Don't: Missing Error Handling

```bash
# ❌ BAD (continues on error)
#!/bin/bash
cd /some/dir
rm -rf *

# ✅ GOOD (exits on error)
#!/usr/bin/env bash
set -euo pipefail
cd /some/dir || exit 1
rm -rf ./*
```

---

### Don't: Undocumented Functions

```bash
# ❌ BAD (no documentation)
adt::lib::module::function() {
    echo "$1"
}

# ✅ GOOD (documented)
##
## @description Prints argument to stdout
## @param $1 String to print
## @return 0 always
##
adt::lib::module::function() {
    echo "$1"
    return 0
}
```

---

## 🔗 Related Documentation

- [Script Organization ADR](../architecture/script-organization.md) - Rationale for bin/ vs lib/ structure
- [Testing Strategy ADR](../architecture/testing-strategy.md) - Why TDD for scripts
- [Script Development Guide](../development/script-development.md) - Practical development workflow
- [Makefile Conventions](./makefile.md) - How scripts integrate with Make

---

## 📚 External References

- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- [Bash Best Practices](https://bertvv.github.io/cheat-sheets/Bash.html)
- [Doxygen Documentation](https://www.doxygen.nl/manual/docblocks.html)
- [ShellCheck](https://www.shellcheck.net/) - Linting tool

---

_Follow these conventions for consistent, maintainable, and testable shell scripts._
