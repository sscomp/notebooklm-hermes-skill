# Troubleshooting

This guide collects the common failure modes that can make NotebookLM look
broken even when the skill itself is installed correctly.

## Post-install smoke test

Run these checks in order after installing into a Hermes profile:

1. Restart the Hermes gateway for that profile.
2. Test `/nb-list`.
3. Test `/nb-login` if the profile has not logged into NotebookLM yet.
4. Test `/nb-use <notebook-id>`.
5. Test `/nb-ask <question>`.

Interpret the results like this:

- `/nb-list` failing usually means the quick-command block was not loaded.
- `/nb-list` succeeding but `/nb-use <id>` failing usually means a Hermes
  quick-command argument compatibility problem.
- `/nb-use <id>` succeeding but `/nb-ask <question>` failing usually means the
  same argument path is still unreliable and should be checked before blaming
  NotebookLM itself.

## What the installer already handles

The standard installer already performs these steps:

- copies the skill into `<PROFILE>/skills/research/notebooklm`
- creates `<PROFILE>/bin/nb`
- writes the NotebookLM `quick_commands` block into `<PROFILE>/config.yaml`
- installs the shared runtime unless `--skip-runtime` is used

Because of that, most users should not manually `cp`, `chmod`, or hand-merge the
template files unless they are repairing a damaged profile.

## Required files to verify

Check these if slash commands still do not work:

- `<PROFILE>/skills/research/notebooklm`
- `<PROFILE>/bin/nb`
- `<PROFILE>/config.yaml`
- `~/.hermes/tools/notebooklm-py-venv/bin/notebooklm`

If the profile has never authenticated before, also expect NotebookLM auth state
to be created under the profile after `nb login`.

## Hermes quick-command argument compatibility

NotebookLM slash commands rely on Hermes `quick_commands` with exec commands such
as:

```yaml
quick_commands:
  nb-use:
    type: exec
    command: /path/to/profile/bin/nb use {args}
  nb-ask:
    type: exec
    command: /path/to/profile/bin/nb ask {args}
```

Two things must both be true:

1. The command definitions include `{args}` for commands that accept arguments.
2. Your Hermes build actually expands `{args}` before executing the shell command.

If either side is missing, parameterized slash commands break even though
`/nb-list` may still work.

### Typical symptom

One or more of these show up:

- `/nb-use <id>` prints `Usage: nb_use.sh <notebook_id>`
- `/nb-ask <question>` behaves as if no question was provided
- commands without arguments work, but commands with arguments fail

### What to check

1. Open `<PROFILE>/config.yaml` and confirm the NotebookLM block exists.
2. Confirm `nb-use`, `nb-ask`, and similar commands contain `{args}`.
3. Restart the Hermes gateway after any `config.yaml` change.
4. Re-test `/nb-use <id>`.

If `/nb-list` works and `{args}` is present but argument-bearing commands still
fail, the remaining issue is usually Hermes-side quick-command argument
substitution rather than the NotebookLM skill itself.

## Telegram command format

For Hermes gateway platforms such as Telegram, use slash commands:

- `/nb-list`
- `/nb-use <notebook-id>`
- `/nb-ask <question>`

Do not validate Telegram installs by typing plain text such as `nb list`. Hermes
does not treat that as a deterministic command path.

## Gateway restart reminder

After changing `<PROFILE>/config.yaml`, restart the profile's Hermes gateway
before testing:

```bash
/Users/sscomp/.local/bin/hermes --profile m2 gateway restart
/Users/sscomp/.local/bin/hermes --profile m2 gateway status
```

Replace `m2` with your actual profile name.
