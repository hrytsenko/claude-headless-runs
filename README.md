# headless-run

A Claude Code plugin for exploring how locally installed agents behave. Give it a prompt (system instructions), an input (user message) and, optionally, an output schema, name an agent, and it runs that agent in headless mode and reports the raw result. Use it to compare how Claude Code, Codex and Antigravity respond to the same prompt and input. Each agent needs its CLI installed and logged in. The skill checks this before running; for Antigravity, only installation can be checked.

## Install

```
/plugin marketplace add hrytsenko/claude-headless-runs
/plugin install headless-run@claude-headless-runs
```

## Use

Load the plugin for a session from this folder:

```bash
claude --plugin-dir .
```

Then describe the run in plain language: the prompt, the input, the agent and, optionally, the model and the schema. For example, in headless mode:

```bash
claude -p --plugin-dir . --allowedTools "Read,Write,Bash,Skill" 'Test the prompt "You are a coffee expert. Identify the coffee product the user names." with input "Lavazza Qualità Rossa" using Codex. Apply an output schema with: product name, manufacturer, coffee type (arabica, robusta or blend), form (beans, ground, instant or capsule), and origin of the beans, which can be unknown.'
```

Headless mode cannot ask for permissions, so `--allowedTools` must include `Write` and `Bash`.

To pick a model, name it with the agent, such as `using Codex with Luna` or `using Claude with Opus`. The skill infers the full model ID, preferring the latest version; without a model, each agent's default is used.

The skill writes the prompt and input verbatim, builds a JSON Schema from the description, runs the agent, and reports the agent, the model, and the output as returned.
