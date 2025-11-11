# Versioning System Architecture Decision

- **Status**: Accepted
- **Date**: 2025-11-10
- **Deciders**: Jose R. Prieto
- **Context**: AI Diagrams Toolkit v0.1.0

## Decision

Use a **3-layer architecture** for automated versioning and releases that provides zero implicit defaults, tool
agnosticism, and full reproducibility.

## Context

### Problem Statement

Automated release tools (like `semantic-release`, `standard-version`, `commit-and-tag-version`) typically provide:

- **Implicit defaults**: Preset CHANGELOG formats, commit type mappings
- **Tool coupling**: Configuration tied to specific tool APIs
- **Hidden behavior**: Templates and logic buried in tool internals
- **Version drift**: Tool updates can silently change output format

**Challenges**:

1. **Format control**: Hard to customize CHANGELOG format exactly
2. **Reproducibility**: Tool updates may change behavior
3. **Transparency**: Can't see what templates are being used
4. **Migration**: Switching tools requires rewriting configuration
5. **Non-standard projects**: Tools assume `package.json` exists

### Project Requirements

This is a **language-agnostic toolkit** (Mermaid templates + guides), not a Node.js application:

- No `package.json` needed
- No Node.js dependencies to install
- No build step
- Pure templates and documentation

**Need**: Automated releases without Node.js project baggage.

## Rationale

### 1. Zero Implicit Defaults

**Principle**: Make all configuration explicit and version-controlled.

**Problem with tool defaults**:

```bash
# Tool preset (hidden in node_modules)
"templates": "default-preset"  # What does this look like? 🤷

# Tool updates
v12.0.0 → "### Features"
v13.0.0 → "### Added"  # Format changed!
```

**Solution: Explicit templates**:

```
.changelog-templates/
├── template.hbs     # Main structure (visible, version-controlled)
├── header.hbs       # Version header format
├── commit.hbs       # Individual commit format
└── footer.hbs       # Footer with links
```

**Benefits**:

- ✅ **Visible**: See exactly what format will be generated
- ✅ **Tracked**: Changes to templates are git-tracked
- ✅ **Stable**: Tool updates don't change format
- ✅ **Customizable**: Edit templates directly

### 2. Separation of Concerns

**Principle**: Separate presentation (templates), behavior (config), and runtime (vars) into distinct layers.

**4-Layer Architecture**:

```
┌─────────────────────────────────────────────────────────────┐
│ LAYER 1: TEMPLATES (.changelog-templates/)                  │
│ ─────────────────────────────────────────────────────────── │
│ Handlebars templates (version-controlled)                   │
│ Define exact CHANGELOG format                               │
│ ─────────────────────────────────────────────────────────── │
│ Files: template.hbs, header.hbs, commit.hbs, footer.hbs    │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ LAYER 2: BEHAVIOR CONFIG (.versionrc.js)                    │
│ ─────────────────────────────────────────────────────────── │
│ What commits to include                                     │
│ How to map commit types to CHANGELOG sections              │
│ Which files to update (.semver, CHANGELOG.md)              │
│ How to generate CHANGELOG (loads Layer 1 templates)        │
│ ─────────────────────────────────────────────────────────── │
│ File: .versionrc.js (JavaScript config module)             │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ LAYER 3: RUNTIME VARS (.env.dist / .env)                    │
│ ─────────────────────────────────────────────────────────── │
│ Which tool to use (commit-and-tag-version)                  │
│ Which version of tool (@12.4.4)                             │
│ Path to config file (.versionrc.js)                         │
│ ─────────────────────────────────────────────────────────── │
│ Files: .env.dist (defaults), .env (local overrides)        │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│ LAYER 4: ORCHESTRATION (Makefile)                           │
│ ─────────────────────────────────────────────────────────── │
│ Loads runtime vars from Layer 3                             │
│ Executes tool with pinned version                           │
│ Tool reads Layer 2 config automatically                     │
│ Config loads Layer 1 templates                              │
│ ─────────────────────────────────────────────────────────── │
│ File: Makefile (GNU Make)                                   │
└─────────────────────────────────────────────────────────────┘
```

**Why layers?**

Each layer has single responsibility:

- **Layer 1**: How output looks (format)
- **Layer 2**: What to include (logic)
- **Layer 3**: Which tool to use (runtime)
- **Layer 4**: How to execute (orchestration)

