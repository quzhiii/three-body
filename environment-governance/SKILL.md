---
name: environment-governance
description: >
  Use when any task needs behavioral guardrails — not just multi-stage tasks.
  Use when about to execute a risky operation, write to files, access history/diagnostics,
  or when task complexity or failure count suggests different constraint levels are needed.
  Use when asked to "be careful", "safe mode", "check before doing", "what's safe to do".
  Also use proactively before destructive operations, before retries after failure, and when context window is getting large.

  适用场景：任何需要行为约束的任务——不仅是多阶段任务。即将执行高风险操作、写入文件、访问历史诊断数据、
  或任务复杂度/失败次数表明需要调整约束强度时。
  触发词：小心、安全模式、写之前检查、这个安全吗、确认一下。
  也在破坏性操作前、失败重试前、上下文变大时主动使用。
  不适用：纯对话、简单查询、无任何风险的信息获取。
---

# Environment Governance — 三体环境法则

> 三体定其界。行为边界先于执行动作。

## What It Is

本 skill 是一组**独立于任务模式的行为约束规则**。它不关心你在做什么任务（研究/实现/验证/写作/运维），只关心你**怎么做**。

它提供五条法则，每条法则根据任务信号自动调整偏置强度，无需先选择工作模式。

## What It Is Not

- 不是任务路由器（不负责判断该做什么任务）
- 不替代 `careful` 或 `guard`（它是行为指导，不是 hook）
- 不依赖阵型或工作模式存在（可独立使用）

## Role

本 skill 只做两件事：

1. 根据当前任务信号，给出适用的行为约束和偏置强度
2. 在高风险或连续失败场景下，给出升级动作建议

## Input Contract

| 输入 | 含义 | 来源 |
|---|---|---|
| `risk_level` | 低 / 中 / 高 | 不可逆性 + 破坏范围 |
| `task_complexity` | 独立判断 |
| `has_failed` | 是 / 否 | 是否存在连续失败 |
| `write_intent` | 只读 / 文档 / 代码 / 配置 / 删除 | 即将写入什么 |

这 4 个信号不需要阵型就能判断。`agent-work-environment`（诛仙阵）本质上就是这 4 个信号的预设组合。

## Output Contract

| 输出 | 含义 |
|---|---|
| `active_laws` | 本轮适用的法则及偏置强度 |
| `must_confirm` | 是否存在必须确认的操作 |
| `diagnostic_hint` | 是否建议读取历史/诊断数据 |
| `bias_summary` | 一句话总结本轮偏置 |

## Bias Workflow

按以下顺序工作：

1. 从上下文推断 `risk_level`、`task_complexity`、`has_failed`、`write_intent`
2. 在 `references/default-bias.md` 中查找对应偏置组合
3. 输出适用的法则和偏置
4. 如触发硬确认项，输出 `must_confirm`

如果任务信号改变（如从"只读"变为"写代码"），重新走一遍工作流。

## Done Gate

本 skill 的约束输出职责在以下条件满足时结束：

- [x] 已根据 4 个信号输出偏置建议
- [x] 如有 must_confirm 项，已标记

后续执行由下游 skill 或 agent 自行负责。本 skill 不干预执行过程。

## Five Laws

| # | 法则 | 管什么 |
|---|---|---|
| 1 | 上下文预算 | 上下文是公共资源，按需加载，不默认全量注入 |
| 2 | 工具边界 | 工具按需暴露，低风险工具优先 |
| 3 | 风险升级 | 高风险操作前停顿确认，连续失败先诊断 |
| 4 | 写回策略 | 按变更类型区分风险，不混为一谈 |
| 5 | 诊断访问 | 历史和原始证据按需读取，不默认全量注入 |

每条法则的完整定义、默认行为、检查项、升级条件和例外情况见 `references/laws.md`。

## When to Load References

| 文件 | 何时加载 |
|---|---|
| `references/laws.md` | 需要查看某条法则的具体行为、检查项或升级条件时 |
| `references/default-bias.md` | 需要根据任务信号查找偏置组合时 |
| `references/escalation-matrix.md` | 需要判断某个操作是否属于硬确认项时 |
