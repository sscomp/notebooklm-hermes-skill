# notebooklm-hermes-skill

Reusable NotebookLM research skill for Hermes Agent profiles.

This project packages the full NotebookLM integration used in the local migration.

Version: `0.3.3`

## Recommended usage

For Hermes gateway platforms such as Telegram, use the slash commands:

- `/nb-list`
- `/nb-use <notebook-id>`
- `/nb-ask <question>`
- `/nb-create <topic>`
- `/nb-status`
- `/nb-login`

This is the reliable user-facing interface for messaging platforms.

The profile-local `nb` wrapper still exists internally because the slash commands call it under the hood, but the public repo guidance is intentionally standardized on `/nb-xxx` so users do not test ambiguous plain-text inputs such as `nb list` in Telegram.

It is profile-isolated by design: each Hermes profile uses its own `NOTEBOOKLM_HOME`.

## Install into a Hermes profile

`install-profile.sh` is the main installer. It installs:

- the Hermes skill files into the target profile
- a pinned shared `notebooklm-py` runtime into `~/.hermes/tools/notebooklm-py-venv`
- the profile-local `nb` wrapper into `<PROFILE>/bin/nb`
- the NotebookLM `quick_commands` block into `<PROFILE>/config.yaml`

Default install:

```bash
/Users/sscomp/notebooklm-hermes-skill/scripts/install-profile.sh /Users/sscomp/.hermes/profiles/m2
/Users/sscomp/notebooklm-hermes-skill/scripts/install-profile.sh /Users/sscomp/.hermes/profiles/n2
```

This installs:

- skill files into `<PROFILE>/skills/research/notebooklm`
- wrapper command into `<PROFILE>/bin/nb`
- shared runtime into `~/.hermes/tools/notebooklm-py-venv`
- slash command mappings into `<PROFILE>/config.yaml`

By default the runtime is pinned to:

- `notebooklm-py[browser]==0.3.4`

If you already manage the runtime separately, you can skip that step:

```bash
/Users/sscomp/notebooklm-hermes-skill/scripts/install-profile.sh /Users/sscomp/.hermes/profiles/m2 --skip-runtime
```

## Installer option

- `--skip-runtime`: do not reinstall the shared `notebooklm-py` runtime

## Install notebooklm-py runtime only (advanced / shared)

Most users do not need this because `install-profile.sh` runs it automatically.

```bash
/Users/sscomp/notebooklm-hermes-skill/scripts/bootstrap-notebooklm.sh
```

By default this creates:

- `~/.hermes/tools/notebooklm-py-venv`
- binary: `~/.hermes/tools/notebooklm-py-venv/bin/notebooklm`

## Hermes profile config

Recommended profile config is to make sure Hermes CLI access is enabled because the slash commands dispatch to the profile-local `nb` wrapper:

```yaml
platform_toolsets:
  cli:
    - hermes-cli
```

A ready-to-copy snippet is included at:

- `/Users/sscomp/notebooklm-hermes-skill/templates/platform_toolsets.yaml`

## Slash command template

The installer now writes the NotebookLM `quick_commands` block into `config.yaml` automatically.

The reusable template still exists at:

- `/Users/sscomp/notebooklm-hermes-skill/templates/quick_commands.yaml`

Use it only if you want to inspect or manually merge the same mappings yourself.

## First-time login per profile

Run separately for each profile:

```bash
HERMES_HOME=/Users/sscomp/.hermes/profiles/m2 /Users/sscomp/.hermes/profiles/m2/bin/nb login
HERMES_HOME=/Users/sscomp/.hermes/profiles/n2 /Users/sscomp/.hermes/profiles/n2/bin/nb login
```

## Usage and verification

### Telegram slash path

After install, restart the Hermes gateway and test:

- `/nb-list`
- `/nb-status`
- `/nb-login`

For slash commands with arguments:

- `/nb-use <notebook-id>`
- `/nb-ask <question>`
- `/nb-create <topic>`

