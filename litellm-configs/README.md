# LiteLLM 网关配置

本目录包含 Crush 连接本地 LiteLLM API 网关的模板和说明。

## 快速开始

### 使用 Make（推荐）

```bash
make setup-litellm      # 交互式配置（自动检测连通性）
make setup-litellm-dry  # 预览，不修改任何文件
make unset-litellm      # 移除配置
```

### 直接调用脚本

```bash
# 指定局域网 IP（替换为你的实际 IP）
bash deploy/client-run-003-setup-litellm.sh --ip 192.168.x.x

# 使用 Tailscale 远程访问（替换为你的 Tailscale IP）
bash deploy/client-run-003-setup-litellm.sh --ip 100.x.x.x --tailscale

# 移除配置
bash deploy/client-run-003-setup-litellm.sh --unset
```

## 脚本功能

`deploy/client-run-003-setup-litellm.sh` 自动完成：

1. **连通性测试** — curl 检测网关是否可达
2. **Crush 全局 Provider** — 写入 `~/.config/crush/crush.json`
3. **环境变量** — 追加到 `~/.zshrc`（`OPENAI_API_KEY`、`OPENAI_BASE_URL`、`ANTHROPIC_BASE_URL`）
4. **模型列表** — 自动查询并展示网关已注册的模型
5. **非破坏性** — 修改前备份原始文件

## 文件说明

| 文件 | 用途 |
|------|------|
| `crush-global.json` | 全局 Crush Provider 模板（脚本自动写入 `~/.config/crush/crush.json`） |

## 环境变量说明

脚本向 `~/.zshrc` 注入以下变量：

| 变量 | 用途 |
|------|------|
| `LITELLM_GATEWAY_IP` | 网关 IP（局域网或 Tailscale） |
| `LITELLM_GATEWAY_URL` | OpenAI 兼容端点 `/v1` |
| `OPENAI_API_KEY` | 用于 Crush、OpenAI SDK |
| `OPENAI_BASE_URL` | Crush 默认读取此变量 |
| `ANTHROPIC_BASE_URL` | Claude Code pass-through（记录 Token 用量） |

## 角色别名（快速选模型）

| 别名 | 实际模型 | 后端 |
|------|---------|------|
| `code-gen` | Qwen3-Coder-Next | MLX 本地 |
| `code-review` | Qwen2.5-Coder-32B | MLX 本地 |
| `code-complete` | Qwen2.5-Coder-7B | MLX 本地 |
| `pdm` | Qwen3-Coder-480B | SiliconFlow 云端 |
| `qa` | Qwen2.5-Coder-32B | MLX 本地 |
| `doc-gen` | GLM-4.6 | SiliconFlow 云端 |

## 网络方案

| 场景 | IP | 命令 |
|------|-----|------|
| 同一局域网 | 你的局域网 IP（如 `192.168.x.x`） | `--ip YOUR_LAN_IP` |
| 跨网络 Tailscale | 你的 Tailscale IP（如 `100.x.x.x`） | `--ip YOUR_TS_IP --tailscale` |

## 管理面板

```
http://YOUR_GATEWAY_IP:4000/ui
```
