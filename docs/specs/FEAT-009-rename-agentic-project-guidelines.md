---
kind: feature-spec
feature_id: FEAT-009
title: Rename skill to agentic-project-guidelines
status: implemented
owner_role: shared
task_ids: TASK-009
related_decisions: ADR-009
related_issues: none
updated_at: 2026-06-11T03:23:18Z
updated_by: codex
---

# FEAT-009 - Rename skill to agentic-project-guidelines

## 背景与目标

- 用户确认将技能改名为 `agentic-project-guidelines`。
- 新名称应表达该技能是面向 AI coding agents 的项目管理与交付治理能力。
- 技能目录、front matter、声明块、校验器、示例和说明文档应统一使用新名称。

## 范围

### In Scope

- 更新 `SKILL.md` 的 `name`、`description`、版本和标题。
- 更新 README、AGENTS、STATE-MODEL、CHANGELOG、示例项目和现有 spec 中的新名称引用。
- 更新 `scripts/ensure-agent-guidance.sh` 和 `scripts/validate-state.py` 中的 marker、技能名与 GitHub 安装地址。
- 将本地技能文件夹改名为 `agentic-project-guidelines`。
- 更新 `.claw` 状态、任务、ADR 和测试记录。

### Out Of Scope

- 不重新引入多人协作、身份校验或任务授权门禁。
- 不修改 `.claw` 和 `docs/specs` 的文件模型。
- 不发布远端 GitHub 仓库或创建 release。

## 方案设计

- 将技能版本提升到 `3.10.0`，把本次变更定义为命名和定位更新。
- 保留 3.9.0 的轻量状态/spec 协议能力面。
- 把技能描述从泛化的状态协议调整为“project management and delivery governance for AI coding agents”。
- 使用 `agentic-project-guidelines` 作为项目级声明 marker，避免新旧声明块混淆。
- 校验器只接受新名称和新 GitHub URL，推动下游项目迁移声明块。

## 接口与数据影响

- `SKILL.md` front matter 的 `name` 从旧名改为 `agentic-project-guidelines`。
- README/AGENTS 受控声明块 marker 改为 `<!-- agentic-project-guidelines:begin -->` 和 `<!-- agentic-project-guidelines:end -->`。
- GitHub 安装源改为 `https://github.com/CloudCCAI/agentic-project-guidelines`。
- 本地目录改为 `/Volumes/AISpace/AI/y-skills/agentic-project-guidelines`。

## 验收标准

- `SKILL.md` front matter 显示 `name: agentic-project-guidelines` 和 `skill_version: 3.10.0`。
- 全仓库不再包含旧技能名、旧 GitHub URL 或旧本地目录名的活动引用。
- `python3 scripts/validate-state.py .claw` 通过。
- `PYTHONPYCACHEPREFIX=/private/tmp/agentic-project-guidelines-pycache python3 -m py_compile scripts/validate-state.py` 通过。
- 临时项目初始化后，README/AGENTS 声明块使用新名称并能通过校验。

## 风险与回滚

- 风险：外部项目仍声明旧技能名时，新校验器会提示失败，需要重新运行 `scripts/ensure-agent-guidance.sh`。
- 风险：远端 GitHub 仓库若尚未同步改名，安装链接会先于远端状态变化。
- 回滚：恢复旧技能名、旧 marker、旧 URL 和旧目录名，并回退版本说明。

## 实现进展

- 当前状态：已实现，待 review。
- 已完成项：核心协议、README、AGENTS、状态模型、脚本、校验器、示例、CHANGELOG、spec 和状态文件已更新。
- 未完成项：远端仓库是否改名或发布 release 待人工确认。

## 交接说明

- 下一位接手者先看 `SKILL.md`、`scripts/ensure-agent-guidance.sh`、`scripts/validate-state.py` 和本 spec。
- 若要发布，先确认 GitHub 仓库已经改名为 `CloudCCAI/agentic-project-guidelines`。
