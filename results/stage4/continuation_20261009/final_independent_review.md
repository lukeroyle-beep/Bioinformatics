# Stage 4 final internal proof review — 9 October 2026

**Verdict: ACCEPTED for the bounded mathematical source review.** Completion permission: **true within this review scope**. Confidence: **HIGH**. No blocking or substantive mathematical finding was identified.

Observed at `2026-10-09T05:13:12.455116+00:00`. Audited content fingerprint: `eef559e36538ebb3ac715d3f59f8ef90f478a6a2ed23b5ed3110adf93417d8bb` (SHA-256 of the sorted compact JSON mapping of the file hashes below).

This is an internal agent review conducted separately from proof implementation, not external specialist review. The reviewer read the proof sources and independently reconciled their hashes with the completed compiler evidence. The compiler commands themselves were run by the implementing agent; this review did not rerun Lean or historical Python experiments. Passing this review does not establish novelty, biological transfer, external review, remote publication, or completion of checkpoint packaging.

## Accepted mathematical statement

For every `a,b,c,u,v >= 3`, the sequence `A^a C^b A^u G^(b+c) A^v C^c U^a` makes the specified three-helix target the unique energy minimum among **all** admissible folds under `wc-stack-2004-2dp-span3-v1`. Its actual target energy is `-93(a-1)-326(b+c-2)` integer units. Every distinct admissible fold has at least 93 greater energy, and deleting the outermost target pair attains 93 exactly (0.93 kcal/mol on the frozen scale).

This follows from `Stage4.unique_minimum` and `Stage4.exact_gap`, not merely the older conditional `Stage4.Gap` lifting theorem. The final statements accept only arbitrary `Params`, `Fold`, and the frozen admissibility/distinctness conditions. There is no finite-case cap, preserved-topology condition, pair-count condition, or additional reconstruction premise in the final result.

## Requirement reconciliation

| Requirement | Implementation and direct verification | Status |
| --- | --- | --- |
| Frozen sequence, target, admissibility and exact energy model are preserved | `Model.lean; parameters.json; STAGE1_SPEC.md`. The frozen specification, parameters and all four original modules match commit 6c20125 byte for byte. The 16 oriented stack entries agree with the ten constants and their rotations. | PASS |
| The family and competitors are fully unbounded within the frozen model | `Model.Params, Fold, admissible; Final.unique_minimum`. Params has five arbitrary natural parameters with only lower bounds >=3. Fold is an arbitrary Boolean relation on natural positions; admissibility requires bounds, span, Watson-Crick compatibility, matching and noncrossing only. | PASS |
| Concrete counts equal actual stacking energy | `Counts.energy_eq_counts; CountAlgebra; TargetEnergy.target_energy`. The actual double sum is decomposed pointwise into the three homogeneous edge classes and the single mixed boundary stack. Matching makes support count each stack once; direct summation proves the target energy. | PASS |
| Count bounds and mixed-stack penalty hold without extra hypotheses | `Counts count bounds; Bounds.mixed_count_bound`. AU <= a-1 and GC <= b+c-2 follow from edge intervals. The mixed count is binary and forces the left C count to zero, leaving GC <= c-1. | PASS |
| Saturated counts determine the complete fold including isolated pairs | `Bounds saturation lemmas; Reconstruction; Final.reconstruction_of_counts`. Saturation reconstructs contiguous helices and fixes their offsets. The final proof establishes both pair-set inclusions and function equality; its forward direction covers every selected pair, including an isolated extra pair. | PASS |
| The actual energy has a unique minimum and exact attained gap 93 | `Final.gap_lower_bound, unique_minimum, exact_gap; Energy.deleteOutermost_energy`. The final theorems discharge all structural hypotheses of the arithmetic bound. Removing the target outermost pair is admissible and distinct and loses exactly one -93 contribution. | PASS |
| Every retained theorem compiles with disclosed permitted transitive axioms | `verification/verification.json and its 14 command logs`. Read and hash-validated the completed clean-build receipt and logs: PASS, 100 declarations, all commands exit 0, all source hashes current, and axiom union Classical.choice, Quot.sound, propext. Static scan found no prohibited proof escape. | PASS |

## Fidelity findings

The energy/count bridge operates on the original sum over every ordered position pair. `contribution_four_terms` classifies actual selected stacks; `rightTerm_sum` and `leftTerm_sum` use matching injectivity before replacing sums by occupied-edge support. The mixed term uses its proved unique block-boundary coordinates. Thus edge presence is not silently substituted for arbitrary stack multiplicity.

Reconstruction handles equality of complete folds. Saturated C edges first force the two reverse-paired GC helices into their target positions. These helices prevent loop As from pairing to the U suffix. Saturated U edges then fix the outer AU helix. The forward inclusion checks all three possible compatible pair classes and uses already reconstructed endpoint partners, so an additional zero-energy isolated pair cannot survive. The backward inclusion restores every target pair.

