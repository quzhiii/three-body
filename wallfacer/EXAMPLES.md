# Wallfacer Examples

## Trigger Example 1 — Architecture refactor

```text
用户：我们想把这个高耦合缓存层重构掉，但我不确定先拆接口还是先改数据流。

诛仙阵判断：复杂多阶段任务
面壁人输出：
- 候选路径 A：先拆接口
- 候选路径 B：先改数据流
- 推荐路径：A
- 原因：回滚更容易，影响面更可控
```

## Trigger Example 2 — Migration planning

```text
用户：把这套旧配置系统迁移到新框架里，帮我先规划下怎么拆阶段。

面壁人输出：
- 阶段划分
- 候选迁移顺序
- 关键未知
- 建议下游：Code / doc
```

## Non-Trigger Example 1 — Simple bugfix

```text
用户：这个按钮点击没反应，帮我修一下。

面壁人：不介入
原因：任务单路径且低复杂度，不需要深度规划
```

## Non-Trigger Example 2 — Plain read-only analysis

```text
用户：先帮我看看这个函数是做什么的。

面壁人：不介入
原因：只读理解任务，交给观机阵即可
```
