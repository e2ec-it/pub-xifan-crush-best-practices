# Crush + Everything Claude Code (ECC) 整合包 v4.0

本整合包將 **affaan-m/everything-claude-code** 的核心概念（agents/skills/rules/hooks/MCP 設定）適配為 **Crush 友好**的配置方式。

由於 Crush 與 Claude Code 的擴展格式不同，本整合包專注於 Crush 目前可直接使用的部分：
- **專案級 `.crush.json` 系統守衛 + 上下文規則**（合併式，非破壞性）
- **Crush 技能**（精選 ECC 技能，轉換為 `~/.config/crush/skills/<name>/SKILL.md`）
- **程式碼片段**，用於可選的專案文件（`AGENTS.md`、`CONVENTIONS.md`），可按需複製使用

## 你將獲得什麼

### A) 專案級 `.crush.json` 增強（安全合併）
- 工具白名單 + 防幻覺提示（避免 `tool not found: read` 錯誤）
- 上下文最佳化清單（精簡、高信噪比）
- 可選「工作流程模式」（plan / build / review）

### B) 全域 Crush 技能（精選自 ECC 理念）
安裝到你的 Crush 技能目錄（預設 `~/.config/crush/skills`）：
- `ecc-planner`（實現規劃模板）
- `ecc-tdd`（TDD 工作流程 + 測試優先清單）
- `ecc-code-review`（品質門控、程式碼風格、基礎安全檢查）
- `ecc-security-review`（類 OWASP 安全檢查 + 依賴項檢查）
- `ecc-deployment`（CI/CD、回滾、健康檢查、發布清單）
- `ecc-docker`（docker compose 模式、網路、資料卷、安全）
- `ecc-api-design`（REST 分頁/錯誤處理/冪等性）
- `ecc-cost-aware-llm`（預算路由、成本日誌、Token 使用規範）

> 這些技能有意保持精簡。上游倉庫體量龐大，本整合包專注於與 Crush 工作流程契合的部分。

### C) 可選程式碼片段（不自動修改文件）
- `.snippets/AGENTS.md.snippet.md`
- `.snippets/CONVENTIONS.md.snippet.md`

## 一鍵安裝

在你的 git 倉庫內任意位置執行（自動偵測倉庫根目錄）：

```bash
bash deploy/install.sh --ecc
```

### 新增工具守衛（建議）
```bash
bash deploy/install.sh --ecc --tool-guard
```

### 預覽執行（僅預覽，不實際修改）
```bash
bash deploy/install.sh --ecc --tool-guard --dry-run
```

## 解除安裝（安全）
```bash
bash deploy/uninstall.sh
```
解除安裝僅移除本整合包新增的特定鍵/技能（操作前會自動備份）。

---

## 關於上游 ECC 的說明
- 上游倉庫：https://github.com/affaan-m/everything-claude-code（MIT 授權）
- 本整合包**並非**上游的完整副本，而是面向 Crush 的適配版本。

---

## v4.1：可選 MCP 安裝（ECC mcp-configs → Crush MCP）

本整合包現已包含 Everything Claude Code 中 `mcp-configs/mcp-servers.json` 的精選移植版本，適配到 Crush 的 `.crush.json` `mcp` 設定段。

安裝範例：
```bash
bash deploy/install.sh --mcp-github
bash deploy/install.sh --mcp-supabase
bash deploy/install.sh --mcp-vercel
bash deploy/install.sh --mcp-common
bash deploy/tools/list_mcp.sh
```

非破壞性行為：
- 若 `.crush.json` 中已存在 `mcp.<name>`，安裝器**不會覆寫**。
- 修改前會自動備份 `.crush.json`。

模板：
- `mcp-configs/ecc-mcp-servers.crush.json`

---

## v4.2：Superpowers（obra/superpowers）技能移植 for Crush（可選）

本整合包現已包含 Superpowers 核心技能（MIT 授權）的**可選**移植版本，適配為 Crush 技能：
- sp-brainstorming（腦力激盪）
- sp-git-worktrees（Git 工作樹）
- sp-writing-plans（編寫計劃）
- sp-tdd（測試驅動開發）
- sp-subagent-dev（子代理開發）
- sp-executing-plans（執行計劃）
- sp-request-code-review（請求程式碼審查）
- sp-finish-branch（完成分支）

安裝：
```bash
bash deploy/install.sh --superpowers
```

組合安裝：
```bash
bash deploy/install.sh --ecc --tool-guard --superpowers --mcp-common
```

版權歸屬：請參閱 `superpowers/ATTRIBUTION.md`。
