# Claude Code

    CLAUDE.md      -> ~/.claude/CLAUDE.md
    settings.json  -> ~/.claude/settings.json
    skills/        -> ~/.claude/skills/
    hooks/         -> ~/.claude/hooks/
    plugins/       reference copies and install manifests, not stowed

`terse` and `thermo-nuclear-code-quality-review` are mine. Both are plain SKILL.md, no deps.

`terse` is meant to be always on. The `SessionStart` and `SubagentStart` hooks in
`settings.json` cat it into every session and subagent.

`hooks/pr-review-gate.sh` denies PR bodies, commits, comments and Slack messages over 15
lines or with em dashes, blocks PR creation until the repo's convention docs are read, and
blocks the first PR-creation attempt of a session until the thermo-nuclear review has run.
The retry passes.

`hooks/docker-cleanup.sh` records containers a session starts and stops them at
`SessionEnd`. `bash ~/.claude/hooks/docker-cleanup.sh stop` does it mid-session.

`plugins/ponytail/` is a vendored copy of the skill files from
[DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) v4.9.0 (MIT, LICENSE
included). Install it as a plugin rather than copying these into `~/.claude/skills/` — the
plugin ships the activation hooks and statusline, and stays current:

```
/plugin marketplace add DietrichGebert/ponytail
/plugin install ponytail@ponytail
```
