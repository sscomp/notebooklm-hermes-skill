# notebooklm-hermes-skill

Reusable NotebookLM research skill for Hermes Agent profiles.

This project packages the full NotebookLM integration used in the local migration:

- `/nb-create` (auto-sets active notebook)
- `/nb-use`
- `/nb-add`
- `/nb-research`
- `/nb-ask`
- `/nb-brief`
- `/nb-slides`
- `/nb-podcast`
- `/nb-quiz`
- `/nb-mindmap`
- `/nb-download`
- `/nb-reset`
- `/nb-list`
- `/nb-status`
- `/nb-login`
- status/list/login helpers

It is profile-isolated by design: each Hermes profile uses its own `NOTEBOOKLM_HOME`.

## Install into a Hermes profile

```bash
/Users/sscomp/notebooklm-hermes-skill/scripts/install-profile.sh /Users/sscomp/.hermes/profiles/m2
/Users/sscomp/notebooklm-hermes-skill/scripts/install-profile.sh /Users/sscomp/.hermes/profiles/n2
```

This installs:

- skill files into `<PROFILE>/skills/research/notebooklm`
- wrapper command into `<PROFILE>/bin/nb`

## Install notebooklm-py runtime (shared)

```bash
/Users/sscomp/notebooklm-hermes-skill/scripts/bootstrap-notebooklm.sh
```

By default this creates:

- `~/.hermes/tools/notebooklm-py-venv`
- binary: `~/.hermes/tools/notebooklm-py-venv/bin/notebooklm`

## Add Telegram slash quick commands

Use the snippet in:

- `/Users/sscomp/notebooklm-hermes-skill/templates/quick_commands.yaml`

Merge under `quick_commands:` in each profile `config.yaml`, then restart gateway.

## First-time login per profile

Run separately for each profile:

```bash
HERMES_HOME=/Users/sscomp/.hermes/profiles/m2 /Users/sscomp/.hermes/profiles/m2/bin/nb login
HERMES_HOME=/Users/sscomp/.hermes/profiles/n2 /Users/sscomp/.hermes/profiles/n2/bin/nb login
```

## Notes

- This project is generic for any Hermes profile name, not tied to `m2` / `n2`.
- Keep auth files profile-local (`<PROFILE>/notebooklm/storage_state.json`).
- Do not share Google auth state between profiles.

## 中文快速說明

這個專案是給 Hermes Agent 用的 NotebookLM 研究技能包，安裝後可透過 `/nb-*` 指令完成建立主題、加資料、研究問答與產出簡報/音訊等流程。

### 1) 安裝技能到指定 profile

```bash
/Users/sscomp/notebooklm-hermes-skill/scripts/install-profile.sh /Users/sscomp/.hermes/profiles/m2
```

### 2) 安裝 NotebookLM 執行環境（全機共用一次）

```bash
/Users/sscomp/notebooklm-hermes-skill/scripts/bootstrap-notebooklm.sh
```

### 3) 每個 profile 各自做一次登入授權

```bash
HERMES_HOME=/Users/sscomp/.hermes/profiles/m2 /Users/sscomp/.hermes/profiles/m2/bin/nb login
```

### 4) 常用指令

- `/nb-create <主題>`：建立 notebook 並自動設為目前使用中
- `/nb-use <notebook_id>`：切換到既有 notebook
- `/nb-add <網址或來源>`：加入資料來源
- `/nb-research <關鍵字>`：啟動 research 並匯入來源
- `/nb-ask <問題>`：對目前 notebook 問答
- `/nb-slides <需求>`：產生簡報
- `/nb-podcast <需求>`：產生音訊導讀
- `/nb-download <artifact-type>`：下載產物到 profile 輸出目錄
- `/nb-list`：列出 notebooks
- `/nb-status`：查看目前 notebook context
- `/nb-login`：為該 profile 執行 NotebookLM 登入
