# Release Workflow

Complete guide for creating and publishing releases.

## 🎯 Overview

This project uses a **fully automated release system**:

1. ✅ Write conventional commits
2. ✅ Run `make release`
3. ✅ Push with `git push --follow-tags`
4. ✅ CHANGELOG, version, and tags are handled automatically

## 📋 Complete Release Process

### Step 1: Preparation

Before creating a release, ensure your work is ready:

```bash
# 1. Ensure clean working directory
git status
# Should show: "nothing to commit, working tree clean"

# 2. Review changes since last release
git log v0.1.0..HEAD --oneline

# 3. Verify all commits follow Conventional Commits
git log --oneline -10
# Check format: "type(scope): subject"

# 4. Run tests (if applicable)
make test/makefile
# Or: make test
```

### Step 2: Create Release

```bash
# Preview what will happen (recommended)
make release/dry-run
```

**Review the output**:

- ✅ Version bump is correct (e.g., `0.1.0` → `0.2.0`)
- ✅ CHANGELOG section looks good
- ✅ All expected commits are included

**If everything looks good**:

```bash
# Create the release
make release
```

**What happens**:

1. ✅ Analyzes commits since last tag (`v0.1.0`)
2. ✅ Calculates version bump (MAJOR/MINOR/PATCH)
3. ✅ Updates `.semver` file (e.g., `0.1.0` → `0.2.0`)
4. ✅ Generates CHANGELOG section
5. ✅ Creates git commit: `chore(release): v0.2.0`
6. ✅ Creates git tag: `v0.2.0`

**Output**:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Creating Release
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

ℹ Using commit-and-tag-version@12.4.4
ℹ Config: .versionrc.js
✔ bumping version in .semver from 0.1.0 to 0.2.0
✔ outputting changes to CHANGELOG.md
✔ committing .semver and CHANGELOG.md
✔ tagging release v0.2.0
✔ Release created!

ℹ Run 'git push --follow-tags' to publish
```

### Step 3: Verify Locally

Before pushing, verify the release is correct:

```bash
# 1. Check version file
cat .semver
# Should show: 0.2.0

# 2. Check latest commit
git log -1 --oneline
# Should show: chore(release): v0.2.0

# 3. Check tag was created
git tag
# Should include: v0.2.0

# 4. Review CHANGELOG
head -50 CHANGELOG.md
# Should show new v0.2.0 section at top
```

### Step 4: Push to GitHub

```bash
# Push commits and tags together
git push --follow-tags origin main
```

**What happens on GitHub**:

1. ✅ Commits pushed to `main` branch
2. ✅ Tag `v0.2.0` pushed
3. ✅ GitHub auto-creates Release page from tag
4. ✅ Release notes extracted from CHANGELOG

**Verify on GitHub**:

- Commits: `https://github.com/USER/REPO/commits/main`
- Tags: `https://github.com/USER/REPO/tags`
- Releases: `https://github.com/USER/REPO/releases`

### Step 5: Publish GitHub Release (Optional)

GitHub auto-creates a release, but you can enhance it:

**Option A: GitHub Web UI**

1. Go to `https://github.com/USER/REPO/releases`
2. Find `v0.2.0` release
3. Click "Edit release"
4. Add additional notes, images, or attachments
5. Mark as "Latest release" if applicable
6. Publish

**Option B: GitHub CLI**

```bash
# Extract CHANGELOG section for this version
gh release create v0.2.0 \
  --title "v0.2.0 - AI Commands" \
  --notes-file <(sed -n '/^## \[0.2.0\]/,/^## \[/p' CHANGELOG.md | head -n -1)
```

## 🎮 Release Variations

### Automatic Version Bump

Let the tool decide based on commits:

```bash
make release
```

**Use when**: Normal development, following Conventional Commits

### Force Specific Version

Override automatic detection:

```bash
# Force PATCH (0.1.0 → 0.1.1)
make release/patch

# Force MINOR (0.1.0 → 0.2.0)
make release/minor

# Force MAJOR (0.1.0 → 1.0.0)
make release/major
```

**Use when**:

- Jumping to `v1.0.0` for first stable release
- Override auto-detection (e.g., force PATCH for docs-only)
- Specific version strategy (e.g., always MINOR for features)

### Pre-release Versions

Create alpha/beta/rc versions:

```bash
# Create alpha pre-release
npx commit-and-tag-version --prerelease alpha
# 0.2.0 → 0.2.1-alpha.0

# Another alpha iteration
npx commit-and-tag-version --prerelease alpha
# 0.2.1-alpha.0 → 0.2.1-alpha.1

# Promote to beta
npx commit-and-tag-version --prerelease beta
# 0.2.1-alpha.1 → 0.2.1-beta.0

# Final stable release
npx commit-and-tag-version
# 0.2.1-beta.0 → 0.2.1
```

**Use when**:

- Testing major changes with select users
- Gradual rollout
- Want feedback before stable release

## 🚨 Hotfix Workflow

For critical bugs in production that need immediate release:

### 1. Create Hotfix Branch

```bash
# Branch from the production tag that has the bug
git checkout -b hotfix/v1.2.4 v1.2.3
```

### 2. Make Fix

```bash
# Fix the bug
vim templates/flowchart.mmd

# Commit with conventional format
git commit -m "fix(critical): resolve security vulnerability CVE-2025-1234

Sanitize user input in template parser to prevent code injection.

Affected versions: v1.2.0 - v1.2.3
Fixed in: v1.2.4"
```

### 3. Create Patch Release

