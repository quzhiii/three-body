# AI 架构完整优化方案（v1）

## 0. 文档目的

这份文档用于把当前项目的状态、已经完成的部分、下一步的优化路径、每个阶段的具体工作、最终目标与定位一次性整理清楚。

本文档采取如下判断前提：

1. **不丢掉“剑阵 / 三体”这套理念**。它们不再只是叙事包装，而应上移为 AI 工作环境的语义层与方法层。
2. **不继续把当前仓库扩成一个更大的完整 agent runtime**。当前更合理的方向，是把现有窄 runtime harness 冻结为稳定内核，再向上补“环境层 / 阵型层 / 经验诊断层”，向外做“宿主适配层”。
3. **OpenClaw / OpenCode / Claude Code 等宿主负责运行时平台**；本项目负责 workflow、context、evaluation、history、经验归档、环境策略与阵型能力编排。
4. **下一阶段的核心增量不是更多 surface，而是更强的环境管理与可检索的诊断经验层**。

---

## 1. 当前项目已经做好的内容

### 1.1 当前定位已经清晰：这是一个窄而保守的 runtime harness

根据现有 README 与 handoff，项目当前已经明确不是 full agent platform，而是一个**可运行、可检查、可对比版本差异的窄 runtime harness**。

其核心特征是：

- 主执行链单路径、可观察、可对比。
- 外层已经具备 profile-aware surface、batch、export、history、history-summary、history-browse、history-shortcuts。
- 整体仍然保持 conservative，不引入更大的控制平面。

这一步非常重要，因为项目已经从“概念性架构”进入了“有稳定边界的可执行骨架”阶段。

### 1.2 已经完成的稳定能力（v0.5.x）

当前已经形成的稳定面，可以概括为 10 组能力：

#### A. Workflow Profile 语义层

已完成：

- `WorkflowProfile`
- 默认 profile 与内置 profile 集合
- `workflow_profile_id` 进入 `TaskContract`
- evaluator input 中携带 profile 信息

意义：

- 项目已经开始具备“不同任务模式有不同解释语义”的能力。
- 这为后续把“剑阵”落成不同任务阵型提供了天然接口。

#### B. Profile-aware evaluation 解释层

已完成：

- 共享的 profile interpretation helper
- `BaselineComparator` 与 `RealmEvaluator` 使用同一套 interpretation 来源

意义：

- compare / evaluator 不再各自维护一套模糊的 profile 语义。
- 为后续“阵型差异化评估”打下基础。

#### C. 外部输入归一化层

已完成：

- `profile_input_adapter`
- 输入字段优先级与 fallback 规则
- `TaskContractBuilder` 改为消费归一化后的 `workflow_profile_id`

意义：

- 外部请求进入 runtime 的方式更统一。
- 为将来适配宿主命令、插件参数、技能配置提供了比较稳定的入口。

#### D. 单任务最小 surface

已完成：

- `SurfaceTaskRequest`
- `run_task_request(...)`
- 薄 CLI surface

意义：

- 项目已经不是纯内部模块，而是有最小外部可调用接口。

#### E. 顺序 batch surface

已完成：

- `SurfaceBatchRequest`
- `run_batch_request(...)`
- `load_batch_request_file(...)`
- 最小失败策略控制

意义：

- 项目已经开始具备 automation-friendly 使用方式。
- 这是后续做宿主批处理命令、批量实验、阵型对比的基础。

#### F. 批处理导出层

已完成：

- `BatchExportOptions`
- `export_batch_results(...)`
- JSON / JSONL / Markdown 导出

意义：

- 项目已经有稳定产物层，而不是只返回内存态结果。

#### G. 运行历史 manifest 层

已完成：

- `RunHistoryEntry`
- `append_run_history_entry(...)`
- `list_run_history(...)`
- append-only `run_history.jsonl`

意义：

- 项目开始具备“经验留痕”能力。
- 但当前仍然是 manifest 层，还不是完整的诊断经验系统。

#### H. latest-run / recent-summary 派生层

已完成：

