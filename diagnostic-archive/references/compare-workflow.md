# Compare Workflow — 两次 Run 对比流程

对比的目标是回答：**这两次 run 之间，什么发生了变化，变化是否引入了问题。**

---

## 何时用对比

- 上次成功，这次失败 → 找引入问题的变化
- 两次都失败，但 failure_class 不同 → 找问题是否演变
- 想验证某个修复是否生效 → 对比修复前后
- 想了解某个参数变化的影响 → 对比不同 formation/profile 的 run

---

## 第一步：各自读 manifest

分别读两个 run 的 `manifest.json`，建立基本认知：

| 字段 | run A | run B | 是否有差异 |
|---|---|---|---|
| `status` | | | |
| `workflow_profile_id` | | | |
| `formation_id` | | | |
| `policy_mode` | | | |
| `task_summary.task_type` | | | |
| `created_at` | | | |

如果 `workflow_profile_id` 或 `formation_id` 不同，这是最重要的变量，优先追踪。

---

## 第二步：对比 failure_signature

读两个 run 的 `failure_signature.json`：

| 字段 | run A | run B |
|---|---|---|
| `status` | | |
| `failure_class` | | |
| `failed_stage` | | |
| `message_excerpt` | | |

对比结论：
- 两次都成功 → 看评估和输出差异
- A 成功 B 失败 → B 的 failed_stage 决定下一步
- 两次都失败但 failure_class 不同 → 问题已经演变，分别诊断
- failure_class 相同 → 问题未解决，看 message_excerpt 是否有变化

---

## 第三步：按差异类型决定下一步

### 情况 1：profile 或 formation 不同

读两个 run 的 `profile_and_mode.json`，对比：
- `profile_resolution.source`（来自哪个字段）
- `profile_resolution.used_fallback`（是否用了 fallback）
- `formation_id` 是否真的不同

**关注点**：profile fallback 是常见的隐性变化来源。

---

### 情况 2：执行结果不同

读两个 run 的 `final_output.json`，对比 `execution_result`：
- `status` 是否变化
- `tool_name` 是否变化
- `output` 的关键字段是否变化

---

### 情况 3：验证结论不同

读两个 run 的 `verification_report.json`，对比：
- `passed` 是否变化
- `warnings` 列表是否变化
- 具体失败检查项是否变化

---

### 情况 4：评估结论不同

读两个 run 的 `evaluation_summary.json`，对比：
- `realm_evaluation.requires_human_review`
- `realm_evaluation.metadata.automatic_action`
- `baseline_compare_results`（如有）

---

### 情况 5：上下文选取不同

读两个 run 的 `context_plan.json`，对比：
- `context_bias.included_blocks`
- `context_bias.block_order`

**关注点**：block 顺序或选取变化可能导致执行行为改变。

---

## 对比结论格式

```text
对比：<run_id_A> vs <run_id_B>

关键变化：
  - [重要] profile: default_general → planning_design
  - [重要] status: success → failed
  - [一般] warnings 数量: 0 → 2
  - [可忽略] created_at 时间差异

变化是否引入回归风险：是 / 否 / 不确定

根因判断：<基于变化的判断>
建议下一步：<具体行动>
```

变化重要性分类（参见 triage-rules.md）：
- `[重要]`：很可能是问题根因或引入了行为变化
- `[一般]`：值得关注但不确定是否是根因
- `[可忽略]`：预期内的正常差异
