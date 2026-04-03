# High-Risk Actions for Swordbearer

以下动作默认视为应进入执剑人视野：

## Directly destructive

- 删除生产数据
- 批量删除关键文件
- 不可逆数据迁移

## Environment-wide changes

- 生产配置修改
- 凭证 / secret 更换
- 权限边界调整

## Collaboration-risk changes

- force push 到共享分支
- 覆盖他人已发布结果

## Failure-pressure scenarios

- 连续失败后仍要执行高危动作
- 证据不足但用户强行催促推进

## Non-trigger examples

- 普通代码修复
- 文档编辑
- 只读分析
- 本地低风险实验
