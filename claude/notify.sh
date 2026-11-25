#!/bin/sh
# Claude Notification hook: shows a macOS notification with session context.
# Reads the hook JSON payload from stdin.

input=$(cat)

message=$(printf '%s' "$input" | jq -r '.message // "Claude needs your attention"')
type=$(printf '%s' "$input" | jq -r '.notification_type // empty')
cwd=$(printf '%s' "$input" | jq -r '.cwd // empty')

project=$(basename "${cwd:-$PWD}")
branch=$(git -C "${cwd:-$PWD}" branch --show-current 2>/dev/null)

case "$type" in
  permission_prompt) reason="Permission needed" emoji="🔐" ;;
  idle_prompt) reason="Waiting" emoji="💤" ;;
  elicitation_dialog) reason="Question" emoji="🙋🏻‍♂️" ;;
  auth_success) reason="Authenticated" emoji="✅" ;;
  *) reason="Needs attention" emoji="👀" ;;
esac

subtitle="📍 $project"
[ -n "$branch" ] && subtitle="📍 $project [$branch]"

title="$reason $emoji"

# Find the TTY of the Claude session by walking up the process tree.
find_tty() {
  pid=$$
  while [ "${pid:-1}" -gt 1 ]; do
    t=$(ps -o tty= -p "$pid" | tr -d ' ')
    if [ -n "$t" ] && [ "$t" != "??" ]; then
      echo "/dev/$t"
      return
    fi
    pid=$(ps -o ppid= -p "$pid" | tr -d ' ')
  done
}

# In Ghostty, emit an OSC 777 notification on the session's TTY. Ghostty owns
# it, so clicking focuses the exact tab/split and it's cleared once that
# tab/split gains focus.
if [ "$TERM_PROGRAM" = "ghostty" ]; then
  tty=$(find_tty)
  if [ -n "$tty" ] && [ -w "$tty" ]; then
    # Strip ';' and control chars, which would break the escape sequence.
    clean() { printf '%s' "$1" | tr -d ';\000-\037\177'; }
    printf '\033]777;notify;%s;%s\007' "$(clean "$title")" "$(clean "$subtitle · $message")" > "$tty"
    exit 0
  fi
fi

# Fallback: plain macOS notification (clicking it opens Script Editor).
# Pass values as argv so quotes in the message can't break the AppleScript.
osascript - "$message" "$title" "$subtitle" <<'EOF' >/dev/null 2>&1
on run argv
  display notification (item 1 of argv) with title (item 2 of argv) subtitle (item 3 of argv) sound name "Glass"
end run
EOF

exit 0
