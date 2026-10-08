import Std

/- DRAFT: not compiled in the authoring environment. No claim of Lean acceptance.
   A finite seven-position example, not the 24-position junction or a general proof.
   Exact units are hundredths of a kilocalorie per mole.
   Fin 16 enumerates every subset of the four admissible edges of G G A A A C C.
   Model-completeness beyond the finite edge check is not proved here. -/

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

#print axioms admissible_edges_complete
#print axioms target_pairs
#print axioms target_legal
#print axioms target_energy
#print axioms empty_energy
#print axioms isolated_pair_energy
#print axioms crossing_rejected
#print axioms reused_endpoint_rejected
#print axioms unique_minimum_in_finite_encoding

end Stage2
