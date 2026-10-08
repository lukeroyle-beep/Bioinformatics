# Stage 2: finite baseline and verification checkpoint

8 October 2026. **Stage 2 verification passed: the Python baseline was reproduced and the seven-position Lean pilot has a clean kernel-checked build with a formal completeness bridge. Stage 3 has not begun.** Stage 1 remains complete as a bounded scoping exercise. The model is explicit; novelty of the infinite-family question remains provisional.

## Frozen question and model

Can every target T(a,b,c,u,v), with all five parameters at least three, be assigned a sequence for which it is the unique minimum-energy fold? T has an outer helix of a pairs surrounding two hairpins with stems b and c and loops u and v, with no unpaired junction positions. Only T(3,3,3,3,3) was screened here.

The sequence alphabet is A, C, G, U. Allowed pairs are AU, UA, CG and GC; folds are noncrossing partial matchings, with at least three positions inside each pair. All admissible competitors are included by the interval recurrence, including empty folds, isolated pairs and topologies outside the target family. Only immediately adjacent nested pairs contribute stacking energy. The model omits loop penalties, terminal and coaxial terms, and every other thermodynamic contribution.

The two-decimal Turner 2004 central values at 37 °C are frozen in parameters.json. Integer units are 0.01 kilocalories per mole (kcal/mol). Exact arithmetic in this specified model does not remove experimental parameter uncertainty. No parameter tuning or biological transfer test was performed.

## Independent computation and coverage

The interval dynamic-programming implementation retains the two lowest distinct energies, exact multiplicities and up to two witnesses per energy. It distinguishes intervals with paired endpoints from intervals without that pair, so an adjacent stack is charged exactly once. A separately implemented topology enumerator and partner-array scorer use an independently transcribed four-by-four stack matrix. They do not import the production evaluator.

| Check | Coverage | Result |
| --- | --- | --- |
| All four-base sequences, length 0 through 8 | 87,381 sequence cases | Agreement |
| Deterministic sample, length 9 through 12 | 128 at each length, 512 cases | Agreement |
| Combined energy and fold checks | 87,893 cases; 306,648 compatible folds scored twice | Agreement |
| Tied optimal folds | 65,234 sequence cases | Counts and witnesses agree |
| Stack orientation convention | All 16 ordered outer/inner Watson–Crick combinations | Agreement |
| Published helix example, stack terms only | Six-pair example, sum -13.36 kcal/mol | Agreement |
| Seed base-pair result | Four simple hairpins in each of two pairing/span settings | Eight passing instances |
| Seed Figure 1 combinatorics | 15,511 noncrossing topologies at length 12 with zero minimum span | Reproduced |

The sample seed is 20261008. Empty structures, isolated-pair ties, minimum-span rejection, excluded wobble and crossing rejection were included. The base-pair examples are G^s A^h C^s for s and h each in {3,4}; each specified hairpin uniquely maximises pair count. Checks cover the seed's zero-span setting with wobble allowed and the new span-three Watson–Crick setting. These are elementary instances consistent with the seed's design results, not reproduction of its full construction algorithm, sampler or empirical dataset.

The deterministic validation digest is d10732f2a5689293eed515e8984b6cbd074399f61f951faf9fd5a8d67a7a864a. The original run used Python 3.12.14 and its standard library. Search and validation bounds were fixed before computation; the later checker repair is recorded in RUN_CONTRACT.md.

## Bounded three-helix pilot

Target: `((((((...)))(((...))))))`, length 24. The candidate budget was 64 assignments constant within each stem, with A-only loops, followed by 192 seeded target-compatible random assignments. Seed: 24031008. All 256 sequences were distinct. There was no adaptive optimisation or exhaustive sequence search.

| Candidate group | Tested | Target uniquely optimal | Target tied | Target beaten |
| --- | --- | --- | --- | --- |
| Constant stems | 64 | 46 | 0 | 18 |
| Random compatible | 192 | 179 | 2 | 11 |
| Total | 256 | 225 | 2 | 29 |

These counts describe this candidate set and this single target. They do not estimate a general success probability. A failed assignment is not evidence that its target is undesignable.

