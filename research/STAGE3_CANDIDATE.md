# Stage 3 candidate: a construction for the three-helix family

8 October 2026. **Proof candidate with a complete informal argument.** This is
the Stage 3 handoff, not an accepted general theorem. Independent mathematical
review, faithful Lean formalisation and kernel checking remain Stage 4 work.
No novelty or biological-performance claim is made.

## Exact proposed statement

For integers a,b,c,u,v >= 3, take the frozen target

    T = ( ^a ( ^b . ^u ) ^b ( ^c . ^v ) ^c ) ^a

where exponents indicate repetition and spaces are for readability. Construct

    w = A^a C^b A^u G^(b+c) A^v C^c U^a.

Under `wc-stack-2004-2dp-span3-v1`, the proposed result is that T is the unique
minimum-energy admissible fold of w, and its exact gap to the best distinct
fold is **93 integer units, or 0.93 kcal/mol**. Its energy is

    E(w,T) = -93(a-1) - 326(b+c-2).

Competitors are every compatible noncrossing partial matching with at least
three enclosed positions per pair. Empty folds, isolated pairs, bulges,
additional branches and folds outside the target family are all included.

For an explicit target of length n, its five run lengths can be parsed and
checked in O(n) time. Emitting w takes O(n) time and O(n) output storage, with
O(1) auxiliary counters. This complexity describes construction, not the
current cubic interval-folding verifier.

## Block notation and target admissibility

Use the following seven consecutive blocks, in left-to-right order:

| Block | Bases | Role in T |
| --- | --- | --- |
| B1 | A^a | Outer helix, left side |
| B2 | C^b | Left hairpin, left side |
| B3 | A^u | Left hairpin loop |
| B4 | G^(b+c) | First b: left hairpin right side; last c: right hairpin left side |
| B5 | A^v | Right hairpin loop |
| B6 | C^c | Right hairpin, right side |
| B7 | U^a | Outer helix, right side |

T matches B1 to B7 in reverse order, B2 to the first b positions of B4 in
reverse order, and the last c positions of B4 to B6 in reverse order.
The two hairpin interiors have lengths u,v >= 3. The outer pairs enclose
both hairpins. Therefore these are compatible, noncrossing, span-three pairs.
The junction creates no stack between its incident helices. Counting each
helix's internal stacks gives the stated target energy.

## Lemma 1: classify every possible stack

A stack is the pair of pairs (i,j),(i+1,j-1). Its physical dinucleotide at
positions j-1,j must be the reverse complement of the dinucleotide at i,i+1.
The only physical dinucleotides in w are

    AA, AC, CC, CA, AG, GG, GA, CU, UU.

AC, CA and GA require, respectively, GU, UG and UC physical dinucleotides,
which are absent. CU could only use the earlier AG boundary, and UU could
only use an earlier AA run; neither ordering can be a stack with i<j.
All remaining possibilities are the following, in the frozen top/bottom
notation (the bottom is read at j,j-1):

| Stack | Required physical locations | Energy |
| --- | --- | --- |
| AA/UU | One A block and B7 | -93 |
| CC/GG | B2 and B4 | -326 |
| GG/CC | B4 and B6 | -326 |
| AG/UC | B3/B4 boundary and B6/B7 boundary | -208 |

The last type has only one possible position: its outer pair joins the last
A of B3 to the first U of B7, and its inner pair joins the first G of B4 to
the last C of B6. Hence its occurrence count m is either 0 or 1.

Let x count AA/UU stacks and y count the two GC-stack types together. For
every admissible S, including structures with isolated pairs,

    E(w,S) = -93x - 326y - 208m.

An isolated pair is still allowed; it simply contributes no stack term.

## Lemma 2: two independent counting bounds

Each AA/UU stack uses one adjacent-position edge in B7. A fixed adjacent U
edge can support at most one stack because each position has at most one
partner. There are a-1 such edges. Thus x <= a-1.

Each GC stack uses one adjacent-position edge in B2 or B6. By the same
matching condition this assignment is injective. Those blocks have
(b-1)+(c-1) adjacent edges, so y <= b+c-2. These bounds concern every
compatible fold, not only folds preserving the target helices.

## Lemma 3: equality in both bounds determines the whole target

Suppose y=b+c-2. Every adjacent C edge in B2 and B6 must occur in a GC
stack. Because b,c >= 3, every C belongs to at least one of these edges
and is paired. Consecutive C positions have consecutive partners in
reverse order, so each C block forms one contiguous helix into B4.

