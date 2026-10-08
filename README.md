# Bioinformatics — RNA inverse folding

Research into whether every target in a restricted, infinite family of
three-helix RNA structures can be made the unique minimum-energy fold under a
fixed stacking-only model.

**Stage 4 is paused at a partial verification checkpoint.** See the
[Stage 4 report](research/STAGE4_REPORT.md). Lean now verifies the arbitrary-length
model, target admissibility, complete stack classification, mixed-stack exclusion,
and an admissible competitor exactly 0.93 kcal/mol above the target. The general
lower bound and uniqueness theorem remain unproved. Independent internal reviews
found no defect in the informal candidate or retained formal model; these are not
external mathematical review. Novelty remains provisional.

The [Stage 3 construction](research/STAGE3_CANDIDATE.md) has 269 passing finite
target cases and an informal all-length argument. Neither those finite checks nor
the current partial Lean results establish the full theorem.

Stage 2 is complete. The repository contains the
Stage 1 problem specification, bounded Python experiments, a kernel-checked
seven-position Lean pilot, and their verification evidence. The infinite-family
question remains unverified under the project's proof standard.

Start with the [research report](REPORT.md), [frozen problem specification](sources/STAGE1_SPEC.md)
and [execution contract](RUN_CONTRACT.md).

## What has been established

| Evidence | Verified scope | Result |
| --- | --- | --- |
| Independent Python implementations | 87,893 sequence cases and 306,648 compatible folds | All reported energies, multiplicities and witnesses agree |
| Elementary base-pair design checks | Eight specified instances | All pass |
| Fixed candidate screen | 256 sequences for the single 24-position target `((((((...)))(((...))))))` | 225 unique target minima, two ties, 29 beaten targets |
| Independent enumeration for `AAAAAAAAAUUUCCCAAAGGGUUU` | All 42,478 compatible folds | Target -10.24 kcal/mol; best alternative -9.31; gap 0.93 |
| Lean 4.19.0 pilot for `GGAAACC` | All six admissible folds of this seven-position sequence, with a proved fold-to-mask completeness bridge | Nested target uniquely minimal at -3.26 kcal/mol; 20 kernel-checked theorem declarations |

The Python validation exhausts all sequences through length eight and samples
128 sequences at each length nine through twelve. It does not exhaust all
sequences through length twelve. The 24-position screen is a fixed finite
experiment, not a theorem for the target family or an estimate of general
success probability. Three representative sequences received independent full
fold enumeration under the unchanged 200,000-fold cap; see the report for
coverage and skipped representatives.

The Lean proof is about `GGAAACC` only. It does not formalize the Python folding
algorithm, the 24-position certificate or the full stacking table. Its complete
transitive axiom set is **`propext` and `Quot.sound`**. There are no `sorry`,
`admit`, additional unproved project axioms or native computation proof shortcuts.
See the [Lean model review](results/lean_model_review.md),
[axiom output](results/stage2_verification/lean_axioms.log) and
[final Stage 2 acceptance review](results/stage2_verification/independent_review_final.md).
The review was performed by a separate internal agent; it is not external
mathematical review.

## Frozen mathematical model

- Alphabet: A, C, G and U. Watson–Crick pairs AU, UA, CG and GC only.
- Folds: noncrossing partial matchings, with at least three enclosed positions
  per pair. Competitors include empty structures, isolated pairs and all other
  admissible topologies, with no requirement to resemble the target.
- Energy: sum only immediately adjacent nested stacks, counted once each.
  Loop, terminal, coaxial and other thermodynamic contributions are omitted.
- Parameters: the frozen two-decimal Turner 2004 values at 37 °C, using exact
  integer hundredths of kcal/mol. See [parameters.json](parameters.json).
- Research family: an outer helix around two hairpins, with all three stems and
  both loops at least length three, and no unpaired junction positions.

This is a mathematical stacking-only model, not the full Turner model. Exact
arithmetic does not remove experimental parameter uncertainty, and these results
do not establish biological performance.

## Get the repository

```sh
git clone https://github.com/lukeroyle-beep/Bioinformatics.git
cd Bioinformatics
```

The Git history preserves the initial model and computations, the saved input
checkpoint `d037996e324a1fc0923270f950e5a540ac0a45d6`, and the verified Stage 2
commit `3a6b467c6887aa07361a81688ed145fb12fd2929`. The GitHub migration adds
presentation and provenance updates; it does not change the mathematical model
or rerun or expand the experiments.

## Reproduce the Lean verification