### Post-install verification checklist

Do not stop after `/nb-list`.

Use this order so you can tell the difference between a NotebookLM install problem
and a Hermes quick-command compatibility problem:

1. Restart the gateway after `config.yaml` changes.
2. Test `/nb-list` to confirm the slash-command mapping is loaded.
3. Test `/nb-login` if this profile has never authenticated with NotebookLM.
4. Test `/nb-use <notebook-id>` with a real notebook ID.
5. Test `/nb-ask <question>` to confirm argument passing works end to end.

Why this matters:

- `/nb-list` only proves the quick command exists.
- `/nb-use <id>` and `/nb-ask <question>` prove Hermes is passing slash-command
  arguments into the NotebookLM wrapper correctly.

If `/nb-list` works but `/nb-use <id>` only prints a usage message, treat that as a
Hermes compatibility problem first, not as a NotebookLM skill installation failure.

### Agent-required `{args}` compatibility check

When installing this repo into a customer Hermes environment, the agent must
explicitly verify the Hermes quick-command `{args}` substitution path.

Required checks:

1. Confirm the Hermes gateway code already replaces `{args}` in `type: exec`
   quick commands.
2. Confirm the installed profile `config.yaml` contains `{args}` on all
   NotebookLM commands that accept parameters.
3. Confirm verification includes `/nb-use <notebook-id>` and `/nb-ask <question>`,
   not only `/nb-list`.

Suggested check command:

```bash
grep -A 3 "Replace {args}" ~/.hermes/hermes-agent/gateway/run.py
```

If that returns nothing, treat the target Hermes build as not yet patched for
argument substitution and follow the repair notes in:

- [docs/quick_commands_args_fix.md](/Users/sscomp/notebooklm-hermes-skill/docs/quick_commands_args_fix.md)
- [docs/troubleshooting.md](/Users/sscomp/notebooklm-hermes-skill/docs/troubleshooting.md)

### Gateway restart and status

After changing `config.yaml`:

```bash
/Users/sscomp/.local/bin/hermes --profile m2 gateway restart
/Users/sscomp/.local/bin/hermes --profile m2 gateway status
```

## Known Hermes compatibility issue

Some Hermes builds do not correctly substitute slash-command arguments into
`quick_commands` exec commands.

Typical symptom:

- `/nb-list` works
- `/nb-use <id>` fails with a usage message such as `Usage: nb_use.sh <notebook_id>`
- `/nb-ask <question>` behaves as if no argument was provided

This usually means the Hermes gateway or CLI is not expanding `{args}` correctly for
user-defined quick commands.

What to check:

- `<PROFILE>/config.yaml` contains NotebookLM `quick_commands`
- the command lines include `{args}` for commands that expect parameters
- the gateway was restarted after editing `config.yaml`
- your Hermes build includes working quick-command argument substitution

Detailed troubleshooting is in:

- [docs/troubleshooting.md](/Users/sscomp/notebooklm-hermes-skill/docs/troubleshooting.md)

## Notes

- This project is generic for any Hermes profile name, not tied to `m2` / `n2`.
- Keep auth files profile-local (`<PROFILE>/notebooklm/storage_state.json`).
- Do not share Google auth state between profiles.
- For Telegram and other messaging platforms, prefer `/nb-xxx` commands and avoid testing plain-text inputs such as `nb list`.

## 中文快速說明

這個專案是給 Hermes Agent 用的 NotebookLM 研究技能包。

### 核心建議

在 Telegram 這類 Hermes gateway 平台上，請直接使用 slash 指令：

- `/nb-list`
- `/nb-use <ID>`
- `/nb-ask <問題>`
- `/nb-create <主題>`

不要把 `nb list`、`nb ask` 這類純文字輸入當成 Telegram 的正式用法。

原因很單純：在 Hermes gateway 內，可靠的命令路徑是 slash command。`nb` wrapper 是內部實作層，slash commands 會去呼叫它，但使用者不應該在 Telegram 直接拿 `nb xxx` 當成正式指令來測。

