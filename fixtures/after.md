# AGENTS.md

Read this file before starting.

## Working in this repository

Run `make test` before every commit. Fix a failing test before adding code; if a test is wrong, change the test in its own commit and say why. Ask before pushing to `main`; push to a branch without asking.

Write the summary in three sentences: what changed, why, and what a reviewer should look at first.

Commit messages carry no emoji. The changelog does, one per entry, because the release notes have had them since the first release.

## Style

Format on save with the repository's formatter. Leave files you did not otherwise touch unformatted, so a change stays reviewable. When the linter and the existing style disagree, follow the existing style and open an issue naming the rule.

## Reviewing

Read the diff twice: once for what changed, once for what did not change but should have. Check that every new function has a test and that every removed test had a reason to go.

State a finding as a finding, not as a question. When there is none, say what you checked, so the author knows what the approval covers.