- `latest_run.json`
- `run_history_summary.json`
- summary writer 与 latest-run pointer

意义：

- 便于自动化脚本与人工快速查看最近一次运行。

#### I. 历史浏览与快捷命令层

已完成：

- `read_latest_run(...)`
- `read_run_history_summary(...)`
- `browse_run_history(...)`
- `get_latest_run_id(...)`
- `get_latest_run_output_dir(...)`
- `find_run_history_entry(...)`
- `format_history_brief(...)`

意义：

- 项目已经有“读历史”的最小体验。
- 但当前仍然偏向最近几次运行的浏览，不是可诊断、可检索、可优化 harness 的经验系统。

#### J. 测试基线与稳定性

当前 README 给出的状态是：

- 当前稳定 closeout tag：`b-v0.5-history-shortcuts`
- 全量测试命令已经明确
- closeout 结果为 `Ran 246 tests`, `OK`

意义：

- 当前仓库已经适合进入“冻结一层、向上扩一层”的策略。
- 现在最不划算的做法，是再把 runtime 内核大幅改写一遍。

---

## 2. 当前项目仍然明确没有做的事情

这部分必须单独写清楚，因为下一步优化路径不能脱离现有边界。

目前仓库仍然**没有**做这些：

- HTTP server / FastAPI shell
- queue / scheduler / async worker
- artifact search / filter engine
- history write-back / replay / rerun controls
- database-backed state
- full-text search / query DSL
- report templating / dashboard system
- parallel worker pools / subagent runtime
- async event bus
- plugin system
- automatic model or methodology execution
- rich memory system

这意味着：

1. 当前项目已经有了**记录层**，但还没有**经验检索层**。
2. 当前项目已经有了**外层 surface**，但还没有**宿主适配层**。
3. 当前项目已经有了**profile 语义**，但还没有**阵型语义**。
4. 当前项目已经有了**history**，但还没有**Meta-Harness 风格的诊断 archive**。

---

## 3. 当前阶段的核心判断

### 3.1 不应继续把当前项目扩成“另一个 OpenClaw / Codex CLI”

当前项目最合理的路线，不是继续膨胀为完整宿主 runtime，而是转向：

> **宿主增强内核 + 环境法则层（三体） + 阵型层（剑阵） + 经验诊断层 + 宿主适配层**

这里要特别区分三件事：

- **宿主**：OpenClaw / OpenCode / Claude Code
- **内核**：你当前已经做好的 narrow runtime harness
- **上层方法论**：剑阵 / 三体

如果不分层，项目会再次摇摆在“完整 runtime 幻觉”和“插件化交付”之间。

### 3.2 “剑阵 / 三体”要保留，但必须工程化落地

#### 三体

更适合落为：

- 环境法则层
- 上下文预算约束
- 工具暴露边界
- 风险升级规则
- 长任务衰减与治理阈值

#### 剑阵

更适合落为：

- 阵型 preset
- 能力编组与方法编组
- 不同任务类型的 harness family
- 可被比较、被切换、被优化的执行方案

也就是说：

- 三体 = **环境层**
- 剑阵 = **编组层**

而不是：

- 三体 = 主题文案
- 剑阵 = 命名装饰

### 3.3 下一步的关键缺口不是更多 command，而是“经验诊断层”

当前项目已经有 batch/export/history，但仍然缺：

- raw trace 级经验归档
- 可检索的诊断 index
- harness 候选实验空间
- 外环 offline 优化机制

这正是下一步优化最关键的增量。

---

## 4. 下一阶段的总体优化方向

下一阶段建议升级为：

# `v0.6 / v1-alpha`
## `AI Work Environment Layer + OpenClaw Adapter + Diagnostic Archive`

### 4.1 新定位

将项目重新定义为：

> **一个面向宿主 AI 平台的增强内核**，负责环境策略、阵型编组、任务 contract、context 组装、evaluation、history、经验诊断归档，并通过宿主插件 / 命令包形式交付。

### 4.2 新目标

不是追求“更大”，而是追求 4 个更清晰的结果：

