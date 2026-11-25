#!/bin/sh
# Claude Notification hook: shows a macOS notification with session context.
# Reads the hook JSON payload from stdin.

input=$(cat)

message=$(printf '%s' "$input" | jq -r '.message // "Claude needs your attention"')
type=$(printf '%s' "$input" | jq -r '.notification_type // empty')
cwd=$(printf '%s' "$input" | jq -r '.cwd // empty')

project=$(basename "${cwd:-$PWD}")

case "$type" in
  permission_prompt) title="🔐 Permission" ;;
  idle_prompt) title="💤 Waiting" ;;
  elicitation_dialog) title="🙋🏻‍♂️ Question" ;;
  auth_success) title="✅ Authenticated" ;;
  *) title="👀 Attention" ;;
esac

# macOS shows one title line and two body lines, and Ghostty uses the tab
# title as the subtitle, so: action in the title, location + message in the body.
body="📍 $project · $message"

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
    printf '\033]777;notify;%s;%s\007' "$(clean "$title")" "$(clean "$body")" > "$tty"
    exit 0
  fi
fi

# Fallback: plain macOS notification (clicking it opens Script Editor).
# Pass values as argv so quotes in the message can't break the AppleScript.
osascript - "$body" "$title" <<'EOF' >/dev/null 2>&1
on run argv
  display notification (item 1 of argv) with title (item 2 of argv) sound name "Glass"
end run
EOF

exit 0
