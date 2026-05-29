#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1091
source "${script_dir}/common.sh"

vault_root="$(agent_memory_resolve_vault_root)"
tasks_dir="${vault_root}/Tasks"

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <task_id>" >&2
  exit 1
fi

task_id="$1"

if [[ ! -d "$tasks_dir" ]]; then
  echo "Tasks directory not found: $tasks_dir" >&2
  echo "Run scripts/init_vault.sh <vault_root> first." >&2
  exit 1
fi

while IFS= read -r file; do
  if grep -q "^task_id: \"${task_id}\"$" "$file"; then
    printf '%s\n' "$file"
  fi
done < <(find "${tasks_dir}" -path '*/task.md' -type f | sort)
