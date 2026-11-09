#!/usr/bin/env bash

set -euo pipefail

TARGET_DIR="${1:-.}"
TARGET_DIR="${TARGET_DIR%/}"

README_PATH="${TARGET_DIR}/README.md"
AGENTS_PATH="${TARGET_DIR}/AGENTS.md"
MARKER_BEGIN="<!-- agentic-project-guidelines:begin -->"
MARKER_END="<!-- agentic-project-guidelines:end -->"
SKILL_REPO_URL="https://github.com/CloudCCAI/agentic-project-guidelines"

README_BLOCK=$(cat <<EOF
${MARKER_BEGIN}
## AI Development Protocol

This project follows the \`agentic-project-guidelines\` skill.

- All AI agents must automatically use this skill before project analysis, planning, implementation, testing, or maintenance.
- If the current agent does not have this skill installed, install it first from GitHub: ${SKILL_REPO_URL}
- Read and follow the project-root \`AGENTS.md\` before working on the project.

本项目遵循 \`agentic-project-guidelines\` 技能规范。

- 所有 AI 智能体在进行项目分析、规划、编码、测试和维护前，必须自动使用此技能。
- 如果当前智能体尚未安装此技能，必须先从 GitHub 安装：${SKILL_REPO_URL}
- 开始项目工作前，必须读取并遵守根目录的 \`AGENTS.md\`。
${MARKER_END}
EOF
)

AGENTS_BLOCK=$(cat <<EOF
${MARKER_BEGIN}
## Required Skill

- This project follows the \`agentic-project-guidelines\` skill.
- Every AI agent must automatically load and use this skill before any project work.
- If the skill is not installed in the current environment, install it first from GitHub: ${SKILL_REPO_URL}
- After the skill is available, follow its greenfield or brownfield workflow to maintain \`README.md\`, \`AGENTS.md\`, \`.claw/\` or \`.ai-dev/\`, and \`docs/specs/\`.

## 必须遵守

- 本项目遵循 \`agentic-project-guidelines\` 技能。
- 所有 AI 智能体在开始任何项目工作前，都必须自动加载并使用此技能。
- 如果当前环境尚未安装该技能，必须先从 GitHub 安装：${SKILL_REPO_URL}
- 技能可用后，必须按技能中的 Greenfield 或 Brownfield 流程维护 \`README.md\`、\`AGENTS.md\`、\`.claw/\` 或 \`.ai-dev/\` 以及 \`docs/specs/\`。
${MARKER_END}
EOF
)

write_with_block() {
  local path="$1"
  local prelude="$2"
  local block="$3"
  local tmp_path
  tmp_path="$(mktemp)"

  if [[ -f "${path}" ]]; then
    GUIDANCE_BLOCK="${block}" awk -v begin="${MARKER_BEGIN}" -v end="${MARKER_END}" '
      index($0, begin) { if (!found) print ENVIRON["GUIDANCE_BLOCK"]; found = skip = 1; next }
      skip && index($0, end) { skip = 0; next }
      !skip { print }
      END { if (!found) { if (NR) print ""; print ENVIRON["GUIDANCE_BLOCK"] } }
    ' "${path}" > "${tmp_path}"
  else
    if [[ -n "${prelude}" ]]; then
      printf "%s\n\n%s\n" "${prelude}" "${block}" > "${tmp_path}"
    else
      printf "%s\n" "${block}" > "${tmp_path}"
    fi
  fi

  if cmp -s "${tmp_path}" "${path}"; then
    rm "${tmp_path}"
    return
  fi
  mv "${tmp_path}" "${path}"
  echo "Updated: ${path}"
}

mkdir -p "${TARGET_DIR}"

AGENTS_PRELUDE="# AGENTS"
CLAUDE_PATH=""
for candidate in "${TARGET_DIR}"/[Cc][Ll][Aa][Uu][Dd][Ee].md; do
  if [[ -f "${candidate}" ]]; then
    CLAUDE_PATH="${candidate}"
    break
  fi
done

if [[ ! -f "${AGENTS_PATH}" && -n "${CLAUDE_PATH}" ]]; then
  CLAUDE_NAME="${CLAUDE_PATH##*/}"
  AGENTS_PRELUDE+=$(printf '\n\nRead the existing project instructions in [%s](%s) before working.\n\n开始项目工作前，请同时读取 [%s](%s) 中的现有规则。' \
    "${CLAUDE_NAME}" "${CLAUDE_NAME}" "${CLAUDE_NAME}" "${CLAUDE_NAME}")
fi

write_with_block "${README_PATH}" "# $(basename "${TARGET_DIR}")" "${README_BLOCK}"
write_with_block "${AGENTS_PATH}" "${AGENTS_PRELUDE}" "${AGENTS_BLOCK}"

if [[ -n "${CLAUDE_PATH}" && ! -L "${CLAUDE_PATH}" ]] &&
   ! grep -Eq '^@([.]/)?AGENTS[.]md[[:space:]]*$' "${CLAUDE_PATH}"; then
  printf '\n\n@AGENTS.md\n' >> "${CLAUDE_PATH}"
  echo "Updated: ${CLAUDE_PATH}"
fi
