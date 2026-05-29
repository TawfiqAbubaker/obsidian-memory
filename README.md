---
title: Obsidian Memory Skills
tags:
  - obsidian-memory
---

# Obsidian Memory Skills

This repository contains Skills.sh-compatible skills for keeping durable task memory in an Obsidian-readable vault. The main memory skill is `obsidian-memory`, and it can be installed by Skills.sh-supported agents such as Codex and Claude Code.

## What It Does

The memory skill keeps long-running task context out of chat history and in Markdown notes:

- what the task is
- why the implementation looks the way it does
- what was tried and rejected
- what files and repos mattered
- what the next agent session should know

The user chooses where the vault lives. The skill does not create a hidden default under `~`.

## Install

Install the memory skill from the public GitHub repo:

```bash
npx skills add TawfiqAbubaker/obsidian-memory --skill obsidian-memory
```

Install every skill in the repo:

```bash
npx skills add TawfiqAbubaker/obsidian-memory
```

During local development, you can inspect the skills the CLI sees:

```bash
npx skills add . --list
```

## First-Time Setup

Choose the folder you want to use as your memory vault. It can be an existing Obsidian vault, a synced folder, or a new directory.

Tell your agent:

```text
$obsidian-memory initialize my memory vault at /path/to/my/ObsidianVault.
```

The initializer creates the missing memory files in that folder and records the chosen path in:

```text
${XDG_CONFIG_HOME:-$HOME/.config}/agent-memory/root
```

Advanced users can override the saved path for a session:

```bash
AGENT_MEMORY_ROOT=/path/to/my/ObsidianVault
```

Open the same folder in Obsidian to preview task notes and `Tasks.base`.

## Normal Use

Start a task with:

```text
$obsidian-memory new task
```

If this work belongs to an existing task note, give the `task_id`. Otherwise, describe the task and the agent will create a new note. If the branch matters, provide `work_branch` and `base_branch`. If other tasks are related, tell the agent which ones are related.

## Repository Layout

- `skills/obsidian-memory/`
  - installable memory skill
  - bundled helper scripts and templates
- `skills/obsidian-*`
  - helper skills for Obsidian Markdown, Bases, Canvas, and CLI workflows
- `skills/defuddle/`
  - web-page extraction helper skill
- `Tasks.base`
  - example task browser for this repository's own vault
- `Tasks/_Templates/Task Note Template.md`
  - example task template for this repository's own vault
- `scripts/`
  - local-development helpers for this repository checkout

## Skill Helpers

The installable memory skill bundles these helpers:

```bash
scripts/init_vault.sh <vault_root>
scripts/new_task.sh <work_branch> <short_description> [task_title] [base_branch]
scripts/find_task.sh <task_id>
```

When installed through Skills.sh, those paths are relative to the installed skill directory.
