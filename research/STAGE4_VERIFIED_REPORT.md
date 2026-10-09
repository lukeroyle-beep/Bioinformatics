# Stage 4 formal verification — 9 October 2026

**The unbounded construction and exact 93-unit gap are kernel checked in the
frozen mathematical model.** The proof covers all five parameters >=3 and
all compatible, span-three noncrossing partial matchings, including empty
folds, isolated pairs and arbitrary competing topologies. This is an internal
formal verification milestone; external specialist review, originality and
biological applicability are separate, unclaimed outcomes.

## Exact result

For every `p : Params`, with independent natural parameters a,b,c,u,v >=3,
use the sequence `A^a C^b A^u G^(b+c) A^v C^c U^a` and the specified three-helix
target. The checked final declarations in [Final.lean](../lean/Stage4/Final.lean)
prove:

- `unique_minimum`: the target is admissible and strictly lower in energy than
  every distinct admissible fold.
- `gap_lower_bound`: every distinct admissible fold has energy at least the
  target's energy plus 93 integer hundredths of kcal/mol.
- `exact_gap`: that lower bound is attained by an admissible distinct fold.

`TargetEnergy.target_energy` (declaration `Stage4.target_energy`) establishes
actual target energy `-93(a-1)-326(b+c-2)`. `deleteOutermost_energy` supplies the
attaining competitor by removing the outermost AU pair. Thus the exact gap is
0.93 kcal/mol. These results are not extrapolations from the finite Stage 3 cases.

The proof uses the full frozen 16-entry oriented Watson-Crick stacking table,
not the full Turner thermodynamic model. It excludes wobble by the frozen
specification, and includes no loop, terminal, coaxial or other energy terms.
It makes no claim about parameter uncertainty or biological folding behaviour.

## How the remaining obligations were closed

| Component | Verified connection |
| --- | --- |
| TargetEnergy | Evaluates the actual double sum over all ordered pairs from exact target stack locations |
| CountAlgebra | Finite-sum swap, scalar linearity, natural-to-integer cast and unique-support sum identities |
| Counts | Concrete edge-support counts equal the actual stack energy; matching prevents duplicate contributions |
| Bounds | Count saturation implies every relevant edge is occupied; a mixed stack forces the left-GC count to zero |
| Reconstruction | Occupied edges force contiguous helices; noncrossing packs both GC helices into exactly B4; those exclude loop-A pairing; U saturation fixes the outer helix; equality is proved for the entire Boolean relation |
| Final | Applies the verified count bounds and reconstruction to the actual model, proving the universal lower bound, uniqueness and attained exact gap |

The previously conditional numerical lemmas remain plainly conditional in
Gap.lean. Final.lean supplies all their hypotheses from the concrete model;
there is no assumed reconstruction, energy identity, count bound or sampling
coverage in the final theorem's premises.

## Evidence and limits

The fresh clean build passed all **100 theorem declarations**. The
[clean-build and axiom receipt](../results/stage4/continuation_20261009/verification/verification.json)
records pinned Lean 4.19.0, every retained source hash and every theorem's full
transitive axioms. The permitted union is `propext`, `Quot.sound` and
`Classical.choice`. Proof placeholders, unproved project axioms and native
computation shortcuts are rejected. This is distinct from checking executable
output: the final universal statements are elaborated and kernel checked.

A fresh [independent final review](../results/stage4/continuation_20261009/final_independent_review.md)
checks theorem scope, model fidelity and the energy/count/reconstruction
connections against the exact retained sources. Earlier partial-build receipts
and reviews remain dated evidence; their incomplete status is not overwritten.

The [literature note](STAGE4_LITERATURE.md) now includes a bounded full-text WABI
comparison using the verified cached publisher PDF. It identifies differences
in wobble, isolated pairs, span, helix-length restrictions and weighted energy,
while retaining the paper's weighted-model discussion as relevant prior art.
These differences do not establish originality. External specialist assessment
and any scientific publication remain outside this invocation. Parsing/output
complexity is argued informally in Stage 3, not a new Lean complexity theorem.

## Reproduce and resume

```sh
python3 scripts/verify_stage4.py \
  --bin-dir .tools/lean-4.19.0-darwin_aarch64/bin \
  --output-dir /tmp/rna-stage4-verified-recheck
```

Use a fresh output directory. No external Lean package is required. The script
runs a clean build of every declared module, then explicitly elaborates and
audits each source. `general_theorem_verified` is true only when the audited
final uniqueness and exact-gap declarations are present in a successful run.
Independent model fidelity is supported by its separately retained review.

The user authorized continuation from 6c20125 with a stop at 50% weekly remaining.
The invocation began at 68%. Final observed allowance and preservation checks
are in [checkpoint_validation.json](../results/stage4/continuation_20261009/checkpoint_validation.json).
Readings describe shared account allowance, not attributed token costs.
No usage reset, background continuation, remote push, external contact or
cloud memory upload occurred. Prior model/proof modules and historical
experiment/evidence files remain byte-identical to their saved checkpoints.

The authorised internal verification gate is reached. The next research gate
is external specialist review and a broader originality assessment; neither
is automatically started, and contacting anyone requires separate authorization.