These two G-partner intervals are disjoint and have lengths b and c. Their
total length is b+c, so together they use all of B4. The B2 partner interval
must precede the B6 partner interval: otherwise a B2-to-G pair and an
earlier-G-to-B6 pair have endpoints C_left < G_early < G_late < C_right,
which cross. Therefore the first b Gs partner B2 and the last c Gs partner
B6. Reverse-order pairing in each interval is forced. These are exactly
the two target GC hairpins.

With both hairpins fixed, an A in B3 or B5 cannot pair to any U in B7:
such a pair would cross the enclosing GC hairpin pair. Thus any AU pair
must join B1 to B7. If also x=a-1, every adjacent U edge is used. Since
a>=3, this pairs every U, requiring every one of the a As of B1. The
noncrossing perfect matching between these two ordered blocks is uniquely
the reverse-order matching, i.e. the target outer helix.

Every C, G and U is now paired. The remaining positions are As in the
loops, which cannot pair to one another. In particular, no extra isolated
pair can be appended. Therefore x=a-1 and y=b+c-2 imply S=T.

## Lemma 4: the mixed stack excludes the left GC helix

Suppose m=1. Let p be the last position of B3 and q the first position of
B7. The mixed stack includes the AU pair (p,q).

Every C position r of B2 is before p, and every G position s of B4 is
strictly between p and q. Pairing r to any G would give r<p<s<q,
a crossing. There are no other Gs. Hence every C of B2 is unpaired.
All GC stacks must use adjacent edges of B6, giving y<=c-1.

Together with Lemma 2,

    E(w,S) >= -93(a-1) -326(c-1) -208
           = E(w,T) +326(b-1)-208
           >= E(w,T) +444.

Thus a mixed stack cannot produce an optimal or tied competitor.

## Candidate argument and exact gap

If m=0, Lemma 2 gives E(w,S)>=E(w,T). For S distinct from T, Lemma 3
means that at least one of its two integer bounds is strict. Accordingly,

    E(w,S)-E(w,T)
      = 93[(a-1)-x] +326[(b+c-2)-y] >=93.

If m=1, Lemma 4 gives a gap of at least 444. These cases exhaust every
admissible S by Lemma 1. Finally, remove only the outermost AU pair of T.
The resulting fold is distinct and admissible, and loses exactly one
AA/UU stack because a>=3. Its energy is E(w,T)+93. The lower bound is
therefore attained: the proposed exact gap is 93 for every parameter tuple.

This derivation does not assume correctness of the Python folding recurrence
or use the finite sample as an induction. It uses the frozen constants,
sequence block order, matching and noncrossing conditions. No unresolved
mathematical step has been identified in this derivation, but that assessment
is the author's self-review, not independent verification.

## Failed approach retained

The direct extension of the Stage 2 example was

    w_old = A^(a+b+u) U^b C^c A^v G^c U^a.

For any u>=4, keep the target outer and right helices, and move every left
endpoint of the left hairpin one position right while keeping its U endpoints
fixed. This consumes one A from the left loop and leaves one unpaired A at
the junction. The reduced loop has length u-1>=3. Pair compatibility,
noncrossing and every helix's stack count are preserved, so the distinct
fold ties the target. This competitor lies outside the target family but
inside the required competitor set. Thus this formula cannot solve Q1
for arbitrary loop lengths. It is not an obstruction to designability.

For T(3,3,3,4,3), independent enumeration finds 68,838 compatible folds
and three minima at -10.24 kcal/mol. The new construction has a unique
minimum for that same target in the retained checks.

## Stage 4 obligations

1. Review Lemmas 1–4 independently, particularly stack-edge injectivity,
   the equality reconstruction, and competitors with extra isolated pairs.
2. Formalise the unbounded sequence, target, span-three noncrossing matchings
   and exact energy. Connect the stack classification to the full frozen
   parameter table; the seven-position Stage 2 proof does not do this.
3. Kernel-check uniqueness and the exact gap with the pinned Lean toolchain,
   no placeholders or extra unproved project axioms, and a disclosed full
   transitive axiom report and clean build.
4. Reconcile the newly located WABI 2026 paper and earlier constructions
   before any originality claim. Specialist review remains required before
   presenting the result as established research; contact needs authorization.

Stage 4 is not started by this checkpoint. The statement remains a candidate
answer to Q1 until the project's verification gates are met.
