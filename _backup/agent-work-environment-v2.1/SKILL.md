---
name: agent-work-environment
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
---

# Agent Work Environment

> 三体定其界，诛仙阵定其式。

## When to Use

在以下场景优先使用本 skill：

- 用户任务是多阶段任务，需要在研究、实现、验证、写作、运维之间切换
- 用户需求还不够清晰，需要先判断当前最合适的工作模式
- 任务带有明显风险，需要先明确确认边界、写入边界或工具边界
- 任务可能跨多个 skill，需要先决定交给谁执行
- 长任务需要控制上下文膨胀、工具滥用和连续失败重试

## When Not to Use

以下场景不应把本 skill 当成主技能：

- 单一步骤且目标明确的任务，例如“修一个确定的 bug”或“写一段确定的文档”
- 用户已经明确指定执行 skill，且任务不存在明显风险或模式歧义
- 只需要具体执行，不需要额外路由、切阵或治理

本 skill 是前置总控，不直接替代编码、评审、文档或运维 skill。

## Role

本 skill 只负责四件事：

1. 判断当前任务属于哪个阵型
2. 明确本轮适用的环境法则和边界
3. 判断是否需要风险确认、失败升级或中途切阵
4. 推荐下游执行 skill 并给出交接格式

本 skill 不负责：

- 直接承诺完成编码、review、写作或运维结果
- 替代 `Code`、`review`、`careful`、`guard` 等执行型 skill
- 提供 runtime hook 级强制防护

## Input Contract

进入本 skill 时，至少应显式或隐式判断以下输入：

| 输入 | 含义 |
|---|---|
| `task` | 用户当前要完成的任务描述 |
| `goal` | 任务最终目标或预期结果 |
| `risk_level` | 低 / 中 / 高，按潜在破坏性和不可逆性判断 |
| `is_multi_stage` | 是否可能跨研究、实现、验证、写作、运维多个阶段 |
| `user_explicit_mode` | 用户是否已明确指定阵型或工作模式 |

如果其中部分输入缺失，应先根据上下文作出最小合理判断，而不是要求完整填写。

## Output Contract

本 skill 的输出必须至少包含以下内容：

| 输出 | 含义 |
|---|---|
| `selected_formation` | 选定阵型 |
| `why_this_formation` | 选择该阵型的原因 |
| `applied_laws` | 本轮重点适用的环境法则 |
| `needs_confirmation` | 是否需要用户确认后再继续 |
| `needs_switch_later` | 是否预期后续会切阵 |
| `recommended_next_skill` | 推荐的下游执行 skill 或 skill 类型 |
| `minimum_done_standard` | 当前阵型下的最小完成标准 |

## Routing Workflow

按以下顺序工作：

1. 识别任务是否需要总控治理
2. 判断当前主阵型
3. 应用该阵型对应的环境法则偏置
4. 判断是否需要风险确认
5. 判断是否建议交给下游执行 skill
6. 明确本轮完成标准和后续可能切阵点

## Formation Selection

根据用户意图选择阵型：

| 用户意图关键词 | 阵型 | 模式 |
|---|---|---|
| 研究、调研、分析、解释、看看、理解 | 观机阵（研究模式） | `research_mode` |
| 实现、修复、开发、改代码、补功能 | 破局阵（实现模式） | `coding_mode` |
| 检查、review、验证、审查、判断 | 明鉴阵（验证模式） | `verification_mode` |
| 文档、总结、方案、prompt、写报告 | 立言阵（写作模式） | `writing_mode` |
| 部署、命令、环境、配置、运维 | 行令阵（运维模式） | `ops_mode` |

如果用户明确指定阵型，例如“进入观机阵”，优先服从用户指定。

## Session Preamble Output

每次使用本 skill 时，优先输出一个简短总控结论：

```text
当前判定：<阵型>
原因：<为什么选这个阵型>
本轮法则：<重点适用的 2-3 条法则>
确认需求：<是否需要确认>
建议下游：<推荐 skill>
完成标准：<本轮最小完成标准>
```

## Downstream Skill Handoff

本 skill 负责路由，不负责替代下游 skill。默认推荐如下：

| 阵型 | 优先推荐 | 可替代类型 |
|---|---|---|
| 观机阵（研究模式） | `brainstorming`, `review` | 研究、调研、分析类 skill |
| 破局阵（实现模式） | `Code`, `test-runner` | 编码、测试、修复类 skill |
| 明鉴阵（验证模式） | `review`, `qa` | 验证、审查、测试类 skill |
| 立言阵（写作模式） | `doc` | 文档、方案、总结类 skill |
| 行令阵（运维模式） | `careful`, `guard` | 环境、部署、命令治理类 skill |

如果当前环境中不存在对应 skill，则只输出 skill 类型，不虚构依赖。

## Formation Switch Rules

当任务性质变化时，主动切阵并简短说明原因：

- 研究 -> 实现：从理解问题转为动手修改
- 实现 -> 验证：改动完成后进入检查
- 验证 -> 实现：发现问题后开始修复
- 任意 -> 写作：需要把结果整理成文档
- 任意 -> 运维：需要执行命令、部署或环境操作

## Done Gate

本 skill 的总控职责在以下条件**全部满足**时结束：

- [x] 已输出 Session Preamble（阵型 + 原因 + 法则 + 确认需求 + 下游推荐 + 完成标准）
- [x] 如需确认，已等待并获得用户批准
- [x] 已将任务交接给下游 skill，或已说明为什么不需要交接

一旦以上条件满足，本 skill 不再干预后续执行。下游 skill 的完成标准由下游 skill 自行负责。

如果任务中途性质变化（需要切阵），重新从 Routing Workflow 第 1 步开始。

## Failure Escalation

遇到连续失败或高风险动作时，不要继续模糊执行。统一进入失败升级模板，详细格式见 `references/escalation-matrix.md`。

## References

| 文件 | 何时加载 |
|---|---|
| `references/formations.md` | 需要查看阵型定义、完成标准和交付格式时 |
| `references/environment-laws.md` | 需要查看环境法则和执行前检查项时 |
| `references/formation-law-mapping.md` | 需要查看阵型与法则偏置映射时 |
| `references/escalation-matrix.md` | 需要判断是否必须确认或进入失败升级模板时 |
