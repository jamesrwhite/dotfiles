#!/bin/sh
# Claude Code status line
# Shows: directory | git branch | model | context usage | session tokens | effort | vim mode
input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
model=$(echo "$input" | jq -r '.model.display_name // empty')
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
printf "\033[34m%s\033[0m" "$short_dir"

# --- Git branch (green clean, yellow dirty) ---
if [ -n "$branch" ]; then
  if [ -n "$dirty" ]; then
    printf " \033[33m%s ±\033[0m" "$branch"
  else
    printf " \033[32m%s\033[0m" "$branch"
  fi
fi

# --- Model (dim) ---
if [ -n "$model" ]; then
  printf " \033[2m%s\033[0m" "$model"
fi

# --- Context window usage (colour-coded by pressure) ---
if [ -n "$used_pct" ]; then
  used_int=$(printf "%.0f" "$used_pct")
  if [ "$used_int" -ge 80 ]; then
    # Red when high
    printf " \033[31mcx:%d%%\033[0m" "$used_int"
  elif [ "$used_int" -ge 50 ]; then
    # Yellow when moderate
    printf " \033[33mcx:%d%%\033[0m" "$used_int"
  else
    # Dim when low
    printf " \033[2mcx:%d%%\033[0m" "$used_int"
  fi
fi

# --- Session token counts (dim, only when data is available) ---
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
  printf " \033[2mtk:%s↑ %s↓\033[0m" "$in_fmt" "$out_fmt"
fi

# --- Effort level (only show when not the default "high") ---
if [ -n "$effort" ] && [ "$effort" != "high" ]; then
  printf " \033[35meffort:%s\033[0m" "$effort"
fi

# --- Vim mode (cyan, only when vim mode is active) ---
if [ -n "$vim_mode" ]; then
  printf " \033[36m[%s]\033[0m" "$vim_mode"
fi

echo ""
