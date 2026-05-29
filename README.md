---
title: Obsidian Memory Skills
tags:
  - obsidian-memory
---

# Obsidian Memory Skill

This repository contains `obsidian-memory`, a [Skills.sh](https://www.skills.sh/) compatible skill for keeping durable task memory in an Obsidian-readable vault. 

## Issues with modern agent workflow

Working with agent such as Codex/Claude code has it's flaws;

When you have an agent session running, especially during a task where the scope isn't obvious, there can be a lot of exploration which involves reading files and trying out different strategies when it comes to solving the problem at hand.

Eventually, the context gets clogged up and the performance drastically diminishes, without mentioning the increasing cost of token usage for every additional request that has to carry all the previous context.

Additionally, sometimes you spend a lot of time explaining to the agent how to solve a type of task, then when you want to work on a similar task, it loses all that context.
But you don't want to have that context present, every single time, because not all tasks are related.

And finally, you forget why you made certain decisions when it comes to your code, espeically if you offload all your work to agents. Why didn't I try this? Why did I do it this way? All of this information is very important to log since it captures the reasons behind the architectural decisions and would save future contributors or even yourself (if you have bad memory like me), from re-trying to do something in a way that was deemed impossible, or inferior.

# The solution 

The memory skill logs all the relevant information that concerns tasks in a markdown format, by filling up the template generated for each new task.

The template contains the following sections :
- what the task is
- why the implementation looks the way it does
- what was tried and rejected
- what files and repos mattered
- what the next agent session should know

The user chooses where the vault lives. 

## Install

Install the memory skill from the public GitHub repo:

```bash
npx skills add TawfiqAbubaker/obsidian-memory --skill obsidian-memory
```

During local development, you can inspect the skills the CLI sees:

```bash
npx skills add . --list
```

## First-Time Setup

Choose the folder you want to use as your memory vault. It can be an existing Obsidian vault, a synced folder, or a new directory.

Tell your agent:

```text
Use obsidian-memory and initialize my memory vault at /path/to/my/ObsidianVault.
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
Use obsidian-memory for this task.
```

If this work belongs to an existing task note, give the `task_id`. Otherwise, describe the task and the agent will create a new note. If the branch matters, provide `work_branch` and `base_branch`. If other tasks are related, tell the agent which ones are related.

## Repository Layout

- `skills/obsidian-memory/`
  - installable memory skill
  - bundled helper scripts, templates, and Obsidian authoring references

## Skill Helpers

The installable memory skill bundles these helpers:

```bash
scripts/init_vault.sh <vault_root>
scripts/new_task.sh <work_branch> <short_description> [task_title] [base_branch]
scripts/find_task.sh <task_id>
```

When installed through Skills.sh, those paths are relative to the installed skill directory.
