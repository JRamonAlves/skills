# Agent workflow configuration

This repository is the portable source of truth for my agent workflow. It works on macOS and Linux without hard-coded usernames or cache paths.

## Problem

Setting up another computer requires the same agent instructions, skills, and preferences. This repository keeps those files together and links the skills into Claude Code, whose discovery directory differs from the shared directory used by Codex and OpenCode.

## Stack and architecture

POSIX shell scripts install JSON and TOML configuration templates and create symbolic links. Git hooks refresh the Claude Code links after merges and rebases. The repository stores configuration and instructions; the coding agents run separately.

## Project work and attribution

The repository combines agent preferences, shared instructions, an installer, and skill synchronization hooks. The bundled skills come from Matt Pocock and Vercel, with source versions in `.skill-lock.json` and licenses in [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md). Bundling or adapting these skills does not imply authorship of their upstream content.

## Contents

- `AGENTS.md` contains the shared instructions for agents.
- `skills/` contains installed skills and their supporting files.
- `codex/config.toml` contains portable Codex preferences.
- `opencode/` contains portable OpenCode settings, including the local Ollama provider.
- `claude/settings.json` contains portable Claude Code preferences.
- `.githooks/` relinks the Claude Code skills after every `git pull`.
- `.skill-lock.json` records installed skill sources and versions.
- `THIRD_PARTY_NOTICES.md` records licenses for bundled third-party content.

## Set up a computer

Clone this repository into `~/.agents` on either macOS or Linux.

```sh
git clone https://github.com/JRamonAlves/skills.git ~/.agents
cd ~/.agents
./scripts/install.sh
```

### What the installer sets up

- Codex discovers the shared skills in `~/.agents/skills` and receives portable preferences from `codex/config.toml`.
- OpenCode discovers the shared skills in `~/.agents/skills` and receives its global `AGENTS.md` through a link to this repository.
- OpenCode receives a portable local Ollama provider configuration at `http://localhost:11434`.
- Claude Code receives its global `CLAUDE.md` through a link to `AGENTS.md`.
- Claude Code discovers each shared skill through a link in `~/.claude/skills`. `scripts/link-claude-skills.sh` creates links for new skills and removes links to deleted ones.
- Git runs `scripts/link-claude-skills.sh` after every `git pull`, because the installer sets `core.hooksPath` to `.githooks`.
- Claude Code receives portable preferences from `claude/settings.json`.
- Codex, OpenCode, and Claude Code configuration directories are created when needed.

The script copies a configuration template only when the target file does not already exist. It preserves an existing `~/.codex/config.toml`, `~/.config/opencode/config.json`, `~/.config/opencode/opencode.json`, `~/.claude/settings.json`, `~/.claude/CLAUDE.md`, or skill in `~/.claude/skills`.

### Finish the setup

Install and authenticate the applications on the new computer. Install and start Ollama if you want to use the bundled local provider. Start a new Codex, OpenCode, or Claude Code session after setup so it reloads the skills and configuration.

It never copies authentication, local project trust settings, history, or machine-specific hooks.

### Install only the skills in Claude Code

Claude Code reads skills from `~/.claude/skills/<name>/SKILL.md` and ignores `~/.agents/skills`. Link the skills, enable the relinking on pull, and link the shared instructions:

```sh
cd ~/.agents
./scripts/link-claude-skills.sh
git config core.hooksPath .githooks
ln -s ~/.agents/AGENTS.md ~/.claude/CLAUDE.md
```

Run `ls ~/.claude/skills` to check the links, then start a new session. Type `/` in Claude Code to list the skills.

## Sync changes

On either computer, commit changes in `~/.agents` and push them. Pull before editing on the other computer.

A `git pull` in `~/.agents` updates the skills for Codex, OpenCode, and Claude Code. Codex and OpenCode read the repository directly. For Claude Code, the Git hooks link new skills and remove links to deleted ones. Start a new session to load the changes.

```sh
git pull --rebase
git add -A
git commit -m "chore: update agent workflow"
git push
```

## Test

Run the checks without installing agents or changing their configuration:

```sh
sh scripts/test.sh
```

The tests use a temporary fixture to check initial linking, repeated runs, newly added skills, removal of stale repository links, preservation of local and unrelated links, and paths containing spaces. They also check shell syntax for the scripts and hooks. They do not run the full installer or verify discovery inside the agent applications.

## Decisions and limitations

- Symbolic links keep skills synchronized without copying them on every update.
- Existing configuration files remain in place; preference changes require a manual merge.
- `core.hooksPath` replaces the repository's previous hook-directory setting. Review existing hooks before installing.
- Installed agent applications, authentication, and Ollama are separate setup steps.
- Portable configuration can still refer to models, plugins, or providers unavailable on another account or computer.
- The synchronization scripts target macOS and Linux. Windows support is not implemented.

## Publish

Create an empty GitHub repository, then connect and push this repository.

```sh
git remote add origin <your-github-repository-url>
git push -u origin main
```

Do not commit credentials, tokens, private keys, chat history, or machine-local override files. Review `git status` before every commit.
