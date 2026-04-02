# Changelog

## 2026-04-01（v2.1 — 质量收紧）

本版本根据六维质量分析（触发性 6→8、完整性 7→8、安全/抗漂移 8→9）对 V2 进行精准修复，不改变整体架构。

### Changed

- **[SKILL.md](./SKILL.md) — frontmatter 改为纯触发语言**
  - 原描述混合了"是什么"和"怎么用"，对模型做技能选择不够友好
  - 改为 "Use when..." 格式，中英双语触发，覆盖中文请求场景

- **[SKILL.md](./SKILL.md) — 新增 Done Gate（完成门）**
  - 路由器之前没有显式的退出条件，可能导致长任务中总控层持续干预
  - 增加 3 条完成条件：preamble 已输出 + 确认已解决 + 交接已完成
  - 满足所有条件后本 skill 退出，不再干预下游执行

- **[references/escalation-matrix.md](./references/escalation-matrix.md) — Must Confirm 不可绕过**
  - 原文档未明确用户说"直接做"时是否可跳过硬确认
  - 新增"Must Confirm 不可绕过"段落，删除/强推/凭证/批量修改等操作无论用户催促都必须确认

- **[references/environment-laws.md](./references/environment-laws.md) — 例外条款收紧**
  - 原"用户明确要求直接做时可跳过部分确认"与 escalation-matrix 存在矛盾
  - 收紧为：例外仅作用于"通常确认"项，不影响 Must Confirm 项

- **[references/formations.md](./references/formations.md) — 五阵型增加执行前检查清单**
  - 五个阵型（观机/破局/明鉴/立言/行令）各补充 4-5 条 `[ ]` 格式 pre-flight checklist
  - 进入阵型时可用于快速自检当前姿态是否正确

### Outcome

综合评分从 7.7 提升至约 8.3/10。

| 维度 | v2.0 | v2.1 |
|---|---|---|
| 触发性 | 6 | 8 |
| 可执行性 | 8 | 8 |
| 完整性 | 7 | 8 |
| 组合性 | 9 | 9 |
| 渐进披露 | 8 | 8 |
| 安全/抗漂移 | 8 | 9 |

### Next Candidates

- 真实安装测试（OpenClaw / Claude Code）
- 根据真实使用反馈迭代触发语言和 Done Gate 条件

---

## 2026-04-01（v2.0 — 可执行合同）

本版本将 `agent-work-environment` 从“治理宣言”收敛为“可执行合同”。

### Changed

- 重写 [SKILL.md](./SKILL.md)，明确：
  - 什么时候使用
  - 什么时候不该使用
  - 它是总控治理 skill，不是执行 skill
  - 输入合同与输出合同
  - session preamble 输出格式
  - 下游 handoff 关系

- 重写 [references/formations.md](./references/formations.md)，为五阵型补齐：
  - 最小完成标准
  - 交付格式
  - 场景示例

- 重写 [references/environment-laws.md](./references/environment-laws.md)，为五条法则补齐：
  - 执行前检查项
  - 更明确的升级条件
  - 更接近操作手册的表达方式

- 重写 [references/escalation-matrix.md](./references/escalation-matrix.md)，新增：
  - 连续失败升级规则
  - Failure Escalation Template

- 重写 [references/formation-law-mapping.md](./references/formation-law-mapping.md)，从解释性文本改为：
  - 使用方法
  - 快速决策规则
  - 阵型速查
  - 常见路由示例

- 新增 [README.md](./README.md)，便于独立分发和陌生用户理解

### Outcome

这次重构后的定位是：

- `session preamble`
- `mode router`
- `总控治理 skill`

而不是：

- 编码 skill
- review skill
- 文档 skill
- 运维保护 skill

### Current Status

当前版本已经具备：

- 顶层合同
- 阵型完成标准
- 场景示例
- 法则检查项
- 风险升级模板
- 阵型与法则速查
- 独立分发说明

### Next Candidates

后续适合继续增强的方向：

- 增加与 `Code / review / careful / guard` 的组合调用模板
- 补更多真实用户输入到输出的 examples
- 如果未来有 runtime 支持，再考虑半强制 hook 机制
