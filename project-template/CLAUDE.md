# <Project name>

<One or two sentences: what this repo builds, for whom, and from what.>
`CONTEXT.md` holds the vocabulary; `docs/adr/` holds the decisions with a
wide blast radius. <If prior code is read but not imported, say where it is
listed, e.g. `docs/reference-sources.md`.>

## Layout

<Numbered pipeline stages or top-level modules, one line each, with the
language of each.> `slurm/` holds the batch submit files, `tests/` the tests,
`logs/` (gitignored) the job logs. Every data path comes from `paths.R` /
`paths.py` at the repo root — never a literal path inside a stage script.

<Sub-stage rule, if any: a helper module belongs to exactly one sub-stage and
is imported by nothing outside it; the path modules stay the only
project-wide shared surface.>

## Data roots

<One entry per root: the env var, its default, what lives there, and its
retention rule. Point at the ADR that chose them.>

- `<PROJECT>_SCRATCH_ROOT` — default `<path>`. Bulk inputs, checkpoints,
  outputs. <Retention rule; if files are scrubbed, say everything here must
  be regenerable.>
- `<PROJECT>_DURABLE_ROOT` — default `<path>`. Final products, copied here by
  the pipeline itself, not by hand.
- `<PROJECT>_CODE_ROOT` — the repo itself. Not a data root: nothing is ever
  written under it; it names small checked-in reference files.

Home is small — code only, never data. Tests point every root at throwaway
directories.

## Environment

<Per language: how it runs on this host (env, container, module), the exact
command lines, and the rules that are easy to get wrong. The user-wide
`00-machine.md` rule holds the host facts; repeat here only what is
project-specific.>

What the stages rely on, all already installed: <package list>. Adding to
this list is a decision, not a step: ask before installing anything.

## Running: login node vs. batch

- **The agent runs small things directly**: tests, and runs on a subset
  (every heavy script honours an `N_SITES`-style env var so a smoke run is
  always possible).
- **Heavy runs go through the scheduler and the user submits them.** The
  agent writes or updates `slurm/<job>.slurm` and hands back the submit
  command; it never submits anything itself. <Conventions: account,
  partition, thread pinning, `--output=logs/<job>_%j.out`.>

## Testing

<One command per track, run from the repo root, with the data roots pointed
at throwaway directories by the harness.>

```bash
<python test command>
<R test command>
```

A ticket that changes a helper covered by `tests/` updates those tests in the
same change.

## Agent skills

### Issue tracker

Issues live as GitHub issues in `<owner>/<repo>`, driven through the `gh`
CLI. See `docs/agents/issue-tracker.md`.

### Triage labels

The five canonical roles, each label string equal to its name (`needs-triage`,
`needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`). See
`docs/agents/triage-labels.md`.

### Domain docs

Single-context: one `CONTEXT.md` at the repo root plus `docs/adr/`. See
`docs/agents/domain.md`.
