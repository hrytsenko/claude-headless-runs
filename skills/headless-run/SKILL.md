---
name: headless-run
description: Run a prompt (system instructions) and an input (user message) through a locally installed agent CLI — Claude Code (claude), Codex (codex), or Antigravity (agy) — in headless mode, optionally enforcing a JSON output schema. Use when the user asks to test or run a prompt with an input using one of these agents, e.g. 'Test the prompt "..." with input "..." using Claude'.
---


# Headless run

`<skill-dir>` is this file's directory.

## 1. Select agent and model

| Agent | `<agent>` | Families (**default**) | Model ID |
|---|---|---|---|
| Claude Code | `claude` | **Haiku**, Sonnet, Opus, Fable | lowercase family |
| Codex | `codex` | **Luna**, Terra, Sol, Astra | `gpt-<version>-<family>` |
| Antigravity | `agy` | **Flash**, Pro | `gemini-<version>-<family>-<tier>` |

Pick the agent the user names (Claude, GPT, Gemini count). Use a full model ID as given, fixing only typos; otherwise use the named or default family at the version before its latest (latest releases may have limited availability), unless the user asks for the latest. If the agent or model is unclear, ask.

For `agy`, use the named tier, else `medium`.

## 2. Check the agent

Run `bash <skill-dir>/scripts/check-<agent>.sh`. On failure, show stderr and stop.

## 3. Write the inputs

In the scratchpad:

- `prompt.md`, `input.txt`: verbatim.
- `schema.json`: only if a schema was requested. A bare JSON Schema, built from the user's description if needed.

For `schema.json`, every object needs `"additionalProperties": false` and all its properties in `required`.

For `codex`, if the prompt contains `'''` (it breaks the TOML string), tell the user and stop.

## 4. Run the agent

Run `MODEL=<model-id> bash <skill-dir>/scripts/run-<agent>.sh prompt.md input.txt [schema.json]`.

For `agy`, if the model is rejected, retry once with the closest ID listed in the error. With a schema, the output is the envelope's `structured_output`; if it's missing, the run failed despite exit 0.

## 5. Report

Show the agent, model ID, prompt, input, schema (if any), and output verbatim in a code block. On failure, show stderr and, if the model was rejected, the ID you tried. No commentary unless asked.
