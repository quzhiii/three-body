# ⚔️ agent-work-environment-v3

<div align="center">

**诛仙阵 · AI Agent 任务路由器**

[![Version](https://img.shields.io/badge/版本-v3.0-blue?style=flat-square)](./CHANGELOG.md)
[![Platform](https://img.shields.io/badge/平台-Claude%20Code-blueviolet?style=flat-square)](https://claude.ai)
[![License](https://img.shields.io/badge/许可-MIT-green?style=flat-square)](../../LICENSE)
[![Status](https://img.shields.io/badge/状态-主推-brightgreen?style=flat-square)]()
[![Requires](https://img.shields.io/badge/依赖-environment--governance-orange?style=flat-square)](../environment-governance)

> **诛仙阵定其式：不负责"怎么做"，只负责"用什么模式做"。**

</div>

---

## 🎯 这是什么

`agent-work-environment-v3` 是一个**纯任务路由 skill**，也是"诛仙阵"的 v3 实现。

它解决一个核心问题：**面对一个模糊的任务请求，AI Agent 应该进入哪种工作模式？**

- ✅ **是**任务路由器（识别意图 → 选定阵型 → 输出信号）
- ✅ **是**模式切换器（任务性质变化时自动切阵）
- ✅ **不内嵌**行为约束（约束由 [`environment-governance`](../environment-governance) 提供）

v3 相比 v2.1 的最大变化：**路由与治理彻底解耦**，各司其职。

---

## 🏯 五阵型详解

诛仙阵包含五个阵型，覆盖 AI Agent 任务的全生命周期：

```
                        ┌──────────────┐
          调研分析 ────▶ │   观机阵      │ research_mode
                        │  risk=低     │
                        │  write=只读  │
                        └──────────────┘

                        ┌──────────────┐
          实现修复 ────▶ │   破局阵      │ coding_mode
                        │  risk=中     │
                        │  write=代码  │
                        └──────────────┘

                        ┌──────────────┐
          验证审查 ────▶ │   明鉴阵      │ verification_mode
                        │  risk=低     │
                        │  write=只读  │
                        └──────────────┘

                        ┌──────────────┐
          文档写作 ────▶ │   立言阵      │ writing_mode
                        │  risk=低     │
                        │  write=文档  │
                        └──────────────┘

                        ┌──────────────┐
          部署运维 ────▶ │   行令阵      │ ops_mode
                        │  risk=高     │
                        │  write=配置  │
                        └──────────────┘
```

| 阵型 | 触发关键词 | 输出信号组合 | 推荐下游 skill |
|:---:|---|---|---|
| 🔭 **观机阵** | 分析、调研、理解、先看看 | risk=低, complexity=复杂, write=只读 | `explore` / `librarian` |
| ⚡ **破局阵** | 实现、修复、重构、加功能 | risk=中, complexity=中等, write=代码 | `Code` / `systematic-debugging` |
| 🔍 **明鉴阵** | 验证、review、检查、确认 | risk=低, complexity=中等, write=只读 | `review` / `qa` |
| 📝 **立言阵** | 写文档、总结、出方案 | risk=低, complexity=中等, write=文档 | `doc-coauthoring` / `writing-plans` |
| 🚀 **行令阵** | 部署、迁移、改配置、删除 | risk=高, write=配置/删除 | `careful` / `guard` |

---

## 🔄 工作流程

```
用户输入
    │
    ▼
识别任务意图
    │
    ▼
选定阵型（五选一）
    │
    ├─ 输出 4 个任务信号 ──────────────▶  environment-governance
    │  risk_level                              │
    │  task_complexity                    计算法则偏置
    │  has_failed                              │
    │  write_intent                            ▼
    │                                    返回当前约束配置
    │
    ▼
合并输出：
  · 阵型名称 + 完成标准
  · 4 个任务信号
  · 约束配置（来自 governance）
  · 推荐下游 skill
    │
    ▼
任务执行
    │
任务性质变化？
    ├─ 是 → 切阵，重新计算
    └─ 否 → 继续当前阵型
```

---

## 🚀 快速开始

### 安装

```bash
# 需要同时安装两个 skill（路由 + 治理）
cp -r agent-work-environment-v3 ~/.claude/skills/
cp -r environment-governance ~/.claude/skills/
```

### 典型使用场景

**场景 1：多阶段任务**
```
用户："先帮我分析这个缓存层值不值得重构，确认后再改"

→ 观机阵（研究阶段）
  信号：risk=低, complexity=复杂, write=只读
  输出：分析结论 + 建议

  ── 用户确认后 ──

→ 破局阵（实现阶段）
  信号：risk=中, complexity=中等, write=代码
  输出：实施重构

  ── 完成后自动 ──

→ 明鉴阵（验证阶段）
  信号：risk=低, complexity=中等, write=只读
  输出：验证无回归
```

**场景 2：高风险运维**
```
用户："把修好的服务部署到生产环境"

→ 行令阵（运维阶段）
  信号：risk=高, write=配置
  触发：environment-governance 风险升级=最高
  效果：每步操作前强制说明原因、影响、替代方案
```

**场景 3：意图模糊时**
```
用户："帮我看看这个"

→ 诛仙阵自动识别：调研性意图
→ 进入观机阵（最保守选择）
→ 完成分析后询问：是否进入实现阶段？
```

---

## 🆚 v3.0 vs v2.1 对比

| 特性 | v2.1 组合版 | v3.0 拆分版（本 skill） |
|---|:---:|:---:|
| 路由功能 | ✅ | ✅ |
| 内置治理层 | ✅（耦合） | ❌（解耦，独立依赖） |
| 治理层可复用 | ❌ | ✅ |
| 独立测试 | 困难 | 容易 |
| 适合新用户 | ✅ 开箱即用 | 需多装一个 skill |
| 推荐状态 | 兼容保留 | **当前主推** |

---

## 📁 文件结构

```
agent-work-environment-v3/
├── SKILL.md                       # 路由合同、阵型选择逻辑、交接格式
├── README.md                      # 本文件
├── CHANGELOG.md                   # 版本历史
├── INTEGRATIONS.md                # 与其他 skill 的集成说明
└── references/
    ├── formations.md              # 五阵型完整定义、完成标准、检查清单
    └── formation-law-mapping.md   # 阵型 → 4 信号映射速查表
```

---

## 🔗 与 environment-governance 的关系

```
agent-work-environment-v3          environment-governance
（诛仙阵 · 路由层）           →    （三体法则 · 治理层）

只决定"做什么模式"              只决定"怎么做更安全"
输出任务信号                    接收信号，计算约束
不管执行细节                    不管任务类型
```

**两者协作，形成完整的 Agent 行为框架**：
- 路由层决定阵型 → 产生信号
- 治理层接收信号 → 产生约束
- Agent 拿到"阵型 + 约束"后才开始执行

---

## ✅ 适用场景

| 场景 | 是否适用 |
|---|:---:|
| 任务意图模糊，需要先判断工作模式 | ✅ |
| 多阶段任务（研究→实现→验证→写文档） | ✅ |
| 需要灵活切换工作模式 | ✅ |
| 想独立复用治理层到其他 skill | ✅ |
| 只想要行为约束，不需要路由 | ❌（直接用 `environment-governance`） |
| 任务意图非常明确，直接执行 | ❌（直接用对应执行 skill） |

---

## 🏗️ 架构定位

```
┌─────────────────────────────────────────────────┐
│              应用层 (Application)                │
│      ★  agent-work-environment-v3  ★             │
│        诛仙阵 · 五阵型 · 任务路由                │
├─────────────────────────────────────────────────┤
│              治理层 (Governance)                 │
│           environment-governance                 │
│    上下文预算 · 工具边界 · 风险升级               │
├─────────────────────────────────────────────────┤
│              执行层 (Execution)                  │
│   Code · review · careful · guard · 自定义 skill │
└─────────────────────────────────────────────────┘
```

---

## 📦 版本

| 版本 | 状态 | 说明 |
|---|---|---|
| v3.0 | ✅ 当前版本 | 路由与治理解耦，纯路由器 |
| v2.1 | 🔶 兼容保留 | 组合版，见 [agent-work-environment](../agent-work-environment) |

历史版本见 [CHANGELOG.md](./CHANGELOG.md)。

---

## 🔗 相关项目

- [environment-governance](../environment-governance) — 三体法则治理层（**必须配合安装**）
- [agent-work-environment](../agent-work-environment) — v2.1 路由+治理组合版（兼容保留）
- [diagnostic-archive](../diagnostic-archive) — 失败诊断与历史对比

---

<div align="center">

**三体定其界，诛仙阵定其式。**

MIT License · 自由使用，欢迎贡献

</div>
