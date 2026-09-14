#!/bin/bash
# Claude Code status line
#
# Segments, separated by " | ":
#   1. current user and directory
#   2. model
#   3. effort
#   4. context window: absolute tokens + percent
#   5. rate limits: 5h and 7d used percentage
#
# Note on segment 5: the status line payload exposes only `used_percentage` for
# the 5h / 7d rate-limit windows. No absolute token count is provided for them,
# so only percentages can be shown. Absolute tokens exist for the context
# window only, and are shown in segment 4.
#
# Requires: jq (installed at ~/.local/bin/jq).

input=$(cat)

# ANSI colors
RESET='\033[0m'
DIM='\033[2m'
CYAN='\033[36m'
MAGENTA='\033[35m'
YELLOW='\033[33m'
BLUE='\033[34m'
GREEN='\033[32m'
SEP="${DIM} | ${RESET}"

# --- parse the whole payload in one jq pass ---
# Joined on \x1f (unit separator), NOT tab: bash treats tab as IFS whitespace and
# collapses runs of it, so a missing middle field would shift every later field.
IFS=$'\x1f' read -r dir model effort ctx_used ctx_size ctx_pct rl5 rl7 <<EOF
$(printf '%s' "$input" | jq -r '[
    (.workspace.current_dir            // ""),
    (.model.display_name               // ""),
    (.effort.level                     // ""),
    (.context_window.total_input_tokens // ""),
    (.context_window.context_window_size // ""),
    (.context_window.used_percentage   // ""),
    (.rate_limits.five_hour.used_percentage // ""),
    (.rate_limits.seven_day.used_percentage // "")
  ] | map(tostring) | join("\u001f")' 2>/dev/null)
EOF

# Compact token counts (pure bash, no awk/bc dependency): 99367 -> 99k, 1000000 -> 1.0M
fmt_tokens() {
  local n=$1
  case "$n" in
    ''|*[!0-9]*) printf '%s' "$n"; return ;;
  esac
  if [ "$n" -ge 1000000 ]; then
    printf '%d.%dM' $((n / 1000000)) $(((n % 1000000) / 100000))
  elif [ "$n" -ge 1000 ]; then
    printf '%dk' $((n / 1000))
  else
    printf '%d' "$n"
  fi
}

# --- 1. current user and directory ---
user=$(whoami)
[ -z "$dir" ] && dir=$(pwd)
dir_display=${dir/#$HOME/\~}          # /home/me/a/b -> ~/a/b
seg_user="${CYAN}${user}${RESET}${DIM}:${RESET}${CYAN}${dir_display}${RESET}"
segments=("$seg_user")

# --- 2. model ---
[ -n "$model" ] && segments+=("${MAGENTA}${model}${RESET}")

# --- 3. effort ---
[ -n "$effort" ] && segments+=("${YELLOW}effort:${effort}${RESET}")

# --- 4. context window (absolute + percent) ---
if [ -n "$ctx_used" ] && [ -n "$ctx_size" ]; then
  seg_ctx="ctx:$(fmt_tokens "$ctx_used")/$(fmt_tokens "$ctx_size")"
  [ -n "$ctx_pct" ] && seg_ctx="${seg_ctx} (${ctx_pct}%)"
  segments+=("${BLUE}${seg_ctx}${RESET}")
fi

# --- 5. rate limits (percentage only; see header note) ---
if [ -n "$rl5" ] || [ -n "$rl7" ]; then
  parts=""
  [ -n "$rl5" ] && parts="5h:${rl5}%"
  if [ -n "$rl7" ]; then
    [ -n "$parts" ] && parts="${parts} "
    parts="${parts}7d:${rl7}%"
  fi
  segments+=("${GREEN}${parts}${RESET}")
fi

# --- assemble ---
output="${segments[0]}"
for i in "${!segments[@]}"; do
  [ "$i" -eq 0 ] && continue
  output="${output}${SEP}${segments[$i]}"
done

printf "%b\n" "$output"
