#!/usr/bin/env bash
# PR review gate. Denies the first PR-creation attempt and asks for the
# review skills to run. The retry passes and consumes the marker, so the
# next PR in the same session gates again.

input=$(cat)
session_id=$(printf '%s' "$input" | jq -r '.session_id // "nosession"')
tool=$(printf '%s' "$input" | jq -r '.tool_name // empty')

if [ "$tool" = "Bash" ]; then
  cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty')
  case "$cmd" in
    *"gh pr create"*) ;;
    *) exit 0 ;;
  esac
fi

marker="${TMPDIR:-/tmp}/claude-pr-review-gate-${session_id}"
if [ -f "$marker" ]; then
  rm -f "$marker"
  exit 0
fi

touch "$marker"
cat <<'EOF'
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"PR review gate. Before creating this PR run this review skills on the branch changes: /thermo-nuclear-code-quality-review. Apply the findings that matter, then retry creating the PR. Reminder for all review output and PR comments: write human and straight to the point, never use em dashes or semicolons."}}
EOF
exit 0
