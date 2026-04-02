# 🏛️ environment-governance

<div align="center">

**三体法则 · AI Agent 行为约束层**

[![Version](https://img.shields.io/badge/版本-v1.0-blue?style=flat-square)](./CHANGELOG.md)
[![Platform](https://img.shields.io/badge/平台-Claude%20Code-blueviolet?style=flat-square)](https://claude.ai)
[![License](https://img.shields.io/badge/许可-MIT-green?style=flat-square)](../LICENSE)
[![Status](https://img.shields.io/badge/状态-主推-brightgreen?style=flat-square)]()

> **三体定其界：不负责"做什么"，只负责"怎么做更安全"。**

</div>

---

## 🎯 这是什么

`environment-governance` 是一个**独立的 AI Agent 行为约束层**，基于"三体法则"设计。

它解决一个核心问题：**AI Agent 在执行任务时，如何在不同风险场景下动态调整行为边界？**

- ✅ **不是**任务路由器（不负责判断"该做什么"）
- ✅ **不是**执行器（不直接操作文件或运行命令）
- ✅ **是**行为约束层（负责"怎么做更安全"）

可**独立使用**，也可作为 [`agent-work-environment-v3`](../agent-work-environment-v3) 的下游治理层。

---

## 💡 核心设计：五条法则 + 4 信号模型

### 五条三体法则

| 法则 | 核心原则 | 关键效果 |
|:---:|---|---|
| ⚖️ **上下文预算** | 上下文是公共资源，按需加载，不过载 | 防止长任务膨胀，简单任务防过度准备 |
| 🔧 **工具边界** | 低风险工具优先，高权限工具必须确认 | 防止习惯性调用高危工具 |
| 🚨 **风险升级** | 高风险操作前强制停顿确认 | 删除、强推、凭证操作等硬拦截 |
| ✍️ **写回策略** | 按变更类型分级，风险逐级递增 | 文档 ＜ 代码 ＜ 配置 ＜ 删除 |
| 🔍 **诊断访问** | 历史证据按需读取，不看总结看原始 | 连续失败时精准定位，而非盲目重试 |

### 4 信号驱动模型

法则不是固定的。它们根据 **4 个实时信号**自动调整偏置强度：

```
┌──────────────────────────────────────────────┐
│              4 信号输入                        │
│                                              │
│  risk_level      低 / 中 / 高               │
│  task_complexity 简单 / 中等 / 复杂          │
│  has_failed      是 / 否                    │
│  write_intent    只读/文档/代码/配置/删除    │
│                                              │
└──────────────────┬───────────────────────────┘
                   │
                   ▼
┌──────────────────────────────────────────────┐
│         五条法则自动偏置计算                   │
│                                              │
│  工具边界偏置 ← risk_level + write_intent    │
│  风险升级阈值 ← risk_level + has_failed      │
│  写回确认强度 ← write_intent + has_failed    │
│  上下文预算   ← task_complexity              │
│  诊断访问策略 ← has_failed + risk_level      │
│                                              │
└──────────────────┬───────────────────────────┘
                   │
                   ▼
         输出：当前约束配置 + 边界声明
```

**无需预设模板**，信号组合即策略。

---

## 🚀 快速开始

### 安装

```bash
# 克隆仓库后
cp -r environment-governance ~/.claude/skills/
```

### 触发方式

在 Claude Code 中，遇到以下场景时直接调用：

```
用户："帮我修这个 bug，要小心别影响其他模块"
→ 直接使用 environment-governance
→ 输入信号：risk=中, write=代码, failed=否
→ 输出：工具边界 + 写回策略 + 本轮约束配置
```

```
用户："把生产环境的配置改一下"
→ 直接使用 environment-governance
→ 输入信号：risk=高, write=配置, failed=否
→ 输出：强制确认触发，操作前逐步说明影响
```

### 信号速查

| 场景 | risk_level | write_intent | has_failed |
|---|---|---|---|
| 只读分析 | 低 | 只读 | 否 |
| 修 bug | 中 | 代码 | 否 |
| 修了还失败 | 中 | 代码 | **是** |
| 改配置文件 | 高 | 配置 | 否 |
| 删除操作 | 高 | 删除 | 任意 |

---

## 🔗 与诛仙阵配合使用

`environment-governance` 可以与 [`agent-work-environment-v3`（诛仙阵）](../agent-work-environment-v3)组合，形成完整的**路由 + 治理**双层架构：

```
诛仙阵（路由层）                    三体法则（治理层）
agent-work-environment-v3    →     environment-governance
        │                                  │
  识别任务意图                       接收 4 个任务信号
  选定五阵型之一                     计算法则偏置强度
  输出任务信号 ──────────────────→   输出当前约束配置
        │                                  │
        └──────────────────────────────────┘
                     ↓
               合并输出给 Agent
         （阵型 + 信号 + 法则 + 下游推荐）
```

**两层均可独立使用**，不强制绑定。

---

## 📁 文件结构

```
environment-governance/
├── SKILL.md                    # 触发条件、输入输出合同、偏置工作流
├── README.md                   # 本文件
├── CHANGELOG.md                # 版本历史
└── references/
    ├── laws.md                 # 五条法则的完整定义与示例
    ├── default-bias.md         # 4信号 → 偏置映射速查表
    └── escalation-matrix.md   # 高风险动作硬确认模板 + 失败升级矩阵
```

---

## ✅ 适用场景

| 场景 | 是否适用 |
|---|:---:|
| 即将执行高风险操作（删除、强推、部署） | ✅ |
| 任务需要写入文件、修改配置 | ✅ |
| 连续失败后需要先调整约束再重试 | ✅ |
| 作为路由器的下游治理层 | ✅ |
| 纯对话、纯查询、无任何写操作 | ❌ |
| 只做任务路由，不想管行为边界 | ❌ |

---

## 🏗️ 架构定位

```
┌─────────────────────────────────────────────────┐
│              应用层 (Application)                │
│  agent-work-environment-v3 / diagnostic-archive  │
├─────────────────────────────────────────────────┤
│              治理层 (Governance)                 │
│          ★  environment-governance  ★            │
│    上下文预算 · 工具边界 · 风险升级               │
│    写回策略 · 诊断访问                           │
├─────────────────────────────────────────────────┤
│              执行层 (Execution)                  │
│   Code · review · careful · guard · 自定义 skill │
└─────────────────────────────────────────────────┘
```

治理层是**整个体系的地基**。无论上层用什么路由，下层执行什么操作，行为边界始终由 `environment-governance` 提供。

---

## 📦 版本

| 版本 | 状态 | 说明 |
|---|---|---|
| v1.0 | ✅ 当前版本 | 独立三体法则，5 法则 + 4 信号模型 |

历史版本见 [CHANGELOG.md](./CHANGELOG.md)。

---

## 🔗 相关项目

- [agent-work-environment-v3](../agent-work-environment-v3) — 诛仙阵任务路由器（主推搭档）
- [agent-work-environment](../agent-work-environment) — v2.1 路由+治理组合版（兼容保留）
- [diagnostic-archive](../diagnostic-archive) — 失败诊断与历史对比

---

<div align="center">

**三体定其界，诛仙阵定其式。**

MIT License · 自由使用，欢迎贡献

</div>
