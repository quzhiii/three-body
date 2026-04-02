# agent-work-environment

`agent-work-environment` 是一个总控治理 skill，用来在任务真正开始前先做三件事：

1. 判定当前应该用哪种工作模式
2. 给出本轮的工具、写入、风险和诊断边界
3. 推荐下游执行 skill

它适合多阶段任务、长任务和高风险任务，不适合替代具体执行 skill。

## 适合的任务

- 先研究后实现的任务
- 需要在实现、验证、写作、运维之间切换的任务
- 需要先定义边界，再交给具体 skill 执行的任务

## 不适合的任务

- 单一步骤且目标非常明确的任务
- 已经明确知道要直接交给 `Code`、`review`、`doc`、`careful` 之类 skill 的任务

## 核心结构

- [SKILL.md](./SKILL.md)
  - 总控合同、输入输出合同、下游 handoff
- [CHANGELOG.md](./CHANGELOG.md)
  - 版本演进和本轮重构说明
- [INTEGRATIONS.md](./INTEGRATIONS.md)
  - 与 `Code / review / careful / guard` 的组合调用模板
- [EXAMPLES.md](./EXAMPLES.md)
  - 真实用户输入到路由输出的完整示例
- [formations.md](./references/formations.md)
  - 五阵型定义、完成标准、交付格式、场景示例
- [environment-laws.md](./references/environment-laws.md)
  - 五条环境法则和执行前检查项
- [formation-law-mapping.md](./references/formation-law-mapping.md)
  - 阵型和法则偏置速查
- [escalation-matrix.md](./references/escalation-matrix.md)
  - 风险升级矩阵和失败升级模板

## 当前定位

这是一个 `session preamble + mode router` skill，不是执行引擎。

更准确地说：

- 它负责选模式
- 它负责定边界
- 它负责决定是否确认或切阵
- 它负责推荐下游 skill

它不负责直接替代：

- 编码 skill
- review skill
- 文档 skill
- 运维保护 skill
