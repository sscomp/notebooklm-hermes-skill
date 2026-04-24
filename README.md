# notebooklm-hermes-skill

Reusable NotebookLM research skill for Hermes Agent profiles.

This project packages the full NotebookLM integration used in the local migration.

Version: `0.3.0`

## Recommended usage

Use the profile-local `nb` wrapper directly:

- `nb list`
- `nb use <notebook-id-or-title>`
- `nb ask <question>`
- `nb create <topic>`
- `nb status`
- `nb login`

This is the primary and recommended entry point because it is more compatible than routing everything through Hermes Gateway slash `quick_commands`. Slash commands can still exist as a legacy compatibility layer, but they are no longer the main path documented by this repo.

It is profile-isolated by design: each Hermes profile uses its own `NOTEBOOKLM_HOME`.

## Install into a Hermes profile

`install-profile.sh` is the main installer. It installs:

- the Hermes skill files into the target profile
- a pinned shared `notebooklm-py` runtime into `~/.hermes/tools/notebooklm-py-venv`
- the profile-local `nb` wrapper into `<PROFILE>/bin/nb`

Default install:

```bash
/Users/sscomp/notebooklm-hermes-skill/scripts/install-profile.sh /Users/sscomp/.hermes/profiles/m2
/Users/sscomp/notebooklm-hermes-skill/scripts/install-profile.sh /Users/sscomp/.hermes/profiles/n2
```

This installs:

- skill files into `<PROFILE>/skills/research/notebooklm`
- wrapper command into `<PROFILE>/bin/nb`
- shared runtime into `~/.hermes/tools/notebooklm-py-venv`
- by default, it does not modify `quick_commands` in `config.yaml`

By default the runtime is pinned to:

- `notebooklm-py[browser]==0.3.4`

If you already manage the runtime separately, you can skip that step:

```bash
/Users/sscomp/notebooklm-hermes-skill/scripts/install-profile.sh /Users/sscomp/.hermes/profiles/m2 --skip-runtime
```

If you also want legacy Telegram slash aliases such as `/nb-list`, install with:

```bash
/Users/sscomp/notebooklm-hermes-skill/scripts/install-profile.sh /Users/sscomp/.hermes/profiles/m2 --install-quick-commands
```

You can combine both options:

```bash
/Users/sscomp/notebooklm-hermes-skill/scripts/install-profile.sh /Users/sscomp/.hermes/profiles/m2 --skip-runtime --install-quick-commands
```

## Installer options

- `--skip-runtime`: do not reinstall the shared `notebooklm-py` runtime
- `--install-quick-commands`: write or refresh the NotebookLM `quick_commands` block in `<PROFILE>/config.yaml`
- `--no-install-quick-commands`: explicit no-op for slash aliases; useful in automation when you want only the `nb` wrapper

## Install notebooklm-py runtime only (advanced / shared)

Most users do not need this because `install-profile.sh` runs it automatically.

```bash
/Users/sscomp/notebooklm-hermes-skill/scripts/bootstrap-notebooklm.sh
```

By default this creates:

- `~/.hermes/tools/notebooklm-py-venv`
- binary: `~/.hermes/tools/notebooklm-py-venv/bin/notebooklm`

## Hermes profile config

Recommended profile config is to make sure Hermes CLI access is enabled so you can call `nb ...` directly:

```yaml
platform_toolsets:
  cli:
    - hermes-cli
```

A ready-to-copy snippet is included at:

- `/Users/sscomp/notebooklm-hermes-skill/templates/platform_toolsets.yaml`

## Optional legacy slash quick commands

Use the snippet in:

- `/Users/sscomp/notebooklm-hermes-skill/templates/quick_commands.yaml`

Only use this if you still want Telegram or other gateway slash aliases such as `/nb-list`.

These quick commands now exist for backward compatibility. They are not the recommended primary interface because argument passing through the gateway can be less reliable than direct `nb ...` usage.

If you prefer automation instead of manual merge, use:

```bash
/Users/sscomp/notebooklm-hermes-skill/scripts/install-profile.sh /Users/sscomp/.hermes/profiles/m2 --install-quick-commands
```

## First-time login per profile

Run separately for each profile:

```bash
HERMES_HOME=/Users/sscomp/.hermes/profiles/m2 /Users/sscomp/.hermes/profiles/m2/bin/nb login
HERMES_HOME=/Users/sscomp/.hermes/profiles/n2 /Users/sscomp/.hermes/profiles/n2/bin/nb login
```

## Usage and verification

### Direct CLI path

Terminal:

```bash
HERMES_HOME=/Users/sscomp/.hermes/profiles/m2 /Users/sscomp/.hermes/profiles/m2/bin/nb list
HERMES_HOME=/Users/sscomp/.hermes/profiles/m2 /Users/sscomp/.hermes/profiles/m2/bin/nb status
```