**Change isolation**:

- Change format → Edit Layer 1 (templates)
- Change logic → Edit Layer 2 (config)
- Change tool → Edit Layer 3 (runtime vars)
- Change workflow → Edit Layer 4 (Makefile)

### 3. Tool Agnosticism

**Principle**: Configuration should be tool-independent where possible.

**Current tool**: `commit-and-tag-version@12.4.4`

**Future tool** (hypothetical): `bun-release@1.0.0`

**Migration effort**:

```bash
# Update .env.dist (2 lines)
- NODE_RELEASE_PACKAGE := commit-and-tag-version
+ NODE_RELEASE_PACKAGE := bun-release
- NODE_RELEASE_PACKAGE_VERSION := 12.4.4
+ NODE_RELEASE_PACKAGE_VERSION := 1.0.0

# Layer 1 (templates): UNCHANGED (tool-agnostic)
# Layer 2 (config): MINIMAL changes (if APIs differ)
# Layer 4 (Makefile): UNCHANGED (reads from Layer 3)
```

### 4. Reproducibility

**Principle**: Same inputs always produce same outputs.

**Reproducible elements**:

1. **Pinned tool version**: `@12.4.4` (not `@latest`)
2. **Explicit templates**: Version-controlled, not preset defaults
3. **Explicit config**: All options specified
4. **Zero install**: `npx` executes pinned version directly

**Guarantee**:

```bash
# Developer A (macOS, today)
make release  # → Uses commit-and-tag-version@12.4.4

# Developer B (Linux, next month)
make release  # → Uses commit-and-tag-version@12.4.4

# CI/CD (Ubuntu, always)
make release  # → Uses commit-and-tag-version@12.4.4

# Same version, same templates, same config → Same result
```

### 5. Configuration as Code

**Principle**: Everything version-controlled, local overrides allowed.

**Committed**:

- `.env.dist` - Default configuration
- `.versionrc.js` - Behavior config
- `.changelog-templates/` - Templates
- `Makefile` - Orchestration

**Gitignored**:

- `.env` - Local overrides (optional)

**Workflow**:

```bash
# Team: Uses defaults
make release
# → Reads .env.dist

# Developer: Tests new tool version
echo "NODE_RELEASE_PACKAGE_VERSION=13.0.0" > .env
make release
# → Reads .env (overrides .env.dist)

# Satisfied? Update .env.dist and commit
# Not satisfied? Delete .env, back to defaults
```

## Benefits

### For Developers

1. **Predictable output**: Know exactly what CHANGELOG will look like
2. **Easy customization**: Edit templates directly
3. **Local experimentation**: Test tool versions via `.env`
4. **Fast debugging**: All config visible in repo

### For Maintainers

1. **Change tracking**: Template/config changes visible in git
2. **Tool migration**: Switch tools with minimal changes
3. **Version locking**: Pin tool versions for stability
4. **Clear contracts**: Each layer has defined responsibility

### For Documentation

1. **Single source**: Document templates, not tool internals
2. **Transparency**: Show actual templates in docs
3. **Stability**: Docs don't change when tool updates

### For CI/CD

1. **Reproducibility**: Same output every time
2. **Zero setup**: `npx` downloads tool on-demand
3. **No drift**: Pinned versions prevent surprise changes

## Trade-offs

### Costs

#### 1. More Files

**Problem**: 3 layers = more files to manage

```
Single-file approach (coupled):
.versionrc.json  # Everything in one file

3-layer approach (decoupled):
.changelog-templates/template.hbs
.changelog-templates/header.hbs
.changelog-templates/commit.hbs
.changelog-templates/footer.hbs
.versionrc.js
.env.dist
Makefile
```

**When it hurts**: Very simple projects, single developer

**Mitigation**: Comprehensive documentation, clear naming

#### 2. Learning Curve

**Problem**: Must understand 3 layers + Handlebars syntax

**Complexity**:

- Layer 1: Handlebars templating language
- Layer 2: JavaScript config + transform functions
- Layer 3: Makefile variable syntax
- Layer 4: GNU Make syntax

**Mitigation**:

- Extensive documentation (this file + conventions)
- Working examples in templates
- `make help` for discoverability

**When to avoid**: Projects where team doesn't want to learn system

#### 3. Initial Setup Time

