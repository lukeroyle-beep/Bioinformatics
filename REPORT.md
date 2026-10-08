# Stage 2: finite baseline and verification checkpoint

8 October 2026. **Computational baseline passed; Stage 2 remains open because the Lean pilot could not be compiled. Stage 3 has not begun.** Stage 1 remains complete as a bounded scoping exercise. The model is explicit; novelty of the infinite-family question remains provisional.

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

The deterministic validation digest is d10732f2a5689293eed515e8984b6cbd074399f61f951faf9fd5a8d67a7a864a. The run used Python 3.12.14 and its standard library. Search and validation bounds were fixed before computation; the later checker repair is recorded in RUN_CONTRACT.md.

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

## Lean pilot: blocked and unverified

A dependency-free seven-position draft is supplied in lean/Pilot.lean, pinned to Lean 4.19.0. It encodes the sequence G G A A A C C, enumerates subsets of its four admissible edges, rejects endpoint reuse and crossings, and states a unique-minimum result for the nested two-pair fold with energy -3.26 kcal/mol. It also includes finite admissible-edge coverage, empty/isolated-pair checks, and axiom-print commands.

**This draft has not been compiled. Its declarations are intended checks, not accepted theorems.** It does not formalise the Python interval algorithm, the 24-position certificate, the full parameter table, general enumeration completeness or Q1.

The official Linux release downloaded successfully. Archive ownership restoration failed initially and was resolved by extraction with --no-same-owner. Lean then exited with code 1 even for `lean --version`: `error: failed to locate application`. Setting LEAN_SYSROOT did not fix it. The executor exposes /proc/self/exe but the numeric process-ID executable path is absent. The official v4.19.0 path source uses that numeric path, supporting an executable-location incompatibility diagnosis. A full trace was unavailable because tracing is not permitted. No system permissions or access controls were changed.

The downloaded archive's SHA256 is 6fe3ce97a58f44e2b3567d455b994eacec5bfe9ae7774f2a573444480ba813fe. No acceptance or transitive axiom report was obtained. The related public base-pair formalisation was not rebuilt and no code was imported; its results are not a dependency.

## Gate, confidence and next action

Confidence is high that the independently implemented finite checks agree as reported. This is substantial finite evidence for the evaluator, not a proof of its general correctness, a theorem for the target family, or external mathematical review.

The Python portion of the Stage 2 gate is satisfied. Keep Stage 2 open until the Lean draft is checked in a compatible installation, any elaboration issues are resolved, a clean build is recorded, and its model and axiom output are reviewed. The next bounded task is that build and review, not a larger sequence search. Stop afterwards for the Stage 2 decision; Stage 3 is not authorised by this checkpoint.

A local Git repository preserves the code, frozen inputs, run contract and results. The archive includes a source snapshot and Git bundle; no remote repository was created. Use a compatible local Codex repository for the outstanding Lean execution and this project Space for review. The active model selector and quota telemetry were unavailable; Astra Extra High and a measured usage percentage are not claimed.

## Sources and interpretation boundary

- [Frozen project problem specification](https://chatgpt.com/space/page_6ac63e1036bc8191b4d9cd3e02f298dd).
- [Boury, Gardelle, Bulteau and Ponty, 2025 seed paper](https://link.springer.com/article/10.1186/s13015-025-00278-6), base-pair design results and Figure 1.
- [Turner 2004 Watson–Crick stack table](https://rna.urmc.rochester.edu/NNDB/parameter_tables/turner_2004_rnastructure/turner_2004_watson_crick_stack.htm) and [helix example](https://rna.urmc.rochester.edu/NNDB/rna_2004/rna_2004_watson_crick_helices.html). The two-decimal table, not the one-decimal software table, defines this pilot.
- [Official Lean 4.19.0 release](https://github.com/leanprover/lean4/releases/tag/v4.19.0) and [executable-path source](https://github.com/leanprover/lean4/blob/v4.19.0/src/util/path.cpp).
- [Related base-pair formalisation](https://github.com/ajogalekar/rna-at-most-two-short-helices), documentation and licence inspected; no independent build claimed.

