# Independent Stage 4 formal model review

8 October 2026. Independent agent review of the retained model foundation,
classification, deletion energy, and conditional arithmetic. **No model-fidelity defect found
in the reviewed sources. The unbounded uniqueness and exact-gap theorem is
not yet established by these sources.**

## Scope and evidence

Reviewed against `parameters.json`, `sources/STAGE1_SPEC.md`, and
`research/STAGE3_CANDIDATE.md`. No source repairs or old experiments were run.
Fresh commands in `lean/Stage4`, using the repository's official pinned
Lean 4.19.0 distribution, each exited 0:

```text
../../.tools/lean-4.19.0-darwin_aarch64/bin/lake env lean Model.lean
../../.tools/lean-4.19.0-darwin_aarch64/bin/lake env lean Gap.lean
../../.tools/lean-4.19.0-darwin_aarch64/bin/lake env lean Classification.lean
../../.tools/lean-4.19.0-darwin_aarch64/bin/lake env lean Energy.lean
```

These are independent fresh elaborations, not an independent clean-build
receipt. The final clean build and full retained-source audit remain separate.
The printed transitive axiom union was exactly `propext`, `Classical.choice`,
and `Quot.sound`; no additional project axioms or proof placeholders appeared
in the successful elaborations. A transient compile failure during concurrent
classification editing was repaired by the author and the final version
above rechecked successfully.

Reviewed source SHA-256 values:

| Source | SHA-256 |
| --- | --- |
| `Model.lean` | `f72d0bdfc6d2da7c0ee381b2e87fad253eb9ddc88220f970be734fe3eec2e922` |
| `Gap.lean` | `5b265a3c470f7e46a64f0ce8c6c95eb86d57ad6741b35b7356d28ea62017832b` |
| `Classification.lean` | `6f107f00686bcc23ed099ca66f4092714e3b7218998d09e0354d113d80fa8b32` |
| `Energy.lean` | `7b6132e4684b230eeabc1bbc8dca170a52105ad8fe85ae7510f307228df646a8` |
| `parameters.json` | `5e43000968b14c8699b3a9cbe71b38cefd869f065fecd5c94dd7c84409695c4d` |
| `sources/STAGE1_SPEC.md` | `00ddb08e306f16a82b750e4659d42a3b9f1bda2fdce10d72300d18d857a9ecaf` |
| `research/STAGE3_CANDIDATE.md` | `70e49ef75688b1f17583ce00699e04d91c3ee84bf648ec513866a5519f94281c` |

## Verified findings

1. **Competitor domain is faithful.** `Fold` is an arbitrary Boolean relation
   on natural positions. `admissible` enforces bounded ordered endpoints,
   Watson–Crick compatibility, partial matching, and noncrossing, with no
   target-family, pair-count, or helix-length restriction. Universal pair
   quantification catches either orientation of a crossing. Requiring all
   selected pairs to lie inside the strand also prevents functions differing
   only outside the physical strand from becoming spurious competitors.
   `empty_admissible` and `singleton_admissible` give explicit evidence that
   empty folds and isolated pairs remain admitted.

2. **Sequence, span and target match the frozen specification.** The seven
   block boundaries encode `A^a C^b A^u G^(b+c) A^v C^c U^a`, with all five
   independent parameters bounded only below by 3. The middle G block's first
   b positions close the left hairpin and its last c positions open the right
   hairpin. The target arithmetic gives the correct three reverse pairings.
   `i+4 ≤ j` is proved equivalent to three enclosed positions. The sequence's
   U-valued extension beyond its length cannot be selected by admissible folds.
   `target_admissible` establishes that the target premise is not vacuous.

3. **The complete energy table is faithful.** A separate mechanical comparison
   expanded every frozen `ab/cd` entry and its `dc/ba` rotation, parsed the Lean
   table, and obtained exact equality for all 16 oriented Watson–Crick stacks.
   `contribution` supplies bases in the required order `i,i+1,j,j-1`; `energy`
   sums each outer ordered pair once. No loop or initiation terms were added.
   Saturating natural subtraction at `j=0` is harmless for admissible selected
   stacks, whose endpoints obey the positive span condition.

4. **The classification covers every admissible stack.** The four cases are
   AA/UU, CC/GG, GG/CC, and AG/UC. The list of physical dinucleotides is proved
   complete, and the order constraints exclude a U-to-earlier-A pair. The
   mixed-stack coordinates are the last A of the first loop and the first U
   of the suffix. `mixed_stack_unique` establishes uniqueness of that position.
   `mixed_excludes_left_C` rules out a left C as opening endpoint by crossing;
   `no_pair_to_left_C` rules it out as closing endpoint by base order. Together
   these do establish that every left C is unpaired when a mixed stack exists.

5. **The conditional gap arithmetic is sound and explicitly conditional.**
   The integer coefficients and the 93/444 bounds agree with Stage 3. The
   generic lifting theorem takes classification, count bounds and equality
   reconstruction as explicit arguments; it does not conceal them in the
   fold definition. The exact-gap lifting theorem additionally requires a
   real admissible, distinct witness with the stated energy. The deletion
   witness is defined in the actual model and its admissibility and
   distinctness are proved in `Model.lean`.

6. **The real deletion witness energy is now proved.** `Energy.lean` was
   reviewed and independently elaborated after its completion. Deleting the
   pair starting at index 0 can affect only the stack with that pair as its
   outer pair: no natural index plus 1 can equal 0. Its original contribution
   is proved to be -93 from the actual sequence and target. Finite-sum
   indicator lemmas then yield
   `energy p (deleteOutermost p) = energy p (target p) + 93`, without assuming
   a closed-form target energy or abstract stack-count formula. This supplies
   an actual admissible distinct competitor at +93; it does not establish the
   lower bound against all competitors.

## Remaining acceptance obligations

The reviewed files do not supply actual finite stack counts linked to the
full energy sum, the global counting inequalities, or the equality
reconstruction theorem. Local endpoint injectivity and mixed-stack exclusion
are useful ingredients, but do not themselves prove these global statements.
In particular, reconstruction must force all target pairs and exclude extra
isolated pairs. `Gap.outer_pair_deletion_energy` concerns abstract counts;
the separate actual witness identity is now supplied by `Energy.lean`.

The closed form for the actual target energy and an application of the generic
gap theorems to all admissible
RNA folds must be proved before accepting the unbounded claim. Any additional
modules beyond these four reviewed files are outside this review. A formal
parser/output complexity result is also not supplied here.
No novelty, specialist-review, or biological-performance claim follows from
these foundation checks.
