#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
vault_root="$(cd "${script_dir}/.." && pwd)"
tasks_dir="${vault_root}/Tasks"
template_file="${tasks_dir}/_Templates/Task Note Template.md"

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <work_branch> <short_description> [task_title] [base_branch]" >&2
  exit 1
fi

work_branch="$1"
short_description="$2"
task_title="${3:-$short_description}"
base_branch="${4:-}"

today="$(date +%F)"

escape_sed_replacement() {
  printf '%s' "$1" | sed -e 's/[\/&\\]/\\&/g'
}

generate_task_id() {
  local candidate
  while true; do
    set +o pipefail
    candidate="$(tr -dc 'A-Z0-9' </dev/urandom 2>/dev/null | head -c 5)"
    set -o pipefail
    [[ "${#candidate}" -eq 5 ]] || continue
    if [[ ! -d "${tasks_dir}/${today}-${candidate}" ]]; then
      printf '%s\n' "$candidate"
      return 0
    fi
  done
}

task_id="$(generate_task_id)"
task_dir="${tasks_dir}/${today}-${task_id}"
task_file="${task_dir}/task.md"

mkdir -p "$task_dir"

if [[ ! -f "$template_file" ]]; then
  echo "Task template not found: $template_file" >&2
  exit 1
fi

escaped_task_title="$(escape_sed_replacement "$task_title")"
escaped_base_branch="$(escape_sed_replacement "$base_branch")"
escaped_work_branch="$(escape_sed_replacement "$work_branch")"
escaped_short_description="$(escape_sed_replacement "$short_description")"

sed \
  -e "s/{{task_title}}/${escaped_task_title}/g" \
  -e "s/^base_branch: .*/base_branch: ${escaped_base_branch}/" \
  -e "s/^work_branch: .*/work_branch: \"${escaped_work_branch}\"/" \
  -e "s/^task_id: .*/task_id: \"${task_id}\"/" \
  -e "s/^short_description: .*/short_description: \"${escaped_short_description}\"/" \
  -e "s/^created: .*/created: \"${today}\"/" \
  -e "s/^last_updated: .*/last_updated: \"${today}\"/" \
  -e "s/^- \`YYYY-MM-DD\`: one or two lines summarizing what happened/- \`${today}\`: task note created/" \
  "$template_file" > "$task_file"

printf '%s\n' "$task_file"
