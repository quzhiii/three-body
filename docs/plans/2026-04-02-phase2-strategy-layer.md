# Phase 2 Strategy Layer Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Land Phase 2 of the `three-body` repository by introducing the strategy layer through `swordbearer`, `wallfacer`, and `wallbreaker`, while keeping `sophon` deferred to Phase 3.

**Architecture:** Phase 1 already provides routing (`agent-work-environment-v3`), governance (`environment-governance`), and evidence reading (`diagnostic-archive`). Phase 2 adds strategic decision roles above the tactical router: `swordbearer` for final authorization of high-risk actions, `wallfacer` for deep planning before implementation, and `wallbreaker` for adversarial review of plans. These roles must integrate with the existing split architecture instead of reintroducing a monolithic controller.

**Tech Stack:** Markdown skill definitions (`SKILL.md`), repository READMEs, references docs, PowerShell packaging scripts, GitHub-facing documentation.

---

## Phase Summary

### Why Phase 2 now

Phase 1 answers three questions well:

- what mode to use (`agent-work-environment-v3`)
- how to act safely (`environment-governance`)
- how to inspect failures (`diagnostic-archive`)

What is still missing is the strategic layer:

- who authorizes dangerous actions
- who creates a deep plan before execution
- who challenges that plan before it turns into code or operations

### Why `sophon` stays later

`sophon` depends on cross-session memory, indexing, and pattern recognition on top of a stable archive substrate. The repository currently has an archive reader, not a long-term cognition layer. Therefore `sophon` remains Phase 3.

---

## Delivery Order

### Phase 2A — `swordbearer`
First because it is the smallest conceptual leap from current governance.

### Phase 2B — `wallfacer`
Second because it fills the gap between routing and execution for complex work.

### Phase 2C — `wallbreaker`
Third because it is most coherent once `wallfacer` exists as the primary plan producer.

---

## Task 1: Create the Phase 2 planning scaffold

**Files:**
- Create: `docs/plans/2026-04-02-phase2-strategy-layer.md`
- Modify later: `README.md`
- Modify later: `README_EN.md`
- Modify later: `UNIVERSE.md`

**Step 1: Write the roadmap document**

Document the strategy-layer objective, the role ordering, and the dependency graph.

**Step 2: Make sure the roadmap is repository-grounded**

Reference these existing roles explicitly:

- `environment-governance` = governance layer
- `agent-work-environment-v3` = tactical routing layer
- `diagnostic-archive` = archive evidence reader
- `agent-work-environment` = compatibility bundle

**Step 3: Capture the high-level execution graph**

Use this operational chain as the source of truth:

```text
User task
  -> Formation Router
  -> Three-Body Laws
  -> [complex task?] Wallfacer
  -> [plan needs challenge?] Wallbreaker
  -> [high-risk action?] Swordbearer
  -> execution skill
  -> Diagnostic Archive when failures occur
```

**Step 4: Define completion criteria for the roadmap**

The roadmap is done when:

- priorities are explicit
- each new skill has a repository file tree
- each new skill has minimum I/O contracts
- documentation and packaging impacts are listed
- validation expectations are listed

---

## Task 2: Land `swordbearer` as the first strategy skill

**Files:**
- Create: `swordbearer/SKILL.md`
- Create: `swordbearer/README.md`
- Create: `swordbearer/CHANGELOG.md`
- Create: `swordbearer/references/authorization-matrix.md`
- Create: `swordbearer/references/high-risk-actions.md`
- Modify: `README.md`
- Modify: `README_EN.md`
- Modify: `UNIVERSE.md`
- Modify: `install.sh`
- Modify: `scripts/build-skill-packages.ps1`
- Modify: `scripts/validate-repo.ps1`

**Purpose:**

Transform “high-risk confirmation” from a rule-only concept into a dedicated authorization role.

**Minimum role definition:**

- It does **not** replace `environment-governance`
- It receives high-risk context from governance and/or ops routing
- It outputs an authorization decision: allow / pause / deny / require-more-context

**Minimum input contract:**

| Input | Meaning |
|---|---|
| `proposed_action` | the concrete high-risk operation |
| `risk_source` | why the action is high-risk |
| `impact_scope` | what could be affected |
| `rollback_plan` | whether and how rollback exists |
| `alternatives_considered` | whether safer alternatives were considered |

**Minimum output contract:**

| Output | Meaning |
|---|---|
| `authorization_status` | allow / pause / deny |
| `required_clarifications` | missing information before proceeding |
| `deterrence_summary` | short justification for the decision |
| `recommended_next_skill` | likely `careful` / `guard` / executor |

**Integration expectations:**

- `environment-governance` flags must-confirm / escalation cases
- `agent-work-environment-v3` `行令阵` or risky transitions may recommend `swordbearer`
- `diagnostic-archive` should be recommended first if the high-risk path follows repeated failures

**Validation:**

Add trigger/non-trigger examples for:

- deleting production data
- force push after review failures
- changing secrets or credentials
- normal code editing (should not trigger `swordbearer`)

---

## Task 3: Land `wallfacer` as the deep planning role

**Files:**
- Create: `wallfacer/SKILL.md`
- Create: `wallfacer/README.md`
- Create: `wallfacer/CHANGELOG.md`
- Create: `wallfacer/references/planning-output-format.md`
- Create: `wallfacer/references/decision-criteria.md`
- Create: `wallfacer/references/escalation-to-wallbreaker.md`
- Modify: `README.md`
- Modify: `README_EN.md`
- Modify: `UNIVERSE.md`
- Modify: `agent-work-environment-v3/INTEGRATIONS.md`
- Modify: `install.sh`
- Modify: `scripts/build-skill-packages.ps1`
- Modify: `scripts/validate-repo.ps1`

