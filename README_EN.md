# 🌌 three-body

<div align="center">

**AI Agent Governance Universe · Inspired by *The Three-Body Problem***

[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](./LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Claude%20Code-blueviolet?style=flat-square)](https://claude.ai)
[![Phase](https://img.shields.io/badge/Phase-1%20·%20Foundation-blue?style=flat-square)](./UNIVERSE.md)
[![Skills](https://img.shields.io/badge/Released-3%20skills-brightgreen?style=flat-square)]()

> **Three-Body defines the boundary. Zhu Xian Formation decides the approach.**
>
> A behavioral constraint and task routing system for AI Agents.
> Every skill is a character in the universe.

🌐 [中文版](./README.md)

</div>

---

## 💡 Why "three-body"

I am an avid reader of Liu Cixin's *The Three-Body Problem*.

In the novel, the Trisolaran civilization evolved unique survival wisdom in an extremely unstable environment. Their world has three suns with unpredictable orbits, and civilization repeatedly rises and falls between Stable Eras and Chaotic Eras. To survive, Trisolarans developed strategies of **dehydration**, **rehydration**, and **radical rationality**.

AI Agents face a strikingly similar situation:
- Context windows are limited resources, like Trisolarans' dehydrated state
- User inputs are unpredictable, like the arrival of Chaotic Eras
- A single wrong tool call can destroy the entire session, like the three suns appearing together

**three-body** draws on the core concepts of the novel to build a governance system for AI Agents: **establishing deterministic constraints and routing rules in an uncertain environment**.

This is not a simple adaptation of the original work, but a tribute to its spirit—
> The Wallfacer's silence against the Sophons, the Swordbearer's understanding of deterrence, and the Dark Forest's philosophy of "safety through concealment."

---

## 🎭 Naming Logic: Three-Body × Zhu Xian Formation

### The Fusion of Sci-Fi and Mythology

| Cultural Origin | Concept | System Position | Core Function |
|:---:|:---|:---|:---|
| 📚 Liu Cixin's *The Three-Body Problem* | **Three-Body Laws** | Governance Layer | Define boundaries, constrain behavior |
| ⚔️ Chinese Mythology | **Zhu Xian Formation** | Tactics Layer | Provide paths, flexible execution |

### Three-Body — The Cosmic Law Layer

*The Three-Body Problem* emphasizes: In an unpredictable universe, the first principle of survival is **recognizing boundaries**.

- **Dehydration**: conserving strength when resources are limited → Context budget management
- **Chaotic Era**: coping strategies when environments mutate → Risk escalation mechanism
- **Dark Forest**: exposure means danger → Confirmation culture (unconfirmed = exposed)
- **Swordbearer Deterrence**: those with the power to destroy choose not to fire → Final authorization for high-risk operations

**Three-Body represents "constraint"** — telling the Agent what cannot be done and when it must stop.

### Zhu Xian Formation — The Tactical Execution Layer

Zhu Xian Formation (诛仙阵) is a supreme killing formation in Chinese mythology, with ever-changing patterns inside. Those who enter must follow specific paths to break the formation.

- **Observing the formation** → Look before acting → **Guan Ji Formation** (Research Mode)
- **Breaking the formation's eye** → Strike at the core → **Po Ju Formation** (Implementation Mode)
- **Verifying the formation** → Check for completeness → **Ming Jian Formation** (Verification Mode)
- **Recording the formation** → Document the strategy → **Li Yan Formation** (Writing Mode)
- **Executing orders** → High-risk operations with caution → **Xing Ling Formation** (Ops Mode)

**Zhu Xian Formation represents "change"** — flexible tactical choices within constraints.

### The Logical Relationship

```
┌─────────────────────────────────────────────────────────────────┐
│                        UNIVERSE LAYER                            │
│                                                                  │
│                        📚 THREE-BODY                             │
│                   Three-Body Problem                             │
│                                                                  │
│       "Establish deterministic boundaries in an                  │
│                    unpredictable universe"                       │
│                                                                  │
│   ┌──────────────┬────────────────────────────────────────┐     │
│   │  Dehydration │  Context is limited, must be conserved │     │
│   │  Dark Forest │  Unconfirmed = exposed, exposed = error│     │
│   │  Deterrence  │  High-risk ops need final authorization│     │
│   └──────────────┴────────────────────────────────────────┘     │
│                              │                                   │
│                              ▼ Tactical choices under law        │
│   ╔══════════════════════════════════════════════════════╗      │
│   ║                                                    ║      │
│   ║   THREE-BODY DEFINES THE BOUNDARY                 ║      │
│   ║   三 体 定 其 界                                   ║      │
│   ║                                                    ║      │
│   ╚══════════════════════════════════════════════════════╝      │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                        TACTICS LAYER                             │
│                                                                  │
│                    ⚔️ ZHU XIAN FORMATION                         │
│                     Formation Router                             │
│                                                                  │
│           "Use formation changes to survive                      │
│                 within constraints"                              │
│                                                                  │
│        ┌─────────────┐    ┌─────────────┐    ┌─────────────┐   │
│        │  Guan Ji    │───▶│  Po Ju      │───▶│  Ming Jian  │   │
│        │  Research   │    │  Implement  │    │  Verify     │   │
│        └─────────────┘    └─────────────┘    └─────────────┘   │
│               │                                      │          │
│               └──────────────┬───────────────────────┘          │
│                              ▼                                  │
│        ┌─────────────┐    ┌─────────────┐                      │
│        │  Li Yan     │    │  Xing Ling  │                      │
│        │  Write      │    │  Ops        │                      │
│        └─────────────┘    └─────────────┘                      │
│                                                                  │
│   ╔══════════════════════════════════════════════════════╗      │
│   ║                                                    ║      │
│   ║   FORMATION DECIDES THE APPROACH                  ║      │
│   ║   诛 仙 阵 定 其 式                                ║      │
│   ║                                                    ║      │
│   ╚══════════════════════════════════════════════════════╝      │
└─────────────────────────────────────────────────────────────────┘
```

**In one sentence**:
> **Three-Body defines the boundary (law constraint). Zhu Xian Formation decides the approach (tactical execution).**
> 
> Cold cosmic laws + Mysterious Eastern formations = A governance system for AI Agents that is both safe and flexible.

---

## 🎯 Problems Solved

AI Agents face two fundamental problems in use:

| Problem | Manifestation | three-body's Answer |
|---|---|---|
| **How to do it safely?** | Don't know when to pause and confirm, blindly execute high-risk operations | Three-Body Laws (`environment-governance`) |
| **What mode to use?** | Facing vague tasks without knowing which working state to enter | Zhu Xian Formation (`agent-work-environment-v3`) |

**Decoupled design**: The governance layer manages constraints, the routing layer manages modes. Independent but combinable.

---

## 🏗️ Current Architecture (Phase 1)

```
┌──────────────────────────────────────────────────────────┐
│                   APPLICATION LAYER                      │
│                                                          │
│   ⚔️ Formation Router          📁 Archive Reader         │
│   agent-work-environment-v3    diagnostic-archive        │
│   Zhu Xian Formation            Archive Reader           │
│   (5 formations routing)        (failure diagnosis)      │
│                                                          │
├──────────────────────────────────────────────────────────┤
│                   GOVERNANCE LAYER                       │
│                                                          │
│              ⚖️ Three-Body Laws                          │
│              environment-governance                      │
│         Five Laws · 4-Signal Model · Dynamic Bias       │
│                                                          │
│   Core Philosophy: Dark Forest Law                       │
│   (Concealment is safety. Swordbearer deterrence.)      │
│                                                          │
├──────────────────────────────────────────────────────────┤
│                   EXECUTION LAYER                        │
│         Code · review · careful · guard · ...            │
└──────────────────────────────────────────────────────────┘
```

---

## 📦 Released Skills

### ⚖️ Three-Body Laws
**`environment-governance`** · v1.0 · [Details](./environment-governance/README.md)

Independent behavioral constraint layer. Five Laws + 4-Signal Model, dynamically calculating Agent behavioral boundaries in different risk scenarios.

```
Five Laws:   Context Budget · Tool Boundary · Risk Escalation ·
             Writeback Policy · Diagnostic Access
4 Signals:   risk_level · task_complexity · has_failed · write_intent
```

---

### ⚔️ Formation Router — Zhu Xian Formation
**`agent-work-environment-v3`** · v3.0 · [Details](./agent-work-environment-v3/README.md)

Pure task router. Identify task intent → Select one of five formations → Output task signals → Recommend downstream skill.

```
Five Formations:
  Guan Ji  (Research)  · Po Ju   (Implementation) ·
  Ming Jian (Verify)   · Li Yan  (Writing)        ·
  Xing Ling (Ops)
```

---

### 📁 Archive Reader
**`diagnostic-archive`** · v1.0 · [Details](./diagnostic-archive/README.md)

Failure diagnosis and historical comparison. Read run archives, locate root causes, support single-run diagnosis and dual-run comparison.

---

### 🔶 Formation Classic — Zhu Xian Formation Combined (Backward Compatible)
**`agent-work-environment`** · v2.1 · [Details](./agent-work-environment/README.md)

Routing + Governance integrated version. Out-of-the-box option when you don't want separate management, no longer actively iterated.

---

## 🖥️ Supported Platforms

three-body works with the following AI Agent development environments:

| Platform | Identifier | Installation | Status |
|:---:|:---:|:---|:---:|
| **Claude Code** | `claude` | Skill directory installation | ✅ Verified |
| **Opencode** | `opencode` | Skill directory installation | ✅ Verified |
| **OpenClaw** | `openclaw` | Skill directory installation | ✅ Verified |
| **Codex CLI** | `codex` | Configuration / MCP | ✅ Verified |

### Platform-Specific Installation

#### Claude Code

```bash
# Recommended: Install split version (v3.0)
cp -r three-body/environment-governance ~/.claude/skills/
cp -r three-body/agent-work-environment-v3 ~/.claude/skills/

# Optional: Archive Reader
cp -r three-body/diagnostic-archive ~/.claude/skills/

# Verify installation
claude skills list
```

#### Opencode

```bash
# Recommended: Install split version (v3.0)
cp -r three-body/environment-governance ~/.opencode/skills/
cp -r three-body/agent-work-environment-v3 ~/.opencode/skills/

# Verify installation
opencode skills list
```

#### OpenClaw

OpenClaw supports loading custom skills via the Skill directory:

```bash
# Create OpenClaw skills directory (if not exists)
mkdir -p ~/.openclaw/skills

# Install three-body skills
cp -r three-body/environment-governance ~/.openclaw/skills/
cp -r three-body/agent-work-environment-v3 ~/.openclaw/skills/
cp -r three-body/diagnostic-archive ~/.openclaw/skills/

# Enable in OpenClaw config (usually ~/.openclaw/config.yaml)
# skills:
#   - environment-governance
#   - agent-work-environment-v3
#   - diagnostic-archive
```

#### Codex CLI

Codex CLI can incorporate three-body via **System Prompt** or **MCP (Model Context Protocol)**:

**Method 1: System Prompt (Recommended)**

Create or edit the Codex configuration file:

```bash
# macOS/Linux
mkdir -p ~/.codex
cat > ~/.codex/config.toml << 'EOF'
[system]
prompt = """
You are an AI Agent with three-body governance.

Always follow these principles from the Three-Body Laws:
1. Context Budget - Conserve context window, load on demand
2. Tool Boundary - Prefer low-risk tools, confirm high-risk ones
3. Risk Escalation - Pause before destructive operations
4. Writeback Policy - Confirm based on change type
5. Diagnostic Access - Read raw evidence when debugging

For task routing, use the Zhu Xian Formation approach:
- Research tasks → Guan Ji Formation (observation mode)
- Implementation → Po Ju Formation (breakthrough mode)
- Verification → Ming Jian Formation (inspection mode)
- Writing → Li Yan Formation (documentation mode)
- Operations → Xing Ling Formation (command mode with extra caution)
"""
EOF
```

**Method 2: MCP (if supported)**

Add to Codex's MCP configuration:

```json
{
  "mcpServers": {
    "three-body-governance": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem"],
      "env": {
        "SKILLS_PATH": "~/three-body"
      }
    }
  }
}
```

**Method 3: Direct SKILL.md Content**

Copy the contents of `environment-governance/SKILL.md` and `agent-work-environment-v3/SKILL.md` into Codex's system prompt.

### Usage

Once installed, use trigger phrases in conversation:

| Trigger Scenario | Description |
|---|---|
| `"Help me analyze this module"` | Auto enters Zhu Xian Formation → Guan Ji Formation (Research Mode) |
| `"Implement this feature, but carefully"` | Auto enters Zhu Xian Formation → Po Ju Formation (Implementation Mode) + Three-Body Laws constraints |
| `"Why did that run fail last time?"` | Invokes Archive Reader for failure diagnosis |
| `"Deploy to production"` | Auto enters Xing Ling Formation (Ops Mode) + Mandatory Swordbearer authorization |

---

## 🚀 Quick Install (Claude Code Example)

```bash
# Recommended: Split version (v3.0), routing and governance separated
cp -r environment-governance ~/.claude/skills/
cp -r agent-work-environment-v3 ~/.claude/skills/

# Optional: Failure diagnosis
cp -r diagnostic-archive ~/.claude/skills/

# Or: Combined version (v2.1), out-of-the-box
cp -r agent-work-environment ~/.claude/skills/
```

---

## 🌍 Universe Roadmap (Phase 2+)

three-body is an ever-expanding universe. Planned characters:

| Character | Candidate ID | Definition | Phase |
|:---:|:---|:---|:---:|
| ⚔️ **Swordbearer** | `swordbearer` | Final authorization for high-risk ops, deterrence > interception | Phase 2 |
| 🧱 **Wallfacer** | `wallfacer` | Independent deep planning, not exposing intermediate intent | Phase 2 |
| 🔓 **Wallbreaker** | `wallbreaker` | Questioning existing solutions, finding unverified assumptions | Phase 2 |
| 👁️ **Sophon** | `sophon` | Cross-session memory, global pattern recognition | Phase 3 |

→ [Complete Universe Map](./UNIVERSE.md)

---

## 💡 Design Philosophy

**1. Layered, Not Monolithic**
The routing layer (Zhu Xian Formation) and governance layer (Three-Body Laws) are decoupled. Each evolves and can be reused independently.

**2. Signal-Driven, Not Rule-Stacking**
4 signals calculate bias in real-time; no need to hand-write rules for every scenario.

**3. Hard Confirmation Cannot Be Bypassed**
Delete, force-push, credential changes — no matter how much the user urges, the governance layer has final veto power.

**4. Names Are The Design**
The Swordbearer's deterrence philosophy, the Wallfacer's deep planning, the Sophon's all-seeing perspective — character names themselves are behavioral logic documentation.

---

## 📁 Project Structure

```
three-body/
├── README.md                        # Chinese version (default)
├── README_EN.md                     # This file (English)
├── UNIVERSE.md                      # Universe map and roadmap
│
├── environment-governance/          # ⚖️ Three-Body Laws (Governance)
│   ├── SKILL.md
│   └── references/
│       ├── laws.md
│       ├── default-bias.md
│       └── escalation-matrix.md
│
├── agent-work-environment-v3/       # ⚔️ Zhu Xian Formation (Router)
│   ├── SKILL.md
│   └── references/
│       ├── formations.md
│       └── formation-law-mapping.md
│
├── diagnostic-archive/              # 📁 Archive Reader
│   ├── SKILL.md
│   └── references/
│
├── agent-work-environment/          # 🔶 Combined Version (Compatible)
│   ├── SKILL.md
│   └── references/
│
└── _backup/
    └── agent-work-environment-v2.1/
```

---

## 📜 License

MIT License — Free to use, contributions welcome.

---

<div align="center">

**Three-Body defines the boundary. Zhu Xian Formation decides the approach.**

[Universe Map](./UNIVERSE.md) · [Three-Body Laws](./environment-governance/README.md) · [Zhu Xian Formation](./agent-work-environment-v3/README.md)

</div>
