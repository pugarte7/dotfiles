# Claude Code

    skills/   -> ~/.claude/skills/
    plugins/  reference copies, not stowed

`terse` and `thermo-nuclear-code-quality-review` are mine. Both are plain SKILL.md, no deps.

`terse` is meant to be always on, which needs a hook in `~/.claude/settings.json`:

```json
"SessionStart": [{ "matcher": "startup|resume|clear|compact",
  "hooks": [{ "type": "command", "command": "cat \"$HOME/.claude/skills/terse/SKILL.md\"" }] }],
"SubagentStart": [{
  "hooks": [{ "type": "command", "command": "cat \"$HOME/.claude/skills/terse/SKILL.md\"" }] }]
```

`plugins/ponytail/` is a vendored copy of the skill files from
[DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) v4.9.0 (MIT, LICENSE
included). Install it as a plugin rather than copying these into `~/.claude/skills/` — the
plugin ships the activation hooks and statusline, and stays current:

```
/plugin marketplace add DietrichGebert/ponytail
/plugin install ponytail@ponytail
```
