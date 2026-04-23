# NotebookLM Research Skill

## Description
Use NotebookLM as a Hermes research toolset. Telegram or other gateways can route slash commands into this skill through quick command mappings.

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

## Auth
Run profile-local login:

```bash
HERMES_HOME="$HERMES_HOME" "$HERMES_HOME/skills/research/notebooklm/scripts/nb_login.sh"
```
