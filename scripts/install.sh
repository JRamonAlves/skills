#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
codex_dir=${CODEX_HOME:-"$HOME/.codex"}
opencode_dir=${XDG_CONFIG_HOME:-"$HOME/.config"}/opencode
claude_dir=${CLAUDE_CONFIG_DIR:-"$HOME/.claude"}

if [ ! -f "$codex_dir/config.toml" ]; then
  mkdir -p "$codex_dir"
  cp "$repo_dir/codex/config.toml" "$codex_dir/config.toml"
  printf '%s\n' "Installed portable Codex preferences at $codex_dir/config.toml"
else
  printf '%s\n' "Kept existing Codex configuration at $codex_dir/config.toml"
  printf '%s\n' "Merge preferences from $repo_dir/codex/config.toml if needed."
fi

printf '%s\n' 'Install or refresh the bundled plugin with:'
printf '%s\n' '  codex plugin add neon-postgres@plugins-cli'

if [ ! -f "$opencode_dir/config.json" ]; then
  mkdir -p "$opencode_dir"
  cp "$repo_dir/opencode/config.json" "$opencode_dir/config.json"
  printf '%s\n' "Installed portable OpenCode configuration at $opencode_dir/config.json"
else
  printf '%s\n' "Kept existing OpenCode configuration at $opencode_dir/config.json"
fi

if [ ! -f "$opencode_dir/opencode.json" ]; then
  mkdir -p "$opencode_dir"
  cp "$repo_dir/opencode/opencode.json" "$opencode_dir/opencode.json"
  printf '%s\n' "Installed portable OpenCode settings at $opencode_dir/opencode.json"
else
  printf '%s\n' "Kept existing OpenCode settings at $opencode_dir/opencode.json"
fi

if [ ! -e "$opencode_dir/AGENTS.md" ]; then
  ln -s "$repo_dir/AGENTS.md" "$opencode_dir/AGENTS.md"
  printf '%s\n' "Linked OpenCode instructions to $repo_dir/AGENTS.md"
else
  printf '%s\n' "Kept existing OpenCode instructions at $opencode_dir/AGENTS.md"
fi

if [ ! -f "$claude_dir/settings.json" ]; then
  mkdir -p "$claude_dir"
  cp "$repo_dir/claude/settings.json" "$claude_dir/settings.json"
  printf '%s\n' "Installed portable Claude Code settings at $claude_dir/settings.json"
else
  printf '%s\n' "Kept existing Claude Code settings at $claude_dir/settings.json"
  printf '%s\n' "Merge preferences from $repo_dir/claude/settings.json if needed."
fi

if [ ! -e "$claude_dir/CLAUDE.md" ]; then
  mkdir -p "$claude_dir"
  ln -s "$repo_dir/AGENTS.md" "$claude_dir/CLAUDE.md"
  printf '%s\n' "Linked Claude Code instructions to $repo_dir/AGENTS.md"
else
  printf '%s\n' "Kept existing Claude Code instructions at $claude_dir/CLAUDE.md"
fi

# Claude Code only discovers skills in its own directory, so link each one.
mkdir -p "$claude_dir/skills"
for skill in "$claude_dir"/skills/*; do
  if [ -L "$skill" ] && [ ! -e "$skill" ]; then
    case $(readlink "$skill") in
      "$repo_dir"/skills/*)
        rm "$skill"
        printf '%s\n' "Removed stale Claude Code skill link $skill"
        ;;
    esac
  fi
done
for skill in "$repo_dir"/skills/*/; do
  name=$(basename "$skill")
  if [ ! -e "$claude_dir/skills/$name" ]; then
    ln -s "$repo_dir/skills/$name" "$claude_dir/skills/$name"
    printf '%s\n' "Linked Claude Code skill $name"
  fi
done

printf '%s\n' 'Install or refresh the bundled Claude Code plugin with:'
printf '%s\n' "  claude plugin marketplace add $repo_dir"
printf '%s\n' '  claude plugin install neon@plugins-cli'
