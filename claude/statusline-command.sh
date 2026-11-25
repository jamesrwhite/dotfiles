#!/bin/sh
# Claude Code status line
# Shows: directory | git branch | model | effort | context usage | vim mode | cost
input=$(cat)

# Extract all fields in one jq call, joined by the ASCII unit separator
# (a non-whitespace IFS char, so empty fields are preserved by read)
sep=$(printf '\037')
IFS="$sep" read -r cwd model cost effort vim_mode used_pct <<EOF
$(echo "$input" | jq -r '[
  .workspace.current_dir // .cwd // "",
  .model.display_name // "",
  .cost.total_cost_usd // "",
  .effort.level // "",
  .vim.mode // "",
  .context_window.used_percentage // ""
] | map(tostring) | join("\u001f")')
EOF

# Shorten the directory path (replace $HOME with ~)
home="$HOME"
short_dir=$(echo "$cwd" | sed "s|^$home|~|")

# Get git branch and dirty state (skip optional locks to avoid blocking)
branch=""
dirty=""
if git -C "$cwd" --no-optional-locks rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null \
           || git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
  dirty=$(git -C "$cwd" --no-optional-locks status --porcelain --ignore-submodules=dirty 2>/dev/null)
fi

# --- Directory (blue) ---
printf "\033[34m📁 %s\033[0m" "$short_dir"

# --- Git branch (green + sparkle when clean, yellow + wrench when dirty) ---
if [ -n "$branch" ]; then
  if [ -n "$dirty" ]; then
    printf " \033[33m🔧 %s ±\033[0m" "$branch"
  else
    printf " \033[32m✨ %s\033[0m" "$branch"
  fi
fi

# --- Model (dim, with a little brain) ---
if [ -n "$model" ]; then
  printf " \033[38;5;246m🧠 %s\033[0m" "$model"
fi

# --- Effort level (emoji + level name, colour-coded green->yellow->red by
#     intensity, no "effort:" label) ---
if [ -n "$effort" ]; then
  case "$effort" in
    low) effort_colour="32" ;;      # green
    medium) effort_colour="33" ;;   # yellow
    high|xhigh|max) effort_colour="31" ;;  # red
    *) effort_colour="35" ;;        # fallback: magenta
  esac
  printf " \033[%sm💪 %s\033[0m" "$effort_colour" "$effort"
fi

# --- Colour helper: green -> yellow -> red as a percentage increases ---
pct_colour() {
  pct="$1"
  if [ "$pct" -ge 80 ]; then
    printf "31"      # red
  elif [ "$pct" -ge 50 ]; then
    printf "33"      # yellow
  else
    printf "32"      # green
  fi
}

# --- Context window usage (colour-coded green->yellow->red by pressure) ---
if [ -n "$used_pct" ]; then
  used_int=$(printf "%.0f" "$used_pct")
  colour=$(pct_colour "$used_int")
  printf " 💭 \033[%sm%d%%\033[0m" "$colour" "$used_int"
fi

# --- Vim mode (cyan, only when vim mode is active) ---
if [ -n "$vim_mode" ]; then
  printf " \033[36m⌨️ [%s]\033[0m" "$vim_mode"
fi

# --- Session cost (2dp USD, colour-coded grey->green->yellow->red by spend) ---
if [ -n "$cost" ]; then
  cost_colour=$(echo "$cost" | awk '{
    if ($1 < 1) print "2";
    else if ($1 < 5) print "32";
    else if ($1 < 10) print "33";
    else print "31";
  }')
  printf " \033[%sm💰 \$%.2f\033[0m" "$cost_colour" "$cost"
fi

echo ""
