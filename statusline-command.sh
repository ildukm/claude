#!/bin/sh
input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
dir=$(basename "$cwd")
model=$(echo "$input" | jq -r '.model.display_name')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
effort=$(echo "$input" | jq -r '.effort.level // empty')

# Git branch and dirty status
ESC=$(printf '\033')
branch=""
git_info=""
if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
  dirty=$(git -C "$cwd" status --porcelain 2>/dev/null)
  if [ -n "$branch" ]; then
    if [ -n "$dirty" ]; then
      git_info=" ${ESC}[1;34mgit:(${ESC}[0;31m${branch}${ESC}[1;34m)${ESC}[0;33m ✗${ESC}[0m"
    else
      git_info=" ${ESC}[1;34mgit:(${ESC}[0;31m${branch}${ESC}[1;34m)${ESC}[0m"
    fi
  fi
fi

# Context usage
ctx_part=""
if [ -n "$used" ]; then
  ctx_part=" · $(printf '%.0f' "$used")%"
fi

effort_part=""
if [ -n "$effort" ]; then
  effort_part=" · ${effort}"
fi

printf "\033[1;36m%s\033[0m%s  \033[38;5;141m%s\033[0;90m%s\033[38;5;211m%s\033[0;90m%s\033[38;5;215m%s\033[0m" "$dir" "$git_info" "$model" "${effort_part:+ · }" "${effort:-}" "${ctx_part:+ · }" "${ctx_part# · }"
