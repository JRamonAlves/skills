#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
codex_dir=${CODEX_HOME:-"$HOME/.codex"}

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
