#!/usr/bin/env bash
# COMBAT installer — for harnesses without native plugin support.
#
# If your tool supports plugins, prefer:
#   /plugin marketplace add Mahditalebian/COMBAT
#   /plugin install combat@combat
#
# Usage:
#   ./install.sh <target> [--dir PATH] [--global] [--dry-run]
#   curl -fsSL https://raw.githubusercontent.com/Mahditalebian/COMBAT/main/install.sh | bash -s -- cursor
#
# Targets: claude-code | opencode | codebuff | freebuff | cursor | codex |
#          windsurf | agents-md | copilot | plain

set -euo pipefail

REPO_RAW="${COMBAT_RAW:-https://raw.githubusercontent.com/Mahditalebian/COMBAT/main}"
SKILLS=(combat-core combat-triage combat-reasoning combat-hypothesis combat-evidence \
        combat-deep-search combat-web-intelligence combat-verification combat-safety \
        combat-stop-policy)
KERNEL=(combat-core combat-triage combat-safety combat-stop-policy)

TARGET="${1:-}"
DEST=""; GLOBAL=0; DRY=0
shift || true
while [ $# -gt 0 ]; do
  case "$1" in
    --dir) DEST="$2"; shift 2 ;;
    --global) GLOBAL=1; shift ;;
    --dry-run) DRY=1; shift ;;
    *) echo "unknown option: $1" >&2; exit 2 ;;
  esac
done

say()  { printf '\033[1;36m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m warn\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31merror\033[0m %s\n' "$*" >&2; exit 1; }

