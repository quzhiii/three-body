# 🧱 wallfacer

<div align="center">

**面壁人 · 复杂任务深度规划层**

[![Version](https://img.shields.io/badge/版本-v0.1-blue?style=flat-square)](./CHANGELOG.md)
[![Platform](https://img.shields.io/badge/平台-Claude%20Code%20%7C%20Opencode%20%7C%20OpenClaw%20%7C%20Codex-blueviolet?style=flat-square)]()
[![Status](https://img.shields.io/badge/状态-Phase%202B-orange?style=flat-square)]()

> **先在黑暗中把路径想清楚，再决定走哪一条。**

</div>

---

## 🎯 这是什么

`wallfacer` 是 three-body 第二阶段的第二个战略角色。

它负责处理这样的问题：

> 当任务已经被识别为复杂任务时，是否应该先做一次深度规划，而不是直接开始实现？

它不是 router，也不是治理器，更不是执行器。
它的价值在于：**先收敛路径，再进入执行。**

---

## 🧭 它在体系中的位置

```text
用户任务
  -> 诛仙阵（选模式）
  -> 三体法则（定边界）
  -> 面壁人（深度规划）
  -> Code / review / doc / 其他执行 skill
```

当规划中的假设太多、争议太大时：

```text
面壁人 -> 破壁人（挑战方案）
```

---

## ✅ 适用场景

| 场景 | 是否适用 |
|---|:---:|
| 架构重构 | ✅ |
| 多阶段迁移 | ✅ |
| 高耦合模块改造 | ✅ |
| 复杂实现前的路径选择 | ✅ |
| 简单 bug 修复 | ❌ |
| 纯文档撰写 | ❌ |
| 普通只读分析 | ❌ |

---

## 📥 输入与输出

### 输入

- `task`
- `goal`
- `constraints`
- `known_risks`
- `needs_multi_stage_plan`

### 输出

- `candidate_paths`
- `recommended_path`
- `rejected_paths`
- `critical_unknowns`
- `recommended_next_skill`
- `plan_summary`

---

## 🔗 与现有 skill 的关系

### `agent-work-environment-v3`
负责选阵型。它判断“要不要进入规划”。

### `wallfacer`
负责真正完成复杂任务的路径收敛与主方案选择。

### `environment-governance`
在规划过程中继续提供风险边界。

### `wallbreaker`
当主方案的假设太重时，由它来做下一轮挑战。

---

## 🚀 当前状态

当前版本是 **Phase 2B 的第一版骨架**，优先把面壁人的角色边界、规划合同和 handoff 逻辑定义清楚。

接下来还会继续补：

- 更细的规划输出模板
- 路径比较标准
- 交给破壁人的升级规则

---

## 📁 文件结构

```text
wallfacer/
├── SKILL.md
├── README.md
├── CHANGELOG.md
├── EXAMPLES.md
└── references/
    ├── planning-output-format.md
    ├── decision-criteria.md
    └── escalation-to-wallbreaker.md
```

---

## 📜 许可证

MIT License · 自由使用，欢迎贡献