**Problem**: Takes longer to set up than using tool defaults

**Setup steps**:

1. Create 4 Handlebars templates
2. Write `.versionrc.js` with types, transform, writerOpts
3. Create `.env.dist` with runtime vars
4. Add Makefile targets

vs.

```bash
# Tool defaults (quick but opaque)
npm install --save-dev semantic-release
npx semantic-release
```

**When it pays off**: Projects with >1 release, custom requirements, long lifespan

#### 4. Debugging Complexity

**Problem**: Errors can occur in any layer

```bash
make release
# Error: ???
# Layer 4 (Make)? Layer 3 (vars)? Layer 2 (config)? Layer 1 (templates)?
```

**Mitigation**:

- `make release/dry-run` - Preview without committing
- `make check/config` - Validate configuration
- `make check/deps` - Verify dependencies
- Clear error messages in Makefile

### Limitations

#### What This Architecture is NOT

1. **Not simpler than defaults**: More files, more complexity
2. **Not beginner-friendly**: Requires understanding 3 layers
3. **Not zero-config**: Requires explicit setup
4. **Not tool-independent**: Still uses specific tool (just switchable)

#### When to avoid this architecture

- **Prototypes**: Use tool defaults for speed
- **Single release**: Not worth setup for one release
- **Standard Node.js app**: npm scripts + package.json is simpler
- **No customization needed**: Tool presets may be sufficient

## Alternatives Considered

### 1. Tool Preset Defaults

**Approach**: Use `commit-and-tag-version` with default configuration

```bash
npx commit-and-tag-version
```

**Pros**:

- ✅ Zero setup
- ✅ Works immediately
- ✅ Community-tested defaults

**Cons**:

