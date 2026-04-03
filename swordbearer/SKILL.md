---
name: swordbearer
description: >
  Use when a task involves a high-risk, irreversible, or broadly destructive action and a final authorization decision is needed before proceeding.
  Use after governance has already identified escalation, hard confirmation, or repeated failure pressure.
  Use when asked to approve deployment, deletion, credential changes, force-push, production config changes, or any action where deterrence and explicit justification matter.

  适用场景：当任务包含高风险、不可逆、或影响范围广的操作，且在继续前需要最终授权判断时使用。
  适用于治理层已经识别出必须确认、风险升级、或连续失败压力的场景。
  例如：生产部署、删除数据、修改凭证、强推分支、生产配置变更等。
  不适用：普通代码修改、低风险文档编写、已明确安全的只读分析。
---

# Swordbearer — 执剑人

> 执剑人的力量不在于开火，而在于让系统知道何时必须停下。

## What It Is

本 skill 是 **高危操作的最终授权层**。

它不负责识别所有风险，也不负责执行动作。它只在风险已经被识别后，回答一个更关键的问题：

**这一步现在是否应该被允许继续？**

## What It Is Not

- 不是治理层本身（`environment-governance` 负责识别风险和法则偏置）
- 不是任务路由器（`agent-work-environment-v3` 负责选阵型）
- 不是执行 skill（不直接部署、不直接删除、不直接修改凭证）
- 不是普通 review（不审实现质量，而审是否该推进）

## Role

本 skill 只负责四件事：

1. 汇总当前高危动作的理由、影响和替代方案
2. 判断是否具备继续推进的条件
3. 输出授权结论：允许 / 暂缓 / 拒绝 / 先补信息
4. 在必要时要求先回到治理层、诊断层或替代路径

## Trigger Conditions

优先在以下情况调用：

- 已识别为高风险动作
- 存在不可逆后果
- 影响范围超出当前模块/当前环境
- 连续失败后仍计划执行高危动作
- 用户在催促推进，但上下文尚未充分说明

## Input Contract

| 输入 | 含义 |
|---|---|
| `proposed_action` | 即将执行的高危动作 |
| `risk_source` | 风险来自哪里 |
| `impact_scope` | 影响哪些系统、数据、用户或环境 |
| `rollback_plan` | 是否有回滚方案，若有则如何回滚 |
| `alternatives_considered` | 是否考虑过更安全的替代方案 |
| `failure_context` | 是否存在连续失败或证据不足背景 |

如果输入不完整，本 skill 的默认行为不是乐观放行，而是要求补充说明。

## Output Contract

| 输出 | 含义 |
|---|---|
| `authorization_status` | `allow` / `pause` / `deny` / `needs_more_context` |
| `decision_reason` | 为什么做出该结论 |
| `required_clarifications` | 如需补充，必须补什么 |
| `recommended_next_skill` | 建议回到哪个 skill 继续 |
| `deterrence_summary` | 一句话威慑式总结 |

## Authorization Workflow

按以下顺序工作：

1. 确认当前动作是否真的属于高危范围
2. 阅读风险来源与影响范围
3. 判断是否存在明确回滚路径
4. 判断是否有更安全替代方案
5. 判断是否已有连续失败或证据不足问题
6. 输出授权结论

## Decision Rules

默认规则如下：

- **allow**：风险已充分说明、影响可控、回滚清楚、替代方案已比较
- **pause**：方向可能对，但当前说明不足，应先补充
- **deny**：风险不可接受，或当前证据表明不应继续
- **needs_more_context**：无法判断，必须先补完整信息

## Session Preamble Output

```text
当前动作：<proposed_action>
风险来源：<risk_source>
影响范围：<impact_scope>
授权结论：<allow/pause/deny/needs_more_context>
原因：<decision_reason>
下一步：<recommended_next_skill>
```

## Integration Boundaries

| 上游 / 下游 | 关系 |
|---|---|
| `environment-governance` | 提供风险升级与 must-confirm 背景 |
| `agent-work-environment-v3` | 在 `行令阵` 或高危切阵时推荐调用 |
| `diagnostic-archive` | 若连续失败后仍想高危推进，应先读证据 |
| `careful`, `guard` | 获得授权后，再交给执行保护型 skill |

## Done Gate

本 skill 的职责在以下条件全部满足时结束：

- [x] 已输出授权结论
- [x] 已说明原因
- [x] 如未放行，已指出下一步该补什么

## References

| 文件 | 何时加载 |
|---|---|
| `references/authorization-matrix.md` | 判断某类动作通常应 allow / pause / deny 时 |
| `references/high-risk-actions.md` | 快速确认哪些动作属于执剑人介入范围 |
