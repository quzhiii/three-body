# Swordbearer Examples

## Trigger Example 1 — Production config change

```text
用户：把生产环境的配置直接改掉，今天就上线。

治理层判断：高风险 + 配置写入 + 影响范围大
执剑人输出：pause
原因：影响范围大，缺少回滚说明与替代方案
下一步：补充 rollback_plan，再交给 careful / guard
```

## Trigger Example 2 — Force push after failures

```text
用户：前面几次都没过，直接 force push 到共享分支吧。

治理层判断：高风险 + 连续失败
执剑人输出：deny
原因：连续失败下强推会扩大影响面
下一步：先调用 diagnostic-archive 读取失败证据
```

## Trigger Example 3 — Secret rotation without context

```text
用户：把线上 API key 先换了再说。

治理层判断：高风险 + 凭证操作
执剑人输出：needs_more_context
原因：未说明依赖服务、切换窗口、回滚方案
下一步：补充影响范围与回滚策略
```

## Non-Trigger Example 1 — Ordinary bugfix

```text
用户：修一下这个前端按钮点击失效的问题。

治理层判断：中风险代码修改
执剑人：不介入
原因：普通代码变更，不属于高危授权场景
```

## Non-Trigger Example 2 — Read-only analysis

```text
用户：先帮我分析下这个模块为什么慢。

治理层判断：低风险只读分析
执剑人：不介入
原因：未进入高风险执行动作
```
