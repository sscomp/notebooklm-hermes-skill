# Changelog

## 0.3.1

- Standardized the public GitHub guidance on slash commands such as `/nb-list` for Hermes gateway usage.
- Simplified installation so NotebookLM slash commands are installed by default instead of being optional.
- Clarified that the `nb` wrapper is an internal execution layer and should not be treated as the Telegram-facing command format.

## 0.3.0

- Added installer flags for optional quick-command installation into Hermes profile `config.yaml`.
- Kept `nb ...` as the primary path while making slash-command installation an explicit installer choice.
- Documented direct CLI usage, Telegram slash usage, gateway restart steps, and post-install verification.

## 0.2.0

- Changed the repo guidance to make direct `nb ...` usage the primary interface.
- Repositioned slash `quick_commands` as an optional legacy compatibility layer.
- Added a `platform_toolsets` template snippet for Hermes CLI access.
- Improved installer messaging to recommend direct CLI usage first.
- Added richer `nb` help output and aligned user-facing error messages with the new command style.
