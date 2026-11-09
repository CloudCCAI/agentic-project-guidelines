---
title: Agentic Project State Model Reference
version: 3.11.0
---

# Agentic Project State Model Reference

This file defines the detailed project state model used by `SKILL.md`.

## Core Principles

1. `current-status.md` is the mandatory entry point for every session.
2. `task-board.md` is the authoritative execution queue for implementation and handoff work.
3. `task-archive.md` stores older completed or canceled work once the active board exceeds its retention window.
4. Non-trivial feature work should have a primary spec under `docs/specs/`.
5. Brownfield projects should establish `PROJECT-BASELINE.md` before broad legacy changes.
6. Other files are read and updated only when their trigger conditions fire.
7. A fact must have exactly one source-of-truth file.
8. Snapshots and history should be separated.
9. Verified evidence must be distinguishable from inference.
10. Project-root `README.md` and `AGENTS.md` must anchor the skill requirement for every agent.
11. Repository documents must not store passwords, bearer tokens, private keys, or reusable secrets.

## Project Instruction Anchors

Projects using this protocol must keep a managed declaration block in the project-root `README.md` and `AGENTS.md`.

That block must say:

- the project follows `agentic-project-guidelines`
- every AI agent must automatically use the skill
- if the skill is missing locally, install it from `https://github.com/CloudCCAI/agentic-project-guidelines`

