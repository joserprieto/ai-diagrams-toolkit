# Versioning System Architecture

Complete technical architecture of the automated versioning and release system.

## 🎯 Overview

The versioning system is a **three-layer architecture** that provides:

✅ **Zero implicit defaults** - All configuration is explicit and version-controlled
✅ **Tool-agnostic** - Easy to switch release tools with 2-line change
✅ **Fully automated** - One command generates CHANGELOG, updates version, creates tag
✅ **Reproducible** - Pinned tool versions, explicit templates, clear configuration

## 📐 Architecture Layers

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

## 🔧 Layer Details

### Layer 1: Templates (`.changelog-templates/`)

**Purpose**: Version-controlled Handlebars templates to avoid implicit defaults from tools.

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

Individual commit format with links to commit and issues:

```handlebars
- {{~#if scope}}**{{scope}}:** {{/if~}}
{{~#if subject}}{{subject}}{{else}}{{header}}{{/if~}}
{{~#if hash}} ([{{shortHash}}](https://github.com/joserprieto/ai-diagrams-toolkit/commit/{{hash}})){{/if~}}
{{~#if references}}, closes {{#each
        references}}[#{{this.issue}}](https://github.com/joserprieto/ai-diagrams-toolkit/issues/{{this.issue}}){{/each}}{{/if}}
```

#### `footer.hbs`

Footer with link to unreleased changes:

```handlebars
{{~#if linkCompare}}
    [Unreleased]: https://github.com/joserprieto/ai-diagrams-toolkit/compare/v{{currentTag}}...HEAD
{{~/if}}
```

**Why Handlebars?**

- Explicit control over format
- No dependency on tool preset defaults
- Version-controlled (changes are tracked)
- Tool updates won't break CHANGELOG format

### Layer 2: Behavior Configuration (`.versionrc.js`)

**Purpose**: Define what commits to include and how to process them.

**Why JavaScript (not JSON)?**

- Can load external files (`fs.readFileSync()` for templates)
- Allows dynamic configuration
- Supports transform functions for commit processing

**Key Sections**:

#### Commit Type Mapping

```javascript
types: [
    {type: 'feat', section: 'Added', hidden: false},
    {type: 'fix', section: 'Fixed', hidden: false},
    {type: 'perf', section: 'Changed', hidden: false},
    {type: 'docs', section: 'Documentation', hidden: false},
    {type: 'revert', section: 'Reverted', hidden: false},
    // ... more types
    {type: 'refactor', section: 'Changed', hidden: true},  // Hidden
    {type: 'style', section: 'Changed', hidden: true},
    // ... more hidden types
]
```

Maps Conventional Commits types → Keep a Changelog sections.

#### Version Control

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

Defines where to read/write version (`.semver` file, not `package.json`).

#### Transform Function

```javascript
transform: (commit, context) => {
    const typeMapping = {
        'feat': 'Added',
        'fix': 'Fixed',
        // ...
    };

    // Skip hidden types
    if (hiddenTypes.includes(commit.type)) {
        return null;
    }

    // Map type to section
    commit.type = typeMapping[commit.type] || commit.type;

    // Add short hash
    commit.shortHash = commit.hash.substring(0, 7);

    return commit;
}
```

Processes each commit before rendering:

- Maps types to Keep a Changelog sections
- Filters hidden commits
- Adds computed properties (shortHash)

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

Loads templates from Layer 1 and defines grouping/sorting.

### Layer 3: Runtime Variables (`.env.dist` / `.env`)

**Purpose**: Externalize tool selection and versions for easy switching.

**`.env.dist`** (version-controlled, defaults):

```makefile
# Release automation tool
NODE_RELEASE_PACKAGE := commit-and-tag-version
NODE_RELEASE_PACKAGE_VERSION := 12.4.4
NODE_RELEASE_CONFIG := .versionrc.js
```

**`.env`** (gitignored, local overrides):

Users can copy `.env.dist` → `.env` and customize:

```makefile
# Use different tool
NODE_RELEASE_PACKAGE := standard-version
NODE_RELEASE_PACKAGE_VERSION := 9.5.0
```

**Why separate runtime vars?**

- **Agnostic**: Variable naming is semantic, not tool-specific
- **Switchable**: Change tool with 2-line edit
- **Pinned**: Exact versions for reproducibility
- **Local**: Users can override without affecting repo

### Layer 4: Orchestration (Makefile)

**Purpose**: Load configuration and execute tool.

**Key Features**:

#### Environment Loading

```makefile
ifneq (,$(wildcard .env))
    include .env
    ENV_FILE_LOADED := .env
else ifneq (,$(wildcard .env.dist))
    include .env.dist
    ENV_FILE_LOADED := .env.dist
endif
```

Tries `.env` first (local overrides), falls back to `.env.dist` (defaults).

#### Release Target

```makefile
.PHONY: release
release: check/config
	@if ! command -v npx >/dev/null 2>&1; then \
		$(call print_error,npx not found); \
		exit 1; \
	fi
	$(call print_header,Creating Release)
	$(call print_info,Using $(NODE_RELEASE_PACKAGE)@$(NODE_RELEASE_PACKAGE_VERSION))
	@npx $(NODE_RELEASE_PACKAGE)@$(NODE_RELEASE_PACKAGE_VERSION)
	$(call print_success,Release created!)
```

