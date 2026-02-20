#!/usr/bin/env bash
# =============================================================================
# setup_litellm_gateway.sh
# 配置 Crush 连接本地 LiteLLM API 网关
#
# 用法:
#   bash deploy/setup_litellm_gateway.sh                  # 交互模式
#   bash deploy/setup_litellm_gateway.sh --ip 192.168.x.x
#   bash deploy/setup_litellm_gateway.sh --ip 100.x.x.x --key sk-my-key
#   bash deploy/setup_litellm_gateway.sh --tailscale      # 使用 Tailscale IP
#   bash deploy/setup_litellm_gateway.sh --dry-run        # 仅预览，不修改
#   bash deploy/setup_litellm_gateway.sh --unset          # 移除配置
# =============================================================================

set -euo pipefail

# ── 默认值 ────────────────────────────────────────────────────────────────────
DEFAULT_LAN_IP="xxx.xxx.xxx.xxx"
DEFAULT_TAILSCALE_IP="xxx.xxx.xxx.xxx"
DEFAULT_PORT="4000"
DEFAULT_API_KEY="YOUR_LITELLM_API_KEY"
PROVIDER_NAME="macstudio"

CRUSH_GLOBAL_CONFIG="${HOME}/.config/crush/crush.json"
ZSHRC="${HOME}/.zshrc"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# ── 颜色输出 ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

info()    { echo -e "${BLUE}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[OK]${NC}   $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $*"; }
error()   { echo -e "${RED}[ERR]${NC}  $*" >&2; }
header()  { echo -e "\n${BOLD}${CYAN}$*${NC}"; }

# ── 参数解析 ──────────────────────────────────────────────────────────────────
GATEWAY_IP=""
GATEWAY_PORT="${DEFAULT_PORT}"
API_KEY=""
DRY_RUN=false
UNSET_MODE=false
USE_TAILSCALE=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --ip)        GATEWAY_IP="$2";   shift 2 ;;
    --port)      GATEWAY_PORT="$2"; shift 2 ;;
    --key)       API_KEY="$2";      shift 2 ;;
    --tailscale) USE_TAILSCALE=true; shift ;;
    --dry-run)   DRY_RUN=true;      shift ;;
    --unset)     UNSET_MODE=true;   shift ;;
    -h|--help)
      echo "用法: bash deploy/setup_litellm_gateway.sh [选项]"
      echo ""
      echo "选项:"
      echo "  --ip <IP>       网关 IP 地址（默认: ${DEFAULT_LAN_IP}）"
      echo "  --port <PORT>   网关端口（默认: ${DEFAULT_PORT}）"
      echo "  --key <KEY>     API Key（默认: ${DEFAULT_API_KEY}）"
      echo "  --tailscale     使用 Tailscale IP（需通过 --ip 指定实际地址）"
      echo "  --dry-run       预览模式，不修改任何文件"
      echo "  --unset         移除 LiteLLM 网关配置"
      echo "  -h, --help      显示此帮助"
      exit 0
      ;;
    *) error "未知参数: $1"; exit 1 ;;
  esac
done

# ── 确定最终 IP ───────────────────────────────────────────────────────────────
if [[ -z "$GATEWAY_IP" ]]; then
  if [[ "$USE_TAILSCALE" == true ]]; then
    GATEWAY_IP="$DEFAULT_TAILSCALE_IP"
  else
    GATEWAY_IP="$DEFAULT_LAN_IP"
  fi
fi

GATEWAY_BASE_URL="http://${GATEWAY_IP}:${GATEWAY_PORT}/v1"
ANTHROPIC_PROXY_URL="http://${GATEWAY_IP}:${GATEWAY_PORT}/anthropic"

# ── 移除模式 ──────────────────────────────────────────────────────────────────
if [[ "$UNSET_MODE" == true ]]; then
  header "移除 LiteLLM 网关配置"

  # 移除 ~/.zshrc 中的配置块
  if grep -q "LiteLLM Gateway" "${ZSHRC}" 2>/dev/null; then
    if [[ "$DRY_RUN" == false ]]; then
      cp "${ZSHRC}" "${ZSHRC}.bak_litellm_${TIMESTAMP}"
      sed -i '' '/# === LiteLLM Gateway/,/# === END LiteLLM Gateway ===/d' "${ZSHRC}"
    fi
    success "已从 ~/.zshrc 移除 LiteLLM 配置块${DRY_RUN:+ (dry-run)}"
  else
    warn "~/.zshrc 中未找到 LiteLLM 配置块"
  fi

  # 从 crush 全局配置移除 provider
  if [[ -f "$CRUSH_GLOBAL_CONFIG" ]] && python3 -c "
