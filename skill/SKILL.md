# NotebookLM Research Skill

## Description
Use NotebookLM as a Hermes research toolset. The preferred interface is the profile-local `nb` command. Telegram or other gateways can still route legacy slash commands into this skill through optional quick command mappings, while the underlying NotebookLM operations run through the shared `notebooklm-py` CLI runtime installed with this skill.

## Router

```bash
HERMES_HOME="$HERMES_HOME" "$HERMES_HOME/skills/research/notebooklm/scripts/nb.sh" <command> [args...]
```

## Commands
- `create`
- `use`
- `add`
- `research`
- `ask`
- `brief`
- `slides`
- `podcast`
- `quiz`
- `mindmap`
- `download`
- `reset`
- `status`
- `list`
- `login`

Recommended day-to-day usage:

- `nb list`
- `nb use <notebook-id-or-title>`
- `nb ask <question>`
- `nb create <topic>`
- `nb status`

## Auth
Run profile-local login:

```bash
HERMES_HOME="$HERMES_HOME" "$HERMES_HOME/skills/research/notebooklm/scripts/nb_login.sh"
```

## Runtime

Standard installation:

```bash
/path/to/notebooklm-hermes-skill/scripts/install-profile.sh <profile-home>
```

This installs the skill into the target profile and bootstraps the pinned shared runtime:

- `~/.hermes/tools/notebooklm-py-venv/bin/notebooklm`
- `notebooklm-py[browser]==0.3.4`

Useful installer flags:

- `--skip-runtime`
- `--install-quick-commands`
- `--no-install-quick-commands`
