# Run Archives — 档案格式与生成方式

这份文档专门回答三个问题：

1. run 档案是什么
2. 谁来生成它
3. `diagnostic-archive` 期望读到什么结构

---

## 什么是 run 档案

run 档案是一组按单次执行落盘的诊断文件。

默认目录结构：

```text
artifacts/runs/
├── index.jsonl
└── <run_id>/
    ├── manifest.json
    ├── failure_signature.json
    ├── execution_trace.jsonl
    ├── verification_report.json
    ├── final_output.json
    ├── task_contract.json
    ├── profile_and_mode.json
    ├── context_plan.json
    ├── evaluation_summary.json
    ├── metrics_summary.json
    └── archive_index.json
```

其中：

- `index.jsonl` 是全局索引
- `<run_id>/` 是单次 run 的详细证据目录

---

## 谁来生成它

`diagnostic-archive` **不会自己生成档案**。

它假定：

- 你的 Agent 执行框架
- 你自己的任务编排器
- 或者你额外写的日志/归档脚本

已经在任务执行后把这些文件写到了 `artifacts/runs/` 下面。

也就是说，`diagnostic-archive` 是**读取层**，不是**采集层**。

---

## 最低可用格式

如果你不想一开始就生成完整 10 个文件，最小可用集合是：

```text
artifacts/runs/index.jsonl
artifacts/runs/<run_id>/manifest.json
artifacts/runs/<run_id>/failure_signature.json
artifacts/runs/<run_id>/final_output.json
```

推荐再补：

- `execution_trace.jsonl`
- `verification_report.json`

因为这两个文件最能提高根因判断的可信度。

---

## 最小示例

### `index.jsonl`

```json
{"run_id":"run_2026_04_02_001","created_at":"2026-04-02T10:30:00Z","status":"failed","task_type":"deploy","formation_id":"ops_mode","failure_class":"verification_failed"}
```

### `manifest.json`

```json
{
  "run_id": "run_2026_04_02_001",
  "created_at": "2026-04-02T10:30:00Z",
  "status": "failed",
  "workflow_profile_id": "ops-safe",
  "formation_id": "ops_mode",
  "policy_mode": "strict"
}
```

### `failure_signature.json`

```json
{
  "status": "failed",
  "failure_class": "verification_failed",
  "failed_stage": "verification",
  "message_excerpt": "Health check did not recover after deployment"
}
```

### `final_output.json`

```json
{
  "execution_result": {
    "summary": "Updated config and restarted service"
  },
  "verification_report": {
    "passed": false,
    "status": "failed"
  }
}
```

---

## 如何开始生成

最简单的方式不是一次到位，而是分三步：

1. 每次任务执行后，先生成 `manifest.json` 和 `final_output.json`
2. 失败时再补 `failure_signature.json`
3. 当你需要更高诊断质量时，再逐步补 `execution_trace.jsonl` 和 `verification_report.json`

这样可以先把 `diagnostic-archive` 用起来，再慢慢升级归档质量。

---

## 与 `archive-schema.md` 的关系

- 本文档回答“这东西是什么、谁来写、怎么起步”
- [`references/archive-schema.md`](./references/archive-schema.md) 负责解释每个文件字段的大致作用

如果你第一次接触 `diagnostic-archive`，建议先读本文，再读 `archive-schema.md`。