### Telegram slash path

If the profile was installed with `--install-quick-commands` and the gateway was restarted, test:

- `/nb-list`
- `/nb-status`
- `/nb-login`

For slash commands with arguments:

- `/nb-use <notebook-id>`
- `/nb-ask <question>`

### Gateway restart and status

After changing `config.yaml`:

```bash
/Users/sscomp/.local/bin/hermes --profile m2 gateway restart
/Users/sscomp/.local/bin/hermes --profile m2 gateway status
```

## Notes

- This project is generic for any Hermes profile name, not tied to `m2` / `n2`.
- Keep auth files profile-local (`<PROFILE>/notebooklm/storage_state.json`).
- Do not share Google auth state between profiles.
- If a slash alias works for `list` but fails for commands with arguments such as `use` or `ask`, switch to direct `nb ...` usage immediately.
- Telegram slash aliases require the profile gateway to be started or restarted after `config.yaml` changes.

## 中文快速說明

這個專案是給 Hermes Agent 用的 NotebookLM 研究技能包。

### 核心建議

現在建議把 `nb` 當成主入口，不要把 `/nb-*` slash 指令當成主要操作方式。

原因很單純：`nb ...` 是直接呼叫 profile 內的 wrapper，比 Hermes Gateway 的 `quick_commands` 轉送更穩，尤其是有參數的命令。

### 1) 安裝到指定 profile

這一步會同時安裝：

- Hermes skill
- 共用的 `notebooklm-py` 執行環境
- profile-local `nb` wrapper

```bash
/Users/sscomp/notebooklm-hermes-skill/scripts/install-profile.sh /Users/sscomp/.hermes/profiles/m2
```

預設會安裝固定版本：

- `notebooklm-py[browser]==0.3.4`

若你已經自行維護 runtime，可改用：

```bash
/Users/sscomp/notebooklm-hermes-skill/scripts/install-profile.sh /Users/sscomp/.hermes/profiles/m2 --skip-runtime
```

如果你也要一起安裝 Telegram slash 指令相容層：

```bash
/Users/sscomp/notebooklm-hermes-skill/scripts/install-profile.sh /Users/sscomp/.hermes/profiles/m2 --install-quick-commands
```

若只想更新 skill，不重裝 runtime，但仍要補上 slash 指令：

```bash
/Users/sscomp/notebooklm-hermes-skill/scripts/install-profile.sh /Users/sscomp/.hermes/profiles/m2 --skip-runtime --install-quick-commands
```

### 2) installer 選項

- `--skip-runtime`：不重裝共用 `notebooklm-py` runtime
- `--install-quick-commands`：自動把 NotebookLM 的 `quick_commands` 寫進該 profile 的 `config.yaml`
- `--no-install-quick-commands`：明確只安裝 `nb` 主路徑，不裝 slash 相容層

### 3) 每個 profile 各自做一次登入授權

```bash
HERMES_HOME=/Users/sscomp/.hermes/profiles/m2 /Users/sscomp/.hermes/profiles/m2/bin/nb login
```

### 4) 建議記住的常用指令

- `nb create <主題>`：建立 notebook 並自動設為目前使用中
- `nb use <notebook_id 或標題>`：切換到既有 notebook
- `nb add <網址或來源>`：加入資料來源
- `nb research <關鍵字>`：啟動 research 並匯入來源
- `nb ask <問題>`：對目前 notebook 問答
- `nb slides <需求>`：產生簡報
- `nb podcast <需求>`：產生音訊導讀
- `nb download <artifact-type>`：下載產物到 profile 輸出目錄
- `nb list`：列出 notebooks
- `nb status`：查看目前 notebook context
- `nb login`：為該 profile 執行 NotebookLM 登入

### 5) 如果真的需要 slash 指令

你還是可以保留 `/nb-list`、`/nb-use` 這些 quick commands，但現在 repo 把它們定位成「相容模式」，不是推薦主入口。

如果出現「`/nb-list` 可以，但 `/nb-use` 不穩」這種情況，請直接改用：

- `nb list`
- `nb use <ID>`
- `nb ask <問題>`

### 6) 安裝後怎麼驗證

CLI 主路徑：

```bash
HERMES_HOME=/Users/sscomp/.hermes/profiles/m2 /Users/sscomp/.hermes/profiles/m2/bin/nb list
HERMES_HOME=/Users/sscomp/.hermes/profiles/m2 /Users/sscomp/.hermes/profiles/m2/bin/nb status
```

若有安裝 slash 相容層，改完 `config.yaml` 後要重啟 gateway：

```bash
/Users/sscomp/.local/bin/hermes --profile m2 gateway restart
/Users/sscomp/.local/bin/hermes --profile m2 gateway status
```

然後再去 Telegram 測：

- `/nb-list`
- `/nb-status`
- `/nb-use <ID>`