**Purpose:**

Provide an explicit deep-planning role for complex tasks before implementation begins.

**Minimum role definition:**

- It is **not** a router
- It is **not** governance
- It is **not** generic brainstorming
- It creates candidate paths and recommends one

**Minimum input contract:**

| Input | Meaning |
|---|---|
| `task` | the task to be solved |
| `goal` | expected end state |
| `constraints` | deadlines, safety constraints, compatibility limits |
| `known_risks` | already identified concerns |
| `needs_multi_stage_plan` | whether the task crosses phases |

**Minimum output contract:**

| Output | Meaning |
|---|---|
| `candidate_paths` | 2-3 viable solution paths |
| `recommended_path` | the chosen direction |
| `rejected_paths` | paths not selected and why |
| `critical_unknowns` | what still needs verification |
| `recommended_next_skill` | likely execution handoff |

**Integration expectations:**

- `agent-work-environment-v3` should recommend `wallfacer` when the task is complex and multi-stage
- `environment-governance` continues to provide risk constraints during planning
- `wallfacer` may escalate to `wallbreaker` when assumptions are material and unproven

**Validation:**

Add examples for:

- architecture refactor before coding
- large multi-step migration
- a simple bugfix that should **not** use `wallfacer`

---

## Task 4: Land `wallbreaker` as the adversarial plan challenger

**Files:**
- Create: `wallbreaker/SKILL.md`
- Create: `wallbreaker/README.md`
- Create: `wallbreaker/CHANGELOG.md`
- Create: `wallbreaker/references/challenge-patterns.md`
- Create: `wallbreaker/references/hidden-assumptions.md`
- Create: `wallbreaker/references/pushback-thresholds.md`
- Modify: `README.md`
- Modify: `README_EN.md`
- Modify: `UNIVERSE.md`
- Modify: `agent-work-environment-v3/INTEGRATIONS.md`
- Modify: `install.sh`
- Modify: `scripts/build-skill-packages.ps1`
- Modify: `scripts/validate-repo.ps1`

**Purpose:**

Challenge plans before execution, especially those produced by `wallfacer` or provided directly by users.

**Minimum role definition:**

- It does **not** generate the initial plan
- It does **not** replace review/qa on completed work
- It attacks assumptions, blind spots, and untested reasoning

**Minimum input contract:**

| Input | Meaning |
|---|---|
| `target_plan` | the plan or recommendation to inspect |
| `decision_context` | why this plan matters now |
| `known_assumptions` | explicit assumptions already stated |
| `risk_profile` | what happens if the plan is wrong |

**Minimum output contract:**

| Output | Meaning |
|---|---|
| `hidden_assumptions` | unstated assumptions found |
| `top_failure_modes` | likely breakdown points |
| `challenge_summary` | short adversarial assessment |
| `required_validation` | checks needed before execution |
| `proceed_recommendation` | proceed / revise / block |

**Integration expectations:**

- best paired with `wallfacer`
- may be invoked by `agent-work-environment-v3` when a plan exists but confidence is low
- should not overlap with ordinary implementation review

**Validation:**

Add examples for:

- challenging a migration plan
- questioning an architecture proposal
- non-trigger example: simple documentation task

---

## Task 5: Update top-level narrative and install flow

**Files:**
- Modify: `README.md`
- Modify: `README_EN.md`
- Modify: `UNIVERSE.md`
- Modify: `install.sh`

**Documentation changes required:**

1. Update root README skill table to include strategy layer roles
2. Add a “Phase 2 strategy layer” architecture diagram
3. Explain that `swordbearer`, `wallfacer`, and `wallbreaker` are optional strategy extensions on top of split install
4. Keep `sophon` marked as Phase 3 only

**Install strategy:**

Recommended approach:

- keep current default install lightweight
- add optional strategy install mode later, e.g. `--with-strategy`
- do not make all Phase 2 skills mandatory for first-time users

---

## Task 6: Extend repository validation for Phase 2

**Files:**
- Modify: `scripts/validate-repo.ps1`

**Validation additions:**

- every new skill must have `SKILL.md`, `README.md`, `CHANGELOG.md`
- every new skill must be present in root `README.md`, `README_EN.md`, and `UNIVERSE.md`
- packaging script must emit corresponding `.skill`
- install documentation must mention how to install optional strategy skills

**Behavior validation examples to add or check:**

- `swordbearer` trigger matrix
- `wallfacer` trigger vs non-trigger matrix
- `wallbreaker` challenge vs non-trigger matrix

---

## Task 7: Define release order and acceptance gates

**Files:**
- Modify later: root docs after each skill lands

**Release order:**

1. `swordbearer`
2. `wallfacer`
3. `wallbreaker`
4. documentation consolidation pass

**Acceptance gate for each skill:**

- skill definition exists and is internally coherent
- README explains role vs existing skills
- references are sufficient to execute the role without guessing
- root docs and universe docs are synchronized
- package build still works
- validation script passes

---

## Implementation Notes for the Executor

- Do **not** re-merge routing and governance into a single new controller.
- Do **not** let `wallfacer` become a generic brainstorming skill.
- Do **not** let `wallbreaker` collapse into ordinary code review.
- Do **not** pull `sophon` into Phase 2.
- Maintain split-architecture discipline throughout.

---

## Suggested Next Execution Options

1. **Subagent-Driven (this session)**
   - implement `swordbearer` first
   - review after each task
   - then continue to `wallfacer`

2. **Parallel Session (separate)**
   - use `superpowers:executing-plans`
   - execute this roadmap file in a fresh implementation session
