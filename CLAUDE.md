# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

This repository contains personal dotfiles configuration. Guidance below is adapted from the zircote/.claude standard.

## Global Instructions

**ALWAYS** ask questions when producing a plan until you have reached 95% or GREATER confidence. ALWAYS DO THIS.

These rules guide Claude across projects. Preserve protocols; keep wording minimal.

## Environment & Standards Includes

When working in these environments, read and follow the corresponding file:

| Environment | Include File |
|-------------|--------------|
| Shell (bash/zsh) | `~/.claude/includes/shell.md` |
| Git/Version Control | `~/.claude/includes/git.md` |
| Vim/Neovim | `~/.claude/includes/vim.md` |
| Documentation | `~/.claude/includes/documentation.md` |
| MCP Tools/Skills | `~/.claude/includes/mcp-reference.md` |

**Usage**: Read the relevant include file(s) at the start of environment-specific tasks to ensure compliance with standards.

## Custom Commands

### Git Workflow (`/git`)

| Command | Description |
|---------|-------------|
| `/git:cm` | Stage all files and create a commit (conventional commits, splits new vs modified) |
| `/git:cp` | Stage, commit, and push all changes |
| `/git:pr [to-branch]` | Create a pull request using `gh` CLI |
| `/git:fr [remote] [branch]` | Fetch from remote and rebase current branch onto remote branch |
| `/git:sync [remote] [branch]` | Full sync: fetch, rebase, and push (with confirmation) |
| `/git:ff [remote] [branch]` | Fast-forward merge only (no rebase, no merge commits) |
| `/git:prune [--force]` | Clean up stale local branches (dry-run by default) |

### Architecture Planning (`/cs` plugin)

**Requires**: Install `cs` plugin via `/plugin` → `./claude-spec-marketplace`

| Command | Description |
|---------|-------------|
| `/cs:p <project-idea>` | Strategic project planner with Socratic requirements elicitation, PRD, and implementation plan |
| `/cs:i [project-id\|project-slug]` | Implementation progress tracker with PROGRESS.md checkpoint file |
| `/cs:s [project-id\|--list\|--expired]` | Project status, portfolio listing |
| `/cs:c <project-path\|project-id>` | Close out completed project, archive artifacts |
| `/cs:log <on\|off\|status\|show>` | Toggle prompt capture logging for architecture work |
| `/cs:wt:create` | Create git worktree with Claude agent |
| `/cs:wt:status` | Show worktree status |
| `/cs:wt:cleanup` | Clean up worktrees |

Workflow: `/cs:p` to plan → `/cs:i` to implement → `/cs:s` to monitor → `/cs:c` to complete

**PROGRESS.md Checkpoint System**: The `/cs:i` command creates and maintains a PROGRESS.md file that tracks task status with timestamps, calculates phase progress, logs divergences from original plan, and persists state across sessions.

## Worktree Management

**Use the `cs` plugin** for worktree operations: `/cs:wt:create`, `/cs:wt:status`, `/cs:wt:cleanup`

Or use trigger phrases with the `worktree-manager` skill.

### Worktree Directory Discipline

**CRITICAL**: When working in a worktree, ALL file operations MUST target the worktree path, not the source repository.

Before creating/editing files, verify your working directory:
1. Check `cwd` from session context or run `pwd`
2. If in a worktree (e.g., `/path/to/worktrees/dotfiles/feature-branch/`), ALL writes go there
3. If in source root (e.g., `~/.claude/`), switch to the worktree or confirm with user

If files were created in the wrong location, copy them to the worktree before committing.

## Prompt Capture Hook

Logs prompts during `/cs:*` sessions for traceability. Part of the `cs` plugin.

- **Enable**: `/cs:log on` | **Disable**: `/cs:log off` | **Status**: `/cs:log status`
- **Auto-analysis**: On `/cs:c`, generates Interaction Analysis for retrospective

## Skills Quick Reference

Skills are in `~/.claude/skills/`. Key categories:
- **Documents**: `pdf`, `docx`, `xlsx`, `pptx`
- **Media**: `ai-multimodal`, `media-processing`, `chrome-devtools`
- **Development**: `frontend-development`, `backend-development`, `databases`, `devops`
- **AI/Prompting**: `anthropic-prompt-engineer`, `anthropic-architect`
- **Utilities**: `docs-seeker`, `changelog-generator`, `mcp-builder`

Invoke via Skill tool or trigger phrases defined in each skill's `SKILL.md`.

## Parallel Specialist Subagents

Leverage the Task tool with specialized subagents from `~/.claude/agents/` for efficiency.

### Agent Categories (`~/.claude/agents/`)
| Category | Specialists | Use For |
|----------|-------------|---------|
| 01-core-development | frontend-developer, backend-developer, fullstack-developer | Application architecture, UI/UX |
| 02-language-specialists | python-pro, typescript-pro, golang-pro | Language-specific implementation |
| 03-infrastructure | devops-engineer, sre-engineer, terraform-engineer | Infrastructure, deployment |
| 04-quality-security | code-reviewer, security-auditor, test-automator | Code quality, security |
| 05-data-ai | data-scientist, ml-engineer, prompt-engineer | Data pipelines, ML/AI |
| 06-developer-experience | documentation-engineer, cli-developer, refactoring-specialist | DX tooling, documentation |

### Parallel Execution Rules
- **When to parallelize**: Launch multiple specialists simultaneously when tasks are independent
- **Specialist matching**: Route work to the most domain-appropriate agent
- **Dependency awareness**: Only serialize when one agent's output informs another's parameters
- **Consolidation**: Synthesize parallel agent results into a unified response

Prefer parallel specialist agents over sequential single-threaded work when the task naturally decomposes into independent expert domains.

## API Response Validation

- Treat unexpected empties as suspicious. Do not proceed.
- Steps: STOP → try minimal query → ask user to confirm → document quirk in ~/.claude/learnings/
- Be honest: state "API returned 0"; list causes; try alternatives; ask for confirmation.
- When in doubt about data quality → ASK THE USER.

## Dotfiles Specific

- Symlink management: Use `ln -sf` to update symlinks atomically
- Version control: Track changes with git commits describing configuration updates
- No formal test suite - validate configurations through manual verification
- Files organized by OS/context (shell, vim, git, etc.)
- No complex build processes - direct file placement

Any changes should maintain simplicity and direct applicability to target systems.