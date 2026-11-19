#!/bin/sh
# Focus the Ghostty terminal (tab/split) attached to the given TTY, e.g. /dev/ttys000.
# Falls back to just activating Ghostty if no terminal matches.

osascript - "$1" <<'EOF' >/dev/null 2>&1
on run argv
  tell application "Ghostty"
    repeat with t in terminals
      if tty of t is (item 1 of argv) then
        focus t
        return
      end if
    end repeat
    activate
  end tell
end run
EOF
