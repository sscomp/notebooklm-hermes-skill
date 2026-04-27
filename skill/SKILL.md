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

- `/nb-list`: List all notebooks
- `/nb-status`: Show the current active notebook status
- `/nb-use <notebook-id>`: Switch to the specified notebook
- `/nb-create <topic>`: Create a new notebook
- `/nb-add <url or text>`: Add a source to the active notebook
- `/nb-ask <question>`: Ask the active notebook a question
- `/nb-research <topic>`: Research a topic and add relevant sources
- `/nb-brief`: Generate a briefing artifact
- `/nb-slides`: Generate slide content
- `/nb-podcast`: Generate a podcast script
- `/nb-quiz`: Generate quiz content
- `/nb-mindmap`: Generate a mind map
- `/nb-download`: Download notebook output
- `/nb-reset`: Clear the current notebook conversation context
- `/nb-login`: Run NotebookLM login for this profile

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

## Agent Install Check

For customer-machine installs, do not stop at `/nb-list`.

The agent must also verify Hermes quick-command `{args}` substitution:

1. Check Hermes gateway code for the `{args}` replacement logic used by
   `type: exec` quick commands.
2. Check the profile `config.yaml` to make sure `nb-use`, `nb-ask`, and other
   parameterized commands still contain `{args}`.
3. Restart the gateway and test `/nb-use <notebook-id>` plus `/nb-ask <question>`.

If `/nb-list` works but argument commands fail, treat it as a Hermes-side
compatibility issue first. See:

- `/Users/sscomp/notebooklm-hermes-skill/docs/quick_commands_args_fix.md`
- `/Users/sscomp/notebooklm-hermes-skill/docs/troubleshooting.md`
