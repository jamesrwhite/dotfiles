#!/bin/sh
# Claude Code status line
# Shows: directory | git branch | model | style | effort | context usage | session tokens | vim mode | cost
input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
model=$(echo "$input" | jq -r '.model.display_name // empty')
style=$(echo "$input" | jq -r '.output_style.name // empty')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')
effort=$(echo "$input" | jq -r '.effort.level // empty')
vim_mode=$(echo "$input" | jq -r '.vim.mode // empty')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
total_in=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
total_out=$(echo "$input" | jq -r '.context_window.total_output_tokens // empty')

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
  printf " \033[2m🧠 %s\033[0m" "$model"
fi

# --- Output style (dim, only when non-empty) ---
if [ -n "$style" ]; then
  printf " \033[2m✏️ %s\033[0m" "$style"
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

# --- Context window usage (colour-coded green->yellow->red by pressure, with mood icon) ---
if [ -n "$used_pct" ]; then
  used_int=$(printf "%.0f" "$used_pct")
  colour=$(pct_colour "$used_int")
  if [ "$used_int" -ge 80 ]; then
    icon="🔥"
  elif [ "$used_int" -ge 50 ]; then
    icon="⚡"
  else
    icon="🚀"
  fi
  printf " %s cx:\033[%sm%d%%\033[0m" "$icon" "$colour" "$used_int"
fi

# --- Session token counts (colour-coded green->yellow->red, scaled to this
#     model's context window size via used_percentage) ---
if [ -n "$total_in" ] && [ -n "$total_out" ]; then
  # Format large numbers with k suffix for readability
  fmt_k() {
    val="$1"
    if [ "$val" -ge 1000 ]; then
      printf "%.1fk" "$(echo "$val 1000" | awk '{printf "%.1f", $1/$2}')"
    else
      printf "%d" "$val"
    fi
  }
  in_fmt=$(fmt_k "$total_in")
  out_fmt=$(fmt_k "$total_out")
  if [ -n "$used_pct" ]; then
    tok_colour=$(pct_colour "$used_int")
  else
    tok_colour="2"  # dim when no context-window percentage is available yet
  fi
  printf " \033[%sm📊 %s↑ %s↓\033[0m" "$tok_colour" "$in_fmt" "$out_fmt"
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
