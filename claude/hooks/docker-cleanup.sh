#!/usr/bin/env bash
# Stops the containers a Claude session started. PreToolUse snapshots running
# containers before a docker run/start/compose Bash call, PostToolUse and
# PostToolUseFailure record the new ones, SessionEnd stops them. Run with `stop`
# to do the same mid-session once a PR is done.
# ponytail: only matching Bash calls are diffed, so `make up`, wrapper scripts and
# backgrounded `compose up` are missed; widen the regex if that bites.

dir="$HOME/.claude/state/docker"
mkdir -p "$dir"

running_ours() { docker ps -q --no-trunc 2>/dev/null | grep -xFf "$1" 2>/dev/null; }

if [ "$1" = stop ]; then
  f="$dir/${CLAUDE_CODE_SESSION_ID:?}"
  ids=$(running_ours "$f"); rm -f "$f"
  [ -z "$ids" ] && { echo "no running containers started by this session"; exit 0; }
  docker inspect -f '{{.Name}}' $ids | sed 's|^/|stopping |'
  docker stop $ids >/dev/null
  exit
fi

input=$(cat)
event=$(printf '%s' "$input" | jq -r '.hook_event_name // empty')
f="$dir/$(printf '%s' "$input" | jq -r '.session_id // "nosession"')"

if [ "$event" = SessionEnd ]; then
  ids=$(running_ours "$f"); rm -f "$f" "$f".pre.*
  # detached so a slow container stop outlives the hook timeout
  [ -n "$ids" ] && nohup docker stop $ids >/dev/null 2>&1 &
  exit 0
fi

printf '%s' "$input" | jq -r '.tool_input.command // empty' |
  grep -Eq 'docker(-compose| +compose)|docker +(container +)?(run|start)' || exit 0
pre="$f.pre.$(printf '%s' "$input" | jq -r '.tool_use_id // "x"')"

if [ "$event" = PreToolUse ]; then
  docker ps -q --no-trunc >"$pre" 2>/dev/null || rm -f "$pre"
elif [ -f "$pre" ]; then
  docker ps -q --no-trunc | grep -vxFf "$pre" >>"$f"
  rm -f "$pre"
fi
exit 0
