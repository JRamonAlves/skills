# Agent workflow configuration

This repository is the portable source of truth for my agent workflow. It works on macOS and Linux without hard-coded usernames or cache paths.

## Contents

- `AGENTS.md` contains the shared instructions for agents.
- `skills/` contains installed skills and their supporting files.
- `plugins/neon-postgres/` contains the Neon plugin used by the marketplace.
- `plugins/marketplace.json` references the bundled plugin by a relative path.
- `codex/config.toml` contains portable Codex preferences.
- `opencode/` contains portable OpenCode settings, including the local Ollama provider.
- `.skill-lock.json` records installed skill sources and versions.
- `THIRD_PARTY_NOTICES.md` records licenses for bundled third-party content.

## Set up a computer

Clone this repository into `~/.agents` on either macOS or Linux.

```sh
git clone <your-github-repository-url> ~/.agents
cd ~/.agents
./scripts/install.sh
```

### What the installer sets up

- Codex discovers the shared skills in `~/.agents/skills` and receives portable preferences from `codex/config.toml`.
- OpenCode discovers the shared skills in `~/.agents/skills` and receives its global `AGENTS.md` through a link to this repository.
- OpenCode receives a portable local Ollama provider configuration at `http://localhost:11434`.
- Codex and OpenCode configuration directories are created when needed.

The script copies a configuration template only when the target file does not already exist. It preserves an existing `~/.codex/config.toml`, `~/.config/opencode/config.json`, or `~/.config/opencode/opencode.json`.

### Finish the setup

Install and authenticate both applications on the new computer. Then install the bundled Codex plugin:

```sh
codex plugin add neon-postgres@plugins-cli
```

Install and start Ollama if you want to use the bundled local provider. Start a new Codex or OpenCode session after setup so it reloads the skills and configuration.

It never copies authentication, local project trust settings, history, or machine-specific hooks.

## Sync changes

On either computer, commit changes in `~/.agents` and push them. Pull before editing on the other computer.

```sh
git pull --rebase
git add -A
git commit -m "chore: update agent workflow"
git push
```

## Publish

Create an empty GitHub repository, then connect and push this repository.

```sh
git remote add origin <your-github-repository-url>
git push -u origin main
```

Do not commit credentials, tokens, private keys, chat history, or machine-local override files. Review `git status` before every commit.
