# dotfiles-claude

My Claude Code configuration, portable across machines: the user-wide rules,
the workflow reference, settings, status line, two local skills, and a
template for starting a new project the same way.

## Layout

```
claude/                      ← linked into ~/.claude by install.sh
  CLAUDE.md                  # title + pointer; the rules are the files below
  rules/
    00-machine.md            # THIS HOST's env facts — untracked, one per machine
    10-tools.md              # missing tools: stop and ask; don't reinvent the wheel
    20-style.md              # script headers, sections, comments, docstrings
    30-workflow.md           # triage labels, frontier report, handoff, harness-proof
  agent-workflow.md          # broader workflow reference (David's 2026-08-15 handoff)
  settings.json              # model, status line, plugin + marketplace registration
  statusline-command.sh
  skills/
    humanizer/               # copy of github.com/blader/humanizer (2026-09-04 state)
    scipilot-figure-skill/
machine.example.md           # template for rules/00-machine.md
project-template/            # skeleton for a new repo: CLAUDE.md, CONTEXT.md, docs/agents, docs/adr
install.sh
```

`~/.claude/rules/*.md` is loaded by Claude Code at every session start, in
filename order, so the numeric prefixes fix the reading order. Nothing here
uses `@` imports or hooks — plain prose files survive harness changes.

## On a new machine

```bash
git clone git@github.com:holajtodos/dotfiles-claude.git ~/dotfiles-claude
~/dotfiles-claude/install.sh
$EDITOR ~/dotfiles-claude/claude/rules/00-machine.md   # this host's python env, R, scheduler
claude          # first launch installs the plugin registered in settings.json
claude login
```

`install.sh` is idempotent: it symlinks each tracked file into `~/.claude/`,
moves anything already there into `~/.claude/backups-dotfiles/<timestamp>/`,
and copies `machine.example.md` to `claude/rules/00-machine.md` if that file
is missing. `--dry-run` prints the actions.

Then check: `/context` inside a session lists the four rule files under
Memory files; `claude plugin list` shows `mattpocock-skills`. `agent-workflow.md`
is calibrated against mattpocock-skills **1.2.3**; a fresh install pulls the
current version, so compare the skill names if routing looks off.

## Starting a new project

```bash
cp -r ~/dotfiles-claude/project-template/. <new-repo>/
```

then fill every `<placeholder>` in `CLAUDE.md`, `CONTEXT.md` and
`docs/agents/issue-tracker.md`, and create the five triage labels in the
tracker (`gh label create needs-triage` … see `docs/agents/triage-labels.md`).

## What does not travel, and why

- **Auto memory** (`~/.claude/projects/<key>/memory/`) is keyed by the repo's
  absolute path with every non-alphanumeric turned into `-`. To carry a
  project's memory to a machine where the path differs, copy the `memory/`
  directory into the new key:
  `~/.claude/projects/$(echo "$PWD" | sed 's#[^A-Za-z0-9]#-#g')/memory/`.
  Memory is project facts; it is not needed for a *different* project.
- **Credentials, history, sessions, caches, plugin cache** — machine state.
  `settings.json` carries enough for Claude Code to reinstall the plugin.
- **`~/scripts/{R,python,slurm}`** — `20-style.md` names them as the
  house-style reference. The prose in that file describes the style fully;
  carry the scripts too if you want the examples, and say in
  `00-machine.md` where they are.

## Keeping it in sync

Edits made through `~/.claude/...` land in the repo through the symlinks —
commit them. `settings.json` is also written by Claude Code itself (`/model`,
`/config`); if that ever replaces the symlink with a real file, diff it
against the repo copy before re-running `install.sh`, which would otherwise
move the live file into the backup directory.
