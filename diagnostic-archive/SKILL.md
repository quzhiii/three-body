---
name: diagnostic-archive
description: >
  Use when a run failed or produced unexpected results and you need to diagnose why.
  Use when comparing two runs to understand what changed.
  Use when asked to "look at the archive", "check the last run", "why did this fail",
  "compare this run with that one", "what changed between runs".
  Also use proactively after any failed task before attempting a retry.

  适用场景：某次 run 失败或结果异常需要排查原因；对比两次 run 找出差异；
  被要求"看看 archive""查一下上次 run""这次为什么失败""对比两次结果"。
  也适合在重试失败任务前主动使用，先诊断根因再重试。
  不适用：run 成功且结果符合预期；只是想查 run 的元数据而不做诊断。
---

# Diagnostic Archive

> 先看证据，再下结论。原始 traces 优于摘要。

## Role

本 skill 只做三件事：

1. 定位目标 run（或对比 run 对）
2. 按正确顺序读取 archive 文件，提取诊断证据
3. 给出结论：失败原因 / 关键变化 / 建议下一步

不负责：
- 修复发现的问题（交给 `Code` 或 `agent-work-environment` 路由）
- 重新执行 run
- 猜测没有证据支持的原因

## Archive 位置

默认 archive 根目录：`artifacts/runs/`

每次 run 对应一个子目录，格式为：
```
artifacts/runs/<run_id>/
```

全局索引文件：`artifacts/runs/index.jsonl`

## Input Contract

| 输入 | 含义 |
|---|---|
| `target_run_id` | 要诊断的 run id，或 `latest` 表示最新一次 |
| `compare_run_id` | 对比用的 run id（可选，不填则只做单次诊断） |
| `failure_class` | 已知的失败类型（可选，帮助聚焦） |
| `archive_root` | archive 根目录（可选，默认 `artifacts/runs/`） |

如果 `target_run_id` 未提供，默认读取 `index.jsonl` 中最新一条。

## Output Contract

| 输出 | 含义 |
|---|---|
| `run_id` | 被诊断的 run id |
| `status` | success / failed |
| `failure_stage` | 失败发生在哪个阶段（execution / verification / governance） |
| `failure_class` | 失败类型 |
| `root_cause` | 基于证据的根因判断 |
| `key_evidence` | 支撑根因判断的关键证据（文件名 + 具体内容） |
| `uncertainty` | 仍不确定的部分 |
| `recommended_next` | 建议的下一步行动 |

对比模式额外输出：
| `key_changes` | 两次 run 之间的关键变化 |
| `regression_risk` | 变化是否引入回归风险 |

## Routing Workflow

按以下顺序工作：

1. 确定 archive 根目录和目标 run_id
2. 读取 `manifest.json` — 确认 run 基本信息和状态
3. 读取 `failure_signature.json` — 快速定位失败阶段和类型
4. 按 `failure_stage` 选择下一个要读的文件（见 references/read-workflow.md）
5. 提取关键证据，形成根因判断
6. 如有 `compare_run_id`，执行对比流程（见 references/compare-workflow.md）
7. 输出结论

如果 `status = success`，跳过步骤 3-4，直接进入验证结果和评估摘要。

## Done Gate

本 skill 的诊断职责在以下条件**全部满足**时结束：

- [x] 已读取足够证据支撑结论（至少 manifest + failure_signature + 对应阶段文件）
- [x] 已给出 root_cause（即使是"证据不足，需要进一步查 X"）
- [x] 已给出 recommended_next

结论可以是"无法确定根因，需要 X"——但不允许"不知道"然后停止。

## References

| 文件 | 何时加载 |
|---|---|
| `references/archive-schema.md` | 需要了解各 archive 文件的内容和用途时 |
| `references/read-workflow.md` | 执行单次 run 诊断时，按阶段选择文件 |
| `references/compare-workflow.md` | 执行两次 run 对比时 |
| `references/triage-rules.md` | 判断某个变化是否值得关注时 |
