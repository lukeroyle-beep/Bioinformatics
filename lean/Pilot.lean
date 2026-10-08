import Std

/- Kernel-checked finite pilot for G G A A A C C at seven positions.
   Exact units are hundredths of a kilocalorie per mole; the only possible stack
   is GG/CC, frozen at -326. Every fold is represented as a Boolean relation on
   all 49 ordered pairs of Fin 7 positions. The completeness bridge below proves
   that every admissible such relation is represented by one of the 16 masks.
   This is not the 24-position certificate, the general folding algorithm, or
   an infinite-family theorem. -/

namespace Stage2

inductive Base where
  | A | C | G | U
  deriving DecidableEq, BEq, Repr

def wc (a b : Base) : Bool :=
  match a, b with
  | .A, .U | .U, .A | .C, .G | .G, .C => true
  | _, _ => false

def seq (i : Fin 7) : Base :=
  if i.val < 2 then .G else if i.val < 5 then .A else .C

abbrev Edge := Nat × Nat

def edges : List Edge := [(0, 5), (0, 6), (1, 5), (1, 6)]

def allowed (i j : Fin 7) : Prop :=
  i.val < j.val ∧ j.val - i.val - 1 ≥ 3 ∧ wc (seq i) (seq j) = true

instance (i j : Fin 7) : Decidable (allowed i j) := inferInstanceAs
  (Decidable (i.val < j.val ∧ j.val - i.val - 1 ≥ 3 ∧ wc (seq i) (seq j) = true))

theorem admissible_edges_complete : ∀ i j : Fin 7,
    allowed i j ↔ (i.val, j.val) ∈ edges := by decide

/-- Every possible adjacent compatible stack has the frozen GG/CC orientation. -/
theorem compatible_stack_bases : ∀ i j k l : Fin 7,
    allowed i j → allowed k l →
    (k.val, l.val) = (i.val + 1, j.val - 1) →
    seq i = .G ∧ seq k = .G ∧ seq j = .C ∧ seq l = .C := by decide

def decode (m : Fin 16) : List Edge :=
  (List.range 4).filterMap fun k =>
    if m.val / (2 ^ k) % 2 = 1 then some (edges[k]!) else none

def legal (m : Fin 16) : Bool :=
  let ps := decode m
  ps.all fun p => ps.all fun q => decide
    (p = q ∨
      (p.1 ≠ q.1 ∧ p.1 ≠ q.2 ∧ p.2 ≠ q.1 ∧ p.2 ≠ q.2 ∧
       ¬ (p.1 < q.1 ∧ q.1 < p.2 ∧ p.2 < q.2) ∧
       ¬ (q.1 < p.1 ∧ p.1 < q.2 ∧ q.2 < p.2)))

/-- All compatible adjacent pairs in this example have the GG/CC value -326. -/
def score (m : Fin 16) : Int :=
  let ps := decode m
  (ps.map fun p => if ps.contains (p.1 + 1, p.2 - 1) then (-326 : Int) else 0).sum

def target : Fin 16 := 6

theorem target_pairs : decode target = [(0, 6), (1, 5)] := by decide
theorem target_legal : legal target = true := by decide
theorem target_energy : score target = -326 := by decide
theorem empty_energy : score 0 = 0 := by decide
theorem isolated_pair_energy : score 1 = 0 := by decide
theorem crossing_rejected : legal 9 = false := by decide
theorem reused_endpoint_rejected : legal 3 = false := by decide
theorem unique_minimum_in_finite_encoding : ∀ m : Fin 16,
    legal m = true → m ≠ target → score target < score m := by decide

/-- Exactly six legal masks: empty, four single pairs, and the nested target. -/
theorem legal_masks_exact : ∀ m : Fin 16,
    legal m = true ↔ m = 0 ∨ m = 1 ∨ m = 2 ∨ m = 4 ∨ m = 8 ∨ m = target := by decide

/-- Arbitrary relation on the 49 ordered position pairs. -/
abbrev Fold := Fin 7 → Fin 7 → Bool

/-- Enumerate every selected ordered pair, without restricting topology. -/
def foldPairs (f : Fold) : List Edge :=
  (List.finRange 7).flatMap fun i =>
    (List.finRange 7).filterMap fun j =>
      if f i j then some (i.val, j.val) else none

/-- Includes orientation, minimum span three, and Watson–Crick compatibility. -/
def compatible (f : Fold) : Prop :=
  ∀ i j : Fin 7, f i j = true → allowed i j

/-- Distinct selected pairs neither share endpoints nor cross. -/
def foldLegal (f : Fold) : Bool :=
  let ps := foldPairs f
  ps.all fun p => ps.all fun q => decide
    (p = q ∨
      (p.1 ≠ q.1 ∧ p.1 ≠ q.2 ∧ p.2 ≠ q.1 ∧ p.2 ≠ q.2 ∧
       ¬ (p.1 < q.1 ∧ q.1 < p.2 ∧ p.2 < q.2) ∧
       ¬ (q.1 < p.1 ∧ p.1 < q.2 ∧ q.2 < p.2)))

