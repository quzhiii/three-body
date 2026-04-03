# ⚔️ swordbearer

<div align="center">

**执剑人 · 高危动作最终授权层**

[![Version](https://img.shields.io/badge/版本-v0.1-blue?style=flat-square)](./CHANGELOG.md)
[![Platform](https://img.shields.io/badge/平台-Claude%20Code%20%7C%20Opencode%20%7C%20OpenClaw%20%7C%20Codex-blueviolet?style=flat-square)]()
[![Status](https://img.shields.io/badge/状态-Phase%202A-orange?style=flat-square)]()

> **威慑不是为了毁灭，而是为了阻止轻率的毁灭。**

</div>

---

## 🎯 这是什么

`swordbearer` 是 three-body 第二阶段的第一个战略角色。

它的职责很单一：

> 当系统已经判断某个动作足够危险时，由谁来做最终授权判断？

它不负责路由任务，不负责定义法则，也不直接执行动作。
它只负责在高风险场景里给出最终结论：**允许 / 暂缓 / 拒绝 / 先补信息**。

---

## 🧭 它在体系中的位置

```text
用户任务
  -> 诛仙阵（选模式）
  -> 三体法则（识别风险）
  -> 执剑人（做最终授权）
  -> careful / guard / 执行 skill
```

### 它不做什么

- 不替代 `environment-governance`
- 不替代 `agent-work-environment-v3`
- 不替代 `careful` / `guard`
- 不做实现质量 review

---

## ✅ 适用场景

| 场景 | 是否适用 |
|---|:---:|
| 删除生产数据 | ✅ |
| 生产配置变更 | ✅ |
| 强制 push 到共享分支 | ✅ |
| 修改凭证 / secrets | ✅ |
| 普通代码修复 | ❌ |
| 普通文档编辑 | ❌ |
| 只读分析 | ❌ |

---

## 📥 输入与输出

### 输入

- `proposed_action`
- `risk_source`
- `impact_scope`
- `rollback_plan`
- `alternatives_considered`
- `failure_context`

### 输出

- `authorization_status`
- `decision_reason`
- `required_clarifications`
- `recommended_next_skill`
- `deterrence_summary`

---

## 🔗 与现有 skill 的关系

### `environment-governance`
负责识别高风险、给出升级建议。

### `swordbearer`
负责在此基础上做最后的推进判断。

### `diagnostic-archive`
如果动作之所以危险，是因为之前已经多次失败，应先用它看证据。

---

## 🚀 当前状态

当前版本是 **Phase 2A 的第一版骨架**，优先把角色边界和授权合同定义清楚。

接下来还会继续补：

- 更细的授权矩阵
- 更明确的高危动作列表
- 与顶层安装 / 打包 / 验证脚本的接入

---

## 📁 文件结构

```text
swordbearer/
├── SKILL.md
├── README.md
├── CHANGELOG.md
└── references/
    ├── authorization-matrix.md
    └── high-risk-actions.md
```

---

## 📜 许可证

MIT License · 自由使用，欢迎贡献
