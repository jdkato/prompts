# Guards

The word "please" in the middle of a sentence is not an opener, so this line stands. A function named `handle` is code, as is everything in the fenced block below:

```
def handle(err):
    # you must never reach here
    ensure(err)
```

Ten absolutes are the budget, and a file with seven keeps them: always, never, must, always, never, must, always.

Use emoji in the changelog. Run the tests. Be brief. Commit after every change.

## A section under the cap

This section stays under three hundred words, so it earns no alert, and it says so in as many words as it needs and no more. The cap is a suggestion in any case, and a section that runs to two hundred and fifty words of dense instruction is a choice the author gets to make.

## What the newer rules leave alone

A lowercase "important" is a word, and three shouts are within budget: IMPORTANT, NEVER, ALWAYS. A path in a code span, `C:\Users\shared`, is code. A description written in the third person, on a line that is not frontmatter, is prose like any other. The year 2026 on its own is a number, and "since the redesign" names no date.

A `name` key in a workflow is not a skill's name:

```yaml
name: Build + Test
```

A description in an example is not the file's own:

```yaml
name: a-workflow-whose-name-runs-far-past-the-sixty-four-characters-a-loader-accepts
description: I can run the tests.
```

A wrapped line can start with a key and still be prose. Use a release tag, not a branch
name: a branch moves without notice, and a pinned tag is the one that stays where you left it.
