#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
codex_dir=${CODEX_HOME:-"$HOME/.codex"}
opencode_dir=${XDG_CONFIG_HOME:-"$HOME/.config"}/opencode

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
