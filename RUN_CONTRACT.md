# Stage 2 execution contract

Authorised: Stage 2 only, 8 October 2026. Stop before Stage 3.

Model: wc-stack-2004-2dp-span3-v1, frozen in parameters.json and sources/STAGE1_SPEC.md.
Use integer energy units; no parameter tuning and no silent competitor exclusions.

Validation cap, fixed before running: all four-base sequences of lengths 0 through 8;
128 deterministic sequences at each of lengths 9 through 12; explicit edge cases;
every admissible topology for each selected sequence; two separately implemented scorers.
Base-pair baseline: homopolymer stem hairpins with three or four GC pairs and three
or four unpaired As, a simple separated-colouring instance of seed Theorem 1/10;
test both zero span with wobble (seed model) and span three with Watson-Crick pairs.
This is a small theorem-instance reproduction, not reproduction of the paper's whole
algorithm, uniform sampler or empirical dataset.

Junction pilot cap: 256 deterministic target-compatible candidates at the minimum
24-position target. 64 stem-constant assignments, then 192 independently seeded
random assignments. No adaptive optimisation or exhaustive sequence search.
Evaluate every admissible fold via exact dynamic programming for each candidate.
Cross-check the first successes/failures on explicit compatible-fold enumeration.
The checker implemented a 200,000-fold cap per case. The initial checker run hit
that cap, after the full candidate screen had run. The repaired checker counts
folds first, logs over-cap representatives, and checks the first representative
in each observed outcome class that fits the unchanged cap. No candidates,
parameters, search bounds or decision criteria changed.

Lean pilot: a new, small dependency-free model and finite certificate, pinned to
Lean 4.19.0. No code imported from the related 2026 repository. That repository's
documentation and software licensing were inspected; its build is not accepted
or required as a dependency of this pilot. General theorem and folder correctness
proof remain outside this stage.

The active model selector and reasoning setting are not exposed in this executor.
No claim is made that Astra Extra High was selected. Mathematical research remains
reserved for the later stage; this run develops and checks the finite baseline.
No external expert review, remote repository publication or background task.

## Authorised Stage 2 verification continuation, 8 October 2026

Luke explicitly authorised restoring the supplied bundle at
`d037996e324a1fc0923270f950e5a540ac0a45d6`, establishing Lean 4.19.0, compiling and
repairing the draft while preserving its intended statement, reviewing model
fidelity and finite coverage, retaining a clean build and transitive axiom
report, reproducing both existing Python runners once, and committing an updated
local checkpoint. Begin directly and stop at the Stage 2 checkpoint.

The original nine Lean statements compiled unchanged. Added work closes only
the seven-position fold-to-mask coverage boundary: arbitrary relations on the
seven positions, admissibility, encoding completeness, specialized stack value,
and the lifted unique minimum. The frozen model, all Python sources, runner
bounds and seeds, parameters.json, and Stage 1 specification remain unchanged.
No full parameter-table formalisation, general folder proof or family theorem
is added. Every project theorem must be kernel checked with a disclosed
transitive axiom set; no placeholders, added unproved project axioms or native
computation proof shortcuts are accepted.

Python runners were each executed exactly once in this continuation. Their
result comparison and actual CPython 3.14.4 environment are retained separately.
Only build/proof repair and artifact validation may be repeated as necessary.
The official Lean 4.19.0 macOS ARM64 distribution is installed locally under
ignored .tools; the original Linux startup failure remains historical evidence.

Internal agent review supports this checkpoint; it is not external mathematical
review. No remote repository publication, external reviewer contact, pending
Google Drive memory upload or background task is authorised. No recovery codes
are needed, read or used. The requested later Astra Extra High setting is not
verified here and is not claimed. Stage 3 remains unauthorised.

## Authorised repository migration, 8 October 2026

After Stage 2 completion, Luke supplied
https://github.com/lukeroyle-beep/Bioinformatics and explicitly requested migration
of the work done so far and a README before Stage 3. This authorises pushing the
reviewed project and its existing commit history to that repository. The remote
was inspected and found empty and public; its visibility is not changed. This
permission supersedes the earlier no-remote-publication restriction only for the
named repository. Preserve original dated evidence, use a normal push without
force, retain the frozen model and search bounds, and verify remote content.

Migration changes are documentation, retained final acceptance evidence and the
checkpoint packager's publication wording. No experiment reruns, additional
searches, Stage 3 work, external reviewer contact or Google Drive memory upload
are authorised by this migration.

## Authorised Stage 3 research, 8 October 2026

Luke subsequently instructed: "Please proceed with Stage 3. Please stop at a
safe checkpoint when usage remaining reaches 70%." This supersedes the earlier
Stage 3 stop for the present bounded research task. The retrieved staged plan
calls for sequential constructive, obstruction and supporting-lemma work, one
active conjecture, and a stop at the Stage 3 gate. That gate accepts a precise
candidate theorem with a complete argument, a reproducible counterexample, or
a useful partial result with all remaining gaps identified.

The explicit local plan gate was satisfied by that instruction. Scope, initial
bounds, one subsequent predeclared amendment and rollback are retained in
research/STAGE3_PLAN.md and results/stage3/execution_contract.json. All frozen
model files, prior experiment sources, Lean files and Stage 2 evidence remain
byte-identical to fc6612f. New results are separate under results/stage3/.

The initial four-case attempt exposed ties. Its replacement was evaluated on
a 243-tuple grid and 26 stress tuples. Seven count-first explicit enumerations
stayed below 200,000 folds per case. These are authorized new Stage 3 checks;
the old Stage 2 runners were not rerun or expanded. The general construction
is an informal proof candidate and does not inherit the Stage 2 Lean result.

The usage limit applies to the provider's shared account allowance. Initial
remaining allowance was 86%; check between batches, reserve checkpoint margin
by 72%, and start no further research at 70%. Stop sooner at the stage gate.
No Stage 4 formalisation, remote push, external contact, cloud memory upload,
usage reset or background continuation is included. The active model/reasoning
selector is not exposed; the requested Astra Extra High setting is unverified.

## Authorised Stage 4 verification, 8 October 2026

Luke subsequently instructed: "Please proceed with Stage 4. Pause at a safe
checkpoint when weekly usage remaining reaches 70%." This supersedes the
Stage 4 stop for the present task. The scope is independent review and faithful
Lean verification of the Stage 3 candidate under the frozen model, plus a
bounded primary-literature comparison. The initial weekly reading is 80%
remaining; reserve closeout margin at 72% and start no research at 70%.

The explicit plan is research/STAGE4_PLAN.md and the execution contract is
results/stage4/execution_contract.json. Preserve earlier sources/evidence;
retain new proofs separately. No remote push, external contact, cloud memory
write, reset or background continuation. Partial formalisation must list the
unproved structural obligations and cannot be called the family theorem.