### 1) 安裝到指定 profile

這一步會同時安裝：

- Hermes skill
- 共用的 `notebooklm-py` 執行環境
- profile-local `nb` wrapper
- NotebookLM slash command mappings

```bash
/Users/sscomp/notebooklm-hermes-skill/scripts/install-profile.sh /Users/sscomp/.hermes/profiles/m2
```

預設會安裝固定版本：

- `notebooklm-py[browser]==0.3.4`

若你已經自行維護 runtime，可改用：

```bash
/Users/sscomp/notebooklm-hermes-skill/scripts/install-profile.sh /Users/sscomp/.hermes/profiles/m2 --skip-runtime
```

### 2) installer 選項

- `--skip-runtime`：不重裝共用 `notebooklm-py` runtime

### 3) 每個 profile 各自做一次登入授權

```bash
HERMES_HOME=/Users/sscomp/.hermes/profiles/m2 /Users/sscomp/.hermes/profiles/m2/bin/nb login
```

### 4) Telegram 正式用法

請測這些：

- `/nb-list`
- `/nb-status`
- `/nb-login`
- `/nb-use <ID>`
- `/nb-ask <問題>`
- `/nb-create <主題>`

### 5) 安裝後怎麼驗證

不要只測 `/nb-list` 就結束。

建議驗證順序：

1. `/nb-list`
2. `/nb-login`
3. `/nb-use <ID>`
4. `/nb-ask <問題>`

原因是：

- `/nb-list` 只能證明 slash command 已載入
- `/nb-use <ID>`、`/nb-ask <問題>` 才能證明 Hermes 有把 quick command 的參數正確傳進去

如果 `/nb-list` 可以，但 `/nb-use <ID>` 只回 usage 訊息，優先懷疑 Hermes 的 quick command `{args}` 相容性，而不是先懷疑 NotebookLM skill 沒裝好。

改完 `config.yaml` 後要重啟 gateway：

```bash
/Users/sscomp/.local/bin/hermes --profile m2 gateway restart
/Users/sscomp/.local/bin/hermes --profile m2 gateway status
```

### 6) Hermes 相容性排錯

有些 Hermes 版本會出現：

- `/nb-list` 正常
- `/nb-use <ID>`、`/nb-ask <問題>` 卻拿不到參數

這通常是 Hermes 本體沒有正確把 `quick_commands` 裡的 `{args}` 展開。

請先檢查：

- `<PROFILE>/config.yaml` 的 NotebookLM `quick_commands` 是否存在
- 需要參數的 command 是否真的含有 `{args}`
- 修改完 `config.yaml` 後是否已重啟 gateway

詳細排錯請看：

- [docs/troubleshooting.md](/Users/sscomp/notebooklm-hermes-skill/docs/troubleshooting.md)

### 7) Agent 必查 `{args}` 參數替換

安裝到客戶機台時，agent 不可以只確認 `/nb-list` 成功。

必查項目：

1. `~/.hermes/hermes-agent/gateway/run.py` 是否已有 `{args}` 替換邏輯
2. `<PROFILE>/config.yaml` 內 `nb-use`、`nb-ask` 等命令是否保留 `{args}`
3. 是否實測 `/nb-use <ID>` 與 `/nb-ask <問題>`

建議檢查：

```bash
grep -A 3 "Replace {args}" ~/.hermes/hermes-agent/gateway/run.py
grep "{args}" /Users/sscomp/.hermes/profiles/m2/config.yaml
```

若第一個檢查沒有結果，代表客戶機上的 Hermes Agent 很可能尚未修補；
這時請依下列文件處理，不要誤判成 NotebookLM skill 安裝失敗：

- [docs/quick_commands_args_fix.md](/Users/sscomp/notebooklm-hermes-skill/docs/quick_commands_args_fix.md)
- [docs/troubleshooting.md](/Users/sscomp/notebooklm-hermes-skill/docs/troubleshooting.md)
