#!/usr/bin/env bash

set -euo pipefail

agent_memory_config_file() {
  local config_home
  config_home="${XDG_CONFIG_HOME:-${HOME}/.config}"
  printf '%s\n' "${config_home}/agent-memory/root"
}

agent_memory_legacy_config_file() {
  printf '%s\n' "${HOME}/.codex/obsidian-memory-root"
}

agent_memory_expand_path() {
  local path="$1"
  case "$path" in
    \~)
      printf '%s\n' "$HOME"
      ;;
    \~/*)
      printf '%s/%s\n' "$HOME" "${path#~/}"
      ;;
    *)
      printf '%s\n' "$path"
      ;;
  esac
}

agent_memory_absolute_path() {
  local path="$1"
  local expanded
  expanded="$(agent_memory_expand_path "$path")"
  mkdir -p "$expanded"
  cd "$expanded"
  pwd
}

agent_memory_write_config() {
  local vault_root="$1"
  local config_file
  config_file="$(agent_memory_config_file)"
  mkdir -p "$(dirname "$config_file")"
  printf '%s\n' "$vault_root" > "$config_file"
}

agent_memory_resolve_vault_root() {
  local config_file
  local legacy_config_file
  local root

  if [[ -n "${AGENT_MEMORY_ROOT:-}" ]]; then
    agent_memory_absolute_path "$AGENT_MEMORY_ROOT"
    return 0
  fi

  config_file="$(agent_memory_config_file)"
  if [[ -f "$config_file" ]]; then
    IFS= read -r root < "$config_file"
    if [[ -n "$root" ]]; then
      agent_memory_absolute_path "$root"
      return 0
    fi
  fi

  legacy_config_file="$(agent_memory_legacy_config_file)"
  if [[ -f "$legacy_config_file" ]]; then
    IFS= read -r root < "$legacy_config_file"
    if [[ -n "$root" ]]; then
      agent_memory_absolute_path "$root"
      return 0
    fi
  fi

  cat >&2 <<'EOF'
Memory vault root is not configured.
Ask the user where their Obsidian memory vault should live, then run:
  scripts/init_vault.sh <vault_root>
Alternatively, set AGENT_MEMORY_ROOT to the vault path.
EOF
  return 1
}
