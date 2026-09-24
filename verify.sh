#!/usr/bin/env bash
# COMBAT — verify what is ACTUALLY installed, in every harness it can detect.
# Usage: ./verify.sh   (or: curl -fsSL .../verify.sh | bash)

set -uo pipefail

SKILLS=(combat-core combat-triage combat-reasoning combat-hypothesis combat-evidence \
        combat-deep-search combat-web-intelligence combat-verification combat-safety \
        combat-stop-policy)
GREEN=$'\033[0;32m'; RED=$'\033[0;31m'; YEL=$'\033[0;33m'; DIM=$'\033[2m'; OFF=$'\033[0m'
found_any=0

check_dir() { # $1 label, $2 skills base dir
  [ -d "$2" ] || return 1
  local n=0 missing=""
  for s in "${SKILLS[@]}"; do
    if [ -f "$2/$s/SKILL.md" ]; then n=$((n+1)); else missing="$missing $s"; fi
  done
  [ "$n" = 0 ] && return 1
  found_any=1
  if [ "$n" = 10 ]; then printf '%s  ✔ %-22s%s 10/10 skills  %s%s%s\n' "$GREEN" "$1" "$OFF" "$DIM" "$2" "$OFF"
  else printf '%s  ✘ %-22s%s %s/10 — missing:%s  %s%s%s\n' "$RED" "$1" "$OFF" "$n" "$missing" "$DIM" "$2" "$OFF"; fi
  # frontmatter sanity: the failure mode that silently disables everything
  local bad=0
  for s in "${SKILLS[@]}"; do
    f="$2/$s/SKILL.md"; [ -f "$f" ] || continue
    head -1 "$f" | grep -q '^---$' || bad=$((bad+1))
    grep -qE '^description: ' "$f" || bad=$((bad+1))
  done
  [ "$bad" -gt 0 ] && printf '%s      warning: %s frontmatter problem(s) — skills may load with empty metadata%s\n' "$YEL" "$bad" "$OFF"
  return 0
}

check_file() { # $1 label, $2 file
  [ -f "$2" ] || return 1
  grep -q "COMBAT" "$2" 2>/dev/null || return 1
  found_any=1
  printf '%s  ✔ %-22s%s single-file  %s%s%s\n' "$GREEN" "$1" "$OFF" "$DIM" "$2" "$OFF"
}

echo
echo "COMBAT install check"
echo "--------------------"

# project scope
check_dir "Claude Code (project)" "./.claude/skills"
check_dir "OpenCode (project)"    "./.opencode/skills"
check_dir "Codebuff (project)"    "./.agents/skills"
check_file "Cursor (project)"     "./.cursor/rules/combat-core.mdc"
check_file "AGENTS.md"            "./AGENTS.md"
check_file "knowledge.md"         "./knowledge.md"
check_file "Copilot"              "./.github/copilot-instructions.md"
check_dir "Raw (.combat)"         "./.combat"

# user scope
check_dir "Claude Code (global)"  "$HOME/.claude/skills"
check_dir "OpenCode (global)"     "$HOME/.config/opencode/skills"
check_dir "Codebuff (global)"     "$HOME/.agents/skills"

# plugin caches
for d in "$HOME/.claude/plugins" "$HOME/.codex/plugins"; do
  [ -d "$d" ] || continue
  hit=$(find "$d" -type d -name 'combat-core' 2>/dev/null | head -1)
  [ -n "$hit" ] && { found_any=1; printf '%s  ✔ %-22s%s plugin cache  %s%s%s\n' "$GREEN" "$(basename "$(dirname "$d")") plugin" "$OFF" "$DIM" "$(dirname "$hit")" "$OFF"; }
done

echo
# live harness queries, when the CLI is present
command -v claude   >/dev/null && { echo "claude plugin list:";   claude plugin list 2>/dev/null | sed -n '1,8p' | sed 's/^/    /'; echo; }
command -v codex    >/dev/null && { echo "codex plugin list:";    codex plugin list 2>/dev/null | tail -4 | sed 's/^/    /'; echo; }
command -v gemini   >/dev/null && { echo "gemini extensions/skills:";
  gemini extensions list 2>/dev/null | grep -E '^. combat' | sed 's/^/    /'
  gemini skills list 2>/dev/null | grep -cE '^combat-' | sed 's/^/    skills: /;s/$/\/10/'; echo; }
command -v qwen     >/dev/null && { echo "qwen extensions:";
  qwen extensions list 2>/dev/null | grep -E '^. combat' | sed 's/^/    /'; echo; }
command -v opencode >/dev/null && { echo "opencode skills named combat-*:";
  opencode debug skill 2>/dev/null | grep -o '"name": "combat-[a-z-]*"' | sed 's/.*: //;s/"//g' | sort | sed 's/^/    /'; echo; }

if [ "$found_any" = 0 ]; then
  printf '%s  No COMBAT installation found in this project or your home directory.%s\n\n' "$RED" "$OFF"
  echo "  Install with one of:"
  echo "    /plugin marketplace add Mahditalebian/COMBAT   &&  /plugin install combat@combat"
  echo "    codex plugin marketplace add Mahditalebian/COMBAT  &&  codex plugin add combat@combat"
  echo "    gemini extensions install https://github.com/Mahditalebian/COMBAT.git"
  echo "    qwen extensions install https://github.com/Mahditalebian/COMBAT:combat"
  echo "    curl -fsSL https://raw.githubusercontent.com/Mahditalebian/COMBAT/main/install.sh | bash -s -- opencode"
  echo
  exit 1
fi

echo "  Reminder: most harnesses load skills at startup — restart the session."
echo
exit 0