Executes pinned tool version via `npx` (no `npm install` needed).

#### Validation Targets

```makefile
check/config:  ## Show current configuration
check/deps:    ## Check system dependencies
```

Validate setup before releasing.

## 🔄 Complete Workflow

### 1. Developer Makes Commits

```bash
git commit -m "feat(templates): add state diagram"
git commit -m "fix(guides): correct Mermaid syntax"
```

### 2. Developer Runs Release

```bash
make release
```

### 3. Makefile Execution

1. Loads `.env` or `.env.dist`
2. Checks dependencies (`npx` available?)
3. Executes: `npx commit-and-tag-version@12.4.4`

### 4. Tool Execution

1. Reads `.versionrc.js` automatically
2. Finds last git tag (`v0.1.0`)
3. Analyzes commits since tag
4. Calculates version bump (MAJOR/MINOR/PATCH)

### 5. CHANGELOG Generation

1. Groups commits by type
2. Calls `transform()` function on each commit
3. Maps types to Keep a Changelog sections
4. Loads Handlebars templates from `.changelog-templates/`
5. Renders CHANGELOG section

### 6. Version Update

1. Updates `.semver` file
2. Prepends CHANGELOG section to `CHANGELOG.md`
3. Creates git commit: `chore(release): v0.2.0`
4. Creates git tag: `v0.2.0`

### 7. Developer Pushes

```bash
git push --follow-tags origin main
```

GitHub detects tag and auto-creates Release page.

## 🎯 Key Design Decisions

### Decision 1: Why `.versionrc.js` instead of `.versionrc.json`?

**Reason**: JSON cannot load external files.

```javascript
// ✅ Possible in .js
mainTemplate: fs.readFileSync('.changelog-templates/template.hbs')

// ❌ Impossible in .json
"mainTemplate"
:
"???"
```

### Decision 2: Why separate `.semver` file instead of `package.json`?

**Reason**: This is not a Node.js application.

- Toolkit is language-agnostic (Mermaid templates + guides)
- No other Node.js dependencies needed
- Simpler, clearer, no confusion about project type

### Decision 3: Why Makefile instead of `npm scripts`?

**Reason**: Standard for language-agnostic toolkits.

- No `package.json` needed
- More powerful (environment loading, conditionals)
- Familiar to template toolkit users
- `npx` provides zero-install experience

### Decision 4: Why `.changelog-templates/` instead of inline strings?

**Reason**: Version control and explicit defaults.

- Templates are tracked in git (changes visible)
- No dependency on tool preset defaults
- Tool updates won't break CHANGELOG format
- Easy to customize per project

### Decision 5: Why `npx` instead of `npm install`?

**Reason**: Zero-install, pinned versions.

```bash
# ✅ Direct execution with pinned version
npx commit-and-tag-version@12.4.4

# ❌ Requires install step
npm install
npm run release
```

Benefits:

- No `node_modules/` directory
- Exact version every time
- Works in CI without setup

## 🔒 Guarantees

### Reproducibility

**Same inputs → Same outputs**:

- Pinned tool version (`@12.4.4`)
- Explicit templates (version-controlled)
- Explicit configuration (all options specified)
- No implicit defaults

### Isolation

**Tool changes don't affect this repo**:

- Tool preset changes → No impact (we have explicit templates)
- Tool API changes → No impact (pinned version)
- Different dev environments → No impact (npx downloads exact version)

### Transparency

**Everything is visible**:

- Templates in repo (`.changelog-templates/`)
- Configuration in repo (`.versionrc.js`)
- Runtime vars in repo (`.env.dist`)
- All changes tracked in git

## 🐛 Troubleshooting

### "Template not found"

**Problem**: `commit-and-tag-version` can't find `.changelog-templates/template.hbs`

**Solution**: Check paths in `.versionrc.js`:

```javascript
function loadTemplate(filename) {
    return fs.readFileSync(
        path.join(__dirname, '.changelog-templates', filename),
        'utf-8'
    );
}
```

`__dirname` should resolve to repo root.

### "CHANGELOG format is wrong"

**Problem**: Generated CHANGELOG doesn't match expected format

**Solutions**:

1. Check templates have correct Handlebars syntax
2. Verify `transform()` function is mapping types correctly
3. Run `make release/dry-run` to preview output
4. Check for whitespace issues (`~` in Handlebars)

### "Wrong version calculated"

**Problem**: Expected `v0.2.0` but got `v1.0.0`

**Solutions**:

1. Check commits for breaking changes (`feat!:` or `BREAKING CHANGE:`)
2. Verify `firstRelease` setting in `.versionrc.js`
3. Check `.semver` contains correct current version
4. Use `make release/minor` to force MINOR bump

## 📚 Related Documentation

- [CHANGELOG Conventions](../conventions/changelog.md) - How CHANGELOG is generated
- [Versioning Strategy](../conventions/versioning.md) - Semantic Versioning rules
- [Release Workflow](../conventions/releases.md) - Complete release process

## 🔗 External Resources

- [commit-and-tag-version](https://github.com/absolute-version/commit-and-tag-version)
- [conventional-changelog-config-spec](https://github.com/conventional-changelog/conventional-changelog-config-spec)
- [Handlebars](https://handlebarsjs.com/)
- [GNU Make](https://www.gnu.org/software/make/manual/)
