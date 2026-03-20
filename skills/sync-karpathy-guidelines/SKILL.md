---
name: sync-karpathy-guidelines
description: Andrej Karpathy의 CLAUDE.md 코딩 가이드라인을 원격 저장소에서 가져와 로컬 CLAUDE.md와 비교하고, 변경사항이 있으면 업데이트합니다. Use this skill when the user mentions syncing coding guidelines, checking for Karpathy CLAUDE.md updates, updating coding guidelines from GitHub, or wants to ensure their CLAUDE.md is up to date with the upstream source.
disable-model-invocation: true
---

# Karpathy CLAUDE.md 가이드라인 동기화

원격 저장소의 Andrej Karpathy 코딩 가이드라인과 로컬 CLAUDE.md를 비교하여 동기화합니다.

## 원격 소스

- URL: `https://raw.githubusercontent.com/forrestchang/andrej-karpathy-skills/refs/heads/main/CLAUDE.md`

## 로컬 파일

- Path: `/Users/charlie/.claude/CLAUDE.md`
- 로컬 파일은 "코딩 가이드라인" 섹션 외에도 Git, Atlassian, Terraform, MySQL, Kubernetes 등 회사 고유 섹션이 포함되어 있음

## 동기화 절차

### 1단계: 원격 파일 가져오기

WebFetch 도구를 사용하여 원격 CLAUDE.md의 전체 내용을 가져온다.

### 2단계: 로컬 파일 읽기

Read 도구를 사용하여 `/Users/charlie/.claude/CLAUDE.md`를 읽는다.

### 3단계: 코딩 가이드라인 섹션 비교

원격 파일의 핵심 섹션들과 로컬 파일의 "코딩 가이드라인" 하위 섹션들을 비교한다:

- **섹션 매핑**: 원격의 `## 1. Think Before Coding` → 로컬의 `### 1. Think Before Coding` (heading level이 다름에 주의)
- **비교 대상 섹션**:
  1. Think Before Coding
  2. Simplicity First
  3. Surgical Changes
  4. Goal-Driven Execution
- **새로운 섹션**: 원격에 5번 이후 새 섹션이 추가되었는지 확인

### 4단계: 차이점 보고

비교 결과를 사용자에게 보고한다:

- 변경 없음 → "코딩 가이드라인이 최신 상태입니다." 메시지 출력
- 변경 있음 → 각 섹션별로 무엇이 변경되었는지 diff 형태로 보여준다
- 새 섹션 추가 → 어떤 섹션이 새로 추가되었는지 보여준다

### 5단계: 업데이트 적용 (변경사항이 있는 경우)

사용자에게 변경사항을 보여준 후 확인을 받고 적용한다.

업데이트 시 주의사항:
- **코딩 가이드라인 섹션만** 업데이트한다
- Git 작업, Atlassian 작업, Terraform 작업, MySQL 작업, Kubernetes 작업, 약어 및 용어 등 회사 고유 섹션은 절대 수정하지 않는다
- 목차도 필요시 업데이트한다
- 로컬 파일의 heading level 체계를 유지한다 (원격이 `##`이면 로컬에서는 `###`으로 변환)

## 출력 형식

```
## Karpathy CLAUDE.md 동기화 결과

**원격 소스**: [GitHub URL]
**로컬 파일**: /Users/charlie/.claude/CLAUDE.md

### 비교 결과
- [섹션명]: 변경 없음 / 변경 있음 (상세 diff)
- [새 섹션]: 추가됨

### 적용 여부
- [변경 없음이면] 이미 최신 상태입니다.
- [변경 있음이면] 변경사항을 적용했습니다. / 사용자가 취소했습니다.
```
