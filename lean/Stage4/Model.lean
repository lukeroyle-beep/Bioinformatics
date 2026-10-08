import Std

/-!
Stage 4 model foundation for the unbounded three-helix construction.
Positions are zero based. Folds are arbitrary Boolean relations on Nat; the
admissibility predicate explicitly excludes every out-of-bounds selected pair.
Energy units are exact integer hundredths of a kilocalorie per mole.
This file establishes model and elementary structural facts, not optimality.
-/
namespace Stage4

inductive Base where
  | A | C | G | U
  deriving DecidableEq, BEq, Repr

def wc (a b : Base) : Bool :=
  match a, b with
  | .A, .U | .U, .A | .C, .G | .G, .C => true
  | _, _ => false

/-- Frozen ab/cd table: a,b are at i,i+1; c,d are at j,j-1.
All 16 oriented Watson-Crick stacks are explicit. Invalid stacks are assigned
zero; admissibility ensures they never contribute to the energy of a fold. -/
def stackEnergy (a b c d : Base) : Int :=
  match a, b, c, d with
  | .A, .A, .U, .U => -93
  | .A, .U, .U, .A => -110
  | .A, .C, .U, .G => -224
  | .A, .G, .U, .C => -208
  | .U, .A, .A, .U => -133
  | .U, .U, .A, .A => -93
  | .U, .C, .A, .G => -235
  | .U, .G, .A, .C => -211
  | .C, .A, .G, .U => -211
  | .C, .U, .G, .A => -208
  | .C, .C, .G, .G => -326
  | .C, .G, .G, .C => -236
  | .G, .A, .C, .U => -235
  | .G, .U, .C, .A => -224
  | .G, .C, .C, .G => -342
  | .G, .G, .C, .C => -326
  | _, _, _, _ => 0

theorem wc_symmetric : ∀ a b : Base, wc a b = wc b a := by
  intro a b
  cases a <;> cases b <;> decide

theorem stackEnergy_rotation : ∀ a b c d : Base,
    stackEnergy a b c d = stackEnergy d c b a := by
  intro a b c d
  cases a <;> cases b <;> cases c <;> cases d <;> decide

theorem compatible_stack_negative : ∀ a b c d : Base,
    wc a c = true → wc b d = true → stackEnergy a b c d < 0 := by
  intro a b c d
  cases a <;> cases b <;> cases c <;> cases d <;> decide

theorem incompatible_stack_zero : ∀ a b c d : Base,
    (wc a c = false ∨ wc b d = false) → stackEnergy a b c d = 0 := by
  intro a b c d
  cases a <;> cases b <;> cases c <;> cases d <;> decide

/-- Arbitrary unbounded family parameters, with exactly the frozen lower bounds. -/
structure Params where
  a : Nat
  b : Nat
  c : Nat
  u : Nat
  v : Nat
  ha : 3 ≤ a
  hb : 3 ≤ b
  hc : 3 ≤ c
  hu : 3 ≤ u
  hv : 3 ≤ v

def length (p : Params) : Nat := 2 * (p.a + p.b + p.c) + p.u + p.v

/-- A^a C^b A^u G^(b+c) A^v C^c U^a.
The total extension after `length p` is irrelevant to admissible folds. -/
def seq (p : Params) (i : Nat) : Base :=
  if i < p.a then .A
  else if i < p.a + p.b then .C
  else if i < p.a + p.b + p.u then .A
  else if i < p.a + 2 * p.b + p.c + p.u then .G
  else if i < p.a + 2 * p.b + p.c + p.u + p.v then .A
  else if i < p.a + 2 * p.b + 2 * p.c + p.u + p.v then .C
  else .U

abbrev Fold := Nat → Nat → Bool

def allowed (p : Params) (i j : Nat) : Prop :=
  i < length p ∧ j < length p ∧ i < j ∧ i + 4 ≤ j ∧
    wc (seq p i) (seq p j) = true

/-- Either identical pairs, or disjoint endpoints. -/
def endpointsDisjoint (i j k l : Nat) : Prop :=
  (i = k ∧ j = l) ∨ (i ≠ k ∧ i ≠ l ∧ j ≠ k ∧ j ≠ l)

/-- No topology or helix-length restrictions on competitors. In particular,
empty folds, isolated pairs, bulges, and arbitrary branching are allowed. -/
def admissible (p : Params) (f : Fold) : Prop :=
  (∀ i j, f i j = true → allowed p i j) ∧
  (∀ i j k l, f i j = true → f k l = true → endpointsDisjoint i j k l) ∧
  (∀ i j k l, f i j = true → f k l = true → ¬ (i < k ∧ k < j ∧ j < l))

