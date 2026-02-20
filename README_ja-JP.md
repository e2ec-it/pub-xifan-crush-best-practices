# Crush + Everything Claude Code (ECC) 統合パック v4.0

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

## ワンクリックインストール

git リポジトリ内の任意の場所から実行（リポジトリルートを自動検出）：

```bash
bash deploy/install.sh --ecc
```

### ツールガードを追加（推奨）
```bash
bash deploy/install.sh --ecc --tool-guard
```

### ドライラン（変更なしでプレビュー）
```bash
bash deploy/install.sh --ecc --tool-guard --dry-run
```

## アンインストール（安全）
```bash
bash deploy/uninstall.sh
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
bash deploy/install.sh --mcp-github
bash deploy/install.sh --mcp-supabase
bash deploy/install.sh --mcp-vercel
bash deploy/install.sh --mcp-common
bash deploy/tools/list_mcp.sh
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
bash deploy/install.sh --superpowers
```

組み合わせインストール：
```bash
bash deploy/install.sh --ecc --tool-guard --superpowers --mcp-common
```

帰属表示：`superpowers/ATTRIBUTION.md` を参照してください。
