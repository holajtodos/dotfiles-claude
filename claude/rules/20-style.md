## Headers and comments: match my own scripts

The scripts in `~/scripts/{R,python,slurm}` set the house style for every script you
write or edit, in any project. The reader is me on a second review, skimming; write for
that reader.

**File header.** One or two plain sentences saying what the script does, then labelled
blocks — a label on its own line, an indented list under it: `Inputs:`, `Output:`,
`Methodology:` (numbered steps) or `Processing:`, `Usage:` (the literal command lines,
one per mode), and, where columns are produced, a table `name – meaning (unit)` with
the columns aligned. Python: the opening `"""` on its own line, text on the next. R: a
`# ====` banner line above and below. Slurm: the banner sits before the `#SBATCH` block
and holds the script names, the env-var switches, and `Submit:` / `Monitor:` /
`Cancel:` / `Logs:` lines.

**Sections.** Top level: a banner — `# ====` / `# Title` / `# ====` in R; in Python and
bash a full-width `# ----` line, `# Title`, `# ----` line (no trailing `#`).
Subsections: `# ---- Title ----`. Steps of a main routine: `# ------ Step N: Verb … ------`.

**Inline comments.** One line saying what the next lines do; a why only when the code
would otherwise look wrong, and then one clause. Constants take a trailing comment.
Roughly one comment per 15–20 lines; an explanation that spans a routine goes in the
header's Methodology block, not through the body. No prose between `#SBATCH` lines —
at most a one-line note above an option.

**Function docstrings.** Verb first (`Return …`, `Compute …`, `Build …`); one line when
one line will do; `*param*` names an argument in prose; a numpy-style `Parameters` /
`Returns` block only for a workhorse function.

**Leave out.** Ticket and spec numbers, and the argument for a design — those live in
the tracker, the ADRs, and the PR. A bare pointer (`see ADR 0002`) is fine; a paragraph
restating it is not. No markdown bold and no `#:` attribute markup in comments. The
header describes, the tracker justifies. Real dashes (– —), not `--`.
