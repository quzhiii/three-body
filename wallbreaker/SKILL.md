---
name: wallbreaker
description: >
  Use when a proposed plan, strategy, or recommendation needs adversarial scrutiny before execution.
  Use after a deep planning pass or whenever a direction looks plausible but may hide untested assumptions, weak premises, or dangerous blind spots.
  Use for architecture proposals, migration plans, refactor strategies, or any high-impact decision where challenge is more valuable than speed.

  适用场景：当一个方案、策略或推荐路径在执行前需要被“对抗式审查”时使用。
  适用于深度规划之后，或当某个方向看起来可行但可能隐藏未验证假设、薄弱前提或关键盲点时。
  例如：架构方案、迁移计划、重构路线、高影响决策。
  不适用：简单 bug 修复、普通代码 review、已明确单路径且低风险的任务。
---

# Wallbreaker — 破壁人

> 破壁人的职责不是提出计划，而是识破计划里最危险的幻觉。

## What It Is

本 skill 是 **方案挑战层**。

它在 `wallfacer` 或其他规划结果已经出现之后介入，用来审查：

- 方案是否建立在未验证前提上
- 是否存在更简单但被忽略的路径
- 是否把局部最优错当成全局最优
- 是否遗漏了会导致失败的关键风险

## What It Is Not

- 不是任务路由器
- 不是治理层
- 不是普通 code review
- 不是 bug finder
- 不是初始方案生成器

## Role

本 skill 只负责四件事：

1. 提取当前方案里的显性和隐性假设
2. 识别最可能的失败点与盲区
3. 判断当前方案是否值得继续推进
4. 指出必须补充的验证项或修正方向

## Trigger Conditions

优先在以下情况调用：

- 已经有一个成型方案或推荐路径
- 方案的风险高、返工成本高
- 关键假设较多，但证据不足
- 团队/用户对方向有争议
- 需要在执行前打一轮“逆风审查”

## Input Contract

| 输入 | 含义 |
|---|---|
| `target_plan` | 被挑战的方案 |
| `decision_context` | 这份方案为什么重要 |
| `known_assumptions` | 已明确写出的假设 |
| `risk_profile` | 如果方案错了，会出什么代价 |

## Output Contract

| 输出 | 含义 |
|---|---|
| `hidden_assumptions` | 发现的隐含假设 |
| `top_failure_modes` | 最可能失败的点 |
| `challenge_summary` | 一段简明挑战摘要 |
| `required_validation` | 执行前必须补的验证项 |
| `proceed_recommendation` | `proceed` / `revise` / `block` |

## Challenge Workflow

按以下顺序工作：

1. 读取目标方案
2. 抽取显性假设
3. 推断隐性假设
4. 识别失败模式与忽略风险
5. 判断是否存在更简单路径被遗漏
6. 输出推进建议与补充验证清单

## Session Preamble Output

```text
当前目标：<target_plan>
关键假设：<known_assumptions + hidden_assumptions>
最大风险：<top_failure_modes>
结论：<proceed/revise/block>
执行前必须补充：<required_validation>
```

## Integration Boundaries

| 上游 / 下游 | 关系 |
|---|---|
| `wallfacer` | 其主要上游，向破壁人提交候选方案 |
| `agent-work-environment-v3` | 在复杂高争议任务中可推荐进入破壁人 |
| `environment-governance` | 提供风险背景，但不负责方案挑战 |
| `review` / `qa` | 这些用于检查结果；破壁人用于挑战方案 |

## Done Gate

本 skill 的职责在以下条件全部满足时结束：

- [x] 已指出至少一组关键假设或盲点
- [x] 已给出推进建议
- [x] 已列出执行前必须补的验证项

## References

| 文件 | 何时加载 |
|---|---|
| `references/challenge-patterns.md` | 需要按套路挑战方案时 |
| `references/hidden-assumptions.md` | 需要寻找隐含前提时 |
| `references/pushback-thresholds.md` | 需要判断是提醒、修正还是阻断时 |
