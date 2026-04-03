# 🌌 three-body

<div align="center">

**AI Agent 行为治理宇宙 · Inspired by *The Three-Body Problem***

[![License](https://img.shields.io/badge/许可-MIT-green?style=flat-square)](./LICENSE)
[![Platform](https://img.shields.io/badge/平台-Claude%20Code%20%2F%20Opencode%20%2F%20OpenClaw-blueviolet?style=flat-square)](./install.sh)
[![Phase](https://img.shields.io/badge/Phase-2%20·%20战略层已接入-blue?style=flat-square)](./UNIVERSE.md)
[![Skills](https://img.shields.io/badge/已发布-7%20skills-brightgreen?style=flat-square)](./ARCHITECTURE.md)
[![Architecture](https://img.shields.io/badge/架构-四层体系-orange?style=flat-square)](./ARCHITECTURE.md)

<p align="center">
  <a href="#为什么这个仓库值得看">为什么值得看</a> ·
  <a href="#当前架构phase-2">当前架构</a> ·
  <a href="#7-个-skills-各自干什么">Skills 关系</a> ·
  <a href="#什么时候该装哪些-skill">安装</a> ·
  <a href="#适配场景">适配场景</a>
</p>

<p align="center">
  <img src="./docs/assets/hero.png" alt="three-body" style="max-height: 360px; width: auto;">
</p>

> **三体定其界，诛仙阵定其式。**
>
> 一套给 AI Agent 使用的**行为治理系统**：
> 不只告诉 Agent **该做什么**，更告诉它 **什么时候该停、什么时候该想、什么时候该查证据、什么时候根本不能继续做**。

[English](./README_EN.md) · [架构总览](./ARCHITECTURE.md) · [宇宙地图](./UNIVERSE.md) · [安装脚本](./install.sh)

</div>

---

## 为什么这个仓库值得看

大多数 agent skill 只解决一个点：

- 要么教模型怎么写代码
- 要么教模型怎么调工具
- 要么给一套“看起来很强”的提示词

真实使用里，AI Agent 的问题通常不出在“能力不够”，而是更早的那几步就已经偏了：

1. **没先判断任务属于哪种工作模式**
2. **没有清楚的风险边界**
3. **复杂任务直接开做，没有先规划**
4. **方案看起来合理，但没人专门拆它**
5. **高危动作知道危险，却没有最终裁决者**
6. **失败以后不回证据，只靠猜**

**three-body** 解决的正是这整条链路。

three-body 由四层组成，可以拆开装，也可以串起来用：

- **战术层**：先决定现在该以什么模式工作
- **治理层**：再决定当前边界、确认和升级策略
- **战略层**：在复杂或高危场景下，插入规划 / 质疑 / 授权角色
- **证据层**：失败后回到 archive 看证据，避免继续靠猜

---

## 它解决什么问题

| 真实问题 | 常见失败表现 | three-body 的回答 |
|---|---|---|
| 任务一上来就开做 | 明明该先分析，却直接写代码或直接改配置 | `agent-work-environment-v3` 先选工作阵型 |
| 风险边界不清 | 该确认的时候不确认，不该继续的时候继续做 | `environment-governance` 先定义边界 |
| 复杂任务边做边想 | 路线频繁漂移，返工成本高 | `wallfacer` 先收敛方案 |
| 方案没人挑战 | 隐含假设没暴露，最后在执行期爆炸 | `wallbreaker` 专门拆方案 |
| 高危动作无人裁决 | 知道危险，但没人决定能不能放行 | `swordbearer` 做最终授权 |
| 失败后靠直觉重试 | 不读日志、不比对 run、重复犯错 | `diagnostic-archive` 回证据层 |

一句话：

> **three-body 关心的不是“赶紧开始做”，而是“先把方向和边界站稳”。**

---

## 30 秒快速理解

如果你只想先抓住这个项目的核心，可以直接记这四句话：

- **诛仙阵**先判断：现在该用什么工作模式
- **三体法则**再判断：当前边界在哪里
- **战略层三角色**只在复杂或高危场景出现
- **档案读取器**负责在失败后把决策重新拉回证据

把这套东西想清楚，其实就一句话：它把 Agent 的行为链路拆成了：

> **模式选择 → 边界定义 → 战略介入 → 证据回看**

---

## 当前架构（Phase 2）

```text
┌────────────────────────────────────────────────────────────────────┐
│                        战术层 · TACTICS                           │
│                                                                    │
│   ⚔️ agent-work-environment-v3                                     │
│   诛仙阵：识别任务意图，选择研究 / 实现 / 验证 / 写作 / 运维模式     │
└────────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌────────────────────────────────────────────────────────────────────┐
│                       治理层 · GOVERNANCE                          │
│                                                                    │
│   ⚖️ environment-governance                                        │
│   三体法则：根据信号定义确认、升级、写回、诊断访问等行为边界         │
│                                                                    │
│   底层哲学：黑暗森林法则                                            │
│   含义是“先控制暴露面，再决定行动”，它代表一套法则，不是具体工具       │
└────────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌────────────────────────────────────────────────────────────────────┐
│                        战略层 · STRATEGY                           │
│                                                                    │
│   🧱 wallfacer   → 深度规划                                         │
│   🔓 wallbreaker → 对抗式审查                                       │
│   ⚔️ swordbearer → 高危动作最终授权                                 │
└────────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌────────────────────────────────────────────────────────────────────┐
│                       证据层 · EVIDENCE                             │
│                                                                    │
│   📁 diagnostic-archive                                            │
│   读取 run archives，定位根因，为重试、授权和方案争议提供证据         │
└────────────────────────────────────────────────────────────────────┘
```

## 7 个 skills 各自干什么

### 主架构中的 6 个角色

| Skill | 层级 | 角色定位 | 负责什么 | 不负责什么 |
|---|---|---|---|---|
| `agent-work-environment-v3` | 战术层 | 诛仙阵 | 识别任务意图，选择阵型，给出下一步工作方式 | 不定义安全边界、不深度规划、不做最终授权 |
| `environment-governance` | 治理层 | 三体法则 | 根据风险、复杂度、失败状态等信号决定边界 | 不负责路由、不代替执行 skill |
| `wallfacer` | 战略层 | 面壁人 | 在复杂任务前收敛候选路径，给出主方案 | 不做对抗审查、不做最终授权 |
| `wallbreaker` | 战略层 | 破壁人 | 对已有方案做拆解，暴露盲点和未验证假设 | 不负责初始规划 |
| `swordbearer` | 战略层 | 执剑人 | 在高危动作前给出 allow / pause / deny 判断 | 不负责全面风险识别 |
| `diagnostic-archive` | 证据层 | 档案读取器 | 从 run archives 读取事实、还原失败原因 | 不修 bug、不重跑任务、不替代规划 |

### 兼容保留的 1 个角色

| Skill | 定位 | 说明 |
|---|---|---|
| `agent-work-environment` | 兼容组合版 | 将“路由 + 治理”合并在一个 skill 中，适合想快速上手、不想拆装的人；当前主线仍然是 split 架构 |

---

## 它们之间怎么协作

README 真正需要讲清楚的，是这几个 skill 在什么顺序下协作。

### 1) 普通任务

```text
用户任务
  → agent-work-environment-v3
  → environment-governance
  → execution skill
```

适合：普通实现、常规修复、明确单路径任务。

### 2) 复杂任务

```text
用户任务
  → agent-work-environment-v3
  → environment-governance
  → wallfacer
  → execution skill
```

适合：重构、多阶段改造、跨模块任务。

### 3) 复杂且争议大的任务

```text
用户任务
  → agent-work-environment-v3
  → environment-governance
  → wallfacer
  → wallbreaker
  → execution skill
```

适合：方案假设很多、返工成本高、方向争议大。

### 4) 高危任务

```text
用户任务
  → agent-work-environment-v3
  → environment-governance
  → swordbearer
  → careful / guard / execution skill
```

适合：删除、强推、生产变更、凭证调整。

### 5) 高危且失败过的任务

```text
用户任务
  → agent-work-environment-v3
  → environment-governance
  → diagnostic-archive
  → swordbearer
  → execution skill
```

适合：已经失败过、但仍想继续推进的高风险动作。

---

## 三体 × 诛仙阵：命名的由来

### 三体定其界

《三体》给这个仓库带来的，是一套很强的**边界观**。

- 上下文有限，必须像脱水一样节省资源
- 环境突变频繁，必须像乱纪元一样考虑升级路径
- 暴露面越大，越容易出错，这就是黑暗森林法则在 Agent 世界里的含义
- 高危动作不靠一时冲动，而要有执剑人式的威慑与裁决

所以：

> **黑暗森林在这里是一条法则，也是一种思路。它不对应某个执行角色。**

### 诛仙阵定其式

诛仙阵给这个仓库的，是**任务模式选择**。

同样是“帮我处理这个任务”，实际可能完全不同：

- 有的应该先研究
- 有的应该直接实现
- 有的应该先验证
- 有的应该写成文档
- 有的属于运维，必须更谨慎

所以 `agent-work-environment-v3` 的第一步，是先决定：

> **现在该进哪一阵。**

---

## 诛仙阵的五阵型

| 阵型 | 英文标识 | 使用场景 |
|---|---|---|
| 观机阵 | Research | 先看清结构、模式和上下文 |
| 破局阵 | Implementation | 明确目标后直接落地实现 |
| 明鉴阵 | Verification | 做检查、测试、回归、验收 |
| 立言阵 | Writing | 写说明、设计文档、总结、发布文案 |
| 行令阵 | Operations | 部署、配置、环境变更等高风险动作 |

这五阵更像一份**工作模式清单**。

---

## 三体法则的核心边界

`environment-governance` 的重点不在规则越多越好，而在于先读懂局势，再给出边界。

### 五条法则

- 上下文预算
- 工具边界
- 风险升级
- 写回策略
- 诊断访问

### 四类核心信号

- `risk_level`
- `task_complexity`
- `has_failed`
- `write_intent`

它的价值在于：

> 它更像是在判断“眼下是什么局面”，然后再决定边界该收紧到什么程度。

---

## 什么时候该装哪些 skill

### 我只想先装最核心的

如果你只想获得“先选模式 + 再控边界”的核心能力：

```bash
./install.sh claude
```

这会安装：

- `agent-work-environment-v3`
- `environment-governance`

适合：大多数第一次接触 three-body 的用户。

### 我需要失败诊断能力

```bash
./install.sh claude --with-archive
```

额外安装：

- `diagnostic-archive`

适合：你已经在用 run archives，或者你经常需要复盘失败原因。

### 我需要完整战略层

```bash
./install.sh claude --with-strategy
```

额外安装：

- `wallfacer`
- `wallbreaker`
- `swordbearer`

适合：复杂任务多、需要方案收敛、需要高危动作授权的人。

### 我想直接上全量推荐配置

```bash
./install.sh claude --with-strategy --with-archive
```

适合：你想把完整的 four-layer 体系一次装齐。

如果你使用手动复制，也可以按需安装：

```bash
cp -r environment-governance ~/.claude/skills/
cp -r agent-work-environment-v3 ~/.claude/skills/
cp -r diagnostic-archive ~/.claude/skills/
cp -r wallfacer ~/.claude/skills/
cp -r wallbreaker ~/.claude/skills/
cp -r swordbearer ~/.claude/skills/
```

兼容组合版：

```bash
./install.sh claude --classic
```

---

## 支持平台

| 平台 | 标识 | 状态 |
|---|---|---|
| Claude Code | `claude` | ✅ 已验证 |
| Opencode | `opencode` | ✅ 已验证 |
| OpenClaw | `openclaw` | ✅ 已验证 |

更多安装细节见：[`install.sh`](./install.sh)

---

## 装了和没装的差别

如果你担心它只是“换了一种说法的 system prompt”，可以直接看这个对照示例：

- [examples/behavior-diff.md](./examples/behavior-diff.md)

它对比了三种情况：

1. 没装 three-body
2. 只装 `environment-governance`
3. 同时装路由层与治理层

你会看到差别不只在措辞，真正拉开差距的是**决策链条本身**。

---

## 适配场景

### 这类人会很适合

- 你正在长期使用 coding agent，不是偶尔来一次一问一答
- 你关心高危操作时的边界，而不只关心“快点做完”
- 你的任务经常跨研究、实现、验证、文档、运维多个阶段
- 你希望复杂任务先出方案，再执行
- 你希望失败后能回看证据，不想靠直觉一遍遍重试

### 下面这些场景就没必要上 full 套了

- 单次简单问答
- 一次性生成几行代码
- 完全不在乎风险确认与行为一致性

这种情况下，three-body 多半会显得偏重。

---

## 当前技术路线

### Phase 1：基础层

完成：

- `environment-governance`
- `agent-work-environment-v3`
- `diagnostic-archive`

核心价值：

> 会选模式、会立边界、会读证据。

### Phase 2：战略层

完成：

- `wallfacer`
- `wallbreaker`
- `swordbearer`

核心价值：

> 会规划、会挑战、会裁决。

### Phase 3：情报与长期记忆

规划中：

- `sophon`

当前尚未实现，不应和 Phase 2 混淆。

---

## 仓库结构

```text
three-body/
├── README.md
├── README_EN.md
├── ARCHITECTURE.md
├── UNIVERSE.md
│
├── environment-governance/      # 三体法则
├── agent-work-environment-v3/   # 诛仙阵（主推）
├── diagnostic-archive/          # 档案读取器
├── wallfacer/                   # 面壁人
├── wallbreaker/                 # 破壁人
├── swordbearer/                 # 执剑人
├── agent-work-environment/      # 兼容组合版
│
├── scripts/
│   ├── validate-repo.ps1
│   └── build-skill-packages.ps1
│
└── examples/
```

---

## 仓库自检与打包

### 校验仓库一致性

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate-repo.ps1
```

### 重新生成 `.skill` 产物

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\build-skill-packages.ps1
```

建议流程：

1. 先改源码目录
2. 再生成 `.skill`
3. 最后跑校验脚本

---

## 设计原则

1. **先分层，再组合**：不要一上来做一个“大总控 skill”
2. **先识别，再授权**：治理层识别风险，执剑人决定放不放行
3. **先规划，再执行**：复杂任务不要直接跳进实现
4. **先挑战，再承诺**：高返工成本的方案必须先拆一轮
5. **先证据，再结论**：失败时优先回 archive，先弄清发生了什么

---

## 如果你第一次接触这个项目，建议这样看

1. 先看本 README，理解 7 个 skills 的关系
2. 再看 [ARCHITECTURE.md](./ARCHITECTURE.md)，理解完整调用顺序
3. 如果你要安装，直接看 [`install.sh`](./install.sh)
4. 如果你要理解未来路线，再看 [UNIVERSE.md](./UNIVERSE.md)

如果你只准备花 5 分钟了解它，可以按这个顺序看：

1. 看“30 秒快速理解”
2. 看“当前架构（Phase 2）”
3. 看“它们之间怎么协作”
4. 最后决定装最小版还是全量版

---

## 许可证

[MIT](./LICENSE)

---

<div align="center">

**三体定其界，诛仙阵定其式。**

它追求的，不是把 Agent 包装得更像“万能助手”。
它更像一套长期运行的系统：遇到复杂任务会先想清楚，遇到高危动作会先踩刹车，失败以后知道回哪找证据。

很多 agent 方案都在强调“更快开始做”。
three-body 更看重另一件事：**别在一开始就把事做偏。**

[架构总览](./ARCHITECTURE.md) · [宇宙地图](./UNIVERSE.md) · [English](./README_EN.md)

</div>
