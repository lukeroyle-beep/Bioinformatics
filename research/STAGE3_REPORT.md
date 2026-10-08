# Stage 3 research checkpoint — 8 October 2026

**Stage 3 has reached its candidate handoff gate.** A linear-time sequence
construction now has a complete informal all-length argument and bounded
computational support. It proposes a unique minimum and an exact 0.93 kcal/mol
gap for every target in the frozen three-helix family. It remains a proof
candidate: Stage 4 independent review and Lean verification have not started.

The construction is

    A^a C^b A^u G^(b+c) A^v C^c U^a,  a,b,c,u,v >= 3.

See [the exact statement and argument](STAGE3_CANDIDATE.md). It classifies
every possible stack, bounds their counts, reconstructs the target when both
ordinary-stack bounds are attained, and excludes the sole mixed-stack case
by a strict energy bound. Removing the outermost AU pair attains the claimed
gap. The argument includes every admissible competing topology and does not
depend on finite testing to cover unbounded lengths.

## What was computed

All energies use the unchanged integer table and the Stage 2 folding algorithm.
The experiment sets and later stress amendment were recorded before execution
in [the plan](STAGE3_PLAN.md). No random or adaptive sequence search was used.

| Check | Coverage | Result |
| --- | --- | --- |
| Original construction, loop extension | Four cases: stems 3, loops in {3,4} | Two unique minima; two ties |
| New construction, full parameter grid | All 243 tuples with each parameter in {3,4,5}; lengths 24–40 | 243 unique target minima; every gap 93 |
| New construction, fixed stress batch | 26 further tuples; lengths up to 138; individual parameters up to 60 | 26 unique target minima; every gap 93 |
| Independent fold enumeration | Six new-construction cases and one original-construction failure | All 466,653 compatible folds enumerated and independently scored |
| Candidate lemma checks within enumeration | Every one of 397,815 folds for the six new-construction cases | All classification, bounds, equality and energy checks pass |
| Mixed-stack branch exercised | 5,586 enumerated folds | Every such fold leaves the left C block unpaired and satisfies the stronger gap bound |

Enumeration checked both lowest distinct energy levels and their exact
multiplicities against the DP. Every case was counted before materialisation
and fit the unchanged 200,000-fold per-case cap. No selected case was skipped.
The independent enumerator and scorer are the unchanged Stage 2 implementations;
the new lemma checks were written in this task. This is numerical independence,
not independent authorship or review of the general argument.

For the minimum target, the new sequence is `AAACCCAAAGGGGGGAAACCCUUU`.
It has 29,304 compatible folds; the target is the sole minimum at -14.90
kcal/mol, followed by four folds at -13.97. These are model-specific energies,
not predictions of biological performance or equilibrium folding probability.

The previous formula fails whenever the left loop has at least four As:
shifting the left hairpin's A endpoints by one produces an admissible tie.
This rules out that formula, not Q1. The 25-position failure has three minima
among 68,838 folds. The exact counterexample is retained in
[counterexample.json](../results/stage3/counterexample.json).

## Literature correction

Stage 1 missed a relevant published follow-up: Boury, Bulteau and Ponty,
[RNA Inverse Folding Under Stacked Base Pair Maximization](https://drops.dagstuhl.de/entities/document/10.4230/LIPIcs.WABI.2026.12),
27 August 2026. The publisher PDF was read, particularly §2 (pp. 3–4),
Theorem 5 (p. 8) and the weighted-model discussion (p. 16).

It supplies an exact construction for sufficiently long helices under stack
maximisation. Its definitions allow wobble and exclude isolated pairs; its
conclusion also discusses weighted guarantees. This is material prior art.
Those statements do not, on this bounded comparison, establish this specific
short-helix construction with the frozen two-decimal weights and full competitor
set. That is an assessment of scope, not an originality conclusion. Detailed
comparison remains required before presenting any result as new.

The downloaded PDF is identified by SHA-256
`54a35a5bd2047adb109e722db9bb99eac66a2c91434213d170e5ab3e1d898ca1`
(1,467,424 bytes). It is not copied into the repository. Stage 1 is preserved
as a dated record; this paragraph supplements its provisional literature boundary.

## Reproduce and inspect

Only Python's standard library is required. This run used CPython 3.14.4.
Choose a fresh output directory; completed evidence is never overwritten:

```sh
python3 research/run_stage3.py original_loop_check --output-dir /tmp/rna-stage3-recheck
python3 research/run_stage3.py separated_gc_grid --output-dir /tmp/rna-stage3-recheck
python3 research/run_stage3.py separated_gc_stress --output-dir /tmp/rna-stage3-recheck
python3 research/check_stage3.py --output /tmp/rna-stage3-recheck/exhaustive_checks.json
```

Batch JSON files retain every tuple, sequence, minimum count, energy, alternative
fold and source hash. Their JSONL journals contain completed per-case records;
the `.partial.jsonl` suffix describes the incremental journal, not an unfinished
batch when the corresponding final JSON says `COMPLETED`. The original runner
bytes from before the stress-batch amendment are retained by hash under
`results/stage3/source_snapshots/`; the amendment did not change either earlier
batch's cases or scoring. Elapsed times are observations, not reproducibility
criteria. The checkpoint validation receipt verifies all recorded source hashes,
retained result structure and preservation of the Stage 2 inputs/evidence.

## Stop and resume boundary

The Stage 3 gate permits a candidate theorem with a complete argument or a
useful partial result with explicit gaps. The retained argument and bounded
evidence meet that handoff criterion; they do not meet Stage 4 acceptance.
Stop here rather than beginning formalisation under Stage 3 authority.

Next action: independently review the four candidate lemmas and formalise the
unbounded theorem in Lean, following the explicit obligations in the candidate
note. The active conjecture is the separated-GC construction; the former
formula is retired. Q1 remains unverified under the project's proof standard.

The account began at 86% remaining. The final observed allowance and stop
reason are recorded in `results/stage3/checkpoint_validation.json`. These are
shared account measurements, not task-attributed token costs. The stage gate
was reached before the 70% boundary. No usage reset or automatic continuation
was requested. The requested Astra Extra High configuration could not be
verified through this executor and is not claimed.

The cloud project Pages still carry an older Stage 2 status. They were read
for scope and not updated. The verified Institutional Memory head has no RNA
project owner; a full corpus query was not performed. No memory candidate was
uploaded. Current research evidence is retained in this local repository.
