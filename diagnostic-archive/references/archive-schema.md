# Archive Schema — 每个文件是什么

每次 run 写入 `artifacts/runs/<run_id>/` 下，共 10 个文件 + 1 个全局索引。

---

## 文件速查表

| 文件 | 格式 | 一句话说明 | 优先读 |
|---|---|---|---|
| `manifest.json` | JSON | run 的基本信息：状态、时间、profile、formation | 总是第一个读 |
| `failure_signature.json` | JSON | 失败类型、失败阶段、错误摘要 | 失败时第二个读 |
| `execution_trace.jsonl` | JSONL | 每个阶段的事件流（execution/verification/evaluation） | 需要时序证据时 |
| `verification_report.json` | JSON | 验证结果：passed/failed、warnings、具体检查项 | verification 失败时 |
| `final_output.json` | JSON | 执行结果、验证报告、残差后续、sandbox 决策的综合输出 | 需要完整输出时 |
| `task_contract.json` | JSON | 任务合同：goal、task_type、workflow_profile_id | 需要确认任务定义时 |
| `profile_and_mode.json` | JSON | profile 解析结果：formation_id、policy_mode、解析路径 | formation 相关问题时 |
| `context_plan.json` | JSON | 上下文选块报告：哪些 block 被选中、block 顺序 | 上下文相关问题时 |
| `evaluation_summary.json` | JSON | 评估输入包 + realm 评估 + baseline 对比结果 | 评估相关问题时 |
| `metrics_summary.json` | JSON | 事件计数、指标聚合 | 性能相关问题时 |
| `archive_index.json` | JSON | 本次 archive 的文件清单（meta） | 通常不需要主动读 |

全局索引：`artifacts/runs/index.jsonl`，每行一条 run 摘要，用于按条件查找 run。

---

## 各文件详解

### manifest.json — 第一个读

包含：
- `run_id`：run 唯一标识
- `created_at`：时间戳
- `status`：`success` 或 `failed`
- `workflow_profile_id`：使用的 profile
- `formation_id`：使用的阵型（如有）
- `policy_mode`：策略模式
- `task_summary`：任务描述、task_type、task_id
- `archive_version`：archive 格式版本

**何时读**：永远第一个。用于确认 run 存在、状态是什么、是哪类任务。

---

### failure_signature.json — 失败时第二个读

包含：
- `status`：`success` 或 `failed`
- `failure_class`：失败类型（如 `tool_not_available`、`verification_failed`、`governance_review_required`）
- `error_type`：具体错误类型
- `failed_stage`：`execution` / `verification` / `governance`
- `message_excerpt`：错误信息摘要（最多 160 字符）

**何时读**：run 失败时，读完 manifest 立刻读这个。它决定后续该看哪个文件。

---

### execution_trace.jsonl — 需要时序证据时

每行一个事件，格式：
```json
{"timestamp": "...", "event_type": "runtime_completed", "status": "...", "metadata": {...}}
```

事件类型：
- `runtime_completed`：执行阶段结束
- `verification_completed`：验证阶段结束
- `evaluation_completed`：评估阶段结束

**何时读**：需要确认各阶段实际执行顺序或状态时；时序问题排查时。

---

### verification_report.json — verification 失败时

包含：
- `passed`：布尔值
- `status`：`passed` / `failed`
- `warnings`：警告列表
- 各项检查的具体结果

**何时读**：`failure_signature.failed_stage = "verification"` 时。

---

### final_output.json — 需要完整输出时

包含执行结果（`execution_result`）、验证报告（`verification_report`）、残差后续（`residual_followup`）、sandbox 决策（`sandbox_decision` / `sandbox_result`）、rollback 结果、学习日志追加等。

**何时读**：需要看执行结果详情、sandbox 是否触发、rollback 是否发生时。

---

### task_contract.json — 确认任务定义时

包含任务合同完整内容：goal、task_type、workflow_profile_id、task_id、contract_id 等。

**何时读**：怀疑任务定义本身有问题（goal 不对、profile 错误匹配）时。

---

### profile_and_mode.json — formation 相关问题时

包含：
- `workflow_profile_id`：解析后的 profile
- `formation_id`：阵型 id
- `policy_mode`：策略模式
- `profile_resolution`：解析路径（来源是哪个字段、是否用了 fallback）

**何时读**：profile 或 formation 选择疑似不对时。

---

### context_plan.json — 上下文相关问题时

包含：
- `block_selection_report`：哪些上下文 block 被选中
- `context_bias.included_blocks`：选中的 block 列表
- `context_bias.block_order`：block 顺序

**何时读**：怀疑上下文选取偏差导致执行结果异常时。

---

### evaluation_summary.json — 评估相关问题时

包含：
- `evaluation_input_bundle`：评估输入
- `realm_evaluation`：realm 评估结果（automatic_action、requires_human_review）
- `baseline_compare_results`：与基线的对比结果（如有）

**何时读**：需要了解评估结论、是否需要人工复核、与基线差异时。

---

### index.jsonl — 查找目标 run 时

全局索引，每行格式：
```json
{"run_id": "...", "created_at": "...", "status": "...", "workflow_profile_id": "...", "task_type": "...", "formation_id": "...", "failure_class": "..."}
```

**何时读**：不知道具体 run_id，需要按 status / task_type / formation_id / failure_class 筛选时。
