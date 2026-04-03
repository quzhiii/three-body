# 🏗️ three-body Architecture

> 这份文档是 three-body 的**系统关系说明书**。  
> 如果 README 是入口页，这里就是正式的结构图、调用协议和技术路线说明。

---

## 1. 总体目标

three-body 不是单一 skill，而是一套 **AI Agent 行为治理体系**。

它解决的不是某一个具体功能，而是 4 个连续问题：

1. **当前应该用什么模式做？**
2. **这一步应该遵守什么边界？**
3. **在复杂任务里，方案该怎么制定与审查？**
4. **如果失败了，应该回到哪里看证据？**

因此，three-body 被设计为一个 **分层架构**，而不是一个“大总控 skill”。

---

## 2. 四层架构

```text
┌────────────────────────────────────────────────────────────┐
│                      战术层 · TACTICS                      │
│                                                            │
│   agent-work-environment-v3                                │
│   诛仙阵：根据任务意图选择工作模式                         │
└────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌────────────────────────────────────────────────────────────┐
│                    治理层 · GOVERNANCE                     │
│                                                            │
│   environment-governance                                   │
│   三体法则：根据任务信号定义行为边界                       │
└────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌────────────────────────────────────────────────────────────┐
│                     战略层 · STRATEGY                      │
│                                                            │
│   wallfacer   → 深度规划                                   │
│   wallbreaker → 挑战方案                                   │
│   swordbearer → 高危授权                                   │
└────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌────────────────────────────────────────────────────────────┐
│                   证据层 · DIAGNOSTICS                     │
│                                                            │
│   diagnostic-archive                                       │
│   档案读取器：失败后读取 run 档案、定位根因                │
└────────────────────────────────────────────────────────────┘
```

---

## 3. 角色总表

| Skill | 层级 | 负责什么 | 不负责什么 |
|---|---|---|---|
| `agent-work-environment-v3` | 战术层 | 选阵型、选模式、决定下一步工作方式 | 不定义安全法则、不深度规划、不做授权 |
| `environment-governance` | 治理层 | 根据信号决定边界、升级、确认要求 | 不路由、不执行、不做最终授权 |
| `wallfacer` | 战略层 | 对复杂任务做深度规划，输出候选路径与主路径 | 不选阵型、不做挑战、不直接执行 |
| `wallbreaker` | 战略层 | 对已有方案进行对抗式审查，找隐含假设和失败点 | 不生成初始方案、不做普通 code review |
| `swordbearer` | 战略层 | 对高危动作做最终授权判断 | 不识别全部风险、不直接执行动作 |
| `diagnostic-archive` | 证据层 | 读取 archive、抽取证据、解释失败原因 | 不修复问题、不重跑任务、不代替治理 |
| `agent-work-environment` | 兼容层 | 提供旧的一体化入口 | 不代表当前主架构方向 |

---

## 4. 默认调用顺序

### 4.1 普通任务

```text
用户任务
  -> agent-work-environment-v3
  -> environment-governance
  -> execution skill
```

适用于：
- 简单 bug 修复
- 普通实现任务
- 明确单路径任务

---

### 4.2 复杂任务

```text
用户任务
  -> agent-work-environment-v3
  -> environment-governance
  -> wallfacer
  -> execution skill
```

适用于：
- 架构重构
- 多阶段迁移
- 复杂高耦合改造

原则：
> 先规划，再执行。

---

### 4.3 复杂且争议大的任务

```text
用户任务
  -> agent-work-environment-v3
  -> environment-governance
  -> wallfacer
  -> wallbreaker
  -> execution skill
```

适用于：
- 已有方案但假设很多
- 高返工成本路径
- 团队/用户对方向存在争议

原则：
> 先出方案，再拆方案。

---

### 4.4 高危任务

```text
用户任务
  -> agent-work-environment-v3
  -> environment-governance
  -> swordbearer
  -> careful / guard / execution skill
```

适用于：
- 生产配置修改
- 凭证变更
- force push
- 删除类操作

原则：
> 先识别风险，再决定放不放行。

---

### 4.5 高危且失败过的任务

```text
用户任务
  -> agent-work-environment-v3
  -> environment-governance
  -> diagnostic-archive
  -> swordbearer
  -> execution skill
```

适用于：
- 连续失败后仍计划执行高危动作
- 证据不足但要强行推进

原则：
> 先看证据，再谈授权。

---

## 5. 关键边界说明

### 5.1 `environment-governance` vs `swordbearer`

这是 three-body 中最重要的一组边界。

#### `environment-governance`
- 判断风险高不高
- 是否必须确认
- 是否应该先升级/先诊断

#### `swordbearer`
- 在高危动作已被识别后
- 做最终 allow / pause / deny / needs_more_context 判断

一句话：

> `environment-governance` **负责识别风险**，`swordbearer` **负责决定是否放行**。

---

### 5.2 `wallfacer` vs `wallbreaker`

#### `wallfacer`
- 负责收敛方案
- 给出候选路径与主路径

#### `wallbreaker`
- 负责拆解方案
- 找出盲点、失败模式和未验证前提

一句话：

> `wallfacer` **负责出方案**，`wallbreaker` **负责拆方案**。

---

### 5.3 `diagnostic-archive` vs 战略层

`diagnostic-archive` 只负责 **证据读取**。

它不做：
- 方案生成
- 风险裁决
- 最终授权

但它经常成为战略层的前置条件，尤其是：

- 连续失败后
- 高危动作前
- 方案争议需要证据支持时

一句话：

> `diagnostic-archive` **提供事实**，战略层 **解释如何行动**。

---

## 6. 技术路线

### Phase 1：建立法则基础

目标：先把系统最基础的问题解决

- `environment-governance`：行为边界
- `agent-work-environment-v3`：任务路由
- `diagnostic-archive`：证据读取

核心价值：
> 会选模式、会立边界、会读证据。

---

### Phase 2：建立战略层

目标：让复杂任务不再“边做边想”，让高危动作不再“知道危险但没人裁决”。

- `wallfacer`：深度规划
- `wallbreaker`：挑战方案
- `swordbearer`：高危授权

核心价值：
> 会规划、会挑战、会裁决。

---

### Phase 3：情报与记忆

规划中：

- `sophon`

目标：
- 跨 session 模式识别
- 长期记忆
- 历史问题与当前任务对齐

当前状态：
> 尚未实现，不应与 Phase 2 混淆。

---

## 7. 安装策略

### 基础 split

安装：
- `environment-governance`
- `agent-work-environment-v3`

适合：
- 大多数用户
- 轻量使用场景

### `--with-archive`

额外安装：
- `diagnostic-archive`

适合：
- 想做失败分析
- 有 run archives 的用户

### `--with-strategy`

额外安装：
- `swordbearer`
- `wallfacer`
- `wallbreaker`

适合：
- 经常面对复杂任务
- 需要高危授权机制
- 希望在执行前就挑战方案

---

## 8. 设计原则

1. **先分层，再组合**：先明确每层边界，再决定如何串起来
2. **先证据，再结论**：诊断层提供事实，战略层做解释
3. **先识别，再授权**：治理层识别风险，执剑人决定是否放行
4. **先规划，再执行**：复杂任务不直接跳到实现
5. **先挑战，再承诺**：高成本方案要先被拆过一轮

---

## 9. 当前状态判断

截至当前仓库版本：

- Phase 1 已完成并验证
- Phase 2 三个战略角色已完成第一版骨架并接入仓库
- 安装、打包、验证链路已经能覆盖战略层
- 还未进入 Phase 3

因此可以把当前版本理解为：

> **three-body = 已具备完整分层雏形的 AI Agent 治理系统**
