# Stage 4 bounded primary-source comparison

8 October 2026. **Comparison incomplete:** the 2025 paper was retrieved and
its relevant definitions/theorems inspected; only the publisher landing page
and abstract of the WABI 2026 paper were retrieved. Research stopped at the
shared usage checkpoint. No originality assertion or external contact.

## WABI 2026

Théo Boury, Laurent Bulteau and Yann Ponty, *RNA Inverse Folding Under Stacked
Base Pair Maximization*, published 27 August 2026, LIPIcs 390, 12:1–12:21.
[Publisher record and abstract](https://drops.dagstuhl.de/entities/document/10.4230/LIPIcs.WABI.2026.12).

The abstract states an exact linear-time maxStacks construction for minimum
helix length ceil(log base 3.56 of Delta + 6.2), where Delta is the maximum
loop degree. It introduces a sufficient locked property and also reports a
pseudoknot variant with the number of helices replacing Delta. Turner-model
experiments are separate from these exact guarantees.

This establishes direct prior work on stack-count inverse folding. It does
not by itself establish the project's unequal sequence-dependent stack
weights or exact gap. The actual PDF request returned an internal retrieval
error. A shell retrieval could not resolve the publisher host in the sandbox;
the escalated attempt was interrupted without a usable response. Consequently
the paper's precise wobble, isolated-pair and minimum-span conventions, theorem
numbers and proof dependencies were **not independently verified in this
Stage 4 pass**. Earlier Stage 3 descriptions of those conventions are not
promoted to newly checked evidence here. Full-paper comparison remains open.

## 2025 seed journal article

Théo Boury, Samuel Gardelle, Laurent Bulteau and Yann Ponty, *RNA inverse folding
can be solved in linear time for structures without isolated stacks or base
pairs*, published 24 October 2025, Algorithms for Molecular Biology 20:20.
[Article](https://link.springer.com/article/10.1186/s13015-025-00278-6);
[PDF](https://link.springer.com/content/pdf/10.1186/s13015-025-00278-6.pdf).

Pages 2–3 define noncrossing partial matchings, permit GU pairing and use a
minimum-distance parameter defaulting to zero. Isolated pairs are not excluded
from the general competitor definition. The objective maximises pair count.
Theorem 10 (page 17) makes modulo-separated sequences designs. Theorem 12 and
Corollaries 1–2 (pages 18–19) give the linear construction/characterisation for
helix lengths at least three, with avoidance of the two forbidden motifs.
Length alone is not an unconditional designability guarantee.

The Turner experiment section (pages 20–22) uses Turner99 and a distance
threshold excluding nearby alternatives. It is not a certificate against
every distinct fold under the project's frozen stacking table.

## Project interpretation

The project requires WC-only competitors, at least three enclosed positions,
isolated-pair competitors, unequal exact integer stack weights, and all helix
lengths from three upward for one restricted three-helix family. Pair-count
optimality does not imply its weighted stacking guarantee. The WABI abstract
likewise cannot establish transfer to these conditions. A complete WABI
full-text model-and-theorem comparison is still needed before assessing
overlap; even that bounded comparison would not establish originality.

## 9 October continuation: full-text access recovered

The cached publisher PDF was located and verified: 1,467,424 bytes, SHA-256
`54a35a5bd2047adb109e722db9bb99eac66a2c91434213d170e5ab3e1d898ca1`,
matching the Stage 3 provenance. Pages 3, 4, 8 and 16 were freshly extracted
from these PDF bytes with pypdf and read. The publisher record was also reopened;
a new online PDF request timed out. The earlier access failure remains historical.

The bounded model/theorem comparison is now complete:

| Dimension | WABI 2026 paper | Frozen project |
| --- | --- | --- |
| Pairing | Includes GU wobble (§2, p.3) | AU/UA/CG/GC only |
| Admissibility | Every pair belongs to a stack (p.3) | Isolated pairs admitted |
| Pair span | j > i+1 (p.3) | At least three enclosed positions |
| Main objective | Maximise stack count (Problem 1, p.4) | Minimise the exact unequal stack-energy sum |
| Construction guarantee | Helix-length condition depending logarithmically on maximum loop degree (Theorem 5, p.8) | Three specified helices, each length >=3 |
| Weighted extension | Discusses transfer when non-wobble stacks dominate wobble stacks (p.16) | Specific frozen two-decimal WC table and exact 93-unit gap |

The weighted discussion is relevant prior art and must not be described as
absent. These assumption differences alone establish neither originality nor
non-overlap. No verified reduction from the published theorem to this exact
short-helix construction and full competitor domain has been supplied. Specialist
comparison and broader novelty assessment remain separate from this bounded read.
Source: [publisher PDF](https://drops.dagstuhl.de/storage/00lipics/lipics-vol390-wabi2026/LIPIcs.WABI.2026.12/LIPIcs.WABI.2026.12.pdf).
