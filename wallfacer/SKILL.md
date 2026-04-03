---
name: wallfacer
description: >
  Use when a task is complex enough that it should not move directly from routing into implementation, and a deep planning pass is needed first.
  Use for architecture changes, multi-stage refactors, migration planning, or high-ambiguity tasks where multiple viable paths exist and one must be chosen deliberately.
  Use when the agent should think through candidate paths before execution without exposing unnecessary intermediate noise.

  适用场景：当任务复杂到不应从路由直接进入实现，而需要先进行一次深度规划时使用。
  例如：架构调整、多阶段重构、迁移方案设计、存在多条可行路径且必须明确取舍的复杂任务。
  不适用：简单 bug 修复、明确单路径任务、普通文档撰写、低风险只读分析。
---

# Wallfacer — 面壁人

> 真正的规划，不是边做边想，而是先在黑暗中完成推演。

## What It Is

本 skill 是 **复杂任务的深度规划层**。

它处在“诛仙阵完成路由”之后、“真正开始实现”之前，负责把复杂任务从模糊状态整理成一份可执行的战略方案。

## What It Is Not

- 不是任务路由器（不负责选阵型）
- 不是治理层（不负责定义风险法则）
- 不是普通 brainstorming（不是发散创意，而是收敛方案）
- 不是执行 skill（不直接改代码、不直接部署）

## Role

本 skill 只负责四件事：

1. 明确任务中的关键未知与主要约束
2. 推导 2-3 条可行路径
3. 选择主路径，并解释为什么不选其他路径
4. 给出下一步最合理的执行 handoff

## Trigger Conditions

优先在以下情况调用：

- 任务复杂且多阶段
- 存在两条及以上可行路径
- 直接编码会放大返工风险
- 涉及架构、迁移、重构、系统演化
- 用户表达为“先分析再改”“先看看再决定”“帮我规划一下怎么做”

## Input Contract

| 输入 | 含义 |
|---|---|
| `task` | 当前任务描述 |
| `goal` | 期望终局 |
| `constraints` | 时间、兼容性、风险、资源等约束 |
| `known_risks` | 当前已知风险 |
| `needs_multi_stage_plan` | 是否跨多个阶段 |

## Output Contract

| 输出 | 含义 |
|---|---|
| `candidate_paths` | 2-3 条可行路径 |
| `recommended_path` | 推荐主路径 |
| `rejected_paths` | 未选路径及原因 |
| `critical_unknowns` | 仍需验证的关键未知 |
| `recommended_next_skill` | 下游执行建议 |
| `plan_summary` | 一段简明规划摘要 |

## Planning Workflow

按以下顺序工作：

1. 识别任务是否真的需要深度规划
2. 提炼约束与目标
3. 列出候选路径
4. 比较路径的成本、风险、收益与可逆性
5. 选出推荐路径
6. 标记关键未知与需要额外验证的点
7. 交接给下游 skill 或建议交给 `wallbreaker`

## Session Preamble Output

```text
当前判断：需要 / 不需要面壁人
任务目标：<goal>
关键约束：<constraints>
候选路径：<A / B / C>
推荐路径：<recommended_path>
关键未知：<critical_unknowns>
建议下游：<recommended_next_skill>
```

## Integration Boundaries

| 上游 / 下游 | 关系 |
|---|---|
| `agent-work-environment-v3` | 在复杂任务时推荐进入面壁人 |
| `environment-governance` | 规划过程中持续提供风险约束背景 |
| `wallbreaker` | 当方案争议大、假设多时，交给破壁人挑战 |
| `Code` / `test-runner` / `doc` | 规划完成后进入具体执行 |

## Done Gate

本 skill 的职责在以下条件全部满足时结束：

- [x] 已给出候选路径
- [x] 已给出推荐主路径
- [x] 已明确关键未知与下一步 handoff

## References

| 文件 | 何时加载 |
|---|---|
| `references/planning-output-format.md` | 需要统一输出格式时 |
| `references/decision-criteria.md` | 需要比较路径优劣时 |
| `references/escalation-to-wallbreaker.md` | 需要判断是否交给破壁人时 |