/-- One helix with opening block [start,start+size), loop of length loopSize.
The arithmetic equality specifies reverse pairing without Nat subtraction. -/
def helixPair (start size loopSize i j : Nat) : Prop :=
  start ≤ i ∧ i < start + size ∧ i + j + 1 = 2 * start + 2 * size + loopSize

instance (s t u i j : Nat) : Decidable (helixPair s t u i j) :=
  inferInstanceAs (Decidable (s ≤ i ∧ i < s + t ∧ i + j + 1 = 2*s + 2*t + u))

def targetPair (p : Params) (i j : Nat) : Prop :=
  helixPair 0 p.a (2 * p.b + 2 * p.c + p.u + p.v) i j ∨
  helixPair p.a p.b p.u i j ∨
  helixPair (p.a + 2 * p.b + p.u) p.c p.v i j

instance (p : Params) (i j : Nat) : Decidable (targetPair p i j) :=
  inferInstanceAs (Decidable
    (helixPair 0 p.a (2*p.b + 2*p.c + p.u + p.v) i j ∨
     helixPair p.a p.b p.u i j ∨ helixPair (p.a+2*p.b+p.u) p.c p.v i j))

/-- Exactly L_a L_b D_u R_b L_c D_v R_c R_a. -/
def target (p : Params) : Fold := fun i j => decide (targetPair p i j)

/-- The outer pair indexes a stack, so each adjacent nesting is counted once. -/
def stackAt (f : Fold) (i j : Nat) : Bool := f i j && f (i + 1) (j - 1)

def contribution (p : Params) (f : Fold) (i j : Nat) : Int :=
  if stackAt f i j then
    stackEnergy (seq p i) (seq p (i + 1)) (seq p j) (seq p (j - 1))
  else 0

/-- Sum over every ordered position pair, with no preselected helix encoding. -/
def energy (p : Params) (f : Fold) : Int :=
  ((List.range (length p)).map fun i =>
    ((List.range (length p)).map fun j => contribution p f i j).sum).sum

def emptyFold : Fold := fun _ _ => false

def singletonFold (r s : Nat) : Fold := fun i j => decide (i = r ∧ j = s)

theorem target_iff (p : Params) (i j : Nat) :
    target p i j = true ↔ targetPair p i j := by simp [target]

theorem target_pair_allowed (p : Params) (i j : Nat)
    (h : targetPair p i j) : allowed p i j := by
  have ha := p.ha
  have hb := p.hb
  have hc := p.hc
  have hu := p.hu
  have hv := p.hv
  rcases h with h | h | h
  · rcases h with ⟨h0, hi, hj⟩
    have si : seq p i = .A := by simp [seq, show i < p.a by omega]
    have sj : seq p j = .U := by
      simp [seq, show ¬ j < p.a by omega, show ¬ j < p.a+p.b by omega,
        show ¬ j < p.a+p.b+p.u by omega,
        show ¬ j < p.a+2*p.b+p.c+p.u by omega,
        show ¬ j < p.a+2*p.b+p.c+p.u+p.v by omega,
        show ¬ j < p.a+2*p.b+2*p.c+p.u+p.v by omega]
    refine ⟨?_, ?_, ?_, ?_, ?_⟩
    all_goals first | (simp [si, sj, wc]) | (unfold length; omega) | omega
  · rcases h with ⟨hi0, hi1, hj⟩
    have si : seq p i = .C := by
      simp [seq, show ¬ i < p.a by omega, hi1]
    have sj : seq p j = .G := by
      simp [seq, show ¬ j < p.a by omega, show ¬ j < p.a+p.b by omega,
        show ¬ j < p.a+p.b+p.u by omega,
        show j < p.a+2*p.b+p.c+p.u by omega]
    refine ⟨?_, ?_, ?_, ?_, ?_⟩
    all_goals first | (simp [si, sj, wc]) | (unfold length; omega) | omega
  · rcases h with ⟨hi0, hi1, hj⟩
    have si : seq p i = .G := by
      simp [seq, show ¬ i < p.a by omega, show ¬ i < p.a+p.b by omega,
        show ¬ i < p.a+p.b+p.u by omega,
        show i < p.a+2*p.b+p.c+p.u by omega]
    have sj : seq p j = .C := by
      simp [seq, show ¬ j < p.a by omega, show ¬ j < p.a+p.b by omega,
        show ¬ j < p.a+p.b+p.u by omega,
        show ¬ j < p.a+2*p.b+p.c+p.u by omega,
        show ¬ j < p.a+2*p.b+p.c+p.u+p.v by omega,
        show j < p.a+2*p.b+2*p.c+p.u+p.v by omega]
    refine ⟨?_, ?_, ?_, ?_, ?_⟩
    all_goals first | (simp [si, sj, wc]) | (unfold length; omega) | omega

