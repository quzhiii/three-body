# 🌌 three-body

<div align="center">

**AI Agent Governance Universe · Inspired by *The Three-Body Problem***

[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](./LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Claude%20Code%20%2F%20Opencode%20%2F%20OpenClaw-blueviolet?style=flat-square)](./install.sh)
[![Phase](https://img.shields.io/badge/Phase-2%20·%20Strategy%20Layer%20Live-blue?style=flat-square)](./UNIVERSE.md)
[![Skills](https://img.shields.io/badge/Released-7%20skills-brightgreen?style=flat-square)](./ARCHITECTURE.md)
[![Architecture](https://img.shields.io/badge/Architecture-4%20layers-orange?style=flat-square)](./ARCHITECTURE.md)

<p align="center">
  <a href="#why-this-repository-exists">Why</a> ·
  <a href="#current-architecture-phase-2">Architecture</a> ·
  <a href="#what-each-of-the-7-skills-does">Skills</a> ·
  <a href="#what-to-install-and-when">Install</a> ·
  <a href="#best-fit-scenarios">Best fit</a>
</p>

<p align="center">
  <img src="./docs/assets/hero.png" alt="three-body" style="max-height: 360px; width: auto;">
</p>

> **Three-Body defines the boundary. Zhu Xian Formation decides the approach.**
>
> A governance system for AI agents:
> not just **what to do**, but **when to pause, when to plan, when to inspect evidence, and when not to proceed at all**.

[中文版](./README.md) · [Architecture](./ARCHITECTURE.md) · [Universe Map](./UNIVERSE.md) · [Installer](./install.sh)

</div>

---

## Why this repository exists

Most agent skills solve only one narrow problem:

- how to write code
- how to call tools
- how to sound smart in a system prompt

In practice, agent failures usually start earlier in the chain:

1. the agent never chose the right working mode
2. the safety boundary was never made explicit
3. complex work went straight into execution without planning
4. the plan looked reasonable because nobody tried to break it
5. high-risk actions had no final decision maker
6. failures were retried from intuition instead of evidence

**three-body** is built around that full chain.

It has four layers that can be installed separately or used together:

- **Tactics**: decide how the task should be approached right now
- **Governance**: define the current behavioral boundary
- **Strategy**: insert planning / challenge / authorization roles when needed
- **Evidence**: go back to archives when something fails, instead of guessing forward

---

## Problems it solves

| Real problem | Typical failure mode | three-body's answer |
|---|---|---|
| The agent starts doing immediately | It codes when it should first inspect or reason | `agent-work-environment-v3` selects the working formation |
| Safety boundary is unclear | It proceeds when it should pause or confirm | `environment-governance` defines the boundary |
| Complex work is improvised mid-flight | Plans drift and rework gets expensive | `wallfacer` plans first |
| Plans are never challenged | Hidden assumptions explode during implementation | `wallbreaker` attacks the plan |
| High-risk actions lack a final decider | Risk is known, but no one authorizes or blocks | `swordbearer` makes the final call |
| Failures are retried from guesswork | No archive reading, no evidence, repeated mistakes | `diagnostic-archive` restores the evidence trail |

In one sentence:

> **three-body cares less about “starting faster” and more about getting the direction and the boundary right first.**

---

## 30-second understanding

If you only want the core idea, keep these four lines:

- **Zhu Xian Formation** decides the working mode first
- **Three-Body Laws** define the current boundary second
- **The three strategy roles** appear only when work is complex or risky
- **Archive Reader** pulls the system back to evidence after failure

The shortest way to think about it is this: it restructures the agent behavior chain into:

> **mode selection → boundary definition → strategic intervention → evidence recovery**

---

## Current architecture (Phase 2)

```text
┌────────────────────────────────────────────────────────────────────┐
│                         TACTICS LAYER                              │
│                                                                    │
│   ⚔️ agent-work-environment-v3                                     │
│   Zhu Xian Formation: choose research / implement / verify /       │
│   writing / ops mode from task intent                              │
└────────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌────────────────────────────────────────────────────────────────────┐
│                       GOVERNANCE LAYER                             │
│                                                                    │
│   ⚖️ environment-governance                                        │
│   Three-Body Laws: define confirmation, escalation, writeback,     │
│   and diagnostic boundaries from task signals                      │
│                                                                    │
│   Core philosophy: Dark Forest law                                 │
│   Here it is a law and philosophy, not a concrete execution role    │
└────────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌────────────────────────────────────────────────────────────────────┐
│                         STRATEGY LAYER                             │
│                                                                    │
│   🧱 wallfacer   → deep planning                                    │
│   🔓 wallbreaker → adversarial challenge                            │
│   ⚔️ swordbearer → final authorization for high-risk actions        │
└────────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌────────────────────────────────────────────────────────────────────┐
│                          EVIDENCE LAYER                            │
│                                                                    │
│   📁 diagnostic-archive                                            │
│   Read run archives, locate root causes, and provide evidence for  │
│   retries, approvals, and disputed plans                           │
└────────────────────────────────────────────────────────────────────┘
```

## What each of the 7 skills does

### The 6 roles in the main architecture

| Skill | Layer | Role | Responsible for | Not responsible for |
|---|---|---|---|---|
| `agent-work-environment-v3` | Tactics | Zhu Xian Formation | detect task intent, choose the formation, shape next-step workflow | does not define safety laws, deep-plan, or authorize |
| `environment-governance` | Governance | Three-Body Laws | define boundaries from risk, complexity, failure state, and write intent | does not route tasks or replace execution skills |
| `wallfacer` | Strategy | Wallfacer | converge candidate paths and choose a main plan for complex work | does not challenge its own plan or authorize |
| `wallbreaker` | Strategy | Wallbreaker | break plans, expose blind spots and unverified assumptions | does not create the first plan |
| `swordbearer` | Strategy | Swordbearer | final allow / pause / deny decision on high-risk actions | does not perform the full risk-identification layer |
| `diagnostic-archive` | Evidence | Archive Reader | read archives and reconstruct failure evidence | does not fix bugs, rerun tasks, or replace planning |

### The 1 compatibility skill

| Skill | Position | Notes |
|---|---|---|
| `agent-work-environment` | compatibility combined version | merges routing + governance into one skill for users who want a single install path; the main direction remains the split architecture |

---

## How they work together

The important thing here is the **interaction model**—how these skills cooperate in sequence.

### 1) Standard task

```text
User task
  → agent-work-environment-v3
  → environment-governance
  → execution skill
```

Use for: ordinary implementation, routine fixes, clear single-path tasks.

### 2) Complex task

```text
User task
  → agent-work-environment-v3
  → environment-governance
  → wallfacer
  → execution skill
```

Use for: refactors, multi-stage changes, cross-module work.

### 3) Complex and controversial task

```text
User task
  → agent-work-environment-v3
  → environment-governance
  → wallfacer
  → wallbreaker
  → execution skill
```

Use for: plan-heavy work, expensive rework risk, disputed directions.

### 4) High-risk task

```text
User task
  → agent-work-environment-v3
  → environment-governance
  → swordbearer
  → careful / guard / execution skill
```

Use for: deletion, force-push, production config changes, credential edits.

### 5) High-risk task that already failed before

```text
User task
  → agent-work-environment-v3
  → environment-governance
  → diagnostic-archive
  → swordbearer
  → execution skill
```

Use for: risky work that already has failure history.

---

## Where the naming comes from

### Three-Body defines the boundary

What *The Three-Body Problem* gives this repository is a strong **boundary philosophy**.

- context is scarce, so resources must be conserved
- environments mutate, so escalation paths matter
- broader exposure increases failure surface: that is the Dark Forest law in agent terms
- high-risk actions should be governed by deterrence and decision, not impulse

So:

> **Dark Forest is a governing law here. It frames how exposure and caution are understood; it is not a concrete execution skill.**

### Zhu Xian Formation decides the approach

What Zhu Xian Formation gives this repository is a **task-mode model**.

The same user request can require completely different modes:

- inspect first
- implement directly
- verify first
- write documentation
- operate carefully in ops mode

That is why `agent-work-environment-v3` starts by deciding:

> **which formation the work should enter.**

---

## The five formations of Zhu Xian

| Formation | Mode | Typical use |
|---|---|---|
| Guan Ji | Research | inspect structure, patterns, and unknowns first |
| Po Ju | Implementation | execute after the goal is clear |
| Ming Jian | Verification | testing, checking, regression, acceptance |
| Li Yan | Writing | docs, design notes, summaries, release text |
| Xing Ling | Operations | deployment, config changes, environment actions |

These five formations work more like a **working-mode menu**.

---

## The core of Three-Body Laws

`environment-governance` is not trying to win by stacking more rules. Its job is to read the situation and tighten or relax the boundary accordingly.

### Five laws

- Context Budget
- Tool Boundary
- Risk Escalation
- Writeback Policy
- Diagnostic Access

### Four core signals

- `risk_level`
- `task_complexity`
- `has_failed`
- `write_intent`

Its real value is this:

> The real move is understanding the situation first, then deciding how strict the boundary should be.

---

## What to install and when

### I only want the core setup

If you only want the core “choose mode first, define boundary second” behavior:

```bash
./install.sh claude
```

This installs:

- `agent-work-environment-v3`
- `environment-governance`

Best for: most first-time users of three-body.

### I need failure diagnosis

```bash
./install.sh claude --with-archive
```

Adds:

- `diagnostic-archive`

Best for: users who already rely on run archives or regularly investigate failures.

### I need the full strategy layer

```bash
./install.sh claude --with-strategy
```

Adds:

- `wallfacer`
- `wallbreaker`
- `swordbearer`

Best for: users with complex work, plan-heavy tasks, or high-risk action review needs.

### I want the recommended full install

```bash
./install.sh claude --with-strategy --with-archive
```

Best for: installing the full four-layer system in one shot.

Manual copy also works:

```bash
cp -r environment-governance ~/.claude/skills/
cp -r agent-work-environment-v3 ~/.claude/skills/
cp -r diagnostic-archive ~/.claude/skills/
cp -r wallfacer ~/.claude/skills/
cp -r wallbreaker ~/.claude/skills/
cp -r swordbearer ~/.claude/skills/
```

Compatibility combined mode:

```bash
./install.sh claude --classic
```

---

## Supported platforms

| Platform | Identifier | Status |
|---|---|---|
| Claude Code | `claude` | ✅ verified |
| Opencode | `opencode` | ✅ verified |
| OpenClaw | `openclaw` | ✅ verified |

More install details: [`install.sh`](./install.sh)

---

## What changes after installation

If you suspect this is “just a prettier system prompt,” look at the smallest proof first:

- [examples/behavior-diff.md](./examples/behavior-diff.md)

It compares the same high-risk prompt in three states:

1. no three-body installed
2. only `environment-governance`
3. routing + governance installed together

The difference is not just style. The real change is in the **decision chain**.

---

## Best-fit scenarios

### Best fit for people who:

- you use coding agents continuously, not just for one-off prompts
- you care about high-risk boundaries, not only speed
- your work spans research, implementation, verification, documentation, and ops
- you want complex tasks to be planned before execution
- you want failures investigated from evidence instead of instinctive retries

### Probably overkill if you only need:

- single-turn Q&A
- a few quick code lines
- no safety boundary or behavior consistency at all

In those cases, three-body will likely feel heavier than necessary.

---

## Technical roadmap

### Phase 1: foundational layer

Completed:

- `environment-governance`
- `agent-work-environment-v3`
- `diagnostic-archive`

Core value:

> choose the mode, define the boundary, read the evidence.

### Phase 2: strategy layer

Completed:

- `wallfacer`
- `wallbreaker`
- `swordbearer`

Core value:

> plan, challenge, authorize.

### Phase 3: intelligence and long memory

Planned:

- `sophon`

Not implemented yet, and should not be confused with Phase 2.

---

## Repository structure

```text
three-body/
├── README.md
├── README_EN.md
├── ARCHITECTURE.md
├── UNIVERSE.md
│
├── environment-governance/      # Three-Body Laws
├── agent-work-environment-v3/   # Zhu Xian Formation (main)
├── diagnostic-archive/          # Archive Reader
├── wallfacer/                   # Wallfacer
├── wallbreaker/                 # Wallbreaker
├── swordbearer/                 # Swordbearer
├── agent-work-environment/      # compatibility combined version
│
├── scripts/
│   ├── validate-repo.ps1
│   └── build-skill-packages.ps1
│
└── examples/
```

---

## Validation and packaging

### Validate repo consistency

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\validate-repo.ps1
```

### Rebuild `.skill` artifacts

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\build-skill-packages.ps1
```

Recommended flow:

1. edit source directories first
2. rebuild `.skill`
3. run the validator last

---

## Design principles

1. **Layer before combination**: do not begin with one giant control skill
2. **Recognize before authorize**: governance identifies risk; swordbearer decides passage
3. **Plan before execution**: complex work should not jump straight into implementation
4. **Challenge before commitment**: expensive plans should be broken once before being trusted
5. **Evidence before conclusion**: after failure, inspect archives before retrying

---

## If this is your first time here

1. read this README first to understand the relationship between the 7 skills
2. then read [ARCHITECTURE.md](./ARCHITECTURE.md) for the full interaction model
3. if you want to install, go straight to [`install.sh`](./install.sh)
4. if you want the long-term roadmap, read [UNIVERSE.md](./UNIVERSE.md)

If you only want to spend 5 minutes on the project, use this reading order:

1. read “30-second understanding”
2. read “Current architecture (Phase 2)”
3. read “How they work together”
4. decide between the core install and the full install

---

## License

[MIT](./LICENSE)

---

<div align="center">

**Three-Body defines the boundary. Zhu Xian Formation decides the approach.**

The goal here is not to make an agent feel more omnipotent.
The goal is to make it behave more like a **system that can survive uncertainty over time**.

Many agent stacks optimize for “start doing faster.”
three-body puts more weight on a different question: **are we about to start in the wrong direction?**

[中文版](./README.md) · [Architecture](./ARCHITECTURE.md) · [Universe Map](./UNIVERSE.md)

</div>
