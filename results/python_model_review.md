# Stage 2 Python reproduction and model review

Reviewed on 8 October 2026 against the restored saved commit
`d037996e324a1fc0923270f950e5a540ac0a45d6`, the supplied source snapshot,
`parameters.json`, `sources/STAGE1_SPEC.md` and `RUN_CONTRACT.md`.
This review concerns the unchanged Python implementation and finite evidence.
It does not review or accept Lean declarations.

## Execution evidence

Both original runners were executed exactly once, unchanged, using CPython
3.14.4 on macOS 26.6.2 arm64. Both exited 0 and produced empty stderr.
`python_reproduction.json` records the full interpreter identity, platform,
commands, timestamps, elapsed times, source hashes, output hashes and comparison
with `/private/tmp/rna-stage2-original/source/results`. Full output is retained in
`python_validation.stdout.log`, `python_validation.stderr.log`,
`python_junction_pilot.stdout.log` and `python_junction_pilot.stderr.log`.

The six model, implementation and runner inputs remained byte-identical to the
supplied snapshot before and after execution. No candidates, random seeds,
enumeration caps or energy parameters were changed. No additional searches or
runner reruns were performed.

The validation result differs from the supplied JSON only in the actual Python
version (3.12.14 to 3.14.4) and measured runtime (9.647 to 4.969 seconds). These
differences reflect the new environment; all computational fields agree. The
result digest is unchanged:
`d10732f2a5689293eed515e8984b6cbd074399f61f951faf9fd5a8d67a7a864a`.
The junction result is byte-identical to the supplied JSON, SHA-256
`3d8421ba6107eb476e243a1290d248585f3d5f1a577c4e053435432e35af3bc1`.

## Model fidelity from source inspection

- `model.validate` restricts the alphabet to A/C/G/U, uses the frozen ordered
  Watson–Crick pairs, rejects reused endpoints and crossings, and requires at
  least three enclosed positions by default. `energy` adds precisely one integer
  term for each pair whose immediately nested neighbour is present. Empty folds
  and isolated pairs have zero energy. It adds no loop, terminal, initiation,
  dangling-end or coaxial contribution.
- The ten frozen two-decimal constants are integers in hundredths of kcal/mol.
  Their 180-degree rotations produce all 16 ordered pair-stack orientations.
  The independently transcribed matrix in `exhaustive.py` does not import the
  production model or dynamic programme. The existing runner checks all 16
  orientations against the frozen table. This review checks the frozen inputs;
  it does not repeat the Stage 1 external parameter or literature review.
- `folding.fold` separates endpoint-paired intervals (`P`) from intervals whose
  endpoints are not paired together (`U`). A paired interval adds a stack only
  when its immediately interior endpoints are paired. This split prevents both
  omitted and double-charged adjacent-stack terms.
- `U` decomposes at the leftmost position: either it is unpaired, or it has a
  unique partner before the interval's last endpoint; pairing to the last
  endpoint belongs to `P`. The enclosed and following intervals are independent
  because crossings are forbidden. Empty structures, isolated pairs, branching,
  bulges and internal loops remain available; the recurrence imposes no target
  topology, helix-count or pair-count restriction on competitors.
- Retaining the two lowest distinct energy levels is sufficient for the reported
  minimum and best distinct alternative: context shifts each entry by a fixed
  integer, and a Cartesian sum's first two distinct levels cannot require a
  third distinct level from either operand. Counts are summed across disjoint
  decompositions and multiplied across independent intervals. At most two
  witnesses per level suffice to exhibit an alternative when a target is tied.
  This is a source-level argument, not a kernel-checked correctness theorem.
- The base-pair experiments explicitly select a separate pair-count objective.
  The zero-span/wobble setting appears only in the declared seed-model checks;
  the stacking tests and junction experiment retain span three and Watson–Crick
  pairing. There is no silent transfer between those settings.

## Enumeration completeness and precise finite coverage

Both explicit enumerators use the leftmost-position decomposition. In any
noncrossing partial matching, position zero is either unpaired, or is paired to
one unique position `k`. Every remaining pair then lies wholly inside `(0,k)`
or wholly after `k`; an edge spanning those two regions would cross `(0,k)`.
Recursing on those regions covers every such matching. Conversely, the generated
substructures are disjoint, do not cross, and retain the span restriction;
the case split is unique, so it creates no duplicate topology. The sequence-aware
junction enumerator additionally restricts each chosen edge to an allowed
Watson–Crick pair. This supplies an informal completeness argument for these
finite enumerations, rather than assuming an arbitrary list of encoded masks
is exhaustive. Python itself and this general recursion argument have not been
formalised in Lean.

The reproduced scope is exactly:

- All 87,381 sequences of lengths zero through eight; 128 deterministic sequence
  cases at each length nine through twelve (512 sampled cases), seed 20261008.
  Across the combined 87,893 cases, 306,648 compatible folds were scored by both
  implementations; 65,234 cases have tied optima. Lengths nine through twelve
  are sampled, not exhaustive over sequences.
- All 16 ordered stack orientations, the six-pair stack sum of -1336 integer
  units, explicit edge cases, the 15,511 zero-span topologies at length twelve,
  and eight specified base-pair instances passed. The eight instances do not
  reproduce the seed paper's full construction, sampler or dataset.
- The fixed 256 distinct sequences for the one length-24 target, seed 24031008,
  yielded 225 uniquely optimal targets, two ties and 29 beaten targets. The
  candidate screen uses dynamic programming for all candidates; it does not
  explicitly enumerate every compatible fold for all 256 sequences.
- The three independent enumeration checks are complete for their individual
  sequences: 42,478 compatible folds for the successful example, 13,117 for the
  tie and 157,353 for the beaten example. The same two over-cap representatives
  (277,398 and 219,736 folds) were skipped under the unchanged 200,000-fold cap.
  They remain part of the 256-candidate dynamic-programming screen.
- `AAAAAAAAAUUUCCCAAAGGGUUU` retains unique target energy -1024, best alternative
  -931 and gap 93 integer units (respectively -10.24, -9.31 and +0.93 kcal/mol).

## Conclusion and limits

No computational discrepancy or concrete frozen-model defect was found in this
bounded reproduction and source review. The evidence supports the existing
finite claims. It does not prove the dynamic programme correct at arbitrary
length, establish a theorem for the infinite target family, establish novelty,
or establish biological performance. No Stage 3 work was performed.
