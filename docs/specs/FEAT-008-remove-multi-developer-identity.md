---
kind: feature-spec
feature_id: FEAT-008
title: Remove multi-developer coordination and identity gates
status: implemented
owner_role: shared
task_ids: TASK-008
related_decisions: ADR-008
related_issues: none
updated_at: 2026-06-04T23:43:00Z
updated_by: codex
---

# FEAT-008 - Remove multi-developer coordination and identity gates

## 背景与目标

- 用户要求去掉此技能的多人协作模式和开发者身份校验功能。
- 技能应回到轻量的项目状态、任务看板、spec 驱动交付模型。
- 新项目初始化后不应生成开发者身份、任务授权、集成队列、团队状态汇总或身份登录门禁相关文件。

## 范围

### In Scope

- 更新 `SKILL.md`、`README.md`、`STATE-MODEL.md`，删除多人协作模式和身份校验协议。
- 更新 `scripts/init-state.sh`，停止创建身份/授权/团队/集成相关目录和文件。
- 更新 `scripts/validate-state.py`，只校验核心状态文件、任务卡和 spec 引用。
- 删除 `dev-login.py`、`check-assignment.py`、团队汇总脚本、GitHub assignment workflow 示例和并行协作模板。
- 更新 feature spec 模板，删除身份与授权计划、并行与集成计划。
- 更新 `.claw` 当前状态、任务看板、ADR 和测试记录。

### Out Of Scope

- 不引入新的身份认证、权限门禁或团队协作系统。
- 不改项目级 README/AGENTS 技能声明块的基本要求。

## 方案设计

- 将技能版本提升到 `3.9.0`。
- 主协议只保留三类目标：状态外存、显式 AI 开发规则、任务/spec 续接。
- 目录模型只保留 `.claw` 核心八个状态文件和 `docs/specs`。
- 初始化脚本只创建核心状态和 spec 模板。
- 校验器删除对开发者记录、assignment、task status、team status、integration queue 的支持。
- 删除已被移除能力专属的历史 feature spec，避免被误认为当前可用协议。

## 接口与数据影响

- `scripts/dev-login.py`、`scripts/check-assignment.py`、`scripts/summarize-team-status.py` 不再存在。
- `templates/parallel/`、`templates/github-workflows/check-assignment.yml`、`templates/team-status.md`、`templates/integration-queue.md` 不再存在。
- 新项目不会自动创建 `.claw/developers/`、`.claw/assignments/`、`.claw/tasks/`、`.claw/team-status.md` 或 `.claw/integration-queue.md`。

## 验收标准

- `SKILL.md` front matter 显示 `skill_version: 3.9.0`。
- `scripts/init-state.sh` 在临时目录初始化后只创建核心 `.claw` 状态文件和 `docs/specs` 模板。
- `scripts/validate-state.py .claw` 通过。
- Python 语法检查通过。
- 关键词检查确认当前协议、模板和脚本不再提供多人协作和开发者身份校验功能。

## 风险与回滚

- 风险：历史 CHANGELOG 仍会提到被移除的能力；这是版本历史，不代表当前协议。
- 风险：依赖旧门禁脚本的外部项目升级后需要改用自身平台权限或 CI 策略。
- 回滚：恢复 3.8.0 版本文件和脚本。

## 实现进展

- 当前状态：已实现，待 review。
- 已完成项：核心协议、README、状态模型、初始化脚本、校验器、模板、状态文件和 CHANGELOG 已更新；旧脚本与模板已删除；状态校验、语法检查、临时初始化验证和关键词回归检查已完成。
- 未完成项：是否同步安装路径待确认。

## 交接说明

- 下一位接手者先看 `SKILL.md`、`scripts/init-state.sh` 和 `scripts/validate-state.py`，确认实际能力面已经与本 spec 一致。
