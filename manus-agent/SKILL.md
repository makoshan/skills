---
name: manus-agent
description: Manus API integration and usage workflows. Use when asked about Manus/Minus API, Manus CLI usage, webhooks, task lifecycle, or when creating/automating Manus tasks and reports.
---

# Manus Agent Skill

## Quick start (CLI)
- Run task + wait for result (best default):
  - `manus run --prompt "..."`
- Create task only:
  - `manus task --prompt "..."`
- Check status / result:
  - `manus status --id <task_id>`
  - `manus result --id <task_id>`
- Local webhook receiver:
  - `manus webhook --addr :8090`

## Environment
- `MANUS_API_KEY` must be set before use.
- Optional: `MANUS_BASE_URL` (default: https://api.manus.ai).

## Best practices (summary)
1) Prefer `manus run` to avoid multi-step manual flow.
2) Use structured prompts with explicit time range and output format.
3) Save report outputs under `work/reports/` for reuse.
4) For long tasks, use webhook receiver or run/wait polling.


## References
- Webhooks: see `references/webhooks.md`
- Quickstart: see `references/quickstart.md`
