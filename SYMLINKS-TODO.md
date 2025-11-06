# Symlinks Needed for v0.2.0

Execute these commands to create necessary symlinks:

```bash
cd /Users/joserprieto/Projects/joserprieto/technical-insight-lab/contexts/personal/ai-diagrams-toolkit/repo/repo-v0.2.0

# 1. AGENTS.md → CLAUDE.md symlink
cd .ai
ln -s AGENTS.md CLAUDE.md
cd ..

# 2. Claude Code commands symlink
cd .claude
ln -s ../.ai/commands commands
cd ..

# 3. Cursor commands symlink
cd .cursor
ln -s ../.ai/commands commands
cd ..
```

After creating symlinks:
- Verify: `ls -la .ai/` should show `CLAUDE.md -> AGENTS.md`
- Verify: `ls -la .claude/` should show `commands -> ../.ai/commands`
- Verify: `ls -la .cursor/` should show `commands -> ../.ai/commands`

Then delete this file: `rm SYMLINKS-TODO.md`
