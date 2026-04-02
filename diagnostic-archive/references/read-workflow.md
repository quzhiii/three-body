# Read Workflow — 单次 Run 诊断顺序

## 第一步：始终从 manifest 开始

读 `manifest.json`，确认：

- `run_id` 是目标 run
- `status`：是 `success` 还是 `failed`
- `task_summary.task_type`：什么类型的任务
- `formation_id`：使用了哪个阵型
- `created_at`：什么时候跑的

如果 `status = success`，跳到 **成功路径**。
如果 `status = failed`，继续下一步。

---

## 失败路径

### 第二步：读 failure_signature.json

快速定位失败在哪个阶段：

```
failed_stage = "execution"   → 执行路径（见下）
failed_stage = "verification" → 验证路径（见下）
failed_stage = "governance"   → 治理路径（见下）
```

记录 `failure_class` 和 `message_excerpt`，这是根因假设的起点。

---

### 执行失败路径（failed_stage = "execution"）

1. 读 `final_output.json` 中的 `execution_result`
   - 看 `status`、`error.type`、`error.message`
   - 看 `tool_name`：哪个工具失败了

2. 常见 failure_class 及对应检查：

   | failure_class | 下一步 |
   |---|---|
   | `tool_not_available` | 检查 task_contract 里的 tool 列表是否配置正确 |
   | `RuntimeError` / `ValueError` | 读 execution_trace 确认失败时序，看 message_excerpt 定位代码路径 |
   | `unknown` | 读 execution_trace 全部事件，找最后一条状态为 failed 的事件 |

3. 如需进一步确认时序，读 `execution_trace.jsonl`

---

### 验证失败路径（failed_stage = "verification"）

1. 读 `verification_report.json`
   - 看 `passed`（应为 false）
   - 看 `warnings` 列表：哪些检查项有警告
   - 看具体失败检查项的详情

2. 读 `final_output.json` 中的 `execution_result`
   - 确认执行本身是否成功（有时执行成功但验证失败）

3. 判断：验证失败是因为执行结果不符合预期，还是验证规则本身有问题？

---

### 治理失败路径（failed_stage = "governance"）

1. 读 `final_output.json` 中的 `residual_followup`
   - 看 `governance.requires_governance_override`
   - 看 `governance.status` 和原因

2. 读 `evaluation_summary.json`
   - 看 `realm_evaluation.requires_human_review`
   - 看 `realm_evaluation.metadata.automatic_action`

3. 判断：是 policy 触发了人工复核，还是评估结果推断需要覆盖？

---

## 成功路径

`status = success` 时，通常不需要深度诊断，但以下情况值得检查：

1. **结果和预期不符但没报错**：读 `final_output.json` 中的 `execution_result.output`，确认输出内容

2. **评估结果异常（如 requires_human_review = true）**：读 `evaluation_summary.json`

3. **想了解上下文选取**：读 `context_plan.json`

---

## 诊断结论格式

每次诊断完成后，按以下格式输出结论：

```text
run_id：<run_id>
status：<success / failed>
失败阶段：<execution / verification / governance / N/A>
失败类型：<failure_class>
根因判断：<基于证据的判断>
关键证据：
  - <文件名>：<具体内容>
  - <文件名>：<具体内容>
不确定项：<仍不清楚的部分>
建议下一步：<具体行动>
```

---

## 诊断停止条件

以下情况可以停止继续读文件：

- 已找到具体的 error.type 和 error.message，足以定位根因
- 已读完 failure_stage 对应的所有关键文件
- 读了 3 个以上文件仍无新增信息 → 输出"证据不足"结论并说明已查的文件

不允许在没有读任何文件的情况下猜测根因。
