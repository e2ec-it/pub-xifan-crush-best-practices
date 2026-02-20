# Crush + Everything Claude Code (ECC) 統合パック v4.0

**言語：** [English](README.md) | [简体中文](README_zh-CN.md) | [繁體中文](README_zh-HK.md) | [한국어](README_ko-KR.md)

このパックは、**affaan-m/everything-claude-code** のコアコンセプト（agents/skills/rules/hooks/MCP設定）を **Crush 対応**のセットアップに適用したものです。

Crush と Claude Code では拡張フォーマットが異なるため、このパックは Crush が現在直接利用できる部分に焦点を当てています：
- **プロジェクトレベルの `.crush.json` システムガード + コンテキストルール**（マージ方式、非破壊的）
- **Crush スキル**（厳選した ECC スキルを `~/.config/crush/skills/<name>/SKILL.md` に変換）
- **スニペット**（オプションのプロジェクトドキュメント `AGENTS.md`、`CONVENTIONS.md` としてコピー可能）

## 含まれるもの

### A) プロジェクトレベルの `.crush.json` 強化（安全なマージ）
- ツールホワイトリスト + ハルシネーション防止（`tool not found: read` エラーを防止）
- コンテキスト最適化チェックリスト（コンパクト、高品質）
- オプションの「ワークフローモード」（plan / build / review）

### B) グローバル Crush スキル（ECC コンセプトから厳選）
Crush スキルディレクトリ（デフォルト `~/.config/crush/skills`）にインストール：
- `ecc-planner`（実装計画テンプレート）
- `ecc-tdd`（TDD ワークフロー + テストファーストチェックリスト）
- `ecc-code-review`（品質ゲート、スタイル、基本的なセキュリティチェック）
- `ecc-security-review`（OWASP 準拠のセキュリティチェック + 依存関係チェック）
- `ecc-deployment`（CI/CD、ロールバック、ヘルスチェック、リリースチェックリスト）
- `ecc-docker`（docker compose パターン、ネットワーク、ボリューム、セキュリティ）
- `ecc-api-design`（REST ページネーション/エラー処理/冪等性）
- `ecc-cost-aware-llm`（予算ルーティング、コストログ、トークン管理）

> これらのスキルは意図的にコンパクトに設計されています。上流リポジトリは膨大ですが、このパックは Crush のワークフローに適合する部分に絞っています。

### C) オプションスニペット（自動編集なし）
- `.snippets/AGENTS.md.snippet.md`
- `.snippets/CONVENTIONS.md.snippet.md`

## クイックスタート

### Make を使う（推奨）

```bash
make install            # コア ECC スキルとルールをインストール
make install-guard      # ECC + ツールガード（推奨）
make install-full       # ECC + ガード + Superpowers + 共通 MCP
make dry-run            # プレビューのみ、変更なし
make uninstall          # 安全なアンインストール（バックアップあり）
```

### スクリプトを直接実行

`deploy/` 配下のスクリプトは番号付きプレフィックスで並び順がわかりやすい：

```bash
# コアインストール（リポジトリルートを自動検出）
bash deploy/client-run-001-install.sh --ecc
bash deploy/client-run-001-install.sh --ecc --tool-guard
bash deploy/client-run-001-install.sh --ecc --tool-guard --dry-run

# アンインストール
bash deploy/client-run-002-uninstall.sh
```

アンインストールは、このパックが追加した特定のキー/スキルのみを削除します（事前にバックアップが作成されます）。

---

## 上流 ECC についての注記
- 上流リポジトリ：https://github.com/affaan-m/everything-claude-code（MIT ライセンス）
- このパックは上流の完全なコピーでは**なく**、Crush 向けに適応させたバージョンです。

---

## v4.1：オプション MCP インストール（ECC mcp-configs → Crush MCP）

このパックには、Everything Claude Code の `mcp-configs/mcp-servers.json` を Crush の `.crush.json` の `mcp` セクション向けに移植した厳選バージョンが含まれるようになりました。

インストール例：
```bash
make mcp-common         # github + supabase + vercel + context7 + filesystem
make mcp-github
make list-mcp           # 利用可能な MCP 名を表示

# または直接実行：
bash deploy/client-run-001-install.sh --mcp-github
bash deploy/client-run-001-install.sh --mcp-common
bash deploy/client-run-004-list-mcp.sh
```

非破壊的な動作：
- `.crush.json` に `mcp.<name>` が既に存在する場合、インストーラーは**上書きしません**。
- 変更前に `.crush.json` のバックアップが作成されます。

テンプレート：
- `mcp-configs/ecc-mcp-servers.crush.json`

---

## v4.2：Superpowers（obra/superpowers）スキル移植 for Crush（オプション）

このパックには、Crush スキルとして適応させた Superpowers コアスキル（MIT ライセンス）の**オプション**移植版が含まれるようになりました：
- sp-brainstorming（ブレインストーミング）
- sp-git-worktrees（Git ワークツリー）
- sp-writing-plans（計画作成）
- sp-tdd（テスト駆動開発）
- sp-subagent-dev（サブエージェント開発）
- sp-executing-plans（計画実行）
- sp-request-code-review（コードレビュー依頼）
- sp-finish-branch（ブランチ完了）

インストール：
```bash
make install-superpowers

# または直接実行：
bash deploy/client-run-001-install.sh --superpowers
```

組み合わせインストール：
```bash
make install-full

# または直接実行：
bash deploy/client-run-001-install.sh --ecc --tool-guard --superpowers --mcp-common
```

帰属表示：`superpowers/ATTRIBUTION.md` を参照してください。
