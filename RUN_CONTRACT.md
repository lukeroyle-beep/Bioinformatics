# Stage 2 execution contract

Authorised: Stage 2 only, 8 October 2026. Stop before Stage 3.

Model: wc-stack-2004-2dp-span3-v1, frozen in parameters.json and sources/STAGE1_SPEC.md.
Use integer energy units; no parameter tuning and no silent competitor exclusions.

Validation cap, fixed before running: all four-base sequences of lengths 0 through 8;
128 deterministic sequences at each of lengths 9 through 12; explicit edge cases;
every admissible topology for each selected sequence; two separately implemented scorers.
Base-pair baseline: homopolymer stem hairpins with three or four GC pairs and three
or four unpaired As, a simple separated-colouring instance of seed Theorem 1/10;
test both zero span with wobble (seed model) and span three with Watson-Crick pairs.
This is a small theorem-instance reproduction, not reproduction of the paper's whole
algorithm, uniform sampler or empirical dataset.

Junction pilot cap: 256 deterministic target-compatible candidates at the minimum
24-position target. 64 stem-constant assignments, then 192 independently seeded
random assignments. No adaptive optimisation or exhaustive sequence search.
Evaluate every admissible fold via exact dynamic programming for each candidate.
Cross-check the first successes/failures on explicit compatible-fold enumeration.
The checker implemented a 200,000-fold cap per case. The initial checker run hit
that cap, after the full candidate screen had run. The repaired checker counts
folds first, logs over-cap representatives, and checks the first representative
in each observed outcome class that fits the unchanged cap. No candidates,
parameters, search bounds or decision criteria changed.

Lean pilot: a new, small dependency-free model and finite certificate, pinned to
Lean 4.19.0. No code imported from the related 2026 repository. That repository's
documentation and software licensing were inspected; its build is not accepted
or required as a dependency of this pilot. General theorem and folder correctness
proof remain outside this stage.

The active model selector and reasoning setting are not exposed in this executor.
No claim is made that Astra Extra High was selected. Mathematical research remains
reserved for the later stage; this run develops and checks the finite baseline.
No external expert review, remote repository publication or background task.
