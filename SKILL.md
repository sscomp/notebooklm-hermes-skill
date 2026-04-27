# NotebookLM Research Skill (Hermes)

## Description
Use Google NotebookLM as a Hermes research skill. For Hermes gateway platforms such as Telegram, the recommended user-facing interface is the slash-command layer (`/nb-list`, `/nb-use`, `/nb-ask`). The profile-local `nb` wrapper remains the internal execution layer used by those slash commands.

## Capabilities
- create notebook and auto-activate context
- switch active notebook by id
- add URL/YouTube/file/text sources
- run web/Drive research import
- ask questions on notebook context
- generate briefing/slides/podcast/quiz/mind map
- download artifacts to profile-local output directory
- clear active notebook context

## Profile Isolation
Each Hermes profile must use its own NotebookLM home:

- `NOTEBOOKLM_HOME=$HERMES_HOME/notebooklm`
- `NOTEBOOKLM_OUTPUT_DIR=$HERMES_HOME/notebooklm/outputs`

Do not share auth/cookies across profiles.

## Primary Entry

```bash
HERMES_HOME="$HERMES_HOME" "$HERMES_HOME/bin/nb" <subcommand> [args...]
```

Subcommands:

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

Recommended gateway commands:

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

## First Login

```bash
HERMES_HOME="$HERMES_HOME" "$HERMES_HOME/bin/nb" login
```

After browser login, return to terminal and press Enter.

## Runtime

Install this skill with:

```bash
/path/to/notebooklm-hermes-skill/scripts/install-profile.sh <profile-home>
```

That installer also bootstraps the pinned shared runtime and writes NotebookLM slash command mappings into the target profile `config.yaml`:

- `~/.hermes/tools/notebooklm-py-venv/bin/notebooklm`
- `notebooklm-py[browser]==0.3.4`

Installer flag:

- `--skip-runtime`

## Agent Install Check

When this skill is installed into a customer Hermes environment, the agent must
verify Hermes quick-command `{args}` substitution before signing off.

Minimum checks:

1. Verify Hermes gateway code contains the `{args}` replacement logic for
   `type: exec` quick commands.
2. Verify the target profile `config.yaml` still includes `{args}` for
   parameterized NotebookLM slash commands.
3. Verify `/nb-use <notebook-id>` and `/nb-ask <question>` both work after
   gateway restart.

Reference:

- `/Users/sscomp/notebooklm-hermes-skill/docs/quick_commands_args_fix.md`
- `/Users/sscomp/notebooklm-hermes-skill/docs/troubleshooting.md`
