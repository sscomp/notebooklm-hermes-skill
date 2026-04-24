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

- `/nb-list`
- `/nb-use <notebook-id>`
- `/nb-ask <question>`
- `/nb-status`

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
