## Issue workflow: the triage label decides the next command

Every issue carries one of the five triage labels, and the label **is** the routing
instruction. Never start work on an issue without checking its label first.

| Label | What to run | Meaning |
| --- | --- | --- |
| `ready-for-agent` | `/implement` directly | Fully specified. No ceremony needed. |
| `ready-for-human` | `/grill-with-docs` → `/to-spec` → `/to-tickets` | Not yet specified enough to build. The ceremony ends by producing `ready-for-agent` tickets. |
| `needs-triage` | `/triage` | Not yet evaluated. Triage assigns one of the other labels. |
| `needs-info` | Nothing — ask me | Blocked on information only I can supply. |
| `wontfix` | Nothing | Closed by decision. Don't reopen without asking. |

The three-step ceremony is a **pipeline, not a menu**: run them in order, and don't skip
straight to `/implement` because an issue looks obvious. The point of `ready-for-human`
is that a decision is embedded in it, and decisions are mine to make. If the ceremony
seems like overkill for a given issue, say so and let me decide — don't quietly shorten it.

An issue only becomes `ready-for-agent` by passing through the ceremony or through
`/triage`. Don't relabel one yourself to skip ahead.

House rule (from David's handoff, adopted 2026-08-15): an issue waiting on *my own*
grilling or design call is `ready-for-human`, not `needs-triage` — `needs-triage`
means nobody has evaluated it yet.

## After a merge: report the ticket frontier

Every time I tell you I merged a PR and ask you to clear the ground, follow the
ground-clean confirmation with a **frontier report** over the open `ready-for-agent`
tickets, unprompted:

1. **Frontier** — which tickets are implementable right now (all their blockers merged).
2. **Parallel-safe pairings** — which frontier tickets can be implemented simultaneously.
   Two tickets are parallel-safe iff there is no `Blocked by` edge between them **and**
   their file footprints are disjoint: the source directories they touch, the test files
   each will edit, and shared root files (README registers, CONTEXT/domain docs).
   Prefactor→swap pairs are never parallel.
3. **Blocked** — which tickets are waiting, and on what (name the blocking ticket/PR).

Specs that carry the `ready-for-agent` label are parents, not implementable units —
report over their tickets, not the specs. The same report applies to tickets newly
minted by `/to-spec` → `/to-tickets`: state their parallel/blocked relationships as
soon as they exist.

`~/.claude/agent-workflow.md` holds broader workflow practices (ceremony philosophy,
skill routing, context hygiene) from David's 2026-08-15 handoff, calibrated against
mattpocock-skills v1.2.3. It is **reference, not mandatory process** — anything said
in-session overrides it, and where it disagrees with this file, this file wins.

Model delegation splits in two: I hold the session lever (`/model`, `/effort`); the
agent holds the subagent lever without asking — cheap models (Haiku/Sonnet) for
fan-out search, inventories, and mechanical fully-specified transforms; the session's
top model for design, specs, grilling, debugging, and code-review verdicts.

## End-of-session handoff

When I ask, at the end of a session, what I should do about an issue or ticket in a
**fresh** session, do both of these before answering:

1. **Save the state to memory** — where the work stopped, what was decided and why, what
   is still open, and anything a cold session could not re-derive from the repo or git
   history. A fresh session starts with no context; write for that reader.
2. **Remind me of the routing convention above** — name the issue's current label and the
   specific command that label calls for, so the next session opens with the right move
   already identified.

## Keep these conventions harness-proof

Write these rules as plain prose in `.md` files. Don't convert them into hooks or
`settings.json` automation on my behalf — ask first if automation seems warranted.

Prose survives model and harness changes; wiring does not. Related: if a slash command
named here is missing from a session's available list, **say so plainly and stop** rather
than improvising a substitute or hand-rolling what the command would have done. A missing
command is a setup problem to report, not a gap to paper over — same principle as the
"Missing tools and libraries" rule above.
