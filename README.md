# 🌌 three-body

<div align="center">

**AI Agent 行为治理宇宙 · 以《三体》为灵感**

[![License](https://img.shields.io/badge/许可-MIT-green?style=flat-square)](./LICENSE)
[![Platform](https://img.shields.io/badge/平台-Claude%20Code-blueviolet?style=flat-square)](https://claude.ai)
[![Phase](https://img.shields.io/badge/Phase-1%20·%20法则基础-blue?style=flat-square)](./UNIVERSE.md)
[![Skills](https://img.shields.io/badge/已发布-3%20skills-brightgreen?style=flat-square)]()

> **三体定其界，诛仙阵定其式。**
>
> 一套为 AI Agent 设计的行为约束与任务路由体系，
> 每一个 skill，都是宇宙中的一个角色。

🌐 [English Version](./README_EN.md)

</div>

---

## 💡 为什么叫 three-body

我是刘慈欣《三体》的忠实读者。

小说里，三体文明在极端不稳定的环境中演化出了独特的生存智慧。他们的世界有三个太阳，轨道不可预测，文明在恒纪元和乱纪元之间反复毁灭与重生。为了活下去，三体人发展出了**脱水**、**浸泡**、**极度理性**的生存策略。

AI Agent 面临的处境何其相似：
- 上下文窗口是有限的资源，像三体人的脱水状态
- 用户输入不可预测，像乱纪元的降临
- 一次错误的工具调用，可能毁掉整个会话，像三日凌空

**three-body** 正是借鉴《三体》的核心概念，为 AI Agent 构建一套行为治理体系：**在不确定的环境中，建立确定性的约束与路由规则**。

这不是对原著的简单套用，而是对其精神的致敬——
> 面壁人对智子的静默、执剑人对威慑的理解、黑暗森林中"不暴露即安全"的生存哲学。

---

## 🎭 命名逻辑：三体 × 诛仙阵

### 科幻与神话的融合

| 文化来源 | 代表概念 | 体系定位 | 核心功能 |
|:---:|:---|:---|:---|
| 📚 刘慈欣《三体》 | **三体法则** | 治理层 | 定义边界、约束行为 |
| ⚔️ 中国神话 | **诛仙阵** | 战术层 | 提供路径、灵活执行 |

### 三体 —— 宇宙法则层

《三体》小说强调：在一个不可预测的宇宙中，生存的第一要义是**认清边界**。

- **脱水**：资源有限时保存实力 → 上下文预算管理
- **乱纪元**：环境突变时的应对策略 → 风险升级机制
- **黑暗森林**：暴露即危险 → 确认文化（不确认即暴露）
- **执剑人威慑**：拥有毁灭权的人选择不开火 → 高危操作的最终授权

**三体代表"约束"**——告诉 Agent 什么不能做、在什么情况下必须停下。

### 诛仙阵 —— 战术执行层

诛仙阵是中国神话中的顶级杀阵，阵内变化万千，入阵者需按特定路径破阵。

- **观阵势** → 先看清再动 → **观机阵**（研究模式）
- **破阵眼** → 直击核心 → **破局阵**（实现模式）
- **验阵法** → 检查无漏 → **明鉴阵**（验证模式）
- **立阵图** → 记录方案 → **立言阵**（写作模式）
- **行军令** → 高风险慎行 → **行令阵**（运维模式）

**诛仙阵代表"变化"**——在约束之下，仍有灵活的战术选择。

### 两者的逻辑关系

```
┌─────────────────────────────────────────────────────────────────┐
│                        宇宙层 · UNIVERSE                         │
│                                                                  │
│                        📚 三  体                                 │
│                   Three-Body Problem                             │
│                                                                  │
│              "在不可预测的宇宙中建立确定性边界"                   │
│                                                                  │
│   ┌──────────────┬────────────────────────────────────────┐     │
│   │   脱水生存   │  上下文是有限的，必须精打细算          │     │
│   │   黑暗森林   │  不确认即暴露，暴露即错误              │     │
│   │   执剑人威慑 │  高危操作需要最终授权                  │     │
│   └──────────────┴────────────────────────────────────────┘     │
│                              │                                   │
│                              ▼ 法则约束下的战术选择               │
│   ╔══════════════════════════════════════════════════════╗      │
│   ║                                                    ║      │
│   ║   三 体 定 其 界                                   ║      │
│   ║   Three-Body Laws define the boundary             ║      │
│   ║                                                    ║      │
│   ╚══════════════════════════════════════════════════════╝      │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                        战术层 · TACTICS                          │
│                                                                  │
│                        ⚔️ 诛仙阵                                 │
│                   Formation Router                               │
│                                                                  │
│              "在约束之下，用阵法变化求生存"                       │
│                                                                  │
│        ┌─────────┐    ┌─────────┐    ┌─────────┐               │
│        │ 观机阵  │───▶│ 破局阵  │───▶│ 明鉴阵  │               │
│        │ 研究    │    │ 实现    │    │ 验证    │               │
│        └─────────┘    └─────────┘    └─────────┘               │
│              │                                     │            │
│              └────────────┬────────────────────────┘            │
│                           ▼                                     │
│        ┌─────────┐    ┌─────────┐                              │
│        │ 立言阵  │    │ 行令阵  │                              │
│        │ 写作    │    │ 运维    │                              │
│        └─────────┘    └─────────┘                              │
│                                                                  │
│   ╔══════════════════════════════════════════════════════╗      │
│   ║                                                    ║      │
│   ║   诛 仙 阵 定 其 式                                ║      │
│   ║   Formation decides the approach                  ║      │
│   ║                                                    ║      │
│   ╚══════════════════════════════════════════════════════╝      │
└─────────────────────────────────────────────────────────────────┘
```

**一句话总结**：
> **三体定其界（法则约束），诛仙阵定其式（战术执行）。**
> 
> 冷酷的宇宙法则 + 玄妙的东方阵法 = 既安全又灵活的 AI Agent 治理体系。

---

## 🎯 解决什么问题

AI Agent 在使用中面临两个根本问题：

| 问题 | 表现 | three-body 的回答 |
|---|---|---|
| **怎么做更安全？** | 不知道何时停下来确认，盲目执行高危操作 | 三体法则（`environment-governance`）|
| **用什么模式做？** | 面对模糊任务不知道进入哪种工作状态 | 诛仙阵（`agent-work-environment-v3`）|

两层**解耦设计**：法则层管约束，路由层管模式。各自独立，也可组合。

---

## 🏗️ 当前架构（Phase 1）

```
┌──────────────────────────────────────────────────────────┐
│                   应用层 · APPLICATION                    │
│                                                          │
│   ⚔️ Formation Router          📁 Archive Reader         │
│   agent-work-environment-v3    diagnostic-archive        │
│   诛仙阵 · 五阵型任务路由       档案读取器 · 失败诊断      │
│                                                          │
├──────────────────────────────────────────────────────────┤
│                   治理层 · GOVERNANCE                     │
│                                                          │
│              ⚖️ Three-Body Laws                          │
│              environment-governance                      │
│         五条法则 · 4信号模型 · 动态偏置计算              │
│                                                          │
│   底层精神：黑暗森林法则（不暴露即安全，执剑人威慑）      │
│                                                          │
├──────────────────────────────────────────────────────────┤
│                   执行层 · EXECUTION                      │
│         Code · review · careful · guard · ...            │
└──────────────────────────────────────────────────────────┘
```

---

## 📦 已发布 Skills

### ⚖️ Three-Body Laws — 三体法则
**`environment-governance`** · v1.0 · [查看详情](./environment-governance/README.md)

独立的行为约束层。五条法则 + 4 信号模型，动态计算 Agent 在不同风险场景下的行为边界。

```
五条法则：上下文预算 · 工具边界 · 风险升级 · 写回策略 · 诊断访问
4 个信号：risk_level · task_complexity · has_failed · write_intent
```

---

### ⚔️ Formation Router — 诛仙阵
**`agent-work-environment-v3`** · v3.0 · [查看详情](./agent-work-environment-v3/README.md)

纯任务路由器。识别任务意图 → 选定五阵型之一 → 输出任务信号 → 推荐下游 skill。

```
五阵型：观机阵（研究）· 破局阵（实现）· 明鉴阵（验证）· 立言阵（写作）· 行令阵（运维）
```

---

### 📁 Archive Reader — 档案读取器
**`diagnostic-archive`** · v1.0 · [查看详情](./diagnostic-archive/README.md)

失败诊断与历史对比。读取 run 档案，定位根因，支持单次诊断和双次对比。

---

### 🔶 Formation Classic — 诛仙阵组合版（兼容保留）
**`agent-work-environment`** · v2.1 · [查看详情](./agent-work-environment/README.md)

路由 + 治理一体化版本。不想分开管理时的开箱即用选项，不再主动迭代。

---

## 🖥️ 适配平台

three-body 适用于以下 AI Agent 开发环境：

| 平台 | 标识 | 安装方式 | 状态 |
|:---:|:---:|:---|:---:|
| **Claude Code** | `claude` | Skill 目录安装 | ✅ 已验证 |
| **Opencode** | `opencode` | Skill 目录安装 | ✅ 已验证 |
| **OpenClaw** | `openclaw` | Skill 目录安装 | ✅ 已验证 |
| **Codex CLI** | `codex` | 配置 / MCP 方式 | ✅ 已验证 |

### 各平台详细安装

#### Claude Code

```bash
# 推荐：安装拆分版（v3.0）
cp -r three-body/environment-governance ~/.claude/skills/
cp -r three-body/agent-work-environment-v3 ~/.claude/skills/

# 可选：档案读取器
cp -r three-body/diagnostic-archive ~/.claude/skills/

# 验证安装
claude skills list
```

#### Opencode

```bash
# 推荐：安装拆分版（v3.0）
cp -r three-body/environment-governance ~/.opencode/skills/
cp -r three-body/agent-work-environment-v3 ~/.opencode/skills/

# 验证安装
opencode skills list
```

#### OpenClaw

OpenClaw 支持通过 Skill 目录加载自定义技能：

```bash
# 创建 OpenClaw 的 skills 目录（如不存在）
mkdir -p ~/.openclaw/skills

# 安装 three-body skills
cp -r three-body/environment-governance ~/.openclaw/skills/
cp -r three-body/agent-work-environment-v3 ~/.openclaw/skills/
cp -r three-body/diagnostic-archive ~/.openclaw/skills/

# 在 OpenClaw 配置中启用（通常在 ~/.openclaw/config.yaml）
# skills:
#   - environment-governance
#   - agent-work-environment-v3
#   - diagnostic-archive
```

#### Codex CLI

Codex CLI 通过 **系统提示（System Prompt）** 或 **MCP (Model Context Protocol)** 方式引入：

**方式一：系统提示（推荐）**

创建或编辑 Codex 配置文件：

```bash
# macOS/Linux
mkdir -p ~/.codex
cat > ~/.codex/config.toml << 'EOF'
[system]
prompt = """
You are an AI Agent with three-body governance.

Always follow these principles from the Three-Body Laws:
1. Context Budget - Conserve context window, load on demand
2. Tool Boundary - Prefer low-risk tools, confirm high-risk ones
3. Risk Escalation - Pause before destructive operations
4. Writeback Policy - Confirm based on change type
5. Diagnostic Access - Read raw evidence when debugging

For task routing, use the Zhu Xian Formation approach:
- Research tasks → Guan Ji Formation (observation mode)
- Implementation → Po Ju Formation (breakthrough mode)
- Verification → Ming Jian Formation (inspection mode)
- Writing → Li Yan Formation (documentation mode)
- Operations → Xing Ling Formation (command mode with extra caution)
"""
EOF
```

**方式二：MCP 方式（如果支持）**

在 Codex 的 MCP 配置中添加：

```json
{
  "mcpServers": {
    "three-body-governance": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem"],
      "env": {
        "SKILLS_PATH": "~/three-body"
      }
    }
  }
}
```

**方式三：直接使用 SKILL.md 内容**

将 `environment-governance/SKILL.md` 和 `agent-work-environment-v3/SKILL.md` 的内容复制到 Codex 的系统提示中。

### 使用方式

安装后，在对话中直接使用触发词即可：

| 触发场景 | 说明 |
|---|---|
| `"帮我分析下这个模块"` | 自动进入诛仙阵 → 观机阵（研究模式） |
| `"实现这个功能，但要小心"` | 自动进入诛仙阵 → 破局阵（实现模式）+ 三体法则约束 |
| `"上次那个 run 为什么失败了"` | 调用档案读取器进行失败诊断 |
| `"部署到生产环境"` | 自动进入行令阵（运维模式）+ 强制执剑人授权流程 |

---

## 🚀 快速安装（Claude Code 示例）

```bash
# 推荐：拆分版（v3.0），路由与治理分离
cp -r environment-governance ~/.claude/skills/
cp -r agent-work-environment-v3 ~/.claude/skills/

# 可选：失败诊断
cp -r diagnostic-archive ~/.claude/skills/

# 或者：组合版（v2.1），开箱即用
cp -r agent-work-environment ~/.claude/skills/
```

---

## 🌍 宇宙规划（Phase 2+）

three-body 是一个持续扩张的宇宙。已规划的角色：

| 角色 | 候选 ID | 定义 | 阶段 |
|:---:|---|---|:---:|
| ⚔️ **执剑人** | `swordbearer` | 高危操作最终授权者，威慑 > 拦截 | Phase 2 |
| 🧱 **面壁人** | `wallfacer` | 独立深度规划，不暴露中间意图 | Phase 2 |
| 🔓 **破壁人** | `wallbreaker` | 质疑现有方案，寻找未验证假设 | Phase 2 |
| 👁️ **智子** | `sophon` | 跨 session 记忆，全局模式识别 | Phase 3 |

→ [完整宇宙地图](./UNIVERSE.md)

---

## 💡 设计哲学

**1. 分层而非一体化**
路由层（诛仙阵）与治理层（三体法则）解耦。每层独立演进，独立复用。

**2. 信号驱动，而非规则堆砌**
4 个信号实时计算偏置，无需为每个场景手写规则。

**3. 硬确认不可绕过**
删除、强推、凭证变更——无论用户怎么催，法则层有最终否决权。

**4. 名字即设定**
执剑人的威慑哲学、面壁人的深度规划、智子的全知视角——角色名字本身就是行为逻辑的说明书。

---

## 📁 项目结构

```
three-body/
├── README.md                        # 本文件（中文版）
├── README_EN.md                     # 英文版
├── UNIVERSE.md                      # 宇宙全图与规划
│
├── environment-governance/          # ⚖️ 三体法则（治理层）
│   ├── SKILL.md
│   └── references/
│       ├── laws.md
│       ├── default-bias.md
│       └── escalation-matrix.md
│
├── agent-work-environment-v3/       # ⚔️ 诛仙阵（路由层，主推）
│   ├── SKILL.md
│   └── references/
│       ├── formations.md
│       └── formation-law-mapping.md
│
├── diagnostic-archive/              # 🔍 黑暗森林档案
│   ├── SKILL.md
│   └── references/
│
├── agent-work-environment/          # 🔶 组合版（兼容保留）
│   ├── SKILL.md
│   └── references/
│
└── _backup/
    └── agent-work-environment-v2.1/
```

---

## 📜 许可证

MIT License — 自由使用，欢迎贡献。

---

<div align="center">

**三体定其界（怎么做），诛仙阵定其式（做什么）。**

[宇宙地图](./UNIVERSE.md) · [三体法则](./environment-governance/README.md) · [诛仙阵](./agent-work-environment-v3/README.md)

🌐 [English Version](./README_EN.md)

</div>
