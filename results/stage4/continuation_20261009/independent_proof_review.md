# Independent source review: reconstruction and target energy

9 October 2026. Bounded internal agent review. Read only the two named Lean
sources during this review and computed their SHA-256 hashes. No compilation,
experiments, web requests, dependency changes or git operations were performed
by this reviewer. The coordinating agents reported successful direct compilation;
that report is not an independently reproduced build in this review.

| Reviewed source | SHA-256 |
| --- | --- |
| `lean/Stage4/Reconstruction.lean` | `93dbe4efc047dd6cd864dd29848ebbbf0b37e28517eab7d9ccb6053c4fbeeae7` |
| `lean/Stage4/TargetEnergy.lean` | `78d3fb34bc45fe3002e841af194ccfeab871d2abe72df6f58a9a0d1658c08077` |

## Findings

**No defect identified in the reviewed statements or arguments.** The six
reconstruction theorems and seven target-energy/helper theorems have the intended
unbounded scope. Their visible proofs contain no placeholders, added project
axioms, finite parameter enumeration or native-computation shortcut. Imported
lemmas remain dependencies; this pass is not a complete transitive source audit
or axiom report.

### Reconstruction

The generic left/right edge lemmas use matching injectivity to join consecutive
stack witnesses into a single constant-sum helix. Their induction bounds cover
every position in the requested block, including both endpoints. The left proof
obtains positivity from admissibility before subtracting one from a partner;
the right proof's index arithmetic stays inside the block. The hypotheses are
actual stack existence on each adjacent edge, rather than an encoded conclusion
that the fold already equals the target.

For the C blocks, four endpoint witnesses and the constant sums give the two
interval widths. Compatibility places all four partners in the G block.
Endpoint disjointness explicitly excludes equality of the left interval's
largest G and the right interval's smallest G. Noncrossing then orders them.
Their combined widths fill the G block, forcing both target constants without
a hidden cardinality or coverage assumption.

The AU proof uses these established GC pairs to exclude pairing from either
loop A block to U. Saturated U edges then give one constant-sum helix with all
left partners in the initial A block. The endpoint bounds force the outer
target constant.

The final theorem proves both directions of Boolean relation equality over
**all natural-number index pairs**. Its forward direction starts from every
selected pair, uses admissibility and the complete allowed-pair classification,
and compares that pair with the forced partner on its C or U endpoint. Thus an
extra isolated pair cannot be omitted from the proof: any such compatible pair
falls into one of the same cases and must already be a target pair. Out-of-range,
reversed and incompatible selected pairs are excluded by admissibility. The
backward direction supplies every target pair; equality is not merely containment
of the three helices.

No vacuity mechanism was identified. The ordinary target's three contiguous
helices mathematically satisfy the edge hypotheses for the frozen parameter
domain. However, this file does not itself provide a theorem deriving those
hypotheses from equality of the actual stack counts. It correctly documents
that remaining connection. Its result is conditional reconstruction, not yet
the complete unique-minimum theorem.

### Target energy

`target_contribution` decomposes the actual contribution at every pair of
indices into three disjoint helix terms, using the imported exact
`target_stack_iff`. `target_stack_weight` evaluates the actual sequence and
frozen table at those stacks, obtaining -93 for the outer helix and -326 for
each GC helix. The proof also handles indices without a target stack.

The summation lemmas explicitly handle half-open intervals, bounded right
partners and uniqueness of the solution to `i+j+1=pairSum`. Their counts are
`a-1`, `b-1` and `c-1`; the full double sum is the model's `energy`, not a
separately assumed scoring function. Integer arithmetic is exact. This proves
the unbounded target energy formula without assuming competitor count bounds
or uniqueness. Completeness of the stack decomposition depends on the imported
`target_stack_iff`, which was not freshly audited here.

## Acceptance boundary

These two files support the reconstruction and target-energy portions of Stage
4. Acceptance still requires the actual finite-count decomposition and bounds,
equality-to-saturation connection, mixed-stack bound, and final assembled
uniqueness/exact-gap theorem, followed by the project's clean build, complete
transitive axiom report and source-fidelity checks. Those obligations are not
assumed complete by this review. The review makes no novelty, external
specialist-validation or biological-performance claim.