Install the appropriate official [Lean 4.19.0 distribution](https://github.com/leanprover/lean4/releases/tag/v4.19.0),
or use an existing toolchain manager with the pin in [lean/lean-toolchain](lean/lean-toolchain).
No external Lean packages are required. The verified toolchain reported:

```text
Lean (version 4.19.0, arm64-apple-darwin23.6.0, commit 6caaee842e94, Release)
Lake version 5.0.0-6caaee8 (Lean version 4.19.0)
```

With the pinned executables on PATH, run from the repository root:

```sh
python3 scripts/verify_lean.py --output-dir /tmp/rna-stage2-lean-recheck
```

For a standalone distribution, also pass `--bin-dir /path/to/lean/bin`.
The script checks the actual version, runs `lake clean` and `lake build`, then
explicitly elaborates `Pilot.lean` to capture every theorem's transitive axioms.
It retains commands, exit codes, output and the source hash. A separate output
directory preserves the committed build evidence. The equivalent direct commands
from `lean/` are:

```sh
lean --version
lake --version
lake clean
lake build
lake env lean Pilot.lean
```

The compiler and `.lake` build cache are excluded from Git. The official macOS
ARM64 archive used for verification was `lean-4.19.0-darwin_aarch64.tar.zst`,
329275227 bytes, with locally measured SHA-256
`94d4246fd90a152a4819419498d3e45c941a31638a57a0a8e32561494ab6cea7`.
This identifies the downloaded bytes; it is not a separately published signature.
[Toolchain provenance](results/stage2_verification/toolchain_archive.json) records
its URL, version and binary hashes. The earlier Linux startup failure is retained
as historical evidence, not a current blocker.

## Reproduce the Python computations

Only the Python standard library is needed. The original run used Python
3.12.14; Stage 2 reproduced both unchanged runners once with CPython 3.14.4:

```sh
python3 tests/validate.py
python3 tests/junction_pilot.py
```

These commands overwrite the corresponding result JSON files, so use a separate
clone if you want to preserve an unchanged checkpoint checkout. Bounds, seeds
and the enumeration cap are in [RUN_CONTRACT.md](RUN_CONTRACT.md).
The reproduced validation digest was
`d10732f2a5689293eed515e8984b6cbd074399f61f951faf9fd5a8d67a7a864a`.
Only the recorded Python version and runtime changed; all numerical results
matched. The junction JSON matched byte-for-byte.

See [Python reproduction evidence](results/python_reproduction.json) and
[model and coverage review](results/python_model_review.md).

## Repository guide

| Path | Contents |
| --- | --- |
| [sources/STAGE1_SPEC.md](sources/STAGE1_SPEC.md) | Problem, frozen conventions and provisional literature boundary |
| [parameters.json](parameters.json) | Exact stacking constants and orientation |
| [src/](src/) | Scorer, interval folding algorithm and independent enumerator |
| [tests/](tests/) | The two bounded experiment runners |
| [lean/Pilot.lean](lean/Pilot.lean) | Seven-position formal model, completeness bridge and proofs |
| [results/](results/) | Computational outputs, reviews, build logs and axiom reports |
| [scripts/](scripts/) | Clean Lean verification and local checkpoint packaging |
| [REPORT.md](REPORT.md) | Detailed findings, provenance and limitations |
| [research/](research/) | Stage 3 candidate and bounded evidence; Stage 4 plan, literature comparison and resume report |
| [results/stage3/](results/stage3/) | Preserved Stage 3 finite evidence and checkpoint records |
| [lean/Stage4/](lean/Stage4/) | Separate dependency-free partial formalisation, pinned to Lean 4.19.0 |
| [results/stage4/](results/stage4/) | Independent reviews, clean build, axiom audit and checkpoint records |

Evidence records are dated snapshots. The original blocked Lean receipt and
pre-delivery review are retained alongside the successful build and final
acceptance; they do not describe the current Stage 2 status. Machine paths in
receipts identify the original execution environment and are not portable
installation requirements.

## Portable checkpoint and current boundary

To create a source snapshot, complete Git bundle and SHA-256 manifest from a
clean committed checkout:

```sh
python3 research/package_stage4.py
```

The script verifies a fresh bundle restoration and writes an archive and checksum
to ignored `checkpoints/`. To restore such an archive, verify its `MANIFEST.json`,
then follow `RESTORE.txt` to clone `RNA_Stage_4.bundle` at the recorded branch.
The older Stage 2/3 packagers are retained for those historical checkouts; use
the Stage 4 packager for this partial verification checkpoint.

The GitHub migration was expressly authorised after Stage 2 verification.
The later Stage 3 work was authorised on 8 October with a stop at 70% account
allowance remaining, or the stage gate if reached sooner. The later Stage 4
instruction authorised verification with a pause at 70% weekly remaining.
This Stage 4 checkpoint is local; it has not been pushed to GitHub.
No external reviewer was contacted
or Google Drive memory uploaded. The requested Astra Extra High configuration
has not been verified or claimed. The frozen Stage 2 evidence is unchanged.