usage() {
  cat <<'EOF'
COMBAT — installer for harnesses without native plugin support

  ./install.sh claude-code   -> .claude/skills/<id>/SKILL.md + commands
  ./install.sh opencode      -> .opencode/skills/<id>/SKILL.md + AGENTS.md
  ./install.sh codebuff      -> .agents/skills/<id>/SKILL.md + knowledge.md
  ./install.sh freebuff      -> alias of codebuff
  ./install.sh cursor        -> .cursor/rules/*.mdc
  ./install.sh codex         -> AGENTS.md + .combat/
  ./install.sh windsurf      -> .windsurf/rules/
  ./install.sh agents-md     -> single portable AGENTS.md
  ./install.sh copilot       -> .github/copilot-instructions.md
  ./install.sh plain         -> .combat/

Options:
  --dir PATH   install into PATH instead of the current directory
  --global     user-level install where the tool supports it
  --dry-run    print what would happen, change nothing
EOF
}

[ -z "$TARGET" ] && { usage; exit 0; }
case "$TARGET" in -h|--help|help) usage; exit 0 ;; esac

ROOT="${DEST:-$PWD}"
HERE="$(cd "$(dirname "$0")" && pwd)"
if [ -d "$HERE/skills/combat-core" ]; then
  SRC="$HERE/skills"; CMD="$HERE/commands"
else
  TMP="$(mktemp -d)"; SRC="$TMP/skills"; CMD="$TMP/commands"
  mkdir -p "$SRC" "$CMD"
  say "fetching COMBAT from $REPO_RAW"
  for s in "${SKILLS[@]}"; do
    mkdir -p "$SRC/$s"
    curl -fsSL "$REPO_RAW/skills/$s/SKILL.md" -o "$SRC/$s/SKILL.md" || die "download failed: $s"
  done
  for c in combat combat-status; do
    curl -fsSL "$REPO_RAW/commands/$c.md" -o "$CMD/$c.md" || warn "command $c not fetched"
  done
fi

write() { # stdin -> $1
  local path="$1"
  if [ "$DRY" = 1 ]; then echo "  would write $path"; return; fi
  mkdir -p "$(dirname "$path")"
  cat > "$path"
  echo "  wrote $path"
}
skill()    { cat "$SRC/$1/SKILL.md"; }
strip_fm() { awk 'BEGIN{n=0} /^---$/{n++; next} n>=2' "$SRC/$1/SKILL.md"; }
desc_of()  { awk -F': ' '/^description: /{ $1=""; sub(/^: /,""); print; exit}' "$SRC/$1/SKILL.md"; }

install_skilldirs() { # $1 = base dir
  for s in "${SKILLS[@]}"; do skill "$s" | write "$1/$s/SKILL.md"; done
}
install_commands() { # $1 = base dir
  for c in combat combat-status; do
    [ -f "$CMD/$c.md" ] && cat "$CMD/$c.md" | write "$1/$c.md"
  done
}
kernel_doc() {
  for s in "${KERNEL[@]}"; do strip_fm "$s"; printf '\n---\n\n'; done
  printf '## On-demand skills\n\nLoad these by exact id when their trigger fires:\n\n'
  for s in "${SKILLS[@]}"; do printf -- '- `%s` — %s\n' "$s" "$(desc_of "$s")"; done
}

case "$TARGET" in
  claude-code)
    base="$ROOT/.claude"; [ "$GLOBAL" = 1 ] && base="$HOME/.claude"
    say "installing Claude Code skills -> $base/skills"
    install_skilldirs "$base/skills"
    install_commands  "$base/commands"
    ;;
  opencode)
    base="$ROOT/.opencode/skills"; agents="$ROOT/AGENTS.md"
    if [ "$GLOBAL" = 1 ]; then
      base="$HOME/.config/opencode/skills"; agents="$HOME/.config/opencode/AGENTS.md"
    fi
    say "installing OpenCode skills -> $base"
    install_skilldirs "$base"
    say "writing always-on kernel -> $agents"
    kernel_doc | write "$agents"
    ;;
  codebuff|freebuff)
    base="$ROOT/.agents/skills"; know="$ROOT/knowledge.md"
    if [ "$GLOBAL" = 1 ]; then base="$HOME/.agents/skills"; know="$HOME/.knowledge.md"; fi
    say "installing Codebuff/Freebuff skills -> $base"
    install_skilldirs "$base"
    say "writing knowledge file -> $know"
    kernel_doc | write "$know"
    ;;
  cursor)
    say "installing Cursor rules -> $ROOT/.cursor/rules"
    for s in "${SKILLS[@]}"; do
      always="false"
      case "$s" in combat-core|combat-triage|combat-safety) always="true" ;; esac
      { printf -- '---\ndescription: "COMBAT — %s"\nalwaysApply: %s\n---\n\n' "$(desc_of "$s")" "$always"
        strip_fm "$s"; } | write "$ROOT/.cursor/rules/$s.mdc"
    done
    ;;
  codex|plain)
    say "installing raw skills -> $ROOT/.combat"
    for s in "${SKILLS[@]}"; do skill "$s" | write "$ROOT/.combat/$s.md"; done
    [ "$TARGET" = codex ] && { kernel_doc | write "$ROOT/AGENTS.md"; }
    ;;
  windsurf)
    say "installing Windsurf rules -> $ROOT/.windsurf/rules"
    for s in "${SKILLS[@]}"; do strip_fm "$s" | write "$ROOT/.windsurf/rules/$s.md"; done
    ;;
  agents-md)
    say "building single-file AGENTS.md -> $ROOT/AGENTS.md"
    { for s in "${SKILLS[@]}"; do strip_fm "$s"; printf '\n---\n\n'; done; } | write "$ROOT/AGENTS.md"
    ;;
  copilot)
    say "building Copilot instructions"
    { for s in combat-core combat-triage combat-reasoning combat-evidence \
               combat-verification combat-safety combat-stop-policy; do
        strip_fm "$s"; printf '\n---\n\n'
      done; } | write "$ROOT/.github/copilot-instructions.md"
    ;;
  *) die "unknown target '$TARGET' (see --help)" ;;
esac

say "done."
[ "$DRY" = 1 ] && warn "dry run — nothing was written"
exit 0