One successful sequence is `AAAAAAAAAUUUCCCAAAGGGUUU`. Its target energy is -10.24 kcal/mol. The best distinct competitor has energy -9.31 kcal/mol, so the exact model-specific gap is **0.93 kcal/mol**. Its structure is `..(((((...))(((...))))))`. Independent enumeration of all **42,478** admissible compatible folds for this sequence confirms the unique minimum and gap.

| Independent exhaustive example | Compatible folds enumerated | Target energy | Best alternative | Gap |
| --- | --- | --- | --- | --- |
| Unique: AAAAAAAAAUUUCCCAAAGGGUUU | 42,478 | -10.24 | -9.31 | +0.93 |
| Tie: GUUCUCCUGGAGUGGACUCCAAAC | 13,117 | -12.97 | -12.97 | 0.00 |
| Beaten: AAAUUUAAAAAAUUUAAAAAAUUU | 157,353 | -5.58 | -7.08 | -1.50 |

Energies and gaps in this table are kcal/mol. Gap means the best alternative's energy minus the target's energy. All three independent enumerations agreed on minimum energy, minimum multiplicity and best distinct alternative.

The initial enumeration checker hit its declared 200,000-fold limit on the first beaten example. The repaired checker counts folds before materialising them, logs the two over-limit representatives (277,398 and 219,736 folds), and uses the first representative in that outcome class fitting the unchanged cap. This was an execution-limit repair, not a numerical discrepancy or a change in candidate selection. The 256-candidate screen was unchanged.

## Lean pilot: verified seven-position instance

The official Lean 4.19.0 macOS ARM64 release works in this environment. The actual
compiler reports `Lean (version 4.19.0, arm64-apple-darwin23.6.0, commit 6caaee842e94, Release)`;
Lake reports `5.0.0-6caaee8 (Lean version 4.19.0)`. There are no external Lean
packages. The locally measured release archive SHA-256 is
`94d4246fd90a152a4819419498d3e45c941a31638a57a0a8e32561494ab6cea7`.
The release metadata supplied no independent digest; this hash identifies the
actual downloaded bytes. See `results/stage2_verification/toolchain_archive.json`
for URL, size, binary hashes and platform.

The original nine declarations compiled unchanged; no repair to their mathematical
statements or proofs was needed. The previous executable-location failure was
specific to the prior Linux executor. Its exact blocked receipt is retained at
`results/stage2_verification/original_lean_status.json`, and the first successful
build of the original source is retained in `results/stage2_verification/initial_build/`.
This run establishes a working environment, not a repaired Linux executor.

The accepted source now has **20 kernel-checked theorem declarations**. The added
coverage bridge is confined to the fixed sequence `GGAAACC`:

- `Fold` is any Boolean relation on all 49 ordered pairs of seven positions.
  Admissibility requires left-to-right orientation, at least three enclosed
  positions, Watson–Crick compatibility, no reused endpoint and no crossing.
  It imposes no target topology or pair-count restriction.
- The only possible compatible edges, in zero-based indexing, are `(0,5)`,
  `(0,6)`, `(1,5)` and `(1,6)`. `all_compatible_folds_encoded` proves every
  compatible relation equals an encoded mask and preserves its complete edge list.
  `all_admissible_folds_encoded` also preserves legality and stack energy.
- `legal_masks_exact` classifies the six legal masks: the empty fold, four
  isolated-pair folds and the nested target `{(0,6),(1,5)}`. All five alternatives
  have zero stack energy. The target has one GG/CC stack, energy -326 integer
  units (-3.26 kcal/mol), and is uniquely minimal. `compatible_stack_bases`
  verifies that GG/CC is the only stack orientation possible in this example.
- `unique_minimum_all_admissible_folds` compares the semantic target energy with
  **every distinct admissible fold of this seven-position sequence**, using the
  proved encoding bridge. The earlier theorem over 16 masks is preserved.