1. **保留现有窄内核的稳定性**
2. **让剑阵 / 三体进入真实执行路径**
3. **让经验从“记录”升级为“可检索诊断资产”**
4. **把系统以宿主增强包而不是另一个宿主的形态交付**

---

## 5. 目标架构（建议版）

建议将项目拆成 6 层。

### 5.1 Host Layer（宿主层）

负责：

- OpenClaw / OpenCode / Claude Code 等平台 runtime
- 消息 / CLI / channel / gateway 等宿主功能
- 插件安装、进程托管、外部渠道接入

原则：

- **这层不在当前仓库重做。**
- 当前项目只做接入与增强。

### 5.2 Environment Law Layer（三体）

建议新增模块：

- `meta/environment/environment_policy.py`
- `meta/environment/context_budget_policy.py`
- `meta/environment/tool_exposure_policy.py`
- `meta/environment/diagnostic_access_policy.py`
- `meta/environment/writeback_policy.py`
- `meta/environment/sandbox_threshold_policy.py`

负责：

- 什么上下文可进入 prompt
- 什么经验默认不可直接注入
- 什么任务必须先做环境快照
- 什么任务禁止自动写回
- 什么操作必须提升治理等级

### 5.3 Formation Layer（剑阵）

建议新增模块：

- `meta/formations/sword_formations.py`
- `meta/formations/formation_registry.py`
- `meta/formations/formation_resolver.py`

建议首批阵型：

- `research_array`
- `coding_array`
- `verification_array`
- `writing_array`
- `ops_array`

每个阵型定义：

- context block 选择规则
- tool exposure preset
- history retrieval mode
- verification chain
- evaluator focus
- export / trace detail level

### 5.4 Core Runtime Layer（现有窄内核）

保留现有主链：

`surface -> profile_input_adapter -> task contract -> state/context -> execution -> verification -> governance -> sandbox/rollback -> journal -> evaluation`

原则：

- 当前阶段不做大改
- 保持 single-path / conservative 边界
- 把增量优先加在上层与外层

### 5.5 Diagnostic Archive Layer（新增关键层）

建议新增：

- `artifacts/runs/<run_id>/task_contract.json`
- `artifacts/runs/<run_id>/profile_resolution.json`
- `artifacts/runs/<run_id>/formation_resolution.json`
- `artifacts/runs/<run_id>/context_plan.json`
- `artifacts/runs/<run_id>/tool_trace.jsonl`
- `artifacts/runs/<run_id>/verification_report.json`
- `artifacts/runs/<run_id>/governance_report.json`
- `artifacts/runs/<run_id>/metrics_summary.json`
- `artifacts/runs/<run_id>/final_score.json`
- `artifacts/runs/<run_id>/environment_snapshot.json`

这层与当前 `run_history.jsonl` 的关系：

- `run_history.jsonl` 继续做 append-only manifest truth source
- Diagnostic Archive 存放**更细粒度、可诊断、可比较、可被检索的 raw traces 与结构化副产物**

### 5.6 Meta-Optimization Layer（离线外环）

建议新增：

- `meta_harness/registry/`
- `meta_harness/evaluator/`
- `meta_harness/proposer/`
- `meta_harness/search_loop/`
- `meta_harness/candidates/`

原则：

- **第一版只做 offline search，不在线改主系统。**
- 候选 harness 在 sandbox 中跑实验
- 写回 candidate 结果
- 排序比较
- 人工决定是否晋升为稳定阵型 / 稳定 policy

---

## 6. 分阶段具体优化路径

下面按“阶段目标—要做什么—产出物—验收标准”的方式写。

---

## Phase 0：冻结当前基线，统一定位

### 目标

把当前 `v0.5.x` 明确冻结为稳定窄内核，停止继续把本仓库往“大而全 runtime”方向扩。

### 要做什么

1. 更新 README / handoff 中的定位说明
2. 明确写清：
   - 当前项目不是 full agent platform
   - 当前项目不替代 OpenClaw / OpenCode
   - 当前项目的下一阶段是 environment + formation + archive + adapter
3. 增加一份单独架构说明文档：
   - `ARCHITECTURE_POSITIONING.md`

