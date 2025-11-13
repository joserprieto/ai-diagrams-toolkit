#!/usr/bin/env bash
#
# install-symlinks.sh - Setup symlinks for AI command systems
#
# This script creates symbolic links from AI assistant directories
# (.claude, .cursor) to the centralized command repository (.ai/commands/).
#
# Platform Support:
#   - Linux/macOS: Native symlinks (ln -sf)
#   - Windows (Git Bash/WSL): Native symlinks if available
#   - Windows (PowerShell): Junction points (see install-symlinks.ps1)
#
# Usage:
#   ./scripts/install-symlinks.sh
#   make install

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Directories
AI_COMMANDS_GENERIC="$PROJECT_ROOT/.ai/commands/generic"
AI_COMMANDS_CLAUDE="$PROJECT_ROOT/.ai/commands/claude"
AI_COMMANDS_CODEX="$PROJECT_ROOT/.ai/commands/codex"
CLAUDE_COMMANDS="$PROJECT_ROOT/.claude/commands"
CURSOR_COMMANDS="$PROJECT_ROOT/.cursor/commands"

# Counters
CREATED=0
SKIPPED=0
ERRORS=0

# Functions
print_header() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  AI Diagrams Toolkit - Symlink Installation${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

check_directories() {
    print_info "Checking source directories..."

    if [[ ! -d "$AI_COMMANDS_GENERIC" ]]; then
        print_error "Source directory not found: .ai/commands/generic/"
        exit 1
    fi

    print_success "Source directories validated"
    echo ""
}

create_symlink() {
    local target="$1"
    local link_name="$2"
    local description="$3"

    # Check if target exists
    if [[ ! -e "$target" ]]; then
        print_warning "$description: Source not found, skipping"
        ((SKIPPED++))
        return
    fi

    # Remove existing link/directory if it exists
    if [[ -L "$link_name" ]]; then
        print_info "$description: Removing existing symlink"
        rm -f "$link_name"
    elif [[ -e "$link_name" ]]; then
        print_warning "$description: Path exists (not a symlink), skipping"
        print_info "  → Manually remove: $link_name"
        ((SKIPPED++))
        return
    fi

    # Create parent directory if needed
    local parent_dir
    parent_dir="$(dirname "$link_name")"
    if [[ ! -d "$parent_dir" ]]; then
        mkdir -p "$parent_dir"
    fi

    # Create symlink
    if ln -sf "$target" "$link_name" 2>/dev/null; then
        print_success "$description"
        ((CREATED++))
    else
        print_error "$description: Failed to create symlink"
        ((ERRORS++))
    fi
}

install_claude_symlinks() {
    print_info "Setting up Claude Code symlinks..."
    echo ""

    # Main generic commands
    local target="../.ai/commands/generic"
    create_symlink "$target" "$CLAUDE_COMMANDS" "Claude Code: generic commands"

    # Claude-specific commands subdirectory
    if [[ -d "$AI_COMMANDS_CLAUDE" ]]; then
        local claude_target="../../.ai/commands/claude"
        create_symlink "$claude_target" "$CLAUDE_COMMANDS/claude" "Claude Code: claude-specific commands"
    fi

    echo ""
}

install_cursor_symlinks() {
    print_info "Setting up Cursor IDE symlinks..."
    echo ""

    # Only generic commands (Cursor doesn't support subdirectories)
    local target="../.ai/commands/generic"
    create_symlink "$target" "$CURSOR_COMMANDS" "Cursor IDE: generic commands"

    echo ""
}

print_codex_instructions() {
    print_info "Codex CLI setup instructions..."
    echo ""
    echo "  Codex CLI uses global scope (~/.codex/prompts/), so symlinks"
    echo "  are not applicable. Copy commands manually as needed:"
    echo ""
    echo -e "  ${YELLOW}# Generic commands${NC}"
    echo "  cp .ai/commands/generic/*.md ~/.codex/prompts/"
    echo ""
    echo -e "  ${YELLOW}# Codex-specific commands${NC}"
    if [[ -d "$AI_COMMANDS_CODEX" ]] && [[ -n "$(ls -A "$AI_COMMANDS_CODEX" 2>/dev/null)" ]]; then
        echo "  cp .ai/commands/codex/*.md ~/.codex/prompts/"
    else
        echo "  (No codex-specific commands yet)"
    fi
    echo ""
    echo "  After copying, restart Codex CLI to load new commands."
    echo ""
}

verify_installation() {
    print_info "Verifying installation..."
    echo ""

    local all_good=true

    # Check Claude Code
    if [[ -L "$CLAUDE_COMMANDS" ]] && [[ -e "$CLAUDE_COMMANDS" ]]; then
        print_success "Claude Code: commands symlink valid"
    else
        print_error "Claude Code: commands symlink invalid or broken"
        all_good=false
    fi

    # Check Cursor
    if [[ -L "$CURSOR_COMMANDS" ]] && [[ -e "$CURSOR_COMMANDS" ]]; then
        print_success "Cursor IDE: commands symlink valid"
    else
        print_error "Cursor IDE: commands symlink invalid or broken"
        all_good=false
    fi

    echo ""

    if $all_good; then
        print_success "All symlinks verified successfully!"
    else
        print_warning "Some symlinks could not be verified"
    fi
}

print_summary() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}  Installation Summary${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "  Symlinks created: ${GREEN}$CREATED${NC}"
    echo -e "  Skipped:          ${YELLOW}$SKIPPED${NC}"
    echo -e "  Errors:           ${RED}$ERRORS${NC}"
    echo ""

    if [[ $ERRORS -eq 0 ]]; then
        print_success "Installation completed successfully!"
        echo ""
        print_info "Next steps:"
        echo "  1. Restart Claude Code / Cursor IDE"
        echo "  2. Type '/' to see available commands"
        echo "  3. For Codex CLI, follow manual copy instructions above"
    else
        print_warning "Installation completed with errors"
        echo ""
        print_info "Please check error messages above and retry"
    fi

    echo ""
}

detect_windows() {
    if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]] || [[ -n "${WSL_DISTRO_NAME:-}" ]]; then
        return 0  # Is Windows
    else
        return 1  # Not Windows
    fi
}

print_windows_warning() {
    echo ""
    print_warning "Windows environment detected"
    echo ""
    echo "  This script uses Unix symlinks which may not work properly on Windows."
    echo "  For native Windows support, use the PowerShell script instead:"
    echo ""
    echo -e "  ${YELLOW}PowerShell (Administrator):${NC}"
    echo "    .\\scripts\\install-symlinks.ps1"
    echo ""
    echo "  Alternatively, ensure Developer Mode is enabled in Windows Settings"
    echo "  to allow symlink creation without administrator privileges."
    echo ""
    read -p "  Continue anyway? (y/N) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo ""
        print_info "Installation cancelled"
        exit 0
    fi
    echo ""
}

# Main execution
main() {
    print_header

    # Platform detection
    if detect_windows; then
        print_windows_warning
    fi

    # Check prerequisites
    check_directories

    # Install symlinks
    install_claude_symlinks
    install_cursor_symlinks

    # Verify installation
    verify_installation

    # Print Codex instructions
    print_codex_instructions

    # Print summary
    print_summary
}

# Run main function
main "$@"
