#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
test_dir=$(mktemp -d "${TMPDIR:-/tmp}/agent-workflow-tests.XXXXXX")
test_dir=$(CDPATH= cd -- "$test_dir" && pwd)
trap 'rm -rf "$test_dir"' EXIT HUP INT TERM

fixture="$test_dir/repository with spaces"
claude_dir="$test_dir/claude with spaces"
mkdir -p "$fixture/scripts" "$fixture/skills/first" "$claude_dir/skills"
cp "$repo_dir/scripts/link-claude-skills.sh" "$fixture/scripts/"

run_linker() {
    CLAUDE_CONFIG_DIR="$claude_dir" sh "$fixture/scripts/link-claude-skills.sh" > /dev/null
}

assert_link() {
    [ -L "$claude_dir/skills/$1" ]
    [ "$(readlink "$claude_dir/skills/$1")" = "$fixture/skills/$1" ]
}

run_linker
assert_link first
printf '%s\n' 'PASS: links skills across paths containing spaces'

run_linker
assert_link first
printf '%s\n' 'PASS: rerunning preserves valid links'

mkdir -p "$fixture/skills/second"
run_linker
assert_link second
printf '%s\n' 'PASS: discovers skills added after initial setup'

mv "$fixture/skills/first" "$test_dir/removed-skill"
run_linker
[ ! -L "$claude_dir/skills/first" ]
assert_link second
printf '%s\n' 'PASS: removes stale links owned by this repository'

mkdir -p "$fixture/skills/local" "$claude_dir/skills/local"
printf '%s\n' 'user content' > "$claude_dir/skills/local/KEEP"
mkdir -p "$fixture/skills/external" "$test_dir/external"
ln -s "$test_dir/external" "$claude_dir/skills/external"
ln -s "$test_dir/missing" "$claude_dir/skills/unrelated"
run_linker
[ "$(cat "$claude_dir/skills/local/KEEP")" = 'user content' ]
[ ! -L "$claude_dir/skills/local" ]
[ "$(readlink "$claude_dir/skills/external")" = "$test_dir/external" ]
[ "$(readlink "$claude_dir/skills/unrelated")" = "$test_dir/missing" ]
printf '%s\n' 'PASS: preserves local skills and unrelated valid or broken links'

for script in "$repo_dir"/scripts/*.sh "$repo_dir"/.githooks/*; do
    sh -n "$script"
done
printf '%s\n' 'PASS: shell scripts and Git hooks parse successfully'