### 产出物

- 冻结后的定位文档
- 统一后的路线图文档

### 验收标准

- 对外表述不再摇摆于“完整 runtime”和“增强层”之间
- README 顶层定位一句话可以直接被外部用户理解

---

## Phase 1：把“三体”落成环境法则层

### 目标

让“三体”从理念进入代码，变成明确的环境治理与上下文法则系统。

### 要做什么

1. 定义环境法则对象：
   - `EnvironmentPolicy`
2. 首批策略项：
   - `context_budget_policy`
   - `tool_exposure_policy`
   - `diagnostic_access_policy`
   - `writeback_policy`
   - `sandbox_threshold_policy`
3. 规定这些策略如何进入主链：
   - task contract 建立后可解析环境 policy
   - context engine 读取 budget / access policy
   - governance 读取 threshold policy

### 产出物

- `meta/environment/*`
- 配置样例
- 一份策略解释文档

### 验收标准

- 一个任务请求能够显式解析出对应的 environment policy
- context assembly 和 governance 行为能受到 policy 影响
- 默认 policy 可运行，不破坏当前主链

---

## Phase 2：把“剑阵”落成阵型编组层

### 目标

让“剑阵”成为真正可切换、可比较、可评估的 harness preset，而不是命名装饰。

### 要做什么

1. 定义 `FormationSpec`
2. 实现 formation registry / resolver
3. 首批阵型建议：
   - `research_array`
   - `coding_array`
   - `verification_array`
   - `writing_array`
   - `ops_array`
4. 每个阵型最少包含：
   - profile mapping
   - toolset exposure
   - context block preference
   - verification route
   - export detail level

### 产出物

- `meta/formations/*`
- 阵型配置文档
- 阵型与 profile 的映射说明

### 验收标准

- 同一任务可切换不同 formation 运行
- 不同 formation 的 context / tool exposure / evaluator focus 产生差异化输出
- 阵型切换不会破坏当前 runtime 稳定性

---

## Phase 3：补上 Diagnostic Archive，而不是停留在 manifest history

### 目标

把当前“历史记录层”升级成“诊断经验层”。

### 要做什么

1. 为每次运行创建独立 run directory
2. 保存更细粒度产物：
   - task contract
   - profile resolution
   - formation resolution
   - context plan
   - tool trace
   - verification report
   - governance report
   - final metrics / score
3. 定义稳定目录结构与最小 schema
4. 保持与 `run_history.jsonl` 解耦：
   - manifest 是真相源
   - archive 是诊断副产物集

### 产出物

- `artifacts/runs/<run_id>/...`
- archive schema 文档
- run artifact writer

### 验收标准

- 一次运行结束后，能生成完整 run artifact 目录
- 可根据 run_id 复原该次运行的关键上下文与诊断信息
- archive 的写入不影响当前 CLI / batch 的正常行为

---

## Phase 4：为经验系统补“可检索层”

### 目标

让系统不只是“有历史”，而是能“按需检索历史经验”。

### 要做什么

1. 增加最小 searchable index
2. 初版方案优先建议：
   - SQLite + FTS5
   - 或简化版本地索引器
3. 支持按以下维度查：
   - run_id
   - workflow_profile_id
   - formation_id
   - task label / task text
   - failure type
   - metric range
4. 增加最小查询接口：
   - CLI query
   - Python helper

### 产出物

- `entrypoints/history_query.py`
- index builder
- 最小查询接口

### 验收标准

- 能按 formation / failure type / task text 找到相关 run
- 能快速定位某类失败对应的 raw trace / report
- 不要求现在就做复杂 dashboard

---

## Phase 5：增加 Environment Snapshot / Workspace Snapshot

### 目标

把“环境先验”做成正式能力，降低 coding / agent 任务开局的信息盲区。

### 要做什么

1. 增加 preflight snapshot：
   - 工作目录结构
   - 关键依赖存在性
   - 语言 / 包管理器 / 运行环境
   - 资源限制信息
2. 将 snapshot 结果作为：
   - archive 的一部分
   - formation 可选注入块
