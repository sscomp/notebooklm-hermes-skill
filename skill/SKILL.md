# NotebookLM Research Skill

## Description
Use NotebookLM as a Hermes research toolset. On Hermes gateway platforms, the preferred user-facing interface is the slash-command layer such as `/nb-list` and `/nb-ask`. The profile-local `nb` wrapper remains the internal router used by those commands.

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

Recommended gateway usage:

- `/nb-list`
- `/nb-use <notebook-id>`
- `/nb-ask <question>`
- `/nb-create <topic>`
- `/nb-status`

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

This installs the skill into the target profile, writes the NotebookLM slash command mappings into `config.yaml`, and bootstraps the pinned shared runtime:

- `~/.hermes/tools/notebooklm-py-venv/bin/notebooklm`
- `notebooklm-py[browser]==0.3.4`

Useful installer flag:

- `--skip-runtime`
