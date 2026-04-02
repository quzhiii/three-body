---
name: agent-work-environment-v3
description: >
  Use when a task is multi-stage (spans research, coding, verification, writing, or ops),
  needs mode selection before execution, or carries risk that requires boundary-setting first.
  Triggers on "先分析再改", "帮我调研", "review一下", "整理成文档", "部署到", or any request
  where the right work mode is unclear.
  Does NOT trigger for single-step tasks with clear intent like "fix this bug" or "write a function".

  适用场景：任务跨多个阶段（研究→实现→验证→写作→运维）、需要先判断工作模式再开始执行、
  或任务带有明显风险需要先确认边界。触发词：先分析再改、帮我调研、先看看再决定、
  review一下、整理成文档、部署到、不确定从哪里入手。
  不适用：单步骤且目标明确的任务，例如"修这个 bug"或"写这个函数"。

  行为约束由 environment-governance skill 提供。本 skill 只负责路由。
---

# Agent Work Environment — 诛仙阵

> 诛仙阵定其式。三体定其界。

## What It Is

本 skill 是**纯任务路由器**。它判断当前任务应该用什么工作模式（阵型），给出阵型对应的执行标准，然后交接给下游 skill。

**行为约束**（上下文预算、工具边界、风险升级、写回策略、诊断访问）由 `environment-governance` skill 提供。本 skill 不内嵌法则。

## Role

本 skill 只负责三件事：

1. 判断当前任务属于哪个阵型
2. 给出阵型对应的完成标准和交付格式
3. 推荐下游执行 skill 并交接

不负责：
- 直接执行编码、review、写作或运维
- 定义行为约束（交给 `environment-governance`）
- 替代 `Code`、`review`、`careful`、`guard` 等执行型 skill

## Input Contract

| 输入 | 含义 |
|---|---|
| `task` | 用户当前要完成的任务描述 |
| `goal` | 任务最终目标或预期结果 |
| `is_multi_stage` | 是否可能跨多个阶段 |
| `user_explicit_mode` | 用户是否已明确指定阵型 |

## Output Contract

| 输出 | 含义 |
|---|---|
| `selected_formation` | 选定阵型 |
| `why_this_formation` | 选择该阵型的原因 |
| `needs_switch_later` | 是否预期后续会切阵 |
| `recommended_next_skill` | 推荐的下游执行 skill |
| `minimum_done_standard` | 当前阵型下的最小完成标准 |

注意：`applied_laws` 不再由本 skill 输出。阵型决定 4 个任务信号（risk_level, task_complexity, has_failed, write_intent），由 `environment-governance` 根据这些信号计算法则偏置。

## Formation Selection

根据用户意图选择阵型：

| 用户意图关键词 | 阵型 | 模式 | 默认信号组合 |
|---|---|---|---|
| 研究、调研、分析、解释、看看、理解 | 观机阵（研究模式） | `research_mode` | risk=低, complexity=复杂, failed=否, write=只读 |
| 实现、修复、开发、改代码、补功能 | 破局阵（实现模式） | `coding_mode` | risk=中, complexity=中等, failed=可能, write=代码 |
| 检查、review、验证、审查、判断 | 明鉴阵（验证模式） | `verification_mode` | risk=低, complexity=中等, failed=可能, write=只读 |
| 文档、总结、方案、prompt、写报告 | 立言阵（写作模式） | `writing_mode` | risk=低, complexity=中等, failed=否, write=文档 |
| 部署、命令、环境、配置、运维 | 行令阵（运维模式） | `ops_mode` | risk=高, complexity=—, failed=—, write=配置/删除 |

如果用户明确指定阵型，例如"进入观机阵"，优先服从用户指定。

## Session Preamble Output

每次使用本 skill 时，优先输出一个简短总控结论：

```text
当前判定：<阵型>
原因：<为什么选这个阵型>
任务信号：risk=<低/中/高>, complexity=<简单/中等/复杂>, write=<只读/文档/代码/配置/删除>
建议下游：<推荐 skill>
完成标准：<本轮最小完成标准>
```

法则偏置由 `environment-governance` 根据任务信号自动计算，无需在 preamble 中重复。

## Downstream Skill Handoff

默认推荐与回退规则以 `references/downstream-skills.md` 为准；下表只是摘要。

| 阵型 | 优先推荐 | 可替代类型 |
|---|---|---|
| 观机阵（研究模式） | `brainstorming`, `review` | 研究、调研、分析类 skill |
| 破局阵（实现模式） | `Code`, `test-runner` | 编码、测试、修复类 skill |
| 明鉴阵（验证模式） | `review`, `qa` | 验证、审查、测试类 skill |
| 立言阵（写作模式） | `doc` | 文档、方案、总结类 skill |
| 行令阵（运维模式） | `careful`, `guard` | 环境、部署、命令治理类 skill |

## Formation Switch Rules
- 研究 -> 实现：从理解问题转为动手修改
- 实现 -> 验证：改动完成后进入检查
- 验证 -> 实现：发现问题后开始修复
- 任意 -> 写作：需要把结果整理成文档
- 任意 -> 运维：需要执行命令、部署或环境操作

切阵时任务信号会随之变化，`environment-governance` 自动调整法则偏置。

## Done Gate

本 skill 的路由职责在以下条件**全部满足**时结束：

- [x] 已输出 Session Preamble
- [x] 已将任务交接给下游 skill，或已说明为什么不需要交接

## Failure Escalation

遇到连续失败时，参考 `environment-governance` 的 escalation-matrix.md。

## References

| 文件 | 何时加载 |
|---|---|
| `references/formations.md` | 需要查看阵型定义、完成标准、检查清单和交付格式时 |
| `references/formation-law-mapping.md` | 需要查看阵型到任务信号的映射（供 environment-governance 使用）时 |
| `references/downstream-skills.md` | 需要查看阵型对应的默认下游 skill 与回退规则时 |