The transitive axiom union over **all 20 theorems** is exactly **`propext` and
`Quot.sound`**, standard Lean foundational axioms for propositional extensionality
and quotient soundness. The final semantic unique-minimum theorem depends on both.
No theorem depends on `Classical.choice`, `sorryAx`, or a project-specific axiom.
There is no `sorry`, `admit`, added unproved project axiom, `native_decide` or unsafe
proof shortcut. Finite facts use ordinary `decide`; the kernel checks their proof
terms. This is not an axiom-free proof claim.

The final `lake clean`, `lake build` and explicit `lake env lean Pilot.lean`
all exited 0. Full output, every theorem's transitive dependencies, actual commands,
exit codes and the exact source hash are retained in
`results/stage2_verification/lean_build.json`, `lean_clean.log`, `lean_build.log`
and `lean_axioms.log`. `results/lean_model_review.md` explains the semantic
review and limits. Internal agent review is not external mathematical review.

This formalisation does **not** cover the full stack table, arbitrary sequences or
lengths, correctness of the Python interval algorithm, the 24-position certificate,
or Q1. The seven-position sequence is not itself a member of the research target
family. Its purpose is finite model-fidelity and proof-toolchain verification.

## Reproduction in the continuation environment

Both unchanged Python runners were run exactly once with CPython 3.14.4 on
macOS 26.6.2 ARM64. Both exited 0 with empty stderr. Their model, implementation,
parameter and runner files remained byte-identical to the supplied commit.
The validation JSON changed only in Python version and measured runtime;
all computational fields and the digest matched. The junction JSON was byte-for-byte
identical, including the unchanged cap and two logged over-cap representatives.
`results/python_reproduction.json` records full commands, output hashes and exact
comparisons; `results/python_model_review.md` records the independent source review.
The figures above are therefore reproduced finite results, without search expansion.

## Gate, confidence and checkpoint boundary

The Stage 2 technical gate passes: the fixed Python evidence was reproduced,
the original Lean statements and added seven-position coverage bridge compile,
the final build is clean, and model fidelity and transitive axioms were reviewed.
The updated local checkpoint packages the reviewed commit, complete Git history,
source snapshot, retained evidence and SHA-256 manifest. Its packaging command
verifies a fresh bundle restoration against every committed file; the outer manifest
identifies the delivered commit. Build and restoration instructions are in README.md.

Confidence is high in the reported finite evidence and the stated seven-position
Lean theorem. The general correctness of the Python algorithm and the infinite-family
question remain unproved. The Stage 1 literature boundary remains provisional;
this continuation found no concrete Stage 1 defect and did not repeat that search.

**Stop at this Stage 2 checkpoint. Stage 3 has not begun and is not authorised.**
A later research decision requires separate authorisation; no infinite-family
result or novelty conclusion follows from this checkpoint. One later question is
whether a construction or obstruction can cover the unbounded target family under
the unchanged model; no work on that question was started here.

No remote repository was published, external reviewers contacted or pending Google
Drive memory copy uploaded. The memory-intake copy remains local and pending.
The active model/reasoning configuration was not verified; Astra Extra High and a
measured usage percentage are not claimed.

## Sources and interpretation boundary

- [Frozen project problem specification](https://chatgpt.com/space/page_6ac63e1036bc8191b4d9cd3e02f298dd).
- [Boury, Gardelle, Bulteau and Ponty, 2025 seed paper](https://link.springer.com/article/10.1186/s13015-025-00278-6), base-pair design results and Figure 1.
- [Turner 2004 Watson–Crick stack table](https://rna.urmc.rochester.edu/NNDB/parameter_tables/turner_2004_rnastructure/turner_2004_watson_crick_stack.htm) and [helix example](https://rna.urmc.rochester.edu/NNDB/rna_2004/rna_2004_watson_crick_helices.html). The two-decimal table, not the one-decimal software table, defines this pilot.
- [Official Lean 4.19.0 release](https://github.com/leanprover/lean4/releases/tag/v4.19.0) and [executable-path source](https://github.com/leanprover/lean4/blob/v4.19.0/src/util/path.cpp).
- [Related base-pair formalisation](https://github.com/ajogalekar/rna-at-most-two-short-helices), documentation and licence inspected; no independent build claimed.

