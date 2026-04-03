# Swordbearer Authorization Matrix

> 用于快速判断某类高危动作更接近 allow / pause / deny / needs_more_context。

## Decision Table

| 动作类型 | 条件充分时 | 信息不全时 | 明显危险时 |
|---|---|---|---|
| 删除生产数据 | pause / deny | needs_more_context | deny |
| 生产配置修改 | allow / pause | needs_more_context | deny |
| 凭证变更 | pause | needs_more_context | deny |
| force push 到共享分支 | pause | needs_more_context | deny |
| 高风险运维回滚 | allow / pause | needs_more_context | deny |

## Interpretation Rules

- `allow`：只有在影响范围清楚、回滚明确、替代方案已比较后才使用
- `pause`：当前方向可能成立，但仍应先停下来确认
- `deny`：证据表明不应继续，或动作后果不可接受
- `needs_more_context`：输入不足，禁止乐观推进