def admissible (f : Fold) : Prop := compatible f ∧ foldLegal f = true

/-- Direct adjacent-stack score over the full relation, counted once per outer pair.
    The constant -326 is justified for compatible folds by compatible_stack_bases. -/
def foldScore (f : Fold) : Int :=
  let ps := foldPairs f
  (ps.map fun p => if ps.contains (p.1 + 1, p.2 - 1) then (-326 : Int) else 0).sum

def canonical (a b c d : Bool) : Fold := fun i j =>
  ((i.val == 0 && j.val == 5) && a) ||
  ((i.val == 0 && j.val == 6) && b) ||
  ((i.val == 1 && j.val == 5) && c) ||
  ((i.val == 1 && j.val == 6) && d)

def encode (a b c d : Bool) : Fin 16 :=
  ⟨(if a then 1 else 0) + (if b then 2 else 0) +
    (if c then 4 else 0) + (if d then 8 else 0), by
      cases a <;> cases b <;> cases c <;> cases d <;> decide⟩

def encodedFold (m : Fin 16) : Fold := fun i j =>
  decide ((i.val, j.val) ∈ decode m)

theorem canonical_forbidden : ∀ a b c d : Bool, ∀ i j : Fin 7,
    ¬ allowed i j → canonical a b c d i j = false := by decide

theorem compatible_canonical (f : Fold) (hf : compatible f) :
    f = canonical (f 0 5) (f 0 6) (f 1 5) (f 1 6) := by
  funext i j
  by_cases hij : allowed i j
  · have he := (admissible_edges_complete i j).mp hij
    rcases i with ⟨i, hi⟩
    rcases j with ⟨j, hj⟩
    simp [edges] at he
    rcases he with ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩
    all_goals simp [canonical]
  · have hz : f i j = false := by
      cases hb : f i j with
      | false => rfl
      | true => exact False.elim (hij (hf i j hb))
    rw [hz]
    exact (canonical_forbidden _ _ _ _ i j hij).symm

theorem canonical_pairs : ∀ a b c d : Bool,
    foldPairs (canonical a b c d) = decode (encode a b c d) := by decide

theorem canonical_realizes : ∀ a b c d : Bool, ∀ i j : Fin 7,
    canonical a b c d i j = encodedFold (encode a b c d) i j := by decide

theorem all_compatible_folds_encoded (f : Fold) (hf : compatible f) :
    ∃ m : Fin 16, f = encodedFold m ∧ foldPairs f = decode m := by
  let a := f 0 5
  let b := f 0 6
  let c := f 1 5
  let d := f 1 6
  refine ⟨encode a b c d, ?_, ?_⟩
  · rw [compatible_canonical f hf]
    funext i j
    exact canonical_realizes a b c d i j
  · rw [compatible_canonical f hf]
    exact canonical_pairs a b c d

theorem all_admissible_folds_encoded (f : Fold) (hf : admissible f) :
    ∃ m : Fin 16, f = encodedFold m ∧ legal m = true ∧ foldScore f = score m := by
  obtain ⟨m, hm, hp⟩ := all_compatible_folds_encoded f hf.1
  refine ⟨m, hm, ?_, ?_⟩
  · simpa [foldLegal, legal, hp] using hf.2
  · simp [foldScore, score, hp]

theorem targetFold_admissible : admissible (encodedFold target) := by
  unfold admissible compatible
  decide

theorem targetFold_score : foldScore (encodedFold target) = score target := by decide

/-- No topology restriction: all admissible relations on these seven positions. -/
theorem unique_minimum_all_admissible_folds (f : Fold) (hf : admissible f)
    (hne : f ≠ encodedFold target) :
    foldScore (encodedFold target) < foldScore f := by
  obtain ⟨m, hm, hl, hs⟩ := all_admissible_folds_encoded f hf
  have hmne : m ≠ target := by
    intro ht
    apply hne
    simpa [ht] using hm
  rw [targetFold_score, hs]
  exact unique_minimum_in_finite_encoding m hl hmne

#print axioms admissible_edges_complete
#print axioms compatible_stack_bases
#print axioms target_pairs
#print axioms target_legal
#print axioms target_energy
#print axioms empty_energy
#print axioms isolated_pair_energy
#print axioms crossing_rejected
#print axioms reused_endpoint_rejected
#print axioms unique_minimum_in_finite_encoding
#print axioms legal_masks_exact
#print axioms canonical_forbidden
#print axioms compatible_canonical
#print axioms canonical_pairs
#print axioms canonical_realizes
#print axioms all_compatible_folds_encoded
#print axioms all_admissible_folds_encoded
#print axioms targetFold_admissible
#print axioms targetFold_score
#print axioms unique_minimum_all_admissible_folds

end Stage2
