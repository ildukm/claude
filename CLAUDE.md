# AI Agent Guidelines

## 목차

- [코딩 가이드라인](#코딩-가이드라인)
  - [Think Before Coding](#1-think-before-coding)
  - [Simplicity First](#2-simplicity-first)
  - [Surgical Changes](#3-surgical-changes)
  - [Goal-Driven Execution](#4-goal-driven-execution)
- [Git 작업](#git-작업)
- [Atlassian 작업](#atlassian-작업)
  - [이슈 생성](#이슈-생성)
  - [Epic 참조](#epic-참조)
- [MySQL 작업](#mysql-작업)
  - [큰 테이블 스키마 변경](#큰-테이블-스키마-변경)
- [Kubernetes 작업](#kubernetes-작업)
  - [Context 선택](#context-선택)
  - [kubectl 명령어 순서](#kubectl-명령어-순서)
- [약어 및 용어](#약어-및-용어)

## 코딩 가이드라인

### 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:

- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

### 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

### 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:

- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:

- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

### 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:

- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:

```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

## Git 작업

- git 명령어 실행 시 `git -C <path>` 대신 `git ...` 형태를 사용할 것
  - 이유: `git -C` 를 사용하면 `Bash(git fetch:*)` 같은 권한 패턴에 매칭되지 않음
- **main, master 브랜치에는 절대 commit, push 금지**
  - 예외: haullabot repo
- git commit, push 할 때 항상 `git-workflow:commit-and-push` skill을 사용할 것
- `git-workflow:commit-and-push` skill을 이용해서 작업 푸시 뒤 PR을 생성할건지 물어볼 것
- PR 생성 요청 시 `git-workflow:create-pull-request` skill을 사용할 것
  - PR status: draft

## Atlassian 작업

### 이슈 생성

- Jira 이슈 생성 시 항상 `atlassian:create-jira-issue` skill을 사용할 것
  - 프로젝트: SW
  - 이슈 타입: Task
  - parent epic이 있는 경우: epic을 본문에 포함시키지 말고 parent 링크로만 설정할 것

### Epic 참조

- AM 대시보드 2026: [SW-12105](https://ecubelabs.atlassian.net/browse/SW-12105)
- 백오피스 2026: [SW-12101](https://ecubelabs.atlassian.net/browse/SW-12101)
- 스카이넷 2026: [SW-12154](https://ecubelabs.atlassian.net/browse/SW-12154)
- 공홈 2026: [SW-12199](https://ecubelabs.atlassian.net/browse/SW-12199)
- 하울러웹 2026: [SW-12238](https://ecubelabs.atlassian.net/browse/SW-12238)

## MySQL 작업

### 큰 테이블 스키마 변경

- 큰 테이블에 대한 스키마 변경 작업은 percona-toolkit의 `pt-online-schema-change`를 사용할 것

#### 컬럼 추가 예시

```bash
finch run --rm -it percona-toolkit:local pt-online-schema-change \
--alter "ADD COLUMN shouldFollowUp TINYINT(1) NOT NULL" \
--chunk-index=PRIMARY \
--chunk-time=1 \
--alter-foreign-keys-method=auto \
--no-drop-old-table \
--execute --ask-pass \
D=call,t=transcript,h=host.finch.internal,u=administrator,P=3307
```

#### 인덱스 추가 예시

```bash
finch run --rm -it percona-toolkit:local pt-online-schema-change \
--alter "ADD INDEX IX_scheduled_job_status_scheduledAt (status, scheduledAt)" \
--chunk-index=PRIMARY \
--chunk-time=1 \
--alter-foreign-keys-method=auto \
--no-drop-old-table \
--execute --ask-pass \
D=tycoon,t=scheduled_job,h=host.finch.internal,u=administrator,P=3307
```

## Kubernetes 작업

### Context 선택

- kubectl로 작업 시작하기 전에 항상 어떤 context를 사용할지 물어볼 것
  - stage: `ecubelabs2-stage.k8s.local`
  - production: `ecubelabs2.k8s.local`

### kubectl 명령어 순서

- kubectl 명령어 사용 시 `-n` (namespace) 플래그는 서브커맨드 뒤에 위치해야 함
- 이유: Claude 권한 설정이 `kubectl --context=... get:*` 패턴으로 되어 있어 context 바로 뒤에 서브커맨드가 와야 매칭됨

```bash
# Bad - 권한 패턴에 매칭되지 않음
kubectl --context=$CONTEXT -n monitoring get configmap filebeat-config

# Good - 권한 패턴에 매칭됨
kubectl --context=$CONTEXT get configmap filebeat-config -n monitoring
```

## 약어 및 용어

- 일반적으로 통용되는 약어가 아닌 경우 회사 내부 약어일 수 있음
- 이런 경우 `knowledge-base` MCP를 사용하여 의미를 확인할 것
