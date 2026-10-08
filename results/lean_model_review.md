# Seven-position Lean model and coverage review

Reviewed on 8 October 2026. Exact accepted `lean/Pilot.lean` SHA-256:
`b8d804c0600e276039c6667820cae44dd83b3e88e3958660971a63d8495c2c01`.
The original draft compiled unchanged. The additions strengthen its coverage
statement without changing its nine original statements, mask definitions,
sequence, admissibility restrictions or energy coefficient.

## Semantic statement

`Stage2.unique_minimum_all_admissible_folds` states that for any
`f : Fin 7 → Fin 7 → Bool`, if `f` is admissible and differs from the target
relation, the target relation's `foldScore` is strictly less than `f`'s score.
`targetFold_admissible`, `targetFold_score` and `target_energy` independently
establish target admissibility and its energy -326 integer units (-3.26 kcal/mol).
This is a result about the fixed sequence `GGAAACC` only.

Positions are indexed 0 through 6. A relation marks an ordered pair as present;
admissibility forces the smaller endpoint first. Any ordinary finite partial
matching on these positions has exactly this Boolean characteristic relation.
`foldPairs` visits all seven choices of each endpoint, adding a pair precisely
when its relation entry is true. Each ordered pair is visited once, so there are
no duplicate edges or hidden exclusions in that representation.

`compatible` requires every selected pair to satisfy `allowed`: ascending
endpoints, at least three enclosed positions, and one of AU/UA/CG/GC. The
`foldLegal` pairwise test accepts equal edges (self comparison) and otherwise
requires disjoint endpoints and absence of either crossing orientation. Empty
and isolated-pair relations are included. No target topology is imposed.

The fixed sequence has no U. Its only possible compatible edges are `(0,5)`,
`(0,6)`, `(1,5)` and `(1,6)`, as kernel checked by
`admissible_edges_complete`. In particular, inner pair `(1,5)` encloses exactly
three positions and is allowed. Natural-number subtraction in the adjacent-edge
calculation cannot create a spurious valid stack: every selected outer pair has
ascending endpoints with the required positive span.

## Completeness bridge

The original theorem `unique_minimum_in_finite_encoding` quantifies over 16
masks only. It is preserved, but is not used alone to claim all-fold coverage.

1. `compatible_canonical` proves that every compatible relation equals the
   four-Boolean relation formed from its values at the four allowed edges.
   All other entries are forced false. Function equality is extensional.
2. `canonical_pairs` checks all 16 Boolean combinations: the full 49-position
   relation enumeration equals the decoded edge list. `canonical_realizes`
   proves pointwise relation equality to the encoded mask.
3. `all_compatible_folds_encoded` supplies a mask with both relation equality
   and edge-list equality. `all_admissible_folds_encoded` transfers the exact
   legality condition and energy, not merely an edge subset.
4. If an admissible relation differs from the target relation, its supplied
   mask cannot equal the target mask. The original strict inequality therefore
   lifts to the semantic fold relation.

`legal_masks_exact` identifies precisely masks 0, 1, 2, 4, 8 and 6. Their
edge sets are empty, four distinct single edges and the target two-edge nest.
Thus all six admissible folds are covered. The five alternatives contain no
adjacent stack and score zero; the target alone contains `(0,6),(1,5)` and
scores -326, giving a 3.26 kcal/mol gap in this example. This gap is distinct
from the reproduced 0.93 kcal/mol gap for the length-24 computational example.

## Energy fidelity and limits

Both mask and relation scores sum once per outer edge when its immediate
nested neighbour `(i+1,j-1)` is present. This exactly counts adjacent nested
stacks; isolated edges contribute zero. `compatible_stack_bases` proves that
any possible compatible adjacent stack has top bases GG and bottom bases CC
in the frozen orientation. Consequently using the single constant -326 is
faithful for this sequence. `parameters.json` supplies that exact coefficient
in hundredths of kcal/mol at 37 degrees C.

The connection to the externally frozen physical table is a reviewed constant
transcription, not a theorem about thermodynamic measurements. No general
four-by-four parameter-table formalisation is claimed. The score is specialized
to GGAAACC and makes no faithful-model claim for incompatible relations.
The full Python recurrence, arbitrary sequence lengths, the 24-position instance,
Q1, literature novelty and biological transfer remain outside the formal proof.

## Proof trust and observed build

All 20 theorem declarations have explicit `#print axioms` commands. The retained
complete output and parsed per-theorem dependencies are in
`stage2_verification/lean_axioms.log` and `stage2_verification/lean_build.json`.
The transitive union is exactly `propext` and `Quot.sound`: Lean's standard
propositional extensionality and quotient-soundness axioms. The final theorem
uses both. There is no `Classical.choice`, `sorryAx`, unproved project axiom,
`native_decide`, `unsafe`, `sorry` or `admit` in the accepted proof/dependencies.
Ordinary `decide` produces proof terms checked by the kernel.

The official pinned Lean 4.19.0 compiler built the exact source after `lake clean`;
all build and audit commands exited 0. Only `Std` is imported and
`lean/lake-manifest.json` has no external packages. The parent verified the
formal statement and build. A separate internal acceptance-review agent read
the final proof and ran an additional direct Lean elaboration: exit 0, empty
stderr, with output exactly matching all retained dependency reports. It found
no blocking proof or model-fidelity issue. This is internal review, not contact
with an external reviewer or an external mathematical endorsement.
