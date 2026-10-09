# Stage 4 partial verification checkpoint — 8 October 2026

Historical checkpoint. The [9 October verified report](STAGE4_VERIFIED_REPORT.md)
supersedes the incomplete proof status below; all dated evidence is preserved.

**Stage 4 is incomplete and paused at the requested weekly-usage boundary.**
The retained formalisation has a clean Lean 4.19.0 build and 52 kernel-checked
theorem declarations. It does not yet prove the unbounded unique-minimum result.

The candidate remains
`A^a C^b A^u G^(b+c) A^v C^c U^a`, for a,b,c,u,v >= 3, under the unchanged
`wc-stack-2004-2dp-span3-v1` model. No biological or originality claim is made.

## Verified scope

| Module | What its checked statements establish |
| --- | --- |
| Model.lean | All 16 oriented stack weights; unbounded sequence; arbitrary Boolean relations with explicit bounded, span-three, matching, compatibility and noncrossing predicates; target admissibility; exact target stack locations; empty and isolated-pair competitors; stack-edge injectivity; admissible distinct outermost-pair deletion |
| Classification.lean | Exact nucleotide-position characterisations; complete physical dinucleotides; every admissible pair and stack classified; mixed stack fixed to one location; every left-block C unpaired whenever the mixed stack occurs |
| Energy.lean | For every parameter tuple, deleting the outermost pair changes the actual double-sum energy by exactly +93 units |
| Gap.lean | Numerical lower bounds and exact-gap implications, explicitly conditional on count bounds, energy classification and equality reconstruction |

The deletion result is unconditional in the actual model:

```lean
energy p (deleteOutermost p) = energy p (target p) + 93
```

Together with the checked admissibility and distinctness results, this gives a
real competitor at +93 for every target. It establishes an upper bound on the
difference between the best alternative and the target. It does not establish
that every alternative is at least +93 or that the target is minimal.

The complete transitive axiom union for all 52 declarations is `propext`,
`Quot.sound`, and `Classical.choice`. No unproved project axiom, placeholder or
native computation shortcut appears. Classical.choice is disclosed; the older
Stage 2 pilot's smaller axiom set is unchanged.

## Independent checks and literature

The [informal review](../results/stage4/independent_math_review.md) independently
scrutinizes all four candidate lemmas, including isolated pairs and the exact
witness. The [formal review](../results/stage4/independent_formal_review.md)
compares the actual definitions and proved statements against the frozen model.
These are separate internal-agent reviews, not external specialist review.

The [literature comparison](STAGE4_LITERATURE.md) records the bounded primary-source
comparison and its access/scope limits. The 2025 paper was read; the 2026
publisher abstract was retrieved but its full PDF comparison remains incomplete.
The 2026 stacked-pair work is material
prior art. No newness claim follows from a difference in model assumptions.

## Remaining proof obligations and resume order

1. Define actual AU, GC and mixed stack counts over the same ordered-pair domain
   as `energy`, and derive the sum identity from `stack_classification`.
2. Lift the verified stack-edge injectivity and block locations to finite counts:
   x <= a-1, y <= b+c-2, m in {0,1}, and m=1 implies y <= c-1.
3. Prove equality reconstruction for arbitrary admissible Boolean relations:
   simultaneous saturation forces both GC hairpins and then the outer AU
   helix, with no possible additional isolated pair. Do not assume this fact
   as a field of an allegedly verified fold or certificate.
4. Derive the target's actual energy `-93(a-1)-326(b+c-2)` from the checked
   target-stack locations.
5. Apply the conditional Gap lemmas to these actual counts and combine the
   resulting lower bound with `deleteOutermost_energy` for unconditional
   uniqueness and an attained exact gap. Re-audit the final theorem's full
   transitive axioms, clean build and formal model fidelity.

The best next action is the stack-count/energy bridge in step 1, followed by
finite edge counting. Do not rerun or enlarge the historical Python experiments
as a substitute for any proof obligation. External specialist review remains a
separate research acceptance requirement; contact is not authorized here.

## Reproduction and preservation

From the repository root, with the pinned toolchain available:

```sh
python3 scripts/verify_stage4.py \
  --bin-dir .tools/lean-4.19.0-darwin_aarch64/bin \
  --output-dir /tmp/rna-stage4-fresh-verification
```

Use a new output directory. The verifier records the actual versions, performs
`lake clean` and `lake build` in the isolated `lean/Stage4` package, then elaborates
every module explicitly and records every theorem's transitive axioms and source
hash. The receipt's `general_theorem_verified: false` is intentional.

[Build evidence](../results/stage4/verification/verification.json) and
[checkpoint validation](../results/stage4/checkpoint_validation.json) retain the
scope, hashes and preservation checks. Every Stage 2/3 source/evidence file,
including the existing Lean pilot and package, is byte-identical to `827ba64`;
only the current README and execution contract were updated. No old Python
runner was executed. The new verification/packaging scripts received Python
syntax validation, and the checkpoint archive is checked by fresh restoration.

## Usage and delivery boundary

The weekly provider window is 10080 minutes. Initial remaining allowance was
80%; substantive proof work stopped for stabilization at 72%. The final
observation and pause reason are in the checkpoint receipt. These are shared
account allowance observations, not task-attributed token measurements.
No reset or automatic continuation was requested or performed.

This is local work. No Stage 3/4 remote push, external reviewer contact or cloud
memory upload occurred. The live Institutional Memory selected checkpoint was
verified by exact bytes/hash and contained no RNA-named owner; no full corpus
query was made. Repository evidence governs this checkpoint. The active
model/reasoning selector is not exposed and is not claimed.
