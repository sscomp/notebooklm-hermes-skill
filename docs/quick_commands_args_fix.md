# Quick Commands `{args}` 參數替換問題修復

## 問題描述

在 Hermes Agent v0.11.0 及更早版本中，`quick_commands` 的 `type: exec` 類型命令**無法正確替換 `{args}` 佔位符**，導致所有帶參數的 slash command 都無法正常工作。

### 症狀

當用戶在 Telegram 或其他 messaging platform 中使用帶參數的 slash command 時：

```
/nb-use 56aa3d60-508b-47eb-8499-d264a2a26047
/nb-ask 總結這個筆記本的重點
```

會收到錯誤訊息：
```
Usage: nb_use.sh <notebook_id>
```

或命令行為如同沒有收到任何參數。

### 根本原因

在 `gateway/run.py` 的 quick_commands 處理邏輯中，**沒有執行 `{args}` 替換**：

```python
# ❌ 錯誤的代碼 (v0.11.0 及更早)
if qcmd.get("type") == "exec":
    exec_cmd = qcmd.get("command", "")
    if exec_cmd:
        proc = await asyncio.create_subprocess_shell(
            exec_cmd,  # ← 這裡直接執行，沒有替換 {args}
            ...
        )
```

這導致命令如 `/Users/sscomp/.hermes/bin/nb list {args}` 會**字面執行**，將 `{args}` 作為參數傳遞給腳本，而不是用戶實際輸入的內容。

---

## 修復方案

### 修改檔案

`gateway/run.py` (第 3674-3676 行附近)

### 修復代碼

```python
# ✅ 正確的代碼
if qcmd.get("type") == "exec":
    exec_cmd = qcmd.get("command", "")
    if exec_cmd:
        # Replace {args} with user-provided arguments
        user_args = event.get_command_args().strip()
        exec_cmd = exec_cmd.replace("{args}", user_args)
        try:
            proc = await asyncio.create_subprocess_shell(
                exec_cmd,
                ...
            )
```

### 完整 diff

```diff
@@ -3672,6 +3672,9 @@ class Gateway:
             if command in quick_commands:
                 qcmd = quick_commands[command]
                 if qcmd.get("type") == "exec":
                     exec_cmd = qcmd.get("command", "")
                     if exec_cmd:
+                        # Replace {args} with user-provided arguments
+                        user_args = event.get_command_args().strip()
+                        exec_cmd = exec_cmd.replace("{args}", user_args)
                         try:
                             proc = await asyncio.create_subprocess_shell(
                                 exec_cmd,
```

---

## 安裝檢查清單

安裝 NotebookLM skill 或其他使用 `quick_commands` 的 skill 時，**必須驗證**以下項目：

### 1. 檢查 `gateway/run.py` 是否包含 `{args}` 替換邏輯

```bash
grep -A 3 "Replace {args}" ~/.hermes/hermes-agent/gateway/run.py
```

**預期輸出：**
```
# Replace {args} with user-provided arguments
user_args = event.get_command_args().strip()
exec_cmd = exec_cmd.replace("{args}", user_args)
```

如果沒有輸出，表示**尚未修復**，需要手動套用 patch。

### 2. 檢查 `config.yaml` 中的 `quick_commands` 是否包含 `{args}`

```bash
grep "{args}" ~/.hermes/config.yaml
```

**預期輸出：** 所有需要參數的命令都應該包含 `{args}`

```yaml
quick_commands:
  nb-ask:
    type: exec
    command: /Users/sscomp/.hermes/bin/nb ask {args}  # ← 應該有 {args}
  nb-use:
    type: exec
    command: /Users/sscomp/.hermes/bin/nb use {args}  # ← 應該有 {args}
```

### 3. 功能測試順序

**不要只測試 `/nb-list` 就結束**，因為它不需要參數，無法驗證 `{args}` 替換是否正常工作。

正確的測試順序：

```bash
# 1. 測試無參數命令（只能證明 quick_command 已註冊）
/nb-list

# 2. 測試有參數命令（才能真正驗證 {args} 替換）
/nb-use <notebook-id>

# 3. 測試參數傳遞完整性
/nb-ask <完整的問題>
```

如果 `/nb-use` 或 `/nb-ask` 回傳 usage 訊息或行為如同沒有參數，則表示 `{args}` 替換未正常工作。

---

## 受影響的 Skill

所有使用 `quick_commands` 且需要參數的 skill 都會受此問題影響：

- `notebooklm-hermes-skill` (所有 `/nb-*` 命令)
- `hcron` (提醒事項相關命令)
- 任何自定義使用 `type: exec` 並帶 `{args}` 的 quick_commands

---

## 暫時解決方案（如果無法立即修復 Hermes Agent）

如果無法修改 `gateway/run.py`，可以使用以下變通方法：

### 方法 1：使用 `alias` 類型（如果支援）

```yaml
quick_commands:
  nb-ask:
    type: alias
    target: nb
```

但這會失去 `exec` 類型的直接執行優勢。

### 方法 2：使用固定參數的命令（不推薦）

為常用參數創建多個固定命令：
```yaml
quick_commands:
  nb-status:
    type: exec
    command: /Users/sscomp/.hermes/bin/nb status  # 不需要參數
```

---

## 參考檔案

- 問題檔案：`~/.hermes/hermes-agent/gateway/run.py`
- 配置文件：`~/.hermes/config.yaml`
- Skill 模板：`notebooklm-hermes-skill/templates/quick_commands.yaml`

---

## 版本資訊

- 受影響版本：Hermes Agent v0.11.0 及更早
- 修復日期：2026-04-26
- 報告者：Scott Chang