3. 区分：
   - `environment_snapshot`
   - `workspace_snapshot`
   - `dependency_snapshot`

### 产出物

- `harness/context/environment_snapshot.py`
- snapshot schema
- 注入规则说明

### 验收标准

- coding / agent 任务在首轮就能拿到环境基础信息
- snapshot 可以被 archive 保存并被检索
- snapshot 失败时不阻塞整个系统，只回落为 warning

---

## Phase 6：做 OpenClaw Adapter / Plugin / Command Pack 最小版

### 目标

把当前系统以“宿主增强包”的形态交付出去。

### 要做什么

1. 新增宿主适配目录：

```text
adapters/
  openclaw/
    manifest/
    commands/
    skills/
    wrappers/
    config/
    examples/
```

2. 第一批命令建议只做最小 5 个：
   - `run-with-profile`
   - `batch-run`
   - `history-latest`
   - `history-summary`
   - `export-last-run`
3. 增加 formation 参数：
   - `--formation research_array`
   - `--formation coding_array`
4. 提供配置样例和安装说明
5. 先做 thin command pack / bundle 形态，再决定是否升级为更完整 native plugin

### 产出物

- OpenClaw plugin / bundle skeleton
- 安装说明
- 示例配置
- 示例命令

### 验收标准

- 用户能够在宿主中安装并运行最小命令集
- 命令能走到当前窄内核，而不是复制一套新 runtime
- 形成最小可安装体验

---

## Phase 7：做 Offline Meta-Harness 外环，而不是在线自修改

### 目标

让系统开始具备“优化 harness 自身”的能力，但先放在 sandbox 中离线运行。

### 要做什么

1. 建立 candidate harness registry
2. 定义 candidate 的最小单元：
   - formation 版本
   - policy 版本
   - context assembly 版本
   - preflight 版本
3. evaluator 执行固定 benchmark / regression task set
4. proposer 只允许在 sandbox 中修改 candidate
5. 将提案结果写入 archive 与 candidate registry
6. 人工批准后才允许晋升为 stable preset

### 产出物

- `meta_harness/*`
- benchmark task set
- candidate diff / score 记录

### 验收标准

- 可以离线比较多个 formation / policy 版本
- proposer 的优化有据可查，可回滚
- 不会直接污染主 runtime 稳定分支

---

## 7. 建议的目录重构方案

建议的顶层目录如下：

```text
core/
  profile/
  contract/
  context/
  evaluation/
  batch/
  history/

meta/
  environment/
  formations/

runtime/
  orchestrator/
  execution/
  verification/
  governance/

artifacts/
  baselines/
  runs/
  indexes/

meta_harness/
  registry/
  proposer/
  evaluator/
  search_loop/
  candidates/

adapters/
  openclaw/
    manifest/
    commands/
    skills/
    wrappers/
    config/
    examples/

docs/
  architecture/
  setup/
  references/
```

如果你不想做大规模物理迁移，也可以先保留现有目录，仅新增：

- `meta/environment/`
- `meta/formations/`
- `artifacts/runs/`
- `artifacts/indexes/`
- `meta_harness/`
- `adapters/openclaw/`

也就是先做**逻辑分层增强**，暂不做大规模目录搬迁。

---

## 8. 最终目标与最终目的

### 8.1 最终目标

把当前项目演化为：

> **一个面向 AI 宿主平台的工作环境增强系统**

它不是另一个大而全宿主，而是：

- 有稳定窄内核
- 有环境法则层（三体）
- 有阵型编组层（剑阵）
- 有可检索的诊断经验层
- 有离线 harness 优化外环
- 有可安装的宿主适配层

### 8.2 最终目的

这个项目最终想解决的，不是“让 agent 看起来更复杂”，而是 5 个更实质的问题：

1. **降低长任务中的上下文腐化与经验丢失**
2. **把 AI 工作环境从临时 prompt 堆叠，升级为可治理、可持续、可进化的外部系统**
3. **把 workflow、evaluation、history、diagnosis 从一次性对话副产物，升级为可复用资产**
4. **让“剑阵 / 三体”从世界观变成真实可执行的方法层**
5. **让系统能作为 OpenClaw / OpenCode / Claude Code 等宿主的增强包落地，而不是孤立自转**

