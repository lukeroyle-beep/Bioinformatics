# Stage 3 bounded research plan — 8 October 2026

Authority: Luke's current instruction to proceed with Stage 3 and checkpoint at
70% usage remaining. Base commit: fc6612f. The prior Stage 2 stop is superseded
for Stage 3 only. Stage 4, public delivery and external review remain separate.
The project Page's older Lean-blocked status is superseded by the repository's
verified Stage 2 build and acceptance evidence.

Preserve the frozen model, Python solver, parameters, Stage 1 specification,
Lean pilot and all Stage 2 results. Add research utilities and evidence only.
No active model/reasoning setting is exposed; Astra Extra High is unverified.

## Attempt 1: extend the Stage 2 example

One initial conjecture: A^(a+b+u) U^b C^c A^v G^c U^a designs T(a,b,c,u,v).
Before any computation, fix four checks: a=b=c=3, u,v in {3,4}. A competing
shift of the left helix is suspected when u>3. Record exact witness and score;
a failure refutes this construction, not target designability or Q1.

## Conditional attempt 2: separate the two GC stems

If attempt 1 fails, replace the active conjecture with:
A^a C^b A^u G^(b+c) A^v C^c U^a designs T for all five parameters >=3.
The expected target energy is -93(a-1)-326(b+c-2) integer units.
Predeclare a 243-case grid with each parameter in {3,4,5}, no random sampling
or optimization. All admissible folds are considered by the unchanged solver.
All returned witnesses are rescored by the separate scorer. Finite successes
motivate analysis; they do not prove the conjecture.

Then analyse arbitrary competing stacks, not just alternative target-family
folds. Retain every assumption and proof obligation. Independently enumerate
representatives only after counting first, with at most 200,000 folds per case.
Additional bounded experiments require a recorded amendment before execution.

## Amendment 1, after the first two batches

Attempt 1 tied for both cases with u=4. Attempt 2 passed all 243 grid cases
with gap 93. The sole active candidate is now the separated-GC construction.
Before further runs, fix these additional checks:

- One-coordinate extremes: start at (3,3,3,3,3), set each coordinate in turn
  to 6, 12, 30 and 60 (20 cases).
- Six combined stress cases: (12,12,12,12,12), (3,30,3,60,3),
  (30,3,3,3,60), (3,3,30,3,60), (3,3,3,60,60), (12,3,9,30,6).
- Explicit enumeration of the six separated-GC cases obtained from the minimum
  case and by increasing each one of the five parameters to four, plus the
  original construction's (3,3,3,4,3) failure. Count first, cap 200,000 per case.
  Enumerate every compatible fold for each eligible case; compare the lowest
  two energy levels and all multiplicities with the DP. For separated-GC
  folds, test the proposed stack classification, count bounds, equality case,
  and the stronger bound when the mixed stack is present.

The proposed all-length argument uses only AA/UU (-93), CC/GG and GG/CC
(-326), and one possible AG/UC (-208) stack. A mixed stack forces every C
in the left C block unpaired. This will be written as an informal candidate
argument with explicit Stage 4 review/formalisation obligations.

## Checkpoint and validation

Usage starts at 86% remaining (weekly account window, integer provider readout).
Recheck between research batches and before closeout. Begin closeout by 72% if
necessary to retain a margin; at 70% start no further research. Account usage
is shared and polling cannot guarantee an exact percentage stopping instant.
Stop sooner if the Stage 3 gate is reached: a precise candidate with complete
argument, reproducible counterexample, or useful partial result with gaps stated.

Retain batch source hashes, parameters, exact spectra summaries and witnesses.
Focused checks cover new research code and frozen-file preservation. Save a
local checkpoint with the current claim, failed approaches and next action.
No account reset, scheduled continuation, push, external messages or memory
upload is part of this research authorization. Rollback is removal of the
additive Stage 3 files and reversal of its documentation changes from the base.