- ❌ Implicit format (can't see templates)
- ❌ Tool updates may change format
- ❌ Hard to customize exactly
- ❌ Tied to tool internals

**Verdict**: Too opaque, not customizable enough

### 2. Single Config File

**Approach**: Everything in `.versionrc.json`

```json
{
  "types": [
    ...
  ],
  "template": "...",
  "header": "...",
  "commit": "..."
}
```

**Pros**:

- ✅ Single file to manage
- ✅ Simpler than 3 layers

**Cons**:

- ❌ JSON can't load external files
- ❌ Templates as inline strings (hard to edit)
- ❌ No local overrides possible
- ❌ Mixes concerns (templates + config + runtime)

**Verdict**: Not expressive enough, couples concerns

### 3. Hybrid Approach (Templates + Inline Config)

**Approach**: Templates external, config inline

```javascript
// .versionrc.js
module.exports = {
    types: [...],
    writerOpts: {
        mainTemplate: fs.readFileSync('template.hbs'),
        // Rest inline
        commitGroupsSort: 'title',
        commitsSort: ['scope', 'subject']
    }
}
```

**Pros**:

- ✅ Templates version-controlled
- ✅ Config in one file

**Cons**:

- ❌ Still mixes config + runtime
- ❌ No local overrides
- ❌ Tool selection hardcoded

**Verdict**: Better than single file, but lacks runtime flexibility

### 4. Tool-Specific Config Only

**Approach**: Use `package.json` scripts + tool config

```json
{
  "scripts": {
    "release": "commit-and-tag-version"
  },
  "standard-version": {
    "types": [
      ...
    ]
  }
}
```

**Pros**:

- ✅ Standard Node.js approach
- ✅ IDE integration

**Cons**:

- ❌ Requires `package.json` (this is not a Node.js app)
- ❌ Tool-specific config format
- ❌ Hard to switch tools
- ❌ No environment vars

**Verdict**: Not suitable for language-agnostic toolkit

### 5. Custom Release Script

**Approach**: Write custom bash/python script

```bash
#!/bin/bash
# release.sh
VERSION=$(cat .semver)
NEW_VERSION=$(bump_version $VERSION)
generate_changelog > CHANGELOG.md
git tag v$NEW_VERSION
```

**Pros**:

- ✅ Complete control
- ✅ No external dependencies

**Cons**:

- ❌ Reinventing the wheel
- ❌ Must maintain custom logic
- ❌ Prone to bugs
- ❌ No community support

**Verdict**: Too much maintenance burden

## Decision Matrix

| Criterion              | 3-Layer | Preset Defaults | Single Config | Hybrid | Tool-Specific | Custom Script |
|------------------------|---------|-----------------|---------------|--------|---------------|---------------|
| Zero implicit defaults | ✅ ✅     | ❌               | ⚠️            | ✅      | ❌             | ✅ ✅           |
| Tool agnostic          | ✅ ✅     | ❌               | ⚠️            | ❌      | ❌             | ✅ ✅           |
| Reproducible           | ✅ ✅     | ⚠️              | ✅             | ✅      | ⚠️            | ⚠️            |
| Easy to customize      | ✅ ✅     | ❌               | ⚠️            | ✅      | ✅             | ✅ ✅           |
| Low setup time         | ❌       | ✅ ✅             | ✅             | ✅      | ✅ ✅           | ❌             |
| Low learning curve     | ❌       | ✅ ✅             | ✅             | ⚠️     | ✅             | ⚠️            |
| Local overrides        | ✅ ✅     | ❌               | ❌             | ❌      | ❌             | ⚠️            |
| Separation of concerns | ✅ ✅     | ❌               | ❌             | ⚠️     | ❌             | N/A           |
| Language-agnostic      | ✅ ✅     | ✅               | ✅             | ✅      | ❌             | ✅ ✅           |
| Community support      | ⚠️      | ✅ ✅             | ✅             | ✅      | ✅ ✅           | ❌             |

**Legend**: ✅ ✅ = Excellent, ✅ = Good, ⚠️ = Acceptable with caveats, ❌ = Poor

## Implementation

### Layer 1: Templates (`.changelog-templates/`)

**Purpose**: Define exact CHANGELOG format using Handlebars templates.

**Files**:

#### `template.hbs`

Main structure that loops through versions and groups commits:

```handlebars
{{> header}}

{{#if noteGroups}}
    {{#each noteGroups}}
        ### ⚠ {{title}}
        {{#each notes}}
            * {{#if commit.scope}}**{{commit.scope}}:** {{/if}}{{text}}
        {{/each}}
    {{/each}}
{{/if}}

{{#each commitGroups}}
    {{#if title}}
        ### {{title}}
    {{/if}}
    {{#each commits}}
        {{> commit root=@root}}
    {{/each}}
{{/each}}
```

#### `header.hbs`

Version header with link to GitHub release:

```handlebars
## [{{version}}](https://github.com/joserprieto/ai-diagrams-toolkit/releases/tag/v{{version}}) - {{date}}
```

#### `commit.hbs`

Individual commit format with links:

```handlebars
- {{#if scope}}**{{scope}}:** {{/if}}{{subject}}{{#if
        hash}} ([{{shortHash}}](https://github.com/joserprieto/ai-diagrams-toolkit/commit/{{hash}})){{/if}}{{#if
        references}}, closes {{#each
        references}}[#{{this.issue}}](https://github.com/joserprieto/ai-diagrams-toolkit/issues/{{this.issue}}){{#unless
        @last}}, {{/unless}}{{/each}}{{/if}}
```

#### `footer.hbs`

Footer with unreleased changes link:

```handlebars

{{#if linkCompare}}
    [Unreleased]: https://github.com/joserprieto/ai-diagrams-toolkit/compare/v{{currentTag}}...HEAD
{{/if}}
```

**Why Handlebars?**

- Industry-standard templating language
- Explicit control over format
- Logic-less (presentation only)
- Compatible with conventional-changelog ecosystem

### Layer 2: Behavior Configuration (`.versionrc.js`)

**Purpose**: Define what commits to include and how to process them.

**Why JavaScript?**

- Can load external files (templates)
- Supports functions (transform, compare)
- More expressive than JSON

**Key Sections**:

#### Commit Type Mapping (Keep a Changelog)

```javascript
types: [
    {type: 'feat', section: 'Added', hidden: false},
    {type: 'fix', section: 'Fixed', hidden: false},
    {type: 'perf', section: 'Changed', hidden: false},
    {type: 'docs', section: 'Documentation', hidden: false},
    {type: 'revert', section: 'Reverted', hidden: false},
    {type: 'security', section: 'Security', hidden: false},
    {type: 'deprecate', section: 'Deprecated', hidden: false},
    {type: 'remove', section: 'Removed', hidden: false},
    // Hidden types (internal changes)
    {type: 'refactor', section: 'Changed', hidden: true},
    {type: 'style', section: 'Changed', hidden: true},
    {type: 'test', section: 'Changed', hidden: true},
    {type: 'build', section: 'Changed', hidden: true},
    {type: 'ci', section: 'Changed', hidden: true},
    {type: 'chore', section: 'Changed', hidden: true}
]
```

Maps Conventional Commits → Keep a Changelog sections.

#### Version File Configuration

```javascript
packageFiles: [
    {filename: '.semver', type: 'plain-text'}
],
    bumpFiles
:
[
    {filename: '.semver', type: 'plain-text'}
]
```

Uses `.semver` instead of `package.json` (language-agnostic).

#### Transform Function

```javascript
transform: (commit, context) => {
    const typeMapping = {
        'feat': 'Added',
        'fix': 'Fixed',
        'perf': 'Changed',
        'docs': 'Documentation',
        'revert': 'Reverted',
        'security': 'Security',
        'deprecate': 'Deprecated',
        'remove': 'Removed'
    };

    // Skip hidden types
    const hiddenTypes = ['refactor', 'style', 'test', 'build', 'ci', 'chore'];
    if (hiddenTypes.includes(commit.type)) {
        return null;
    }

    // Map type to Keep a Changelog section
    commit.type = typeMapping[commit.type] || commit.type;

    // Ensure shortHash exists
    if (typeof commit.hash === 'string' && !commit.shortHash) {
        commit.shortHash = commit.hash.substring(0, 7);
    }

    // Capitalize first letter of subject
    if (commit.subject) {
        commit.subject = commit.subject.charAt(0).toUpperCase() + commit.subject.slice(1);
    }

    return commit;
}
```

Processes each commit before rendering.

#### Writer Options

```javascript
writerOpts: {
    mainTemplate: loadTemplate('template.hbs'),
        headerPartial
:
    loadTemplate('header.hbs'),
        commitPartial
:
    loadTemplate('commit.hbs'),
        footerPartial
:
    loadTemplate('footer.hbs'),
        groupBy
:
    'type',
        commitsSort
:
    ['scope', 'subject']
}
```

Loads Layer 1 templates and defines grouping/sorting.

### Layer 3: Runtime Variables (`.env.dist` / `.env`)

**Purpose**: Externalize tool selection for easy switching.

**`.env.dist`** (committed, defaults):

```makefile
# ── Release Tool Configuration ────────────────────────────────
NODE_RELEASE_PACKAGE := commit-and-tag-version
NODE_RELEASE_PACKAGE_VERSION := 12.4.4
NODE_RELEASE_CONFIG := .versionrc.js
```

**`.env`** (gitignored, local overrides):

```makefile
# Test different tool version
NODE_RELEASE_PACKAGE_VERSION := 13.0.0
```

**Why separate?**

- Team uses defaults (`.env.dist`)
- Individual devs can experiment (`.env`)
- CI always uses defaults (no `.env` in repo)

### Layer 4: Orchestration (Makefile)

**Purpose**: Load configuration and execute tool. See [Orchestration Architecture Decision](./orchestration.md) for
complete details.

**Key Features**:

```makefile
# Load environment
ifneq (,$(wildcard .env))
    include .env
else ifneq (,$(wildcard .env.dist))
    include .env.dist
endif

# Construct command
CMD := npx $(NODE_RELEASE_PACKAGE)@$(NODE_RELEASE_PACKAGE_VERSION)

# Execute release
release:
	@$(CMD)
```

## Workflow Example

### 1. Developer Makes Commits

```bash
git commit -m "feat(templates): add state diagram template"
git commit -m "fix(guides): correct Mermaid syntax example"
git commit -m "docs(readme): update installation instructions"
```

### 2. Developer Creates Release

```bash
make release
```

### 3. Makefile Loads Configuration

```
Makefile reads .env.dist:
  NODE_RELEASE_PACKAGE = commit-and-tag-version
  NODE_RELEASE_PACKAGE_VERSION = 12.4.4
  NODE_RELEASE_CONFIG = .versionrc.js

Constructs command:
  npx commit-and-tag-version@12.4.4
```

### 4. Tool Executes

```
commit-and-tag-version:
  1. Reads .versionrc.js automatically
  2. Finds last tag: v0.1.0
  3. Analyzes commits: v0.1.0..HEAD
  4. Detects types: feat, fix, docs
  5. Calculates bump: MINOR (0.1.0 → 0.2.0)
```

### 5. Commits Processed

```
For each commit:
  1. Calls transform(commit)
  2. Maps type: feat → Added, fix → Fixed, docs → Documentation
  3. Skips hidden: (none in this case)
  4. Adds shortHash
  5. Capitalizes subject
```

### 6. CHANGELOG Generated

```
Loads templates from Layer 1:
  template.hbs
  header.hbs
  commit.hbs
  footer.hbs

Groups commits by type:
  Added:        feat commits
  Fixed:        fix commits
  Documentation: docs commits

Renders CHANGELOG:
  ## [0.2.0](...) - 2025-11-10

  ### Added
  - **templates:** Add state diagram template ([a1b2c3d](...))

  ### Fixed
  - **guides:** Correct Mermaid syntax example ([b2c3d4e](...))

  ### Documentation
  - **readme:** Update installation instructions ([c3d4e5f](...))
```

### 7. Files Updated

```bash
# .semver
0.1.0 → 0.2.0

# CHANGELOG.md
New section prepended (previous versions untouched)

# Git
Commit: chore(release): v0.2.0
Tag: v0.2.0
```

### 8. Developer Pushes

```bash
git push --follow-tags origin main
```

GitHub detects tag and auto-creates Release page.

## Key Design Decisions

### Decision 1: Why `.semver` instead of `package.json`?

**Context**: This is not a Node.js application

**Rationale**:

- Toolkit is language-agnostic (Mermaid templates + guides)
- No other Node.js dependencies
- `package.json` would be misleading

**Result**: Simpler, clearer project structure

### Decision 2: Why `.versionrc.js` instead of `.versionrc.json`?

**Context**: Need to load external template files

**Rationale**:

```javascript
// ✅ Possible in .js
mainTemplate: fs.readFileSync('template.hbs')

// ❌ Impossible in .json
```

**Result**: Can load Layer 1 templates from Layer 2 config

### Decision 3: Why separate `.changelog-templates/` directory?

**Context**: Need version-controlled, explicit templates

**Rationale**:

- Tool presets are implicit (can't see source)
- Tool updates may change presets
- Custom format requires explicit control

**Result**: Templates tracked in git, stable across tool updates

### Decision 4: Why `npx` instead of `npm install`?

**Context**: Want zero-install experience

**Rationale**:

```bash
# ✅ Direct execution (no install)
npx commit-and-tag-version@12.4.4

# ❌ Requires setup
npm install
npm run release
```

**Result**: No `node_modules/`, exact version every time

### Decision 5: Why Makefile instead of npm scripts?

**Context**: Language-agnostic toolkit, not Node.js app

**Rationale**: See [Orchestration Architecture Decision](./orchestration.md)

**Result**: Standard interface, powerful configuration loading

## Future Evolution

### Planned Enhancements

**v0.2.0+**:

- Pre-release support (alpha, beta, rc)
- Multiple CHANGELOG formats (GitHub, GitLab, plain text)

**v0.3.0+**:

- Automated GitHub Release creation
- Release notes templates

**v1.0.0+**:

- Plugin system for custom commit types
- Multi-repo support (monorepo)

### Extension Points

**Add custom commit type**:

```javascript
// .versionrc.js
types: [
    // ... existing types
    {type: 'experiment', section: 'Experimental', hidden: false}
]
```

**Custom template**:

```bash
# Create custom template
cp .changelog-templates/commit.hbs .changelog-templates/commit-custom.hbs

# Edit as needed
vim .changelog-templates/commit-custom.hbs

# Reference in .versionrc.js
commitPartial: loadTemplate('commit-custom.hbs')
```

## References

- [conventional-changelog](https://github.com/conventional-changelog/conventional-changelog)
- [commit-and-tag-version](https://github.com/absolute-version/commit-and-tag-version)
- [Handlebars](https://handlebarsjs.com/)
- [Keep a Changelog](https://keepachangelog.com/)
- [Semantic Versioning](https://semver.org/)

## Related Documentation

- [Orchestration Decision](./orchestration.md) - Why Makefile as orchestrator
- [CHANGELOG Conventions](../conventions/changelog.md) - CHANGELOG format and automation
- [Versioning Strategy](../conventions/versioning.md) - Semantic Versioning rules
- [Release Workflow](../conventions/releases.md) - Complete release process
