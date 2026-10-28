#!/usr/bin/env bash
# Three gates. Terse gate: any PR body, commit message, review or issue
# comment, or Slack message over the line cap or with an em dash is denied
# with the rule. Conventions gate: a PR creation is denied while the session
# has not opened the repo's own convention docs, checked against the
# transcript. Review gate: the first PR creation per session is denied until
# the review skill runs; the retry consumes the marker.

input=$(cat)
session_id=$(printf '%s' "$input" | jq -r '.session_id // "nosession"')
tool=$(printf '%s' "$input" | jq -r '.tool_name // empty')
cwd=$(printf '%s' "$input" | jq -r '.cwd // empty')
transcript=$(printf '%s' "$input" | jq -r '.transcript_path // empty')

deny() {
  jq -n --arg r "$1" '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$r}}'
  exit 0
}

pr_create=0
if [ "$tool" = "Bash" ]; then
  text=$(printf '%s' "$input" | jq -r '.tool_input.command // empty')
  case "$text" in
    *"gh pr create"*) pr_create=1 ;;
    *"git commit"*|*"gh pr comment"*|*"gh pr review"*|*"gh pr edit"*|*"gh issue comment"*) ;;
    *) exit 0 ;;
  esac
else
  [ "$tool" = "mcp__github__create_pull_request" ] && pr_create=1
  text=$(printf '%s' "$input" | jq -r '[.tool_input | .title, .body, .message, .description, .text, .commit_message, .commit_title] | map(select(. != null)) | join("\n")')
  [ -z "$text" ] && exit 0
fi

MAX=15
lines=$(printf '%s\n' "$text" | grep -c .)
case "$text" in *"—"*) deny "Terse: em dash found. Plain sentences only. Rewrite and retry." ;; esac
[ "$lines" -gt "$MAX" ] && deny "Terse: $lines non-empty lines, max $MAX. PR body = what changed, why, how to verify. Commit = imperative subject under 60 chars, body only if the why is not obvious. Comment = one line per point, no preamble, no summary. Rewrite and retry."

[ "$pr_create" = 1 ] || exit 0

root=$(git -C "${cwd:-.}" rev-parse --show-toplevel 2>/dev/null)
if [ -n "$root" ] && [ -f "$transcript" ]; then
  docs=$(cd "$root" && ls AGENTS.md CLAUDE.md CONTRIBUTING.md 2>/dev/null)
  style=$(cd "$root" && ls .claude/skills/*/SKILL.md 2>/dev/null | grep -Ei 'standard|style|convention|lint|format')
  [ -z "$style" ] && style=$(cd "$root" && ls .cursor/skills/*/SKILL.md 2>/dev/null | grep -Ei 'standard|style|convention|lint|format')
  unread=""
  # the absolute path lands in the transcript on a real read, never from this message
  for doc in $docs $style; do
    grep -qF "$root/$doc" "$transcript" || unread="$unread
  $doc"
  done
  [ -n "$unread" ] && deny "Conventions gate. This repo writes its rules down and this session has not opened:$unread
Read them, check the diff against them, fix what breaks a rule, then retry."
fi

marker="${TMPDIR:-/tmp}/claude-pr-review-gate-${session_id}"
if [ -f "$marker" ]; then
  rm -f "$marker"
  exit 0
fi
touch "$marker"
deny "PR review gate. Before creating this PR run /thermo-nuclear-code-quality-review on the branch changes. Apply the findings that matter, then retry. Review output and PR text: human, straight to the point, no em dashes."