import json, sys
data = json.load(open('${CRUSH_GLOBAL_CONFIG}'))
providers = data.get('providers', {})
if '${PROVIDER_NAME}' in providers:
    sys.exit(0)
sys.exit(1)
" 2>/dev/null; then
    if [[ "$DRY_RUN" == false ]]; then
      cp "${CRUSH_GLOBAL_CONFIG}" "${CRUSH_GLOBAL_CONFIG}.bak_${TIMESTAMP}"
      python3 - <<PYEOF
import json
path = '${CRUSH_GLOBAL_CONFIG}'
data = json.load(open(path))
data.get('providers', {}).pop('${PROVIDER_NAME}', None)
if data.get('default_provider') == '${PROVIDER_NAME}':
    data.pop('default_provider', None)
json.dump(data, open(path, 'w'), indent=2, ensure_ascii=False)
print('  已从 crush.json 移除 ${PROVIDER_NAME} provider')
PYEOF
    fi
    success "已从 Crush 全局配置移除 ${PROVIDER_NAME} provider${DRY_RUN:+ (dry-run)}"
  else
    warn "Crush 全局配置中未找到 ${PROVIDER_NAME} provider"
  fi

  echo ""
  success "配置已移除。重新加载 shell: source ~/.zshrc"
  exit 0
fi

# ── 交互式确认 IP ─────────────────────────────────────────────────────────────
header "Crush → LiteLLM 网关配置"
echo ""
echo "  网关地址 : ${BOLD}${GATEWAY_BASE_URL}${NC}"
echo "  API Key  : ${BOLD}${API_KEY:-（稍后输入）}${NC}"
echo "  Dry-run  : ${DRY_RUN}"
echo ""

# 如未指定 API_KEY，使用默认值
if [[ -z "$API_KEY" ]]; then
  API_KEY="$DEFAULT_API_KEY"
  info "使用默认 API Key: ${API_KEY}"
fi

# ── 连通性测试 ────────────────────────────────────────────────────────────────
header "1. 测试网关连通性"

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" \
  --connect-timeout 5 \
  -H "Authorization: Bearer ${API_KEY}" \
  "http://${GATEWAY_IP}:${GATEWAY_PORT}/health" 2>/dev/null || echo "000")

if [[ "$HTTP_CODE" == "200" ]]; then
  success "网关可达 (HTTP ${HTTP_CODE}): http://${GATEWAY_IP}:${GATEWAY_PORT}"
else
  warn "网关返回 HTTP ${HTTP_CODE} — 请确认:"
  warn "  1. Mac Studio (${GATEWAY_IP}) 已开机且在同一网络"
  warn "  2. LiteLLM 服务已启动 (默认端口 ${GATEWAY_PORT})"
  warn "  3. 如不在同一局域网，请使用 --tailscale 参数"
  echo ""
  read -r -p "继续配置（y/N）？ " CONFIRM
  [[ "${CONFIRM,,}" == "y" ]] || { info "已取消"; exit 0; }
fi

# ── 备份函数 ──────────────────────────────────────────────────────────────────
backup_file() {
  local file="$1"
  if [[ -f "$file" ]]; then
    local backup="${file}.bak_litellm_${TIMESTAMP}"
    cp "$file" "$backup"
    info "已备份: ${backup}"
  fi
}

# ── 配置 ~/.config/crush/crush.json ──────────────────────────────────────────
header "2. 配置 Crush 全局 Provider"

mkdir -p "$(dirname "${CRUSH_GLOBAL_CONFIG}")"

if [[ "$DRY_RUN" == false ]]; then
  backup_file "${CRUSH_GLOBAL_CONFIG}"
fi

# 读取现有配置或创建新的
EXISTING_CRUSH="{}"
if [[ -f "${CRUSH_GLOBAL_CONFIG}" ]]; then
  EXISTING_CRUSH=$(cat "${CRUSH_GLOBAL_CONFIG}")
fi

NEW_CRUSH=$(python3 - <<PYEOF
import json, sys

existing = json.loads('''${EXISTING_CRUSH}'''.strip() or '{}')

# 注入/覆盖 provider
providers = existing.setdefault('providers', {})
providers['${PROVIDER_NAME}'] = {
    "type": "openai-compat",
    "base_url": "${GATEWAY_BASE_URL}",
    "api_key": "${API_KEY}",
    "name": "Mac Studio LLM Gateway (${GATEWAY_IP})"
}

# 设置默认 provider（若未设置或已是本 provider）
if existing.get('default_provider', '${PROVIDER_NAME}') == '${PROVIDER_NAME}':
    existing['default_provider'] = '${PROVIDER_NAME}'

print(json.dumps(existing, indent=2, ensure_ascii=False))
PYEOF
)