theorem target_endpoints_disjoint (p : Params) (i j k l : Nat)
    (h : targetPair p i j) (g : targetPair p k l) : endpointsDisjoint i j k l := by
  have ha := p.ha
  have hb := p.hb
  have hc := p.hc
  have hu := p.hu
  have hv := p.hv
  unfold targetPair helixPair at h g
  unfold endpointsDisjoint
  rcases h with h | h | h <;> rcases g with g | g | g <;> omega

theorem target_noncrossing (p : Params) (i j k l : Nat)
    (h : targetPair p i j) (g : targetPair p k l) : ¬ (i < k ∧ k < j ∧ j < l) := by
  have ha := p.ha
  have hb := p.hb
  have hc := p.hc
  have hu := p.hu
  have hv := p.hv
  unfold targetPair helixPair at h g
  rcases h with h | h | h <;> rcases g with g | g | g <;> omega

theorem target_admissible (p : Params) : admissible p (target p) := by
  refine ⟨?_, ?_, ?_⟩
  · intro i j h
    exact target_pair_allowed p i j ((target_iff p i j).mp h)
  · intro i j k l h g
    exact target_endpoints_disjoint p i j k l ((target_iff p i j).mp h)
      ((target_iff p k l).mp g)
  · intro i j k l h g
    exact target_noncrossing p i j k l ((target_iff p i j).mp h)
      ((target_iff p k l).mp g)

theorem empty_admissible (p : Params) : admissible p emptyFold := by
  simp [admissible, emptyFold]

theorem sum_map_zero {α : Type} (xs : List α) :
    (xs.map fun _ => (0 : Int)).sum = 0 := by
  induction xs with
  | nil => rfl
  | cons x xs ih => simp [ih]

theorem empty_energy (p : Params) : energy p emptyFold = 0 := by
  simp [energy, contribution, stackAt, emptyFold, sum_map_zero]

theorem singleton_admissible (p : Params) (r s : Nat) (h : allowed p r s) :
    admissible p (singletonFold r s) := by
  refine ⟨?_, ?_, ?_⟩
  · intro i j hij
    simp [singletonFold] at hij
    rcases hij with ⟨rfl, rfl⟩
    exact h
  · intro i j k l hij hkl
    simp [singletonFold] at hij hkl
    rcases hij with ⟨rfl, rfl⟩
    rcases hkl with ⟨rfl, rfl⟩
    exact Or.inl ⟨rfl, rfl⟩
  · intro i j k l hij hkl
    simp [singletonFold] at hij hkl
    rcases hij with ⟨rfl, rfl⟩
    rcases hkl with ⟨rfl, rfl⟩
    omega

theorem singleton_no_stack (r s i j : Nat) :
    stackAt (singletonFold r s) i j = false := by
  simp [stackAt, singletonFold]
  omega

theorem singleton_energy (p : Params) (r s : Nat) :
    energy p (singletonFold r s) = 0 := by
  simp [energy, contribution, singleton_no_stack, sum_map_zero]

/-- The additive span condition is exactly three enclosed positions. -/
theorem span_equivalence (i j : Nat) (hij : i < j) :
    i + 4 ≤ j ↔ 3 ≤ j - i - 1 := by omega

/-- Removing selected pairs preserves every admissibility condition. -/
theorem admissible_of_subset (p : Params) (f g : Fold)
    (hf : admissible p f) (hsub : ∀ i j, g i j = true → f i j = true) :
    admissible p g := by
  refine ⟨?_, ?_, ?_⟩
  · intro i j h
    exact hf.1 i j (hsub i j h)
  · intro i j k l h g
    exact hf.2.1 i j k l (hsub i j h) (hsub k l g)
  · intro i j k l h g
    exact hf.2.2 i j k l (hsub i j h) (hsub k l g)

/-- Exact locations of internal stacks of the three target helices. -/
def targetStackPair (p : Params) (i j : Nat) : Prop :=
  (helixPair 0 p.a (2*p.b + 2*p.c + p.u + p.v) i j ∧ i+1 < p.a) ∨
  (helixPair p.a p.b p.u i j ∧ i+1 < p.a+p.b) ∨
  (helixPair (p.a+2*p.b+p.u) p.c p.v i j ∧ i+1 < p.a+2*p.b+p.u+p.c)

