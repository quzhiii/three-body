# Integrations

`agent-work-environment-v3` 的职责是把任务交给正确的下游 skill。

行为约束不在这里定义；如果需要边界判断，先交给 environment-governance。

默认下游映射以 eferences/downstream-skills.md 为准；本文件只描述组合路径，不重复定义权威表。

## 与 environment-governance 的关系

- `agent-work-environment-v3` 负责选阵型
- `environment-governance` 负责根据任务信号给出法则偏置
- 两者可以组合使用，但职责保持分离

## 常见组合路径

### 路径 1：研究 -> 实现 -> 验证

- `agent-work-environment-v3` 选观机阵
- 下游交给 `brainstorming` 或 `review`
- 进入实现阶段后交给 `Code`
- 完成后交给 `review` 或 `qa`

### 路径 2：实现 -> 运维 -> 验证

- `agent-work-environment-v3` 选破局阵
- 下游交给 `Code`
- 需要部署或命令操作时交给 `careful` / `guard`
- 完成后交给 `review`

### 路径 3：研究 -> 写作

- `agent-work-environment-v3` 选观机阵
- 下游交给研究/分析类 skill
- 整理成果时交给 `doc`

## 不该做的事

- 不要在 v3 里重复定义三体法则
- 不要把 `environment-governance` 当成可选附件
- 不要让路由器替下游 skill 完成实际执行