echo ""
echo "将写入 ${CRUSH_GLOBAL_CONFIG}:"
echo "${NEW_CRUSH}" | sed 's/^/  /'

if [[ "$DRY_RUN" == false ]]; then
  echo "${NEW_CRUSH}" > "${CRUSH_GLOBAL_CONFIG}"
  success "已更新: ${CRUSH_GLOBAL_CONFIG}"
else
  info "Dry-run: 跳过写入"
fi

# ── 配置 ~/.zshrc 环境变量 ────────────────────────────────────────────────────
header "3. 配置环境变量 (~/.zshrc)"

ZSHRC_BLOCK=$(cat <<ENVBLOCK

# === LiteLLM Gateway (由 crush-best-practices 配置 @ ${TIMESTAMP}) ===
export LITELLM_GATEWAY_IP="${GATEWAY_IP}"
export LITELLM_GATEWAY_PORT="${GATEWAY_PORT}"
export LITELLM_GATEWAY_URL="http://${GATEWAY_IP}:${GATEWAY_PORT}/v1"
export OPENAI_API_KEY="${API_KEY}"
export OPENAI_BASE_URL="http://${GATEWAY_IP}:${GATEWAY_PORT}/v1"
# Claude Code pass-through (记录 Token 用量，OAuth 登录不受影响)
export ANTHROPIC_BASE_URL="${ANTHROPIC_PROXY_URL}"
# === END LiteLLM Gateway ===
ENVBLOCK
)

if grep -q "LiteLLM Gateway" "${ZSHRC}" 2>/dev/null; then
  warn "~/.zshrc 中已存在 LiteLLM Gateway 配置块，跳过追加"
  warn "如需更新，请先运行: bash deploy/setup_litellm_gateway.sh --unset"
else
  echo ""
  echo "将追加到 ${ZSHRC}:"
  echo "${ZSHRC_BLOCK}" | sed 's/^/  /'

  if [[ "$DRY_RUN" == false ]]; then
    backup_file "${ZSHRC}"
    echo "${ZSHRC_BLOCK}" >> "${ZSHRC}"
    success "已更新: ${ZSHRC}"
  else
    info "Dry-run: 跳过写入"
  fi
fi

# ── 可用模型列表 ──────────────────────────────────────────────────────────────
header "4. 查询可用模型"

if [[ "$HTTP_CODE" == "200" ]]; then
  MODEL_LIST=$(curl -s \
    -H "Authorization: Bearer ${API_KEY}" \
    "http://${GATEWAY_IP}:${GATEWAY_PORT}/v1/models" 2>/dev/null \
    | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    models = sorted(m['id'] for m in data.get('data', []))
    for m in models:
        print(f'    {m}')
except:
    print('    (解析失败，请手动查询)')
" 2>/dev/null || echo "    (查询失败)")

  echo "网关当前可用模型:"
  echo "${MODEL_LIST}"
else
  warn "网关未连通，跳过模型列表查询"
fi

# ── 完成摘要 ──────────────────────────────────────────────────────────────────
header "配置完成"
echo ""
echo "  网关地址 : ${GATEWAY_BASE_URL}"
echo "  API Key  : ${API_KEY}"
echo ""
echo -e "${BOLD}后续步骤:${NC}"
echo ""
echo "  1. 重新加载 shell 环境变量:"
echo "     ${CYAN}source ~/.zshrc${NC}"
echo ""
echo "  2. 验证 Crush provider 配置:"
echo "     ${CYAN}cat ~/.config/crush/crush.json${NC}"
echo ""
echo "  3. 使用角色别名（在 Crush 或直接 curl 中）:"
echo "     code-gen    → Qwen3-Coder-Next (MLX 本地)"
echo "     code-review → Qwen2.5-Coder-32B (MLX 本地)"
echo "     pdm         → Qwen3-Coder-480B (SiliconFlow 云端)"
echo "     qa          → Qwen2.5-Coder-32B (MLX 本地)"
echo ""
echo "  4. 管理面板:"
echo "     ${CYAN}open http://${GATEWAY_IP}:${GATEWAY_PORT}/ui${NC}"
echo ""
echo "  5. 移除配置:"
echo "     ${CYAN}bash deploy/setup_litellm_gateway.sh --unset${NC}"
echo ""
if [[ "$DRY_RUN" == true ]]; then
  warn "以上为 DRY-RUN 预览，未修改任何文件"
fi
