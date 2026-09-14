## The Python environment: always `<env>`

Every Python script — mine, yours, a skill's, a one-off probe — runs in
**`<env>`**. Never bare `python` or `python3`; the system default is `<version>`.

```bash
# Interactive
<module load lines>
<activate line>

# Non-interactive (scripts, agent tool calls)
<what a non-login shell must source first>
<activate line>
python your_script.py

# Or skip activation and call the interpreter directly
<absolute interpreter path> your_script.py
```

`<env>` is Python `<version>` at `<absolute env path>`. <Any path aliases or
symlinks that make two spellings name one environment.>

Installing into `<env>` is a **decision, not a step** — see `10-tools.md`.

## R

<How R runs on this host: module, container image, or native; the exact
command line; anything that must not be done (e.g. inline -e code).>

## Batch scheduler

<Scheduler name, account and partition names, where job logs land, and who
submits — the agent writes job files, the user submits.>

## House-style reference scripts

`20-style.md` names `~/scripts/{R,python,slurm}` as the house-style reference.
<State where those scripts live on this host, or that the prose in 20-style.md
is the only reference here.>