theorem target_stack_iff (p : Params) (i j : Nat) :
    stackAt (target p) i j = true ↔ targetStackPair p i j := by
  have ha := p.ha
  have hb := p.hb
  have hc := p.hc
  have hu := p.hu
  have hv := p.hv
  simp only [stackAt, Bool.and_eq_true, target_iff]
  unfold targetPair targetStackPair helixPair
  omega

/-- Delete one ordered pair from an arbitrary fold. -/
def withoutPair (r s : Nat) (f : Fold) : Fold :=
  fun i j => f i j && !(decide (i = r ∧ j = s))

theorem withoutPair_admissible (p : Params) (f : Fold) (r s : Nat)
    (h : admissible p f) : admissible p (withoutPair r s f) := by
  apply admissible_of_subset p f _ h
  intro i j hij
  simp only [withoutPair, Bool.and_eq_true] at hij
  exact hij.1

theorem target_outermost (p : Params) : target p 0 (length p - 1) = true := by
  apply (target_iff p 0 (length p - 1)).mpr
  apply Or.inl
  have ha := p.ha
  unfold helixPair length
  omega

/-- Explicit distinct admissible competitor used in the proposed exact-gap proof.
Its energy difference is not yet established in this foundation module. -/
def deleteOutermost (p : Params) : Fold := withoutPair 0 (length p - 1) (target p)

theorem deleteOutermost_admissible (p : Params) : admissible p (deleteOutermost p) :=
  withoutPair_admissible p (target p) 0 (length p - 1) (target_admissible p)

theorem deleteOutermost_distinct (p : Params) : deleteOutermost p ≠ target p := by
  intro h
  have ht := target_outermost p
  have he := congrFun (congrFun h 0) (length p - 1)
  simp [deleteOutermost, withoutPair, ht] at he

/-- Matching gives uniqueness of the partner at a fixed right endpoint. -/
theorem pair_right_injective (p : Params) (f : Fold) (hf : admissible p f)
    (i j k : Nat) (h : f i j = true) (g : f k j = true) : i = k := by
  have hm := hf.2.1 i j k j h g
  rcases hm with h | h
  · exact h.1
  · exact False.elim (h.2.2.2 rfl)

/-- Matching gives uniqueness of the partner at a fixed left endpoint. -/
theorem pair_left_injective (p : Params) (f : Fold) (hf : admissible p f)
    (i j l : Nat) (h : f i j = true) (g : f i l = true) : j = l := by
  have hm := hf.2.1 i j i l h g
  rcases hm with h | h
  · exact h.2
  · exact False.elim (h.1 rfl)

/-- Distinct stacks cannot use the same right adjacent-position edge. -/
theorem stack_right_injective (p : Params) (f : Fold) (hf : admissible p f)
    (i j k : Nat) (h : stackAt f i j = true) (g : stackAt f k j = true) : i = k := by
  simp only [stackAt, Bool.and_eq_true] at h g
  exact pair_right_injective p f hf i j k h.1 g.1

/-- Distinct stacks cannot use the same left adjacent-position edge. -/
theorem stack_left_injective (p : Params) (f : Fold) (hf : admissible p f)
    (i j l : Nat) (h : stackAt f i j = true) (g : stackAt f i l = true) : j = l := by
  simp only [stackAt, Bool.and_eq_true] at h g
  exact pair_left_injective p f hf i j l h.1 g.1

#print axioms pair_right_injective
#print axioms pair_left_injective
#print axioms stack_right_injective
#print axioms stack_left_injective

#print axioms span_equivalence
#print axioms admissible_of_subset
#print axioms target_stack_iff
#print axioms withoutPair_admissible
#print axioms target_outermost
#print axioms deleteOutermost_admissible
#print axioms deleteOutermost_distinct

#print axioms wc_symmetric
#print axioms stackEnergy_rotation
#print axioms compatible_stack_negative
#print axioms incompatible_stack_zero
#print axioms target_iff
#print axioms target_pair_allowed
#print axioms target_endpoints_disjoint
#print axioms target_noncrossing
#print axioms target_admissible
#print axioms empty_admissible
#print axioms sum_map_zero
#print axioms empty_energy
#print axioms singleton_admissible
#print axioms singleton_no_stack
#print axioms singleton_energy

end Stage4
