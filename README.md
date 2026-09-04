# Prompts: a Vale style for instruction files

`AGENTS.md`, `CLAUDE.md`, `SKILL.md`, and system prompts are prose files in a repository, and this style lints them. It holds an instruction file to the standard the file holds a model to: say what to do, in the mood of a command, in a file short enough to be read on every turn.

The rules run wherever Vale runs, in an editor, a hook, or CI, and on any agent's file.

## Install

> Prompts requires Vale v3.21.0 or later, for the section-length rule.

```ini
Packages = https://github.com/jdkato/prompts/releases/latest/download/Prompts.zip

[{AGENTS,CLAUDE,SKILL}.md]
BasedOnStyles = Prompts
```

```console
$ vale sync
```

Name the files you mean. A style for instructions has no business in the README.

## Rules

| Rule | Level | What it reports |
| ---- | ----- | --------------- |
| `Imperative` | warning | A sentence that opens with advice rather than an instruction: `you should`, `please`, `make sure to`, `it is important to`. |
| `Vague` | warning | A word that names no action: `handle`, `ensure`, `appropriately`, `as needed`, `best practices`, and their kin. |
| `Absolutes` | warning | More than ten of `always`, `never`, `must`, and `under no circumstances` in one file, counted over its prose. |
| `Contradiction` | warning | Two instructions that pull opposite ways: `ask before` and `never ask`, `use emoji` and `no emoji`, `be brief` and `be thorough`, `commit after` and `never commit`, `run the tests` and `skip the tests`. |
| `Frontmatter` | error | A skill's `name` past 64 characters or `description` past 1,024, which is where a loader stops reading. |
| `SectionLength` | suggestion | A section past 300 words, subsections included. The fix is a heading. |
| `Length` | warning | A file past 2,500 words, which is read on every turn. Move what is only sometimes needed into a skill or a linked file. |
| `Emphasis` | warning | More than three shouted words, `IMPORTANT`, `MUST`, `NEVER`, `DO NOT`, in capitals. Emphasize one line and it stands out; emphasize many and none does. |
| `ThirdPerson` | error | A skill description that opens `I can` or `You can use this`. It is read inside a system prompt, in the third person. |
| `Trigger` | warning | A skill description that says what the skill does but never when to use it. |
| `TimeSensitive` | warning | `as of 2025`, `before August 2026`, `currently`, `for now`. Wrong on a date the file does not know. |
| `Paths` | error | A path with backslashes in prose. Forward slashes work everywhere. |

Each alert names the span, so an agent asked to fix its own instruction file gets the exact words back. `Vague` and `Imperative` carry no replacement on purpose, since the fix is a sentence written around what should happen, and only the author knows what that is.

## Tune it

Levels and toggles from your config, as always. The two counts take a bracket key:

```ini
[AGENTS.md]
BasedOnStyles = Prompts
Prompts.Absolutes[max] = 20
Prompts.SectionLength = NO
```

To extend a word list, extend the rule in a style of your own and switch the parent off:

```yaml
# styles/House/Vague.yml
extends: Prompts.Vague
tokens+:
  - leverage
```

## Contradiction, honestly

`Contradiction` reads a fixed list of pairs and reports the second half of a pair when the first is already in the file. It does not understand the file. Two instructions that apply to different situations, `never ask` in one section and `always ask before` in another, read as a contradiction to it, and the alert says so: say when each applies. A file that does is a better file, which is the point of the rule.

## Sources

Each rule carries a `link` to the guidance it enforces, and each alert shows it. The guidance, in the vendors' own words:

- **Imperative** and **Vague**. Anthropic's prompting guide, under "Be clear and direct": "Claude responds well to clear, explicit instructions," and "explicitly request it rather than relying on the model to infer this from vague prompts." The Claude Code guide's table of what to leave out of a `CLAUDE.md` includes "Self-evident practices like 'write clean code'," and OpenAI's GPT-4.1 guide asks for instructions "as specific and clear as possible."
- **Absolutes**. The Claude Code guide: "If you emphasize many lines, none of them stands out." The GPT-4.1 guide: "It's generally not necessary to use all-caps or other incentives like bribes or tips," and a prompt that does "could cause GPT-4.1 to pay attention to it too strictly."
- **Contradiction**. The GPT-4.1 guide: "if there are conflicting instructions, GPT-4.1 tends to follow the one closer to the end of the prompt." The skill authoring guide, under "Use consistent terminology": "Choose one term and use it throughout."
- **Frontmatter**. The skill authoring guide's frontmatter requirements: a `name` of "Maximum 64 characters" and a `description` of "Maximum 1,024 characters."
- **SectionLength** and **Length**. The skill authoring guide: "Keep SKILL.md body under 500 lines for optimal performance," and the Claude Code guide on the over-specified `CLAUDE.md`: "Claude ignores half of it because important rules get lost in the noise." The section figure is a fraction of the file figure; no guide publishes one.
- **Emphasis**. The same two sentences as **Absolutes**, applied to capitals: "If you emphasize many lines, none of them stands out," and all-caps that "could cause GPT-4.1 to pay attention to it too strictly."
## Sources for the skill rules

- **ThirdPerson** and **Trigger**. The skill authoring guide, under "Writing effective descriptions": "Always write in third person. The description is injected into the system prompt, and inconsistent point-of-view can cause discovery problems," and "include both what the Skill does and when to use it."
- **TimeSensitive**. The skill authoring guide, under "Avoid time-sensitive information," whose own bad example is `If you're doing this before August 2025, use the old API.`
- **Paths**. The skill authoring guide: "Always use forward slashes in file paths, even on Windows."

The pages: Anthropic's [prompting guide](https://platform.claude.com/docs/en/build-with-claude/prompt-engineering/claude-prompting-best-practices), the [Claude Code guide](https://code.claude.com/docs/en/best-practices), the [skill authoring guide](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices), and OpenAI's [GPT-4.1 prompting guide](https://developers.openai.com/cookbook/examples/gpt4-1_prompting_guide).

## Tests

```console
$ ./test.sh
```

One deliberately bad file against every rule, compared to a golden file; a rewrite, required to produce nothing; a guards file, which pins what each rule leaves alone; and the README, linted by the rules it describes. A rule no fixture reaches fails the run, since a Vale rule that matches nothing reports success.

## License

MIT.