```bash
# Create patch release (v1.2.3 → v1.2.4)
make release/patch
```

### 4. Push Hotfix

```bash
# Push hotfix branch with tag
git push origin hotfix/v1.2.4 --follow-tags
```

### 5. Merge Back to Main

```bash
# Switch to main
git checkout main

# Merge hotfix
git merge hotfix/v1.2.4

# Push main
git push origin main

# Delete hotfix branch (optional)
git branch -d hotfix/v1.2.4
git push origin --delete hotfix/v1.2.4
```

### 6. Notify Users

```bash
# Create GitHub Release with security notice
gh release create v1.2.4 \
  --title "v1.2.4 - Security Fix" \
  --notes "🚨 Security Update: Fixes CVE-2025-1234. All users should upgrade immediately."
```

## 🛠️ Advanced Scenarios

### Undo Release (Before Push)

If you made a release but haven't pushed yet:

```bash
# 1. Delete the tag
git tag -d v0.2.0

# 2. Undo the release commit (keep changes)
git reset --soft HEAD~1

# 3. Fix issues (edit .versionrc.js, fix commits, etc.)

# 4. Recreate release
make release
```

### Undo Release (After Push)

⚠️ **Avoid if possible** - Published releases should be permanent

If absolutely necessary:

```bash
# 1. Delete remote tag
git push origin :refs/tags/v0.2.0

# 2. Delete local tag
git tag -d v0.2.0

# 3. Revert release commit
git revert HEAD

# 4. Push revert
git push origin main

# 5. Create corrected release
make release
git push --follow-tags origin main
```

**Better approach**: Create new patch release (v0.2.1) with fix

### Edit CHANGELOG After Release

If you need to improve CHANGELOG text:

```bash
# 1. Edit CHANGELOG.md
vim CHANGELOG.md

# 2. Amend release commit
git add CHANGELOG.md
git commit --amend --no-edit

# 3. Force update tag
git tag -f v0.2.0

# 4. Force push (⚠️ use carefully)
git push --force-with-lease origin main
git push --force origin v0.2.0
```

### Release from Non-Main Branch

For feature branches or experimental work:

```bash
# 1. Switch to branch
git checkout feature/new-api

# 2. Create pre-release
npx commit-and-tag-version --prerelease alpha

# 3. Push
git push origin feature/new-api --follow-tags

# 4. Merge to main when ready
git checkout main
git merge feature/new-api
git push origin main
```

## ✅ Pre-Release Checklist

Before running `make release`:

- [ ] All commits follow Conventional Commits format
- [ ] Tests pass (if applicable)
- [ ] Documentation updated
- [ ] Breaking changes documented in commit footer
- [ ] No uncommitted changes (`git status` clean)
- [ ] Reviewed changes since last release (`git log`)
- [ ] Ran `make release/dry-run` and verified output

## 📊 Post-Release Checklist

After running `git push --follow-tags`:

- [ ] Verify commits on GitHub: `https://github.com/USER/REPO/commits/main`
- [ ] Verify tag created: `https://github.com/USER/REPO/tags`
- [ ] Verify release page: `https://github.com/USER/REPO/releases`
- [ ] CHANGELOG looks correct on GitHub
- [ ] Version in `.semver` is correct
- [ ] (Optional) Announce release (Twitter, Discord, newsletter)
- [ ] (Optional) Update documentation site with new version
- [ ] (Optional) Close related issues/PRs

## 🐛 Troubleshooting

### "Cannot push to protected branch"

**Problem**: GitHub branch protection prevents direct push

**Solution**:

```bash
# Create PR instead
git checkout -b release/v0.2.0
git push origin release/v0.2.0 --follow-tags
gh pr create --title "Release v0.2.0" --body "Automated release"
```

### "Tag already exists"

**Problem**: Tag `v0.2.0` already exists

**Solution**:

```bash
# Check if tag is local or remote
git ls-remote --tags origin

# If local only, delete and recreate
git tag -d v0.2.0
make release

# If remote, either force-push (dangerous) or use next version
git push --force origin v0.2.0  # ⚠️ Use carefully
```

### "No commits since last release"

**Problem**: `make release` says no changes

**Solution**:

```bash
# Verify you have commits
git log v0.1.0..HEAD

# If no commits, make commits first
git commit -m "feat: add feature"
make release
```

### "Wrong version calculated"

**Problem**: Expected `v0.2.0` but got `v1.0.0`

**Solution**:

```bash
# Check for breaking change commits
git log v0.1.0..HEAD --grep "BREAKING CHANGE"
git log v0.1.0..HEAD --grep "!"

# If incorrect, use manual override
git tag -d v1.0.0
git reset --soft HEAD~1
make release/minor  # Force MINOR instead of MAJOR
```

### Release tool errors

**Problem**: `commit-and-tag-version` errors

**Solutions**:

```bash
# Check dependencies
make check/deps

# Verify configuration
make check/config

# Check .versionrc.js syntax
node -c .versionrc.js

# Check templates exist
ls .changelog-templates/
```

## 📖 Related Documentation

- [Commits Guide](./commits.md) - How to write conventional commits
- [CHANGELOG Guide](./changelog.md) - CHANGELOG format and automation
- [Versioning Guide](./versioning.md) - Semantic versioning strategy

## 🔗 External Resources

- [GitHub: About releases](https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases)
- [commit-and-tag-version Documentation](https://github.com/absolute-version/commit-and-tag-version)
- [git push --follow-tags](https://git-scm.com/docs/git-push#Documentation/git-push.txt---follow-tags)
