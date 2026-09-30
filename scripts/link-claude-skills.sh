#!/bin/sh
# Claude Code only discovers skills in its own directory, so link each one.
# The Git hooks in .githooks run this script after every pull.
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
claude_dir=${CLAUDE_CONFIG_DIR:-"$HOME/.claude"}

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
