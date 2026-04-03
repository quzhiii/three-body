# Wallbreaker Examples

## Trigger Example 1 — Challenge a refactor plan

```text
输入方案：先整体替换缓存层，再一次性切换全部调用点。

破壁人输出：
- 隐含假设：所有调用方行为一致
- 最大风险：一旦切换失败，回滚范围极大
- 结论：revise
- 补充验证：先抽样验证核心调用路径
```

## Trigger Example 2 — Challenge a migration strategy

```text
输入方案：先迁移配置，再补兼容层。

破壁人输出：
- 隐含假设：现网没有依赖旧配置路径
- 最大风险：兼容层补得太晚，会放大生产事故
- 结论：block
```

## Non-Trigger Example 1 — Simple bugfix

```text
用户：修一下这个空指针错误。

破壁人：不介入
原因：任务无复杂战略方案，不需要对抗式审查
```

## Non-Trigger Example 2 — Standard code review

```text
用户：帮我 review 一下这段代码风格。

破壁人：不介入
原因：这是实现质量审查，不是方案挑战
```
