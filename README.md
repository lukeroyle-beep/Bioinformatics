# RNA inverse folding: Stage 2 checkpoint

Stage 2 verification passed. Read REPORT.md for the exact finite
claims and evidence. Stop at Stage 2; Stage 3 is not authorised.

## Reproduce the Lean verification

The project is dependency-free apart from the official Lean distribution,
pinned by `lean/lean-toolchain` to `leanprover/lean4:v4.19.0`.
The verified installation is project-local at
`.tools/lean-4.19.0-darwin_aarch64/` on macOS ARM64. It reports:

```text
Lean (version 4.19.0, arm64-apple-darwin23.6.0, commit 6caaee842e94, Release)
Lake version 5.0.0-6caaee8 (Lean version 4.19.0)
```

Obtain the appropriate official [Lean 4.19.0 release](https://github.com/leanprover/lean4/releases/tag/v4.19.0)
for your platform or install that exact version with your existing toolchain
manager. No global installation change is required. The compiler is excluded
from the checkpoint. The macOS ARM64 archive used here was
`lean-4.19.0-darwin_aarch64.tar.zst`, 329275227 bytes, locally measured SHA-256
`94d4246fd90a152a4819419498d3e45c941a31638a57a0a8e32561494ab6cea7`.
This is a recorded download hash, not a separately published signature.

From this repository root, use the absolute or relative compiler `bin` directory:

```sh
python3 scripts/verify_lean.py --bin-dir .tools/lean-4.19.0-darwin_aarch64/bin
```

Alternatively, with the pinned `lean` and `lake` on PATH, omit `--bin-dir`.
The script checks the actual version, runs `lake clean`, `lake build`, then
`lake env lean Pilot.lean` to retain every transitive axiom report. It writes
complete logs, exit codes, source hash and a receipt to
`results/stage2_verification/`. For a later reproduction without overwriting
checkpoint evidence, pass `--output-dir /tmp/rna-lean-recheck`.
The equivalent direct commands, from `lean/`, are:

```sh
lean --version
lake --version
lake clean
lake build
lake env lean Pilot.lean
```

The seven-position `GGAAACC` pilot is separate from the length-24 computational
certificate. See `lean/Pilot.lean` and `results/lean_model_review.md` for the
formal fold-to-mask bridge and exact limits. It does not prove the Python
algorithm or the infinite-family research question.

## Reproduce the finite computations

The original run used Python 3.12.14. This checkpoint reproduced both runners
once with CPython 3.14.4 and its standard library:

```sh
python3 tests/validate.py
python3 tests/junction_pilot.py
```

The bounds and seeds are frozen in RUN_CONTRACT.md. The junction runner retains
the 200,000-fold enumeration cap and logs skipped representatives; all 256
candidates are evaluated by the interval algorithm. These commands overwrite
the corresponding JSON outputs. Only Python version and elapsed time changed
in validation.json; its digest and all numerical results matched. The junction
JSON matched byte-for-byte. Full reproduction evidence is in
`results/python_reproduction.json` and `results/python_model_review.md`.

## Restore or package the checkpoint

Verify the outer `MANIFEST.json`, then restore the complete local history:

```sh
git clone RNA_Stage_2.bundle recovered-repository
```

The saved input commit was `d037996e324a1fc0923270f950e5a540ac0a45d6`.
The updated bundle's commit and every source hash are in its manifest.
No remote repository has been published. To package a clean committed checkout:

```sh
python3 scripts/package_checkpoint.py
```

This creates a ZIP, manifest and checksum in ignored `checkpoints/` and verifies
a fresh bundle restoration. It excludes the compiler, build cache and credentials.
The memory-intake copy remains local and pending; no Drive upload is authorised.
