---
name: obsidian-memory
description: Use when working on tasks that need durable memory across Codex sessions. This skill maintains a task note in this Obsidian vault for every task session, compresses exploration into short summaries, and leaves a resume-ready handoff so old chat context does not need to be preserved.
---

# Codex Memory

Use this skill for engineering work tied to this vault.
Resolve the vault root in this order:
1. If `AGENT_MEMORY_ROOT` is set, use that as the vault root.
2. Read `${XDG_CONFIG_HOME:-$HOME/.config}/agent-memory/root`. If it exists, its single-line content is the vault root.
3. For backward compatibility, read `~/.codex/obsidian-memory-root`. If it exists, its single-line content is the vault root.
4. Otherwise, ask the user where the Obsidian vault should live. Do not create a default vault path.

Use the helper scripts bundled next to this `SKILL.md`; do not assume the current project has a `scripts/` directory.

## Files
- Helpers:
  - `scripts/init_vault.sh`
  - `scripts/new_task.sh`
  - `scripts/find_task.sh`
- References:
  - `references/obsidian-markdown.md`
  - `references/obsidian-json-canvas.md`

## Default Workflow

1. Resolve the vault root.
2. If the user does not mention anything about an existing `task_id`, assume the task is `new`.
3. If the user says the task is `existing` but does not provide the `task_id`, ask for it before broad repo exploration.

If it's `new`
1. Ask only for the missing fields needed to create the note:
	- Task complexity: `low`, `medium`, or `high`
	- Whether there are related independent tasks
	- `work_branch` if it is not already clear
	- `base_branch` if it matters for the task
	- Whether the user wants to provide the short description or wants you to generate it
2. Create the note with:
   `scripts/new_task.sh <work_branch> <short_description> [task_title] [base_branch]`
3. Compress important findings into the note.
4. Before ending the session, leave a concise handoff in the note.

If it's `existing` and you have the `task_id`
1. Find the note with:
   `scripts/find_task.sh <task_id>`
   - `task_id` is globally unique inside `Tasks`.
2. Read the note before doing broad repo exploration.
3. During work, compress important findings into the note.
4. Before ending the session, leave a concise handoff in the note.

The user is responsible for telling Codex which tasks are related. Do not search the vault to infer related tasks unless the user explicitly asks for that.

If the user asks you explicitely to do something, different that writing the findings into the note or something expected (For example he can tell you change the work branch to this or something), just follow his instructions.

## Rules

1. Append to the existing note instead of creating a duplicate.
2. If the user gives related task notes or task IDs, add them to `related_tasks` in the frontmatter as Obsidian links with a short one- or two-word description, for example:
   `- "[[Tasks/2026-04-29-QX3ZW/task|vault memory]]"`
3. Do not try to infer related tasks automatically.

The helper generates the `task_id` automatically when creating a new note.

## Obsidian Authoring References

If you need Obsidian-specific Markdown syntax, read `references/obsidian-markdown.md`.

If a visual map would make the task handoff clearer, read `references/obsidian-json-canvas.md` before creating or editing a `.canvas` file.

## Branch Model

- `base_branch`: the branch the task is based on
- `work_branch`: the current implementation branch for the task
- `task_id`: stable task identity

## What To Write During Work

Update the note when any of these happen:

- a design decision is made
- an exploration path is ruled out
- the real relevant files are identified
- validation changes the confidence level
- the task is paused or handed off

Prefer short statements over transcripts.

Good examples:

- `Searched repo for X; only file Y participates in this path.`
- `Rejected fix in Z layer because failure happens before that hook.`
- `Warm boot regression risk remains; no failing test yet.`

## End Of Session

Before finishing, update:

- `last_updated`
- `Current Summary`
- `Files / Areas That Matter`
- `Decisions`
- `Dead Ends / Compressed Exploration`
- `Validation`
- `Session Log`

Do not modify `created` after the note is created.
Make sure that there's no redundant information / repeated information between the note sections.

## Behavior Expectations

- Treat chat context as disposable and the note as the durable record.
- Prefer updating the task note for the current session over relying on chat history.
- If the user gives related tasks, add wikilinks instead of repeating the history.
- Do not spend time searching for related tasks unless the user explicitly asks for it.
- Treat `task_id` as the unique lookup key for existing notes.
- Keep notes readable in under two minutes.