The attained-gap witness uses the actual energy function: deleting the outermost pair removes exactly the stack indexed by that pair, changes its contribution by +93, and preserves admissibility as a subset. Minimum span remains exactly three enclosed positions (`i+4 <= j`); wobble, crossing pairs and all omitted Turner terms remain excluded exactly as frozen. Empty folds, isolated pairs, bulges, internal loops and arbitrary branching remain permitted competitors when otherwise admissible.

## Build and axiom evidence

The completed receipt reports `PASS`, `general_theorem_verified: true`, **100 theorem declarations**, and **14 successful commands**, including `lake clean`, the full default-target build, and axiom output for all ten modules. It finished at `2026-10-09T05:11:45.653988+00:00`. This review independently matched every recorded source and command-log hash to current bytes. The 52 prior declarations and their four source modules remain unchanged from `6c20125`; the new modules add 48 declarations.

The transitive axiom union is exactly `Classical.choice`, `Quot.sound`, and `propext`. Each final theorem has that disclosed set. No project axiom, placeholder, unsafe declaration, external implementation hook, or native-computation proof shortcut was found. Lean is pinned to 4.19.0; the Lake manifest has no additional packages. These are foundational assumptions, not an absolute zero-axiom claim.

Receipt: `verification/verification.json`, SHA-256 `24ddb4f837d898ce74f3bea8e49acf2ba52260b42f1a75d21216c9dcec59bb5c`.

## Exact audited file hashes

| File | SHA-256 |
| --- | --- |
| `lean/Stage4/Bounds.lean` | `58f80284b781dff94540d1def03a5d4869541bed0a59d1ff1f8156167ba1f9e7` |
| `lean/Stage4/Classification.lean` | `6f107f00686bcc23ed099ca66f4092714e3b7218998d09e0354d113d80fa8b32` |
| `lean/Stage4/CountAlgebra.lean` | `539e5aaec498d7d2ebd41e47c64a59ed7d55ac37dbe73ec7d9959de9ecc1666c` |
| `lean/Stage4/Counts.lean` | `f63e1c08a351917b306df9ad3e59e2f1bd093d0694046c86212d38e39a534da3` |
| `lean/Stage4/Energy.lean` | `7b6132e4684b230eeabc1bbc8dca170a52105ad8fe85ae7510f307228df646a8` |
| `lean/Stage4/Final.lean` | `3faba712c05e22dbf6a0bdaa0fd07df704724ba7b33b2583cb522b86871e5bb1` |
| `lean/Stage4/Gap.lean` | `5b265a3c470f7e46a64f0ce8c6c95eb86d57ad6741b35b7356d28ea62017832b` |
| `lean/Stage4/Model.lean` | `f72d0bdfc6d2da7c0ee381b2e87fad253eb9ddc88220f970be734fe3eec2e922` |
| `lean/Stage4/Reconstruction.lean` | `93dbe4efc047dd6cd864dd29848ebbbf0b37e28517eab7d9ccb6053c4fbeeae7` |
| `lean/Stage4/TargetEnergy.lean` | `78d3fb34bc45fe3002e841af194ccfeab871d2abe72df6f58a9a0d1658c08077` |
| `parameters.json` | `5e43000968b14c8699b3a9cbe71b38cefd869f065fecd5c94dd7c84409695c4d` |
| `sources/STAGE1_SPEC.md` | `00ddb08e306f16a82b750e4659d42a3b9f1bda2fdce10d72300d18d857a9ecaf` |
| `lean/Stage4/lean-toolchain` | `55e97be96000b5e9e290c9e74482e5e317861499a5540353ce845471bded8cea` |
| `lean/Stage4/lakefile.toml` | `f6616f29c7c2d6d464a98540c5cdfc1e596611f0ba9949c0e15b9c3cd2343be2` |
| `lean/Stage4/lake-manifest.json` | `960836fc5304674d55640bb6384bcffe99534a92975070ec285668c426132152` |
| `scripts/verify_stage4.py` | `6da11023e5e4b5505635f00d6f48061f6bcef0abc7f0fea8d503dcce9faaa320` |

## Scope and remaining work

No correction is required for this proof-review scope. External specialist review, originality assessment, and project delivery/packaging were not audited here and must not be inferred from this result. All work was read-only except creation of this report.

The acceptance-completion-auditor deterministic engine was executed with the seven mandatory requirements above, direct source/receipt evidence tied to the content fingerprint, and no unresolved findings. It returned `ACCEPTED` and `completion_allowed: true`. The engine reconciles the recorded evidence; it does not replace mathematical source review or the Lean kernel.

Required action for this bounded review: **No further action required.**
