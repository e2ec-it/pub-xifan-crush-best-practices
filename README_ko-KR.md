# Crush + Everything Claude Code (ECC) 통합 패키지 v4.0

이 패키지는 **affaan-m/everything-claude-code**의 핵심 개념(agents/skills/rules/hooks/MCP 설정)을 **Crush 친화적** 설정으로 적용한 것입니다.

Crush와 Claude Code는 확장 형식이 다르기 때문에, 이 패키지는 현재 Crush에서 직접 사용할 수 있는 부분에 초점을 맞추고 있습니다：
- **프로젝트 레벨 `.crush.json` 시스템 가드 + 컨텍스트 규칙** (병합 방식, 비파괴적)
- **Crush 스킬** (엄선된 ECC 스킬을 `~/.config/crush/skills/<name>/SKILL.md`로 변환)
- **스니펫**, 선택적 프로젝트 문서(`AGENTS.md`, `CONVENTIONS.md`)로 복사 가능

## 제공되는 것

### A) 프로젝트 레벨 `.crush.json` 강화 (안전한 병합)
- 도구 화이트리스트 + 환각 방지 안내 (`tool not found: read` 오류 방지)
- 컨텍스트 최적화 체크리스트 (간결하고 고품질)
- 선택적 "워크플로우 모드" (plan / build / review)

### B) 글로벌 Crush 스킬 (ECC 개념에서 엄선)
Crush 스킬 디렉토리(기본값 `~/.config/crush/skills`)에 설치：
- `ecc-planner` (구현 계획 템플릿)
- `ecc-tdd` (TDD 워크플로우 + 테스트 우선 체크리스트)
- `ecc-code-review` (품질 게이트, 코드 스타일, 기본 보안 검사)
- `ecc-security-review` (OWASP 준수 보안 검사 + 의존성 검사)
- `ecc-deployment` (CI/CD, 롤백, 헬스 체크, 릴리즈 체크리스트)
- `ecc-docker` (docker compose 패턴, 네트워킹, 볼륨, 보안)
- `ecc-api-design` (REST 페이지네이션/오류처리/멱등성)
- `ecc-cost-aware-llm` (예산 라우팅, 비용 로깅, 토큰 관리)

> 이 스킬들은 의도적으로 간결하게 설계되었습니다. 업스트림 저장소는 방대하지만, 이 패키지는 Crush 워크플로우에 적합한 부분에만 집중합니다.

### C) 선택적 스니펫 (자동 편집 없음)
- `.snippets/AGENTS.md.snippet.md`
- `.snippets/CONVENTIONS.md.snippet.md`

## 원클릭 설치

git 저장소 내 어디서나 실행 (저장소 루트 자동 감지)：

```bash
bash deploy/install.sh --ecc
```

### 도구 가드 추가 (권장)
```bash
bash deploy/install.sh --ecc --tool-guard
```

### 드라이런 (변경 없이 미리보기)
```bash
bash deploy/install.sh --ecc --tool-guard --dry-run
```

## 제거 (안전)
```bash
bash deploy/uninstall.sh
```
제거 시 이 패키지가 추가한 특정 키/스킬만 삭제됩니다 (먼저 백업이 생성됩니다).

---

## 업스트림 ECC 관련 참고사항
- 업스트림 저장소: https://github.com/affaan-m/everything-claude-code (MIT 라이선스)
- 이 패키지는 업스트림의 완전한 복사본이 **아니며**, Crush 향으로 적응된 버전입니다.

---

## v4.1: 선택적 MCP 설치 (ECC mcp-configs → Crush MCP)

이 패키지에는 이제 Everything Claude Code의 `mcp-configs/mcp-servers.json`을 Crush의 `.crush.json` `mcp` 섹션에 맞게 이식한 엄선 버전이 포함됩니다.

설치 예시：
```bash
bash deploy/install.sh --mcp-github
bash deploy/install.sh --mcp-supabase
bash deploy/install.sh --mcp-vercel
bash deploy/install.sh --mcp-common
bash deploy/tools/list_mcp.sh
```

비파괴적 동작：
- `.crush.json`에 `mcp.<name>`이 이미 존재하는 경우, 설치 관리자는 **덮어쓰지 않습니다**.
- 변경 전에 `.crush.json` 백업이 생성됩니다.

템플릿：
- `mcp-configs/ecc-mcp-servers.crush.json`

---

## v4.2: Superpowers (obra/superpowers) 스킬 이식 for Crush (선택 사항)

이 패키지에는 이제 Crush 스킬로 적응된 Superpowers 핵심 스킬(MIT 라이선스)의 **선택적** 이식 버전이 포함됩니다：
- sp-brainstorming (브레인스토밍)
- sp-git-worktrees (Git 워크트리)
- sp-writing-plans (계획 작성)
- sp-tdd (테스트 주도 개발)
- sp-subagent-dev (서브에이전트 개발)
- sp-executing-plans (계획 실행)
- sp-request-code-review (코드 리뷰 요청)
- sp-finish-branch (브랜치 완료)

설치：
```bash
bash deploy/install.sh --superpowers
```

통합 설치：
```bash
bash deploy/install.sh --ecc --tool-guard --superpowers --mcp-common
```

저작권 표시: `superpowers/ATTRIBUTION.md`를 참조하세요.
