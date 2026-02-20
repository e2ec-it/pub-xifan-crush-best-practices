# =============================================================================
# Makefile — Crush + ECC Integration Pack
# 使用 make <target> 执行常用命令
# =============================================================================

SHELL := /usr/bin/env bash
.DEFAULT_GOAL := help

# 脚本路径
INSTALL   := bash deploy/client-run-001-install.sh
UNINSTALL := bash deploy/client-run-002-uninstall.sh
LITELLM   := bash deploy/client-run-003-setup-litellm.sh
LIST_MCP  := bash deploy/client-run-004-list-mcp.sh

# =============================================================================
# 帮助
# =============================================================================
.PHONY: help
help:
	@echo ""
	@echo "Crush + ECC Integration Pack"
	@echo "============================="
	@echo ""
	@echo "安装命令:"
	@echo "  make install            安装核心 ECC 技能和规则"
	@echo "  make install-guard      安装 ECC + 工具守卫（推荐）"
	@echo "  make install-full       完整安装（ECC + 守卫 + Superpowers + MCP）"
	@echo "  make install-superpowers  仅安装 Superpowers 技能"
	@echo "  make dry-run            预览安装内容（不修改文件）"
	@echo ""
	@echo "卸载命令:"
	@echo "  make uninstall          安全卸载（自动备份）"
	@echo ""
	@echo "MCP 服务器:"
	@echo "  make list-mcp           列出所有可用 MCP 服务器"
	@echo "  make mcp-common         安装常用 MCP（github/supabase/vercel/context7/filesystem）"
	@echo "  make mcp-github         安装 GitHub MCP"
	@echo "  make mcp-supabase       安装 Supabase MCP"
	@echo "  make mcp-vercel         安装 Vercel MCP"
	@echo "  make mcp-context7       安装 Context7 MCP（文档检索）"
	@echo ""
	@echo "LiteLLM 网关:"
	@echo "  make setup-litellm      配置连接本地 LiteLLM 网关（交互式）"
	@echo "  make setup-litellm-dry  预览 LiteLLM 网关配置"
	@echo "  make unset-litellm      移除 LiteLLM 网关配置"
	@echo ""

# =============================================================================
# 001 安装
# =============================================================================
.PHONY: install
install:
	$(INSTALL) --ecc

.PHONY: install-guard
install-guard:
	$(INSTALL) --ecc --tool-guard

.PHONY: install-full
install-full:
	$(INSTALL) --ecc --tool-guard --superpowers --mcp-common

.PHONY: install-superpowers
install-superpowers:
	$(INSTALL) --superpowers

.PHONY: dry-run
dry-run:
	$(INSTALL) --ecc --tool-guard --dry-run

# =============================================================================
# 002 卸载
# =============================================================================
.PHONY: uninstall
uninstall:
	$(UNINSTALL)

# =============================================================================
# 004 MCP 服务器管理
# =============================================================================
.PHONY: list-mcp
list-mcp:
	$(LIST_MCP)

.PHONY: mcp-common
mcp-common:
	$(INSTALL) --mcp-common

.PHONY: mcp-github
mcp-github:
	$(INSTALL) --mcp-github

.PHONY: mcp-supabase
mcp-supabase:
	$(INSTALL) --mcp-supabase

.PHONY: mcp-vercel
mcp-vercel:
	$(INSTALL) --mcp-vercel

.PHONY: mcp-context7
mcp-context7:
	$(INSTALL) --mcp-context7

# =============================================================================
# 003 LiteLLM 网关
# =============================================================================
.PHONY: setup-litellm
setup-litellm:
	$(LITELLM)

.PHONY: setup-litellm-dry
setup-litellm-dry:
	$(LITELLM) --dry-run

.PHONY: unset-litellm
unset-litellm:
	$(LITELLM) --unset
