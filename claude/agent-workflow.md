# Agent workflow practices (Claude Code + mattpocock-skills)

*Reference, not mandatory process — anything said in-session overrides it, and
where it disagrees with the rules in `~/.claude/CLAUDE.md`, that file wins.
Source: handoff from David, 2026-08-15 (archived at
`~/learning/sde/learning-records/0002-agent-workflow-practices-handoff.md`).
Calibrated against `mattpocock-skills` v1.2.3, commit `8b78b53` — check
`/ask-matt`, the plugin's own router, if anything below looks stale.*

## 1. Philosophy — when ceremony is worth it

- **Ceremony scales with ambiguity and irreversibility, not lines of code.** A
  vague idea deserves a full interview even if the code ends up tiny; a large
  mechanical change can go straight to plan mode.
- **Harnesses are scaffolding for the model of the day.** Hard gates and
  mandatory checklists compensate for weak-model failure modes; on strong
  models they cost tokens for steps good judgment would skip. Prefer thin
  skills; hold every convention (labels, gates, flows) as a dated snapshot.
- Three things stay valuable at any model strength: (1) **artifacts that
  outlive context windows** — specs, `CONTEXT.md`, ADRs, tickets; (2)
  **verification external to the model** — golden files, review against a
  fixed diff (stronger models make *more convincing* mistakes); (3)
  **extracting what's in your head** — grilling works because the bottleneck
  is unstated requirements. A skill earns its invocation when it buys one of
  these; otherwise work directly.

## 2. Setup, once per repo

`/setup-matt-pocock-skills` — configures the issue tracker (GitHub via `gh`,
or local markdown), the triage-label mapping (`triage-labels.md`), and the doc
layout (`CONTEXT.md` glossary + `docs/adr/`) the other skills assume.
(Already done for `MDA8_Mod_Comp`, 2026-07-24.)

## 3. The two workflows

**Vague idea → product:** `/grill-with-docs → /to-spec → /to-tickets →
/implement per ticket → push, PR`.
- No repo? `/grill-me` (same interview, stateless). Too big/foggy for one
  session? `/wayfinder` first (decision tickets, not deliverables), merge in
  at `/to-spec`.
- Question needs a runnable answer? `/handoff` out → fresh session →
  `/prototype` → `/handoff` back. Prototypes are kept on a `prototype/<name>`
  branch as a primary source, not deleted.
- Reading legwork → `/research` (background agent, cited markdown file).
  Blocker in someone else's head → `/to-questionnaire`.
- `/implement` drives `/tdd` (red-green slices) and closes with
  `/code-review` before committing.
- Small idea → plan mode or plain conversation, no skill.

**Change to existing code:** trivial → plan mode/direct; one behaviour →
`/tdd`; real feature that fits a session → short `/grill-with-docs` →
`/implement`; too big → the flow above at `/to-spec`; broken →
`/diagnosing-bugs` (tight red loop first, fix ships with a regression test);
incoming bugs/requests you didn't write → `/triage`; upkeep →
`/improve-codebase-architecture`; a step only a human can do (secrets,
dashboards) → `/wizard`.

**Tail for everything:** branch → `/code-review` → commit → push → PR →
optionally `/code-review ultra <PR#>` (multi-agent cloud review).

## 4. Triage labels — shape over strings

Every triaged issue carries **one category** (`bug` / `enhancement`) and
**one state**; the state answers *who acts next?* The five states and their
routing live in `~/.claude/CLAUDE.md` ("Issue workflow") — that table is
authoritative. What this section adds:

- Specs and tickets are artifacts, not states: `/to-spec` and `/to-tickets`
  publish straight to `ready-for-agent`. Never triage tickets you authored.
- House rule (David's, adopted): an issue waiting on *my own* grilling/design
  call is `ready-for-human`, not `needs-triage` (which means "unevaluated").
- Strings are per-repo (`triage-labels.md`); the durable part is one state per
  issue, state = who acts next, category orthogonal to state.

## 5. Context hygiene and phase boundaries

- Keep grill → spec → tickets in **one unbroken context**; each `/implement`
  starts fresh (`/clear` between tickets). Near the smart zone (~150k
  tokens), `/compact` at the nearest phase boundary — never mid-phase.
- Five options at a phase boundary, in the order to consider them:
  **Continue** (rule out first) → `/clear` (nothing carries over) → `/handoff`
  (only for a new harness, new directory, a colleague, or forking mid-phase)
  → **subagent** (tightly-scoped task, report back) → `/compact` (the default,
  at the bottom of the tree). Message didn't land? `/wait-what`.
- **Docs are living or records.** Living pages (instructions, current state,
  vocabulary) stay small and current; records (ADRs, run logs, landed specs)
  are dated, append-only, one file each, indexed from the entry point. One
  home per fact; everything else points. Route agents to `CONTEXT.md` and
  ~1K-token ADRs, never whole-spec reads.
- **Agent memory is a resume point, not a journal** — frontier plus pointers,
  about a screenful; history belongs in the repo. When sessions start
  tens-of-K heavy, `wc -c` everything auto-read (tokens ≈ chars ÷ 4).

## 6. Model delegation

Two levers, split cleanly. **The user** holds the session lever (`/model`,
`/effort`: high for build sessions, medium for chat/triage). **The agent**
holds the subagent lever without asking: Haiku/Sonnet for fan-out search,
inventories, command-running, mechanical fully-specified transforms; the
session's top model for design, specs, grilling, debugging, code-review
verdicts, anything numerically critical — cheap reviewers produce confident
false negatives. Bigger savings, in order: drop ceremony > protect context by
delegating bulk reading > downgrade subagent tier.
