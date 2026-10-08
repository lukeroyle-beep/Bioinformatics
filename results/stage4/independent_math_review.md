# Independent informal mathematical review

8 October 2026. Internal agent review of the Stage 3 candidate; not external
specialist review or a Lean acceptance result.

## Material inspected

Read `research/STAGE3_CANDIDATE.md`, `sources/STAGE1_SPEC.md`,
`parameters.json`, `RUN_CONTRACT.md`, and the construction/observation definitions
in `research/stage3.py`. Listed the retained Stage 3 evidence files, but did not
rerun experiments or independently reproduce their numerical results. The review
below concerns the unbounded informal argument, not finite-sample extrapolation.

## Finding

**Informal-review pass: no mathematical gap or counterexample identified.** This
is bounded independent checking, not a guarantee that an error is impossible.
The claim remains restricted to the frozen Watson–Crick, span-three,
noncrossing, stacking-only model and the five-parameter target family.

1. **Stack classification.** The physical adjacent dinucleotides are exactly
   AA, AC, CC, CA, AG, GG, GA, CU and UU. Their reverse complements and block
   order leave AA/UU, CC/GG, GG/CC and AG/UC. The frozen rotation rule gives
   CC/GG = GG/CC = -326 and AG/UC = CU/GA = -208. The mixed type uses the
   unique B3/B4 and B6/B7 boundaries, so its multiplicity is at most one.
   Span-three admissibility ensures separated endpoints; no overlapping
   adjacent edges add another case.
2. **Counting injections.** An adjacent U edge can support at most one stack:
   its endpoint partners are unique in a matching. The same argument applies
   to the disjoint union of adjacent C edges in B2 and B6. This proves the
   stated independent bounds on x and y without imposing target topology.
3. **Equality reconstruction.** Saturation of the C-edge bound uses every
   edge in both C blocks. Every C belongs to such an edge, and shared endpoints
   force consecutive partners in reverse order. Thus the G partners form two
   disjoint intervals of lengths b and c covering B4. Their reversed order
   would give a B2-to-late-G pair crossing an early-G-to-B6 pair. Their correct
   order forces the two target hairpins. A loop A paired to B7 would cross
   its enclosing hairpin, so all remaining AU pairs must use B1. Saturating
   U edges pairs every U and therefore every B1 A, with reverse order forced
   by noncrossing. All C, G and U positions are occupied. Remaining loop As
   cannot pair together, excluding extra isolated pairs.
4. **Mixed stack.** Its outer AU pair joins the last B3 position p to the
   first B7 position q. Every possible B2-to-B4 pair has endpoints r<p<s<q
   and would cross it. B2 is consequently unpaired and y<=c-1. The penalty
   relative to the target is at least 326(b-1)-208>=444.
5. **Exact gap.** With no mixed stack, a distinct fold fails at least one
   integer count bound by equality reconstruction. The positive deficit is
   therefore at least 93. Removing only the outermost target AU pair preserves
   compatibility, matching, noncrossing and span. It removes exactly one
   AA/UU stack, attaining gap 93. The target's three separate helix stack
   counts give its claimed energy; the junction adds no stack.

## Formal acceptance boundary

The unbounded Lean development must prove the injections, saturation-to-edge
coverage, interval reconstruction and admissible deletion witness from its
actual sequence and fold definitions. A theorem assuming count bounds and
equality reconstruction proves only the final arithmetic implication. This
review does not certify a particular Lean file, build, axiom report, novelty,
or biological performance. No experiments, external contact or git operations
were performed by this reviewer.
