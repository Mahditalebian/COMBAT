#!/usr/bin/env bash
# RELENTLESS v3 installer
# Usage:
#   ./install.sh <target> [--dir PATH] [--global] [--dry-run]
#   curl -fsSL https://raw.githubusercontent.com/Mahditalebian/COMBAT/main/install.sh | bash -s -- cursor
#
# Targets: cursor | claude-code | codex | windsurf | agents-md | copilot | plain

set -euo pipefail

REPO_RAW="${RELENTLESS_RAW:-https://raw.githubusercontent.com/Mahditalebian/COMBAT/main}"
SKILLS=(core triage reasoning hypothesis evidence deep-search web-intelligence verification safety stop-policy)

TARGET="${1:-}"
DEST=""
GLOBAL=0
DRY=0
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
RELENTLESS v3 — installer

  ./install.sh cursor        -> .cursor/rules/*.mdc          (project)
  ./install.sh claude-code   -> .claude/skills/<name>/SKILL.md
  ./install.sh codex         -> AGENTS.md + .relentless/
  ./install.sh windsurf      -> .windsurf/rules/
  ./install.sh agents-md     -> AGENTS.md (single file, portable)
  ./install.sh copilot       -> .github/copilot-instructions.md
  ./install.sh plain         -> .relentless/ (raw markdown)

Options:
  --dir PATH   install into PATH instead of the current directory
  --global     user-level install where the tool supports it
  --dry-run    print what would happen, change nothing
EOF
}

[ -z "$TARGET" ] && { usage; exit 0; }
case "$TARGET" in -h|--help|help) usage; exit 0 ;; esac

ROOT="${DEST:-$PWD}"
SRC=""
if [ -d "$(dirname "$0")/skills" ]; then
  SRC="$(cd "$(dirname "$0")" && pwd)/skills"
else
  SRC="$(mktemp -d)/skills"; mkdir -p "$SRC"
  say "fetching skills from $REPO_RAW"
  for s in "${SKILLS[@]}"; do
    curl -fsSL "$REPO_RAW/skills/$s.md" -o "$SRC/$s.md" || die "download failed: $s.md"
  done
fi

write() { # write <path> <content-file-or-->
  local path="$1"
  if [ "$DRY" = 1 ]; then echo "  would write $path"; return; fi
  mkdir -p "$(dirname "$path")"
  cat > "$path"
  echo "  wrote $path"
}

strip_fm() { awk 'BEGIN{n=0} /^---$/{n++; next} n>=2' "$1"; }
desc_of() { awk -F': ' '/^purpose:/{print $2; exit}' "$1"; }
act_of()  { awk -F': ' '/^activation:/{print $2; exit}' "$1"; }

case "$TARGET" in
  cursor)
    say "installing Cursor rules -> $ROOT/.cursor/rules"
    for s in "${SKILLS[@]}"; do
      f="$SRC/$s.md"; [ -f "$f" ] || continue
      always="false"; [ "$s" = core ] || [ "$s" = triage ] || [ "$s" = safety ] && always="true"
      { printf -- '---\ndescription: "RELENTLESS v3 — %s"\nalwaysApply: %s\n---\n\n' "$(desc_of "$f")" "$always"
        strip_fm "$f"; } | write "$ROOT/.cursor/rules/relentless-$s.mdc"
    done
    ;;
  claude-code)
    base="$ROOT/.claude/skills"; [ "$GLOBAL" = 1 ] && base="$HOME/.claude/skills"
    say "installing Claude Code skills -> $base"
    for s in "${SKILLS[@]}"; do
      f="$SRC/$s.md"; [ -f "$f" ] || continue
      { printf -- '---\nname: relentless-%s\ndescription: %s Activate when: %s\n---\n\n' \
          "$s" "$(desc_of "$f")" "$(act_of "$f")"
        strip_fm "$f"; } | write "$base/relentless-$s/SKILL.md"
    done
    ;;
  windsurf)
    say "installing Windsurf rules -> $ROOT/.windsurf/rules"
    for s in "${SKILLS[@]}"; do
      f="$SRC/$s.md"; [ -f "$f" ] || continue
      strip_fm "$f" | write "$ROOT/.windsurf/rules/relentless-$s.md"
    done
    ;;
  codex|plain)
    say "installing raw skills -> $ROOT/.relentless"
    for s in "${SKILLS[@]}"; do
      f="$SRC/$s.md"; [ -f "$f" ] || continue
      cat "$f" | write "$ROOT/.relentless/$s.md"
    done
    if [ "$TARGET" = codex ]; then
      { strip_fm "$SRC/core.md"
        printf '\n## Skill files\n\nLoad on demand from `.relentless/`:\n'
        for s in "${SKILLS[@]}"; do printf -- '- `.relentless/%s.md` — %s\n' "$s" "$(desc_of "$SRC/$s.md")"; done
      } | write "$ROOT/AGENTS.md"
    fi
    ;;
  agents-md)
    say "building single-file AGENTS.md -> $ROOT/AGENTS.md"
    { for s in "${SKILLS[@]}"; do
        f="$SRC/$s.md"; [ -f "$f" ] || continue
        strip_fm "$f"; printf '\n---\n\n'
      done; } | write "$ROOT/AGENTS.md"
    ;;
  copilot)
    say "building Copilot instructions"
    { for s in core triage reasoning evidence verification safety stop-policy; do
        strip_fm "$SRC/$s.md"; printf '\n---\n\n'
      done; } | write "$ROOT/.github/copilot-instructions.md"
    ;;
  *) die "unknown target '$TARGET' (see --help)" ;;
esac

say "done."
[ "$DRY" = 1 ] && warn "dry run — nothing was written"
exit 0
