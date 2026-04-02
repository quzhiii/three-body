# Triage Rules — 什么变化值得关注

对比两次 run 时，不是所有差异都值得深究。本文件定义哪些变化是重要的，哪些可以忽略。

---

## 重要变化（总是值得关注）

这些变化很可能是问题根因或引入了行为变化：

| 变化 | 原因 |
|---|---|
| `status`: success → failed | 直接回归，必须查 |
| `failure_class` 出现新值 | 问题类型变化，说明失败路径不同 |
| `failed_stage` 变化 | 问题从一个阶段转移到了另一个阶段 |
| `workflow_profile_id` 变化 | 任务模式变了，行为预期也变了 |
| `formation_id` 变化 | 阵型变了，工具优先级和约束都变了 |
| `profile_resolution.used_fallback`: false → true | profile 没有按预期解析，触发了 fallback |
| `requires_human_review`: false → true | 评估认为需要人工复核，说明结果可信度下降 |
| `execution_result.status` 变化 | 执行层直接失败或成功状态变化 |
| `verification_report.passed` 变化 | 验证结论变化 |
| `sandbox_triggered`: false → true | sandbox 被激活，说明执行触发了隔离条件 |
| `rollback_result` 出现非空值 | 发生了回滚，需要了解原因 |

---

## 一般变化（值得关注但不一定是根因）

这些变化可能有影响，但需要结合上下文判断：

| 变化 | 说明 |
|---|---|
| `warnings` 数量增加 | 可能是新的边界条件触发了警告，也可能无害 |
| `automatic_action` 变化 | 评估推断的自动行动变了，需确认是否符合预期 |
| `context_bias.included_blocks` 变化 | 上下文选取变了，可能影响执行结果 |
| `context_bias.block_order` 变化 | block 顺序变了，可能影响上下文权重 |
| `message_excerpt` 内容变化（同一 failure_class） | 失败类型相同但错误信息变了，问题可能在演变 |
| `task_type` 变化 | 任务类型解析不同，可能影响 profile 匹配 |

---

## 可忽略变化

这些变化通常是预期内的正常差异：

| 变化 | 原因 |
|---|---|
| `created_at` 时间差异 | 正常，不同时间跑的 run |
| `run_id` 不同 | 正常，每次 run 都有唯一 id |
| `metrics_summary.event_count` 小幅变化（± 1-2） | 正常波动 |
| `task_id` / `contract_id` 不同 | 正常，每次生成新 id |
| `archive_version` 相同 | 无差异，不需要记录 |
| `history_entry_written` 布尔值 | archive meta 字段，不影响诊断 |

---

## 快速判断规则

遇到以下情况可以快速得出结论，不需要继续深挖：

**直接定位根因**：
- `failure_class = tool_not_available` → 工具配置问题，看 task_contract 的工具列表
- `failure_class = verification_failed` → 执行结果不满足验证条件，看 verification_report
- `failure_class = governance_review_required` → 治理策略触发，看 realm_evaluation

**暂停继续对比，转为单次诊断**：
- 两次 run 的 `workflow_profile_id` 完全不同 → 这不是同类任务的对比，先各自诊断
- 两次 run 间隔超过一天且有代码变更 → 变化来源太多，缩小范围再对比

**标记为证据不足，输出建议**：
- 读了 manifest + failure_signature + 对应阶段文件，仍无法定位 → 建议跑一次新的 run 并加强 trace 记录
- message_excerpt 被截断且关键信息丢失 → 建议直接查原始日志或重新跑并捕获完整错误