### 8.3 未来可形成的对外表述

一句话版本：

> 这是一个面向宿主 AI 平台的工作环境增强框架：用环境法则、阵型编组、诊断归档和离线 harness 优化，提升长任务的稳定性、可控性与可复用性。

---

## 9. 当前最优先的执行建议

如果只允许选最重要的前三步，建议顺序如下：

### 优先级 1：先补 Diagnostic Archive

原因：

- 现在已有 history，但还没有真正可诊断的经验层。
- 没有 raw traces 与可检索 archive，后续无论做 formation 还是 meta-harness，都会停留在概念层。

### 优先级 2：把“三体 / 剑阵”配置化

原因：

- 如果它们不进入代码与配置，就会继续沦为命名包装。
- 只有变成 policy / formation，后面才谈得上评估、切换与优化。

### 优先级 3：做 OpenClaw Adapter 最小命令集

原因：

- 当前最合理的对外交付方式，是宿主增强包。
- 但 adapter 要建立在明确的 environment / formation / archive 之上，才不会只是命令壳子。

---

## 10. 结论

当前项目已经从“概念架构”阶段走到了“窄而稳定的可执行骨架”阶段。

因此，下一步最合理的优化，不是继续横向膨胀 runtime，而是完成这条升级链：

**冻结窄内核 → 落地三体环境层 → 落地剑阵阵型层 → 建立诊断经验层 → 增加可检索索引 → 接入 OpenClaw → 进入离线 Meta-Harness 优化外环。**

这条路径的核心价值在于：

- 保留你最初的“剑阵 / 三体”思想；
- 但把它们转化为真实可运行、可治理、可检索、可优化的工程层；
- 同时避免项目再次掉回“大而全宿主 runtime”的复杂度陷阱。

---

## 11. 参考链接（仓库 / 文献 / 文档）

### 11.1 你当前项目内部材料

- 当前仓库 README（本次对话上传）
- `PROJECT_HANDOFF_v0.5.md`（本次对话上传）

### 11.2 相关仓库 / 产品 / 文档

- Hermes Agent 仓库：
  - https://github.com/NousResearch/hermes-agent
- Hermes Context Files：
  - https://hermes-agent.nousresearch.com/docs/user-guide/features/context-files/
- Hermes Persistent Memory：
  - https://hermes-agent.nousresearch.com/docs/user-guide/features/memory/
- Hermes Tools & Toolsets：
  - https://hermes-agent.nousresearch.com/docs/user-guide/features/tools/

- danghuangshang 仓库：
  - https://github.com/wanikua/danghuangshang

- OpenClaw 总览：
  - https://docs.openclaw.ai/
- OpenClaw Plugins：
  - https://docs.openclaw.ai/plugin
- OpenClaw Plugins CLI：
  - https://docs.openclaw.ai/cli/plugins
- OpenClaw Building Plugins：
  - https://docs.openclaw.ai/plugins/building-plugins
- OpenClaw Plugins / Tooling：
  - https://docs.openclaw.ai/tools/plugin
- OpenClaw Community Plugins：
  - https://docs.openclaw.ai/plugins/community

### 11.3 相关论文 / 研究

- Meta-Harness 论文 PDF：
  - https://yoonholee.com/meta-harness/paper.pdf
- Meta-Harness 项目页：
  - https://yoonholee.com/meta-harness/
- Meta-Harness 优化产物仓库：
  - https://github.com/stanford-iris-lab/meta-harness-tbench2-artifact

---

## 12. 建议的下一份执行文档

在这份总方案之后，下一份最值得继续写的文档是：

1. `v0.6 / v1-alpha 实施路线图（按周拆解）`
2. `目录改造清单 + 文件级实现说明`
3. `可直接交给 Codex / OpenCode 的完整执行 prompt`
4. `人工验收清单 + 回归测试清单`
