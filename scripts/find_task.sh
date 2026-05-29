#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
vault_root="$(cd "${script_dir}/.." && pwd)"
tasks_dir="${vault_root}/Tasks"

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <task_id>" >&2
  exit 1
fi

task_id="$1"

while IFS= read -r file; do
  if rg -q "^task_id: \"${task_id}\"$" "$file"; then
    printf '%s\n' "$file"
  fi
done < <(find "${tasks_dir}" -path '*/task.md' -type f | sort)
