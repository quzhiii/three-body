# Formation-Signal Mapping — 阵型到任务信号映射

本文件解决一个问题：**选定阵型后，对应的 4 个任务信号是什么。**

这 4 个信号被传递给 `environment-governance` skill，由它根据信号计算法则偏置。

---

## 信号定义

| 信号 | 值域 | 含义 |
|---|---|---|
| `risk_level` | 低 / 中 / 高 | 操作的不可逆性和破坏范围 |
| `task_complexity` | 简单 / 中等 / 复杂 | 涉及文件数、模块数、步骤数 |
| `has_failed` | 是 / 否 | 同类操作是否已连续失败 |
| `write_intent` | 只读 / 文档 / 代码 / 配置 / 删除 | 即将写入什么 |

---

## 总映射表

| 阵型 | risk_level | task_complexity | has_failed | write_intent |
|---|---|---|---|---|
| 观机阵（研究模式） | 低 | 复杂 | 否 | 只读 |
| 破局阵（实现模式） | 中 | 中等 | 可能 | 代码 |
| 明鉴阵（验证模式） | 低 | 中等 | 可能 | 只读 |
| 立言阵（写作模式） | 低 | 中等 | 否 | 文档 |
| 行令阵（运维模式） | 高 | — | — | 配置/删除 |

---

## 使用方法

1. 选定阵型后，从本表查到 4 个信号值
2. 将信号传递给 `environment-governance` 的 Bias Workflow
3. `environment-governance` 根据信号输出法则偏置

切阵时信号自动变化，`environment-governance` 随之调整偏置。

---

## 阵型速查

### 观机阵（研究模式）

| 信号 | 值 | 说明 |
|---|---|---|
| risk_level | 低 | 主要防误判，不防大写入 |
| task_complexity | 复杂 | 需要读更多相关材料 |
| has_failed | 否 | 研究阶段一般不会连续失败 |
| write_intent | 只读 | 不修改，不创建 |

### 破局阵（实现模式）

| 信号 | 值 | 说明 |
|---|---|---|
| risk_level | 中 | 改动范围扩大时提高确认 |
| task_complexity | 中等 | 只读必要上下文，避免全量扫仓库 |
| has_failed | 可能 | 失败后增强诊断，不机械重试 |
| write_intent | 代码 | 小改直接做，大改先说明 |

### 明鉴阵（验证模式）

| 信号 | 值 | 说明 |
|---|---|---|
| risk_level | 低 | 重点防误判 |
| task_complexity | 中等 | 只看关键证据，不做宽泛阅读 |
| has_failed | 可能 | 验证失败时查看原始 traces |
| write_intent | 只读 | 除非用户要求，否则不写入 |

### 立言阵（写作模式）

| 信号 | 值 | 说明 |
|---|---|---|
| risk_level | 低 | 文档写入默认低风险 |
| task_complexity | 中等 | 够写即可，不做重型检索 |
| has_failed | 否 | 写作一般不会连续失败 |
| write_intent | 文档 | 可以写文档，不碰代码和配置 |

### 行令阵（运维模式）

| 信号 | 值 | 说明 |
|---|---|---|
| risk_level | 高 | 变更环境前先确认 |
| task_complexity | — | 按操作复杂度实时判断 |
| has_failed | — | 按失败情况实时提升 |
| write_intent | 配置/删除 | 强制确认，不可绕过 |

---

## 切阵时信号变化

| 切换路径 | 变化的信号 |
|---|---|
| 观机阵 → 破局阵 | write_intent: 只读→代码, risk_level: 低→中 |
| 破局阵 → 明鉴阵 | write_intent: 代码→只读, risk_level: 中→低 |
| 明鉴阵 → 破局阵 | write_intent: 只读→代码, risk_level: 低→中 |
| 任意 → 立言阵 | write_intent → 文档, risk_level → 低 |
| 任意 → 行令阵 | risk_level → 高, write_intent 视操作而定 |

---

## 路由示例

示例 1：
- 用户输入："先帮我分析这个线上报错原因，不要改代码。"
- 阵型：观机阵 → 信号：risk=低, complexity=复杂, failed=否, write=只读

示例 2：
- 用户输入："这个接口确认是空指针了，直接修。"
- 阵型：破局阵 → 信号：risk=中, complexity=中等, failed=可能, write=代码

示例 3：
- 用户输入："review 一下这次改动有没有引入鉴权问题。"
- 阵型：明鉴阵 → 信号：risk=低, complexity=中等, failed=可能, write=只读

示例 4：
- 用户输入："把刚才的排查结果整理成团队 SOP。"
- 阵型：立言阵 → 信号：risk=低, complexity=中等, failed=否, write=文档

示例 5：
- 用户输入："把修复后的服务发布到测试环境。"
- 阵型：行令阵 → 信号：risk=高, write=配置/删除
