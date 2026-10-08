**Stage 1 completed on 8 October 2026. Recommendation: narrow the scope and proceed to a bounded Stage 2 baseline.** Stacking-energy parameters and stacking-based design methods already exist. The proposed research concerns a universal unique-fold guarantee for one restricted family under a fixed stacking-only model. No matching solution was identified in the reviewed literature; novelty remains provisional.

## Research starting point

Boury, Gardelle, Bulteau and Ponty, 2025, [RNA inverse folding can be solved in linear time for structures without isolated stacks or base pairs](https://link.springer.com/article/10.1186/s13015-025-00278-6).

The supplied journal article establishes results for base-pair maximisation. Theorem 10 states that modulo-separated sequences are designs in that model. Theorem 12 guarantees a modulo-2 separated colouring for targets avoiding the two forbidden motifs and having every maximal helix at least three base pairs long. Corollaries 1 and 2 give the linear-time decision/construction result and the associated designability characterisation. Avoidance of the forbidden motifs is required for the existence guarantee; helix length alone does not make every target designable. See pages 17–19.

The conclusion on page 24 explicitly proposes extending separability to a stacking-energy model. The Turner-model section is empirical and uses Turner99 parameters. Its reported energy-distance comparisons exclude sufficiently close alternatives according to a distance threshold, so they must not be reused as certificates against every distinct fold. The attached scientific article was read for Stage 1; it supersedes the earlier unusable sign-in-page attachment.

The [2024 conference version](https://drops.dagstuhl.de/entities/document/10.4230/LIPIcs.WABI.2024.19) is useful for provenance; use the later journal article as the initial technical reference and record any differences.

## Proposed success criterion

**Question Q1:** For every target T in the three-helix family F defined below, does there exist a compatible four-base sequence w for which T has strictly smaller stacking-only energy than every other admissible fold of w? An affirmative answer should supply a construction and analyse its complexity; a negative answer requires a target and an obstruction covering every compatible sequence, not merely failed search attempts.

Possible narrower outcomes are a sufficient condition for a structural family, an efficiently checkable certificate, a proved obstruction, or a counterexample to a plausible extension. These are research options. No new result is claimed.

## Frozen initial model

1. **Alphabet and pairings:** A (adenine), C (cytosine), G (guanine), U (uracil). Allowed ordered pairs are AU, UA, CG and GC. GU and UG wobble pairs are excluded from both targets and competitors in this initial pilot. This is an explicit project narrowing; the seed paper allows wobble competitors.

2. **Admissible folds:** one linear strand of length n; a partial matching on positions 1,…,n; no crossing pairs; each pair (i,j) has i<j and j−i−1≥3. Empty folds, isolated pairs, two-pair helices, arbitrary branching, bulges and internal loops are allowed among competitors. No circular strands or additional sequence constraints.

3. **Energy:** sum the sequence-dependent contribution for each adjacent nested pair of base pairs (i,j),(i+1,j−1), exactly once. An isolated pair contributes zero. All hairpin, bulge, internal-loop, multiloop, terminal, dangling-end, coaxial-stacking, initiation and symmetry terms are omitted. This is a stacking-only mathematical model, not the full Turner model.

4. **Parameters:** freeze the ten Watson–Crick stack free-energy central values from the Turner 2004 online parameter table at 37 °C, listed below. Use the two-decimal table as exact rational constants, or integer hundredths of a kilocalorie per mole. Do not substitute the linked one-decimal software table or tune the values. Experimental uncertainties are outside this initial mathematical model.

5. **Target family F:** one outer helix enclosing exactly two hairpins, hence one three-way junction and three maximal helices. Helix lengths a,b,c≥3; hairpin unpaired lengths u,v≥3; no unpaired junction positions, exterior tails, bulges or additional branches. In dot-bracket notation, let L_k mean k opening parentheses, R_k k closing parentheses, and D_k k dots. Then T(a,b,c,u,v)=L_a L_b D_u R_b L_c D_v R_c R_a, with n=2(a+b+c)+u+v. The smallest target has n=24. This is an analyst-selected subfamily of the seed paper's admissible designable class, not a published new theorem.

6. **Competitors:** every fold allowed by item 2 and compatible with w, including folds outside F and folds with fewer pairs. Stacking weights can favour a different combination of stacks even when base-pair count falls. Do not require a competitor to preserve the target's helices, junction, loops or pairing count.

7. **Guarantee:** require E(w,S)>E(w,T) for every admissible S≠T. Record the minimum difference as the energy gap. Under the frozen integer scale, strict superiority means a gap of at least one unit (0.01 kilocalories per mole). Ties fail. This does not assert a particular equilibrium folding probability or experimental stability.

8. **Representation and complexity:** input is an explicit target dot-bracket string of length n; the alphabet and energy table are fixed. Q1 is unbounded in a,b,c,u,v. Finite search is a pilot only. If a construction exists, report time and space in n; polynomial time is the first algorithmic ambition, with linear time a later improvement.

## Claim discipline

Use these labels consistently: source-established result; proposed question; computational observation; counterexample; proof candidate; independently checked result; unresolved.

A finite computation cannot establish a claim for all lengths. A result under one energy model does not transfer automatically to another. A favourable minimum-energy structure does not by itself prove high folding probability or a particular biological function.

## Evidence to retain

For each source: title, authors, version, publication date, exact relevant theorem or section, assumptions, link and the claim it supports.

For each experiment: frozen model, target set, algorithm version, settings, random seed if relevant, result, failure cases and reproducibility instructions.

For each proof candidate: exact statement, dependencies, proof text, known gaps, counterexample searches and independent verification status.

## Stage 1 checkpoint and remaining uncertainty

Model and target family are frozen as an initial research specification, subject to an explicit revision if Stage 2 reveals a defect or prior-art overlap. Stage 2 has not started. No sequence search, proof attempt, package installation or Lean build was performed. The probability of solving Q1 is unknown. Current evidence supports a bounded feasibility pilot, not a promise of novelty, tractability or biological benefit.

## Exact stacking table

A stack written ab/cd has top strand 5′-ab-3′ and bottom strand 3′-cd-5′. For adjacent pairs (i,j),(i+1,j−1), use ab=w_i w_(i+1) and cd=w_j w_(j−1). Apply the same value to its 180-degree rotated form dc/ba.

| Stack | Free energy at 37 °C, kilocalories per mole |
| --- | --- |
| AA/UU | −0.93 |
| AU/UA | −1.10 |
| UA/AU | −1.33 |
| CU/GA | −2.08 |
| CA/GU | −2.11 |
| GU/CA | −2.24 |
| GA/CU | −2.35 |
| CG/GC | −2.36 |
| GG/CC | −3.26 |
| GC/CG | −3.42 |

Source: [Turner 2004 Watson–Crick parameter table](https://rna.urmc.rochester.edu/NNDB/parameter_tables/turner_2004_rnastructure/turner_2004_watson_crick_stack.htm). Here GU in a strand denotes adjacent nucleotides, not a GU base pair. The [helix documentation](https://rna.urmc.rochester.edu/NNDB/rna_2004/rna_2004_watson_crick_helices.html) attributes these fitted stack parameters to Xia and colleagues (1998). The linked [software table](https://rna.urmc.rochester.edu/NNDB/parameter_tables/turner_2004_rnastructure/turner_2004_watson_crick_stack_dg.txt) rounds to one decimal place; it is a different numerical specification.

## Literature boundary checked on 8 October 2026

| Source | What it establishes or reports | Relationship to Q1 |
| --- | --- | --- |
| [Halès, Héliou, Maňuch, Ponty and Stacho, 2017; 2016 preprint](https://arxiv.org/abs/1603.03577) | Separability and designability for additive base-pair models; scope checked through the seed paper and preprint abstract | Does not supply sequence-dependent adjacent-stack guarantees |
| [Hammer, Wang, Will and Ponty, 25 April 2019](https://link.springer.com/article/10.1186/s12859-019-2784-7) | Exact sampling framework including stacking features; positive design and empirical use as seeds for negative design; Methods and Results inspected | Existing stacking-based sequence design must not be claimed as new. Optimising energy for listed targets does not ensure unique optimality against all folds |
| [Boury, Gardelle, Bulteau and Ponty, 24 October 2025](https://link.springer.com/article/10.1186/s13015-025-00278-6) | Journal seed paper; Theorems 10 and 12, Corollaries 1–2, empirical Turner section and conclusion | Source of the mathematical direction, not a stacking theorem |
| [Boury, Sidl, Hofacker, Ponty and Yao, 2025, Old dog, new tricks](https://htyao.gitlab.io/) | Author-hosted abstract reports biseparability and improved seeds for RNAinverse in the Turner model | Empirical seeding improvement already exists. Full chapter retrieval was blocked, so this comparison is abstract-level |
| [Zhou, Mathews and Huang, 14 February 2026, version 1](https://arxiv.org/html/2602.13610v1) | Ensemble approximation and decomposition provide upper bounds on attainable folding probability; abstract and model sections inspected | Different objective from constructing a unique minimum for every member of F; the inspected version is the preprint |
| [Jogalekar, August 2026 preprint and public repository](https://github.com/ajogalekar/rna-at-most-two-short-helices) | Reports a Lean 4 proof for at most two length-2 helices in a Watson–Crick base-pair-count model; zero minimum span | Relevant potential formalisation foundation, not stacking-energy progress. Repository documentation inspected; proof and clean build not independently checked here |

The bounded search covered exact seed-title and author searches, stacking energy with inverse folding, separability and designability, and 2026 follow-ups using two search engines. No matching solution to Q1 was identified. Indexing delays, terminology differences and inaccessible full texts prevent a definitive claim that no solution exists. A targeted novelty check remains required before presenting any later result as original.

## Why this family and what would count as useful

A single three-way junction introduces competition between helices while keeping the target topology fixed and the family infinite. This is a deliberate feasibility choice. The no-spacer junction and omitted loop energies limit immediate biological realism.

Potential use, if the mathematics and later transfer experiments succeed: a certified source of starting sequences or failure filters for larger inverse-folding searches. Existing seeding work makes this a plausible route, but an advantage over current methods has not been demonstrated. A counterexample or obstruction would still identify where the simple extension breaks.

## Bounded Stage 2 handoff

1. Use a version-controlled repository and pin the parameter table, orientation convention, target grammar and tool versions. Record the chosen model and reasoning setting. Astra on Extra High remains Luke's requested setting for mathematical work; no automatic setting change is claimed.

2. Independently check the ten stack constants and rotation mapping. Implement exact integer energy evaluation and a separate folding algorithm that retains ties.

3. Validate scoring and optimal-fold counts against exhaustive enumeration on small instances, initially at lengths up to 12 with a stated case cap. Include legal isolated pairs, near alternatives, empty folds and ties. Do not compare stacking-only scores to default full-Turner outputs as though they were the same model.

4. Reproduce a small base-pair baseline, then evaluate a capped set of candidate sequences for the minimum 24-position target T(3,3,3,3,3). Exhaustive sequence enumeration at length 24 is not part of this pilot.

5. Start a small Lean 4 model-fidelity pilot. Inspect licensing, exact definitions and the build of the related public formalisation before deciding what can be reused; neither its zero-span assumptions nor its counting objective transfers automatically.

6. Stop with evaluator agreement, coverage, failures and one next question. A candidate beating all folds for one target is an instance certificate. Failure to find a sequence is not an impossibility proof.

## Verification and execution recommendation

**Workflow opinion:** retain this Space for sources, decisions and review; use Codex with a dedicated repository for computational and Lean work. [Official Codex documentation](https://learn.chatgpt.com/docs/codex/cli) describes repository editing, local tools and repeatable scripts. [Official Work documentation](https://learn.chatgpt.com/docs/get-started-with-work) supports research and reviewable outputs here. The relevant advantage is execution and reproducibility, not an assumed difference in mathematical intelligence.

Stage 4 requires a faithful Lean 4 statement and kernel-checked proof, no `sorry` or `admit`, no additional unproved project axioms, a disclosed transitive axiom set, pinned dependencies and a reproducible clean build. Standard foundational axioms must be disclosed; an absolute zero-axiom requirement is not intended. Model fidelity and biological usefulness remain separate checks.

**Confidence:** high that stacking parameters and related methods exist and that the seed theorem is limited to base-pair scoring; moderate that the proposed gap is unaddressed in published work; undetermined whether Q1 is true or practically useful.
