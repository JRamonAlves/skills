---
name: pull-request-modeling
description: Write pull request titles and descriptions from the current branch, diff, issue, or user notes. Use when the user asks to draft, improve, or prepare a PR.
argument-hint: "Optional base branch, PR URL, issue link, or notes"
disable-model-invocation: true
---

# Pull request writing

Write a pull request that helps reviewers understand the change quickly and review it safely.

## Process

1. Identify the source of truth.
   - Prefer the current branch diff against the base branch.
   - Use linked issues, specs, commits, and user notes as supporting context.
   - If the base branch is unclear, inspect common defaults such as `main`, `master`, or the merge base. Ask only if inspection cannot determine it.

2. Inspect the change.
   - Check `git status` first.
   - Read the diff and relevant files before writing.
   - Separate intentional changes from unrelated local noise.
   - Notice migrations, config changes, public API changes, feature flags, and behavior changes.

3. Write the PR.
   - Use a clear title with the user-facing or reviewer-facing outcome.
   - Start the body with what changed and why.
   - Group details by reviewer concern, not by implementation chronology.
   - Include validation run, skipped validation, and manual checks.
   - Call out risks, rollout notes, migrations, follow-ups, and breaking changes when present.
   - Do not invent tests, tickets, metrics, or product intent.

4. Self-review.
   - Remove filler, hype, and generic claims.
   - Make every bullet answer a reviewer question.
   - Keep wording concise and concrete.
   - Ensure the title and body match the actual diff.

## Default PR template

Follow the template if it already exists in the repo, search for it if needed to make sure you're not skipping it.

Use this shape unless the repo has its own pull request template.

```markdown
## Summary

-

## Validation

-

## Notes


```

Omit `Notes` when there are no risks, rollout details, migrations, follow-ups, or reviewer context.

## Repository templates

If the repo has a PR template, follow it instead of the default. Look for:

- `.github/pull_request_template.md`
- `.github/PULL_REQUEST_TEMPLATE.md`
- `.github/PULL_REQUEST_TEMPLATE/*.md`
- `docs/pull_request_template.md`

Preserve required sections, prompts, checkboxes, and issue-linking syntax. Remove placeholder text when filling the template.

## Title rules

- Prefer an imperative or outcome-focused title.
- Keep it under 72 characters when practical.
- Prefer to include conventional prefixes even if the repo doesn't use them.
- Avoid vague titles such as "Fix bug", "Update code", or "Improve flow".

## Body rules

- Explain the reviewer-visible result before implementation details.
- Mention files or modules only when they help review.
- Include screenshots or recordings only when the user provided them or they already exist in the repo.
- Use checkboxes only when the repo template requires them.
- Keep the PR honest about incomplete work.

## Validation rules

- List commands exactly as run, using backticks.
- Say when validation was not run and why.
- Do not claim the app was manually tested unless it was.
- Include failing validation only with the failure cause and whether it appears related.

## Output

Return only the PR title and body unless the user asks for analysis. If useful, add a short note after the draft with missing context the user may want to fill in.
