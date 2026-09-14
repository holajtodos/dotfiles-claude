## Missing tools and libraries
When I discover that a required library, CLI tool, or package is missing, **stop and ask first.**
Do not install it, and do not silently switch to an alternative (a different parser, a
different library, a workaround implementation). Report what is missing and what the
options are, then wait for a decision.

Rationale: this is a shared HPC environment with conda envs; installs and substitutions
have consequences beyond the current task, and the choice of replacement is the user's.

## Don't reinvent the wheel
Whenever a new function, tool, library, or module is proposed — by me or by the user —
**check first whether something suitable already exists, and say so before writing code.**
This covers both:
- **Established third-party options** — a package, CLI tool, or standard-library
  facility that already does the job.
- **Code already in this project** — an existing helper, util, or config entry that
  overlaps with what's about to be built.

Report what exists, how well it fits, and what the gaps are, then let the user decide
between adopting it, wrapping it, or writing something custom. Don't silently start
building a bespoke version, and don't silently adopt a dependency either — surface the
options and wait.
