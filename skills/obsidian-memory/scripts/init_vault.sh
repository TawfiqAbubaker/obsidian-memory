#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
skill_dir="$(cd "${script_dir}/.." && pwd)"
template_dir="${skill_dir}/templates"

# shellcheck disable=SC1091
source "${script_dir}/common.sh"

usage() {
  cat >&2 <<'EOF'
Usage: init_vault.sh [--force] <vault_root>

Initialize the memory files inside a user-chosen Obsidian vault.
No default vault path is created.
EOF
}

force="false"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --force)
      force="true"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --*)
      echo "Unknown option: $1" >&2
      usage
      exit 1
      ;;
    *)
      break
      ;;
  esac
done

if [[ $# -ne 1 ]]; then
  usage
  exit 1
fi

vault_root="$(agent_memory_absolute_path "$1")"
tasks_dir="${vault_root}/Tasks"
template_dest="${tasks_dir}/_Templates/Task Note Template.md"
base_dest="${vault_root}/Tasks.base"

install_file() {
  local src="$1"
  local dest="$2"

  if [[ -e "$dest" && "$force" != "true" ]]; then
    printf 'keep  %s\n' "$dest"
    return 0
  fi

  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
  printf 'write %s\n' "$dest"
}

if [[ ! -f "${template_dir}/Task Note Template.md" ]]; then
  echo "Missing bundled task template: ${template_dir}/Task Note Template.md" >&2
  exit 1
fi

if [[ ! -f "${template_dir}/Tasks.base" ]]; then
  echo "Missing bundled Tasks.base template: ${template_dir}/Tasks.base" >&2
  exit 1
fi

mkdir -p "$tasks_dir"
mkdir -p "${tasks_dir}/_Templates"

install_file "${template_dir}/Task Note Template.md" "$template_dest"
install_file "${template_dir}/Tasks.base" "$base_dest"
agent_memory_write_config "$vault_root"

printf 'Vault root file: %s\n' "$(agent_memory_config_file)"
printf 'Vault root: %s\n' "$vault_root"
