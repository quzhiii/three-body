# 📁 diagnostic-archive

<div align="center">

**档案读取器 · AI Agent 失败诊断与历史对比**

[![Version](https://img.shields.io/badge/版本-v1.0-blue?style=flat-square)](./SKILL.md)
[![Platform](https://img.shields.io/badge/平台-Claude%20Code-blueviolet?style=flat-square)](https://claude.ai)
[![License](https://img.shields.io/badge/许可-MIT-green?style=flat-square)](../LICENSE)
[![Status](https://img.shields.io/badge/状态-已发布-brightgreen?style=flat-square)]()

> **先看证据，再下结论。原始 traces 优于摘要。**

</div>

---

## 🎯 这是什么

`diagnostic-archive` 是一个专门处理 run 档案的诊断 skill。

它解决两个核心问题：

- 某次 run 失败了，根因到底在哪一层
- 两次 run 看起来都“不对”，真正变化点是什么

它不负责修复问题，也不负责重新执行 run；它只负责按正确顺序读取档案，抽取证据，形成可执行结论。

---

## ✅ 适用场景

| 场景 | 是否适用 |
|---|:---:|
| 某次 run 失败，需要定位根因 | ✅ |
| 两次 run 结果不同，需要对比变化 | ✅ |
| 重试前先判断是否应该读取历史证据 | ✅ |
| 只想看 run 元数据，不做诊断 | ⚠️ 可用，但偏重 |
| 已经确认成功且不需要复盘 | ❌ |

---

## 🔄 标准工作流

按以下顺序工作：

1. 确定 `archive_root` 和目标 `run_id`
2. 读取 `manifest.json`，确认状态与阶段
3. 读取 `failure_signature.json`，定位失败类型
4. 按失败阶段继续读取对应证据文件
5. 形成根因判断与下一步建议
6. 如提供 `compare_run_id`，再执行双 run 对比

默认 archive 根目录：

```text
artifacts/runs/
```

---

## 📦 输出内容

单次诊断至少输出：

- `run_id`
- `status`
- `failure_stage`
- `failure_class`
- `root_cause`
- `key_evidence`
- `uncertainty`
- `recommended_next`

对比模式额外输出：

- `key_changes`
- `regression_risk`

---

## 🚀 快速开始

### 安装

```bash
cp -r diagnostic-archive ~/.claude/skills/
```

### 典型使用场景

```text
用户："上次那次 run 为什么失败了？"
→ 读取 manifest.json
→ 读取 failure_signature.json
→ 按失败阶段继续查 execution / verification / governance 证据
→ 输出根因、关键证据、建议下一步
```

```text
用户："对比一下昨天和今天这两次 run 有什么变化"
→ 定位两次 run
→ 抽取关键差异
→ 评估是否存在回归风险
```

---

## 📁 文件结构

```text
diagnostic-archive/
├── SKILL.md
├── README.md
└── references/
    ├── archive-schema.md
    ├── read-workflow.md
    ├── compare-workflow.md
    └── triage-rules.md
```

---

## 🔗 与其他 skill 的关系

- 与 `agent-work-environment-v3` 配合时，可作为“连续失败后先诊断”的证据层
- 与 `environment-governance` 配合时，可支撑“失败后先看证据，再决定是否重试”的治理原则
- 与执行类 skill 配合时，负责提供根因和证据，不直接负责修复

---

## 📜 许可证

MIT License · 自由使用，欢迎贡献
