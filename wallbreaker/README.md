# 🔓 wallbreaker

<div align="center">

**破壁人 · 方案对抗式审查层**

[![Version](https://img.shields.io/badge/版本-v0.1-blue?style=flat-square)](./CHANGELOG.md)
[![Platform](https://img.shields.io/badge/平台-Claude%20Code%20%7C%20Opencode%20%7C%20OpenClaw%20%7C%20Codex-blueviolet?style=flat-square)]()
[![Status](https://img.shields.io/badge/状态-Phase%202C-orange?style=flat-square)]()

> **不是为了反对而反对，而是为了让错误在执行前暴露。**

</div>

---

## 🎯 这是什么

`wallbreaker` 是 three-body 第二阶段的第三个战略角色。

它的职责不是产出方案，而是专门挑战方案：

> 这条路径真的成立吗？它依赖了哪些还没验证的前提？

如果 `wallfacer` 负责“把路线想清楚”，那么 `wallbreaker` 负责“把路线拆清楚”。

---

## 🧭 它在体系中的位置

```text
用户任务
  -> 诛仙阵（选模式）
  -> 三体法则（定边界）
  -> 面壁人（出方案）
  -> 破壁人（挑战方案）
  -> 执剑人（高危授权）
  -> 执行 skill
```

---

## ✅ 适用场景

| 场景 | 是否适用 |
|---|:---:|
| 架构方案挑战 | ✅ |
| 迁移路线挑战 | ✅ |
| 高返工成本决策 | ✅ |
| 团队对方向存在争议 | ✅ |
| 简单 bug 修复 | ❌ |
| 普通代码 review | ❌ |
| 普通测试验证 | ❌ |

---

## 📥 输入与输出

### 输入

- `target_plan`
- `decision_context`
- `known_assumptions`
- `risk_profile`

### 输出

- `hidden_assumptions`
- `top_failure_modes`
- `challenge_summary`
- `required_validation`
- `proceed_recommendation`

---

## 🔗 与现有 skill 的关系

### `wallfacer`
负责生成和收敛方案。

### `wallbreaker`
负责拆解方案的前提和弱点。

### `review` / `qa`
偏向检查结果或实现质量，不负责挑战战略方案本身。

### `environment-governance`
负责行为风险约束，不负责方案优劣判断。

---

## 🚀 当前状态

当前版本是 **Phase 2C 的第一版骨架**，优先把破壁人的角色边界、挑战合同和升级标准定义清楚。

接下来还会继续补：

- 更细的 challenge patterns
- 更细的隐藏假设判断规则
- 更清晰的 pushback 阈值

---

## 📁 文件结构

```text
wallbreaker/
├── SKILL.md
├── README.md
├── CHANGELOG.md
├── EXAMPLES.md
└── references/
    ├── challenge-patterns.md
    ├── hidden-assumptions.md
    └── pushback-thresholds.md
```

---

## 📜 许可证

MIT License · 自由使用，欢迎贡献
