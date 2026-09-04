# AGENTS.md

You should read this file before you start. Please keep it in mind at all times.

## Working in this repository

Make sure to handle errors appropriately. It is important to ensure that the tests pass, and you must never skip them. Always run the tests before you commit, and commit after every change. Never commit without asking. Always ask before you push.

Try to deal with edge cases properly, and address any relevant warnings as needed. Remember to keep it concise. You need to be thorough when you write the summary.

Don't use emoji in commit messages. Use emoji in the changelog, since the release notes have always had them.

## Style

Under no circumstances should you use tabs. Never use spaces for alignment. You must always format on save, and you must never reformat files you did not touch. At all times prefer the existing style, without exception, no matter what the linter says.

## Reviewing

This section is one that runs long, because a reviewer has a great deal to keep in mind and every one of those things ended up here rather than under a heading of its own. Read the diff twice. Read it once for what changed and once for what did not change but should have. Check that every new function has a test and that every removed test had a reason to go. Look at the names: a name that describes the old behavior is a bug waiting to be reported. Look at the comments: a comment that explains what the code does is a comment that will be wrong soon, and a comment that explains why will outlast three rewrites. Check the error paths, since the happy path is the one the author ran. Check the boundaries, the empty input, the largest input, the input that arrives twice. Check that nothing was logged that should not be, and that everything was logged that a person at three in the morning will need. Then read the description of the change and ask whether it matches what you read in the diff, because the two drift apart in the last hour before a pull request is opened, and the description is what the next reader will trust. If the change touches a public interface, look for the place where that interface is documented and confirm the documentation moved with it. If the change touches configuration, look for the place where the defaults are stated and confirm they still hold. If the change is larger than a screen, ask whether it could have been two changes, and if it could, say so, because a reviewer who accepts one large change teaches the author that large changes are accepted. When you have a finding, state it as a finding and not as a question, since a question invites a defense and a finding invites a fix. When you have no finding, say that too, and say what you checked, so the author knows what the approval covers. Finally, keep the tone level. A review is a second pair of eyes, and the eyes are not the point.
