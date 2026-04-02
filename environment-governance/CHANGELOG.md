# Changelog

## 2026-04-02（v1.0 — 独立治理层）

首次从 `agent-work-environment` 中拆分出独立的三体环境法则 skill。

### Changed

- 新增 [SKILL.md](./SKILL.md)，定义独立的行为约束层
- 新增 [references/laws.md](./references/laws.md)，收纳五条法则的完整定义
- 新增 [references/default-bias.md](./references/default-bias.md)，支持脱离阵型时按任务信号自动调参
- 新增 [references/escalation-matrix.md](./references/escalation-matrix.md)，统一硬确认与失败升级模板

### Outcome

`environment-governance` 现在可以单独安装和单独发布，也可以被 `agent-work-environment-v3` 复用。

### Next Candidates

- 根据真实任务继续微调默认偏置映射
- 如需要，再补更多真实场景示例
