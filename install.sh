#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  cat <<'EOF'
Usage:
  ./install.sh <target> [options]

Targets:
  claude      Install into ~/.claude/skills
  opencode    Install into ~/.opencode/skills
  openclaw    Install into ~/.openclaw/skills

Options:
  --classic         Install agent-work-environment only
  --with-archive    Also install diagnostic-archive
  --with-strategy   Also install swordbearer, wallfacer, wallbreaker
  --dry-run         Print actions without copying files
  -h, --help        Show this help

Examples:
  ./install.sh claude
  ./install.sh claude --with-archive
  ./install.sh claude --with-strategy
  ./install.sh opencode --classic
EOF
}

if [[ $# -lt 1 ]]; then
  usage
  exit 1
fi

target=""
mode="split"
with_archive="false"
with_strategy="false"
dry_run="false"

while [[ $# -gt 0 ]]; do
  case "$1" in
    claude|opencode|openclaw)
      target="$1"
      shift
      ;;
    --classic)
      mode="classic"
      shift
      ;;
    --with-archive)
      with_archive="true"
      shift
      ;;
    --with-strategy)
      with_strategy="true"
      shift
      ;;
    --dry-run)
      dry_run="true"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ -z "$target" ]]; then
  echo "Missing target platform." >&2
  usage
  exit 1
fi

case "$target" in
  claude)
    skill_home="$HOME/.claude/skills"
    ;;
  opencode)
    skill_home="$HOME/.opencode/skills"
    ;;
  openclaw)
    skill_home="$HOME/.openclaw/skills"
    ;;
esac

skills=()
if [[ "$mode" == "classic" ]]; then
  skills+=("agent-work-environment")
else
  skills+=("environment-governance" "agent-work-environment-v3")
fi

if [[ "$with_archive" == "true" ]]; then
  skills+=("diagnostic-archive")
fi

if [[ "$with_strategy" == "true" ]]; then
  skills+=("swordbearer" "wallfacer" "wallbreaker")
fi

echo "Target directory: $skill_home"
echo "Skills to install: ${skills[*]}"

if [[ "$dry_run" == "true" ]]; then
  exit 0
fi

mkdir -p "$skill_home"

for skill in "${skills[@]}"; do
  src="$REPO_ROOT/$skill"
  dst="$skill_home/$skill"

  if [[ ! -d "$src" ]]; then
    echo "Missing skill directory: $src" >&2
    exit 1
  fi

  rm -rf "$dst"
  cp -R "$src" "$dst"
  echo "Installed $skill -> $dst"
done

echo "Done."
