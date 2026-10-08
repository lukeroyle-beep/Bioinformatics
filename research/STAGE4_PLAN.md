# Stage 4 verification plan — 8 October 2026

Authority: Luke's instruction to proceed with Stage 4 and pause at a safe
checkpoint when weekly usage remaining reaches 70%. Base: clean commit
`827ba64`. The implementation plan gate is satisfied by that instruction.

The sole candidate is the separated-GC construction in STAGE3_CANDIDATE.md.
All frozen model files, existing Python implementations, Stage 2 Lean pilot,
and Stage 2/3 evidence remain unchanged. New Lean modules live in lean/Stage4;
new records in results/stage4. No dependency, model or search-bound changes.

## Ordered work and acceptance

1. Independently scrutinize the four informal lemmas and exact-gap witness.
2. Encode the arbitrary-length sequence, unrestricted partial matching model,
   target, exact stack sum, and all frozen oriented stack constants.
3. Prove numerical energy bounds and then their structural premises for every
   admissible fold. A conditional theorem is explicitly partial progress.
4. Compile using the existing pinned Lean 4.19.0 distribution. Retain a clean
   build, source hashes and every project theorem's transitive axiom report.
   No placeholders, unproved project axioms or native computation shortcuts.
5. Independently review formal model fidelity and theorem scope, and reconcile
   the 2025 seed paper and 2026 stacking paper before any originality claim.
6. Save a resumable local checkpoint with explicit outstanding obligations.

Full Stage 4 mathematical acceptance requires an unconditional unbounded
unique-minimum theorem and exact 93-unit gap under the actual model. A build
of definitions, finite checks or the final arithmetic implication cannot
substitute for that result. Internal agent review is not external specialist
review. No external reviewer contact, remote push, cloud write, usage reset,
background continuation or scientific originality claim is authorized here.

## Usage and safe stopping

Provider weekly window: 10080 minutes. Initial observation: 20% used, 80%
remaining. Measurements are shared account allowance, not task token costs.
Check between bounded proof work units and agent deliveries. At 72% remaining,
prioritize stabilizing the current module and recording the checkpoint. At
70% remaining, start no further research and stop agents; retain only validated
proofs and explicit gaps. The stage gate may be reached sooner. No automatic
continuation is scheduled. The active model/reasoning configuration is not
exposed and is not claimed.

## Rollback and verification

Changes are additive, with reviewable README/contract updates. The original
base commit remains restorable. Verify all frozen paths byte-for-byte against
827ba64, compile every new theorem, reject undeclared axioms/placeholders, and
retain exact accepted source hashes. Do not rerun the old Python experiments.
