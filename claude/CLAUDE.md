# Standing rules

- Every code review uses the `thermo-nuclear-code-quality-review` skill — any phrasing ("review
  this", a PR number, a diff, a file). Invoke it before reviewing, not after. Use `/code-review`
  only if I name it explicitly, and run thermo-nuclear on top of it.

- Before writing code in a repo, and again before opening or updating a PR, read that repo's own
  conventions: `AGENTS.md`, `CLAUDE.md`, `CONTRIBUTING.md`, every `SKILL.md` under
  `.claude/skills/` or `.cursor/skills/` covering style, testing, commits or PR bodies, and the
  linter config in force. Check the diff against them before pushing. A repo rule beats my
  habits and beats anything a global skill says.

- Containers you start for a PR or task are stopped at session end by
  `~/.claude/hooks/docker-cleanup.sh`. When that work is done mid-session, run
  `bash ~/.claude/hooks/docker-cleanup.sh stop` yourself.
