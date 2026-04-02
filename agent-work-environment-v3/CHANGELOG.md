# Changelog

## 2026-04-02（v3.0 — 路由/治理拆分）

`agent-work-environment` 拆分后的纯路由版本。

### Changed

- `agent-work-environment-v3` 只保留阵型路由职责
- 行为约束迁移到独立 skill：`environment-governance`
- `formation-law-mapping` 改为阵型到任务信号映射
- 保留五阵型定义、完成标准和交接规则

### Outcome

v3 作为组合层适合继续维护路由逻辑；`environment-governance` 作为独立层适合跨场景复用。

### Next Candidates

- 增加更多真实路由示例
- 根据实际使用反馈微调阵型到任务信号的映射
