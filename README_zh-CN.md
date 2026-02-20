# Crush + Everything Claude Code (ECC) 集成包 v4.0

本集成包将 **affaan-m/everything-claude-code** 的核心概念（agents/skills/rules/hooks/MCP 配置）适配为 **Crush 友好**的配置方式。

由于 Crush 与 Claude Code 的扩展格式不同，本集成包专注于 Crush 当前可直接使用的部分：
- **项目级 `.crush.json` 系统守卫 + 上下文规则**（合并式，非破坏性）
- **Crush 技能**（精选 ECC 技能，转换为 `~/.config/crush/skills/<name>/SKILL.md`）
- **代码片段**，用于可选的项目文档（`AGENTS.md`、`CONVENTIONS.md`），可按需复制使用

## 你将获得什么

### A) 项目级 `.crush.json` 增强（安全合并）
- 工具白名单 + 防幻觉提示（避免 `tool not found: read` 错误）
- 上下文优化清单（精简、高信噪比）
- 可选"工作流模式"（plan / build / review）

### B) 全局 Crush 技能（精选自 ECC 理念）
安装到你的 Crush 技能目录（默认 `~/.config/crush/skills`）：
- `ecc-planner`（实现规划模板）
- `ecc-tdd`（TDD 工作流 + 测试优先清单）
- `ecc-code-review`（质量门控、代码风格、基础安全检查）
- `ecc-security-review`（类 OWASP 安全检查 + 依赖项检查）
- `ecc-deployment`（CI/CD、回滚、健康检查、发布清单）
- `ecc-docker`（docker compose 模式、网络、数据卷、安全）
- `ecc-api-design`（REST 分页/错误处理/幂等性）
- `ecc-cost-aware-llm`（预算路由、成本日志、Token 使用规范）

> 这些技能有意保持精简。上游仓库体量庞大，本集成包专注于与 Crush 工作流契合的部分。

### C) 可选代码片段（不自动修改文件）
- `.snippets/AGENTS.md.snippet.md`
- `.snippets/CONVENTIONS.md.snippet.md`

## 一键安装

在你的 git 仓库内任意位置运行（自动检测仓库根目录）：

```bash
bash deploy/install.sh --ecc
```

### 添加工具守卫（推荐）
```bash
bash deploy/install.sh --ecc --tool-guard
```

### 预览运行（仅预览，不实际修改）
```bash
bash deploy/install.sh --ecc --tool-guard --dry-run
```

## 卸载（安全）
```bash
bash deploy/uninstall.sh
```
卸载仅移除本集成包添加的特定键/技能（操作前会自动备份）。

---

## 关于上游 ECC 的说明
- 上游仓库：https://github.com/affaan-m/everything-claude-code（MIT 协议）
- 本集成包**并非**上游的完整副本，而是面向 Crush 的适配版本。

---

## v4.1：可选 MCP 安装（ECC mcp-configs → Crush MCP）

本集成包现已包含 Everything Claude Code 中 `mcp-configs/mcp-servers.json` 的精选移植版本，适配到 Crush 的 `.crush.json` `mcp` 配置段。

安装示例：
```bash
bash deploy/install.sh --mcp-github
bash deploy/install.sh --mcp-supabase
bash deploy/install.sh --mcp-vercel
bash deploy/install.sh --mcp-common
bash deploy/tools/list_mcp.sh
```

非破坏性行为：
- 若 `.crush.json` 中已存在 `mcp.<name>`，安装器**不会覆盖**。
- 修改前会自动备份 `.crush.json`。

模板：
- `mcp-configs/ecc-mcp-servers.crush.json`

---

## v4.2：Superpowers（obra/superpowers）技能移植 for Crush（可选）

本集成包现已包含 Superpowers 核心技能（MIT 协议）的**可选**移植版本，适配为 Crush 技能：
- sp-brainstorming（头脑风暴）
- sp-git-worktrees（Git 工作树）
- sp-writing-plans（编写计划）
- sp-tdd（测试驱动开发）
- sp-subagent-dev（子代理开发）
- sp-executing-plans（执行计划）
- sp-request-code-review（请求代码审查）
- sp-finish-branch（完成分支）

安装：
```bash
bash deploy/install.sh --superpowers
```

组合安装：
```bash
bash deploy/install.sh --ecc --tool-guard --superpowers --mcp-common
```

版权归属：请参阅 `superpowers/ATTRIBUTION.md`。
