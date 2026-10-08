# RNA inverse folding: Stage 2 checkpoint

Python baseline PASS. Stage 2 remains open because Lean cannot start in the
authoring executor. Read REPORT.md before interpreting results.

## Reproduce the finite computations

Python 3.12.14 was used; only its standard library is needed.

```sh
python3 tests/validate.py
python3 tests/junction_pilot.py
```

The exhaustive bounds and seeds are in RUN_CONTRACT.md. The junction runner
preserves the 200,000-fold enumeration cap and logs skipped representatives.
All 256 candidates are still evaluated by the interval algorithm. Results
overwrite only the corresponding JSON outputs. Runtime in validation.json
can vary; its result digest should not.

## Complete the outstanding Lean pilot

Use a compatible Lean installation and the pinned lean-toolchain file.
The dependency-free source is a DRAFT; it has not been compiled. It concerns
only the seven-base G G A A A C C example, not the research target family.

```sh
cd lean
lake clean
lake build
```

Retain exit codes and the complete axiom output. Resolve all errors or
unexpected axioms and independently review the finite encoding. No acceptance
is claimed until that work is done. The general correctness of the Python
algorithm and the infinite-family research question remain unproved.

The downloaded official Linux release had SHA256
6fe3ce97a58f44e2b3567d455b994eacec5bfe9ae7774f2a573444480ba813fe.
It is not included in this archive. See results/lean_status.json for the
startup failure and diagnosis. No external project code was imported.

The accompanying Git bundle preserves the local commit history. To restore:
`git clone RNA_Stage_2.bundle recovered-repository`. There is no remote repository.