Follow the [mandatory AGENTS.md and legacy CLAUDE.md migration rules](SKILL.md#project-level-skill-declaration). The recommended writer is `scripts/ensure-agent-guidance.sh`.

## Canonical File Semantics

### `current-status.md`

Use as the hot snapshot for the current phase, active task, next action, read hints, changed files summary, and verification summary.

Must contain:

- current phase
- active task
- next action
- changed files summary
- read-next hints for other state files

Must not contain:

- full issue details
- full ADR content
- long test logs
- long chronological session history
- complete feature design

### `goals.md`

Use as the durable description of scope and success.

Must contain:

- project vision
- in-scope outcomes
- out-of-scope items
- success metrics
- hard constraints

Update only when product intent changes.

### `task-board.md`

Use as the queue for executable work items and handoff state.

Each task should record:

- task id
- status
- priority
- owner role
- optional claimed-by runtime label
- dependencies or blockers
- related issues
- scope files or scope summary
- spec path when required
- branch and PR URL when useful
- done-when checklist
- next action
- handoff note

Recommended statuses:

- `todo`
- `ready`
- `in_progress`
- `blocked`
- `review`
- `done`
- `canceled`

Recommended priority values:

- `critical`
- `high`
- `medium`
- `low`

Recommended `owner_role` values:

- `backend-agent`
- `frontend-agent`
- `fullstack-agent`
- `qa-agent`
- `release-agent`
- `project-manager`
- `integration-agent`
- `human`
- `shared`
- `unassigned`

Retention rule:

- Keep active work in `Active Tasks`.
- Keep only the most recent 20 task cards in `Completed Tasks`.
- Move older completed or canceled task cards to `task-archive.md` instead of deleting them.

### `task-archive.md`

Use as the historical archive for completed and canceled task cards that aged out of `task-board.md`.

Archived tasks should retain:

- task id
- final status
- owner role
- related issues
- scope files
- handoff summary or completion context
- archived timestamp when available

Archived tasks should use only these statuses:

- `done`
- `canceled`

### `decisions.md`

Use as the ADR log.

Each decision should record:

- status
- date
- context
- options considered
- chosen option
- why it won
- consequences

Recommended statuses:

- `proposed`
- `accepted`
- `rejected`
- `superseded`

### `issue-list.md`

Use as the queue for bugs, blockers, risks, and follow-up work.

Each issue should record:

- id
- severity
- status
- owner
- summary
- evidence
- root cause status
- next action

Recommended statuses:

- `open`
- `in_progress`
- `blocked`
- `fixed`
- `verified`
- `closed`

Recommended severity values:

- `critical`
- `high`
- `medium`
- `low`

For root cause, use:

- `verified`
- `inferred`
- `unknown`

### `test-report.md`

Use as the record of the latest verified test evidence.

Must be updated only after a real command, CI job, or equivalent verification ran.

Recommended fields:

- last run timestamp
- command
- scope
- status
- pass/fail summary
- failing tests
- coverage summary

Recommended statuses:

- `passed`
- `failed`
- `partial`
- `not_run`

### `devops.md`

Use as the runbook for build, startup, deployment, environment, and operations.

Store:

- verified build commands
- verified run commands
- required services and environment variables
- deployment steps
- operational troubleshooting notes

Do not store speculative commands as final guidance.

### `docs/specs/FEAT-xxx-*.md`

Use as the primary delivery document for one feature or non-trivial change.

Each feature spec should record:

- feature id
- title
- status
- background and goals
- scope and out-of-scope
- current constraints
- design approach
- interfaces or data-shape changes
- task breakdown
- acceptance criteria
- risks and rollback notes
- implementation progress
- handoff notes

Recommended statuses:

- `draft`
- `in_design`
- `approved`
- `in_implementation`
- `implemented`
- `verified`
- `archived`

### `docs/specs/PROJECT-BASELINE.md`

Use as the brownfield adoption baseline for a legacy project that lacks prior state discipline.

The baseline should record:

- current project purpose and active delivery slice
- verified architecture facts
- inferred architecture facts
- active unknowns and pending verification
- legacy hotspots and risky modules
- known run, build, and dependency entry points
- first adoption tasks

Recommended statuses:

- `draft`
- `adopting`
- `active_reference`
- `verified`
- `archived`

## Front Matter Schema

Every state file should start with YAML front matter. Keep it small and stable.

Recommended minimum fields:

```yaml
---
kind: current-status
version: 3
updated_at: 2026-04-01T10:30:00Z
updated_by: ai
---
```

Recommended `kind` values:

- `current-status`
- `goals`
- `decisions`
- `issue-list`
- `task-board`
- `task-archive`
- `test-report`
- `devops`

## Read Strategy

Use this read order:

1. Read `current-status.md`.
2. Inspect its `read_next` or equivalent hints.
3. Read `task-board.md` for implementation, prioritization, or handoff work.
4. Read `task-archive.md` only when archived completed-work history matters.
5. In brownfield projects, open `PROJECT-BASELINE.md` before major legacy implementation when it exists.
6. Open the feature spec referenced by `spec_path` before non-trivial implementation.
7. Read additional warm or cold files only when triggered by the task.

## Source Of Truth Map

| Fact | Source of truth |
|------|-----------------|
| Current phase, active task, next action | `current-status.md` |
| Task queue, owner roles, dependencies, handoff notes | `task-board.md` |
| Archived completed/canceled tasks | `task-archive.md` |
| Project scope and success criteria | `goals.md` |
| Feature design and acceptance criteria | `docs/specs/FEAT-xxx-*.md` |
| Brownfield baseline and verified/inferred legacy facts | `docs/specs/PROJECT-BASELINE.md` |
| Technical decisions | `decisions.md` |
| Bugs, blockers, risks | `issue-list.md` |
| Verification evidence | `test-report.md` |
| Build, run, deploy operations | `devops.md` |

## Validation Expectations

`scripts/validate-state.py` should verify:

- required state files exist
- state front matter includes `kind`, `version`, `updated_at`, and `updated_by`
- `current-status.md` includes `phase`, `active_task`, `next_action`, and a `task_board` read hint
- `task-board.md` task cards use valid statuses and owner roles
- blocked tasks identify a blocker or dependency
- referenced `spec_path` files exist and have valid feature-spec or project-baseline front matter
- archived tasks are terminal
- completed-task retention stays under the active board limit
- `README.md` and `AGENTS.md` include the managed skill declaration block

## Safety Boundaries

- Never store passwords, private keys, bearer tokens, or reusable secrets in project state or specs.
- Do not treat chat memory as durable state.
- Do not invent test results or verified facts.
- Do not duplicate the same fact across several files.
- Do not use `current-status.md` as a dumping ground for logs or long designs.
