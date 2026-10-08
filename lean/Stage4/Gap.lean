import Std

/- The numerical end of the Stage 3 argument, independent of any fold encoding.
   The hypotheses below are explicit proof obligations for the structural model.
   These theorems alone do not establish designability of an RNA sequence. -/

namespace Stage4.Gap

def energy (x y m : Nat) : Int := -93 * (x : Int) - 326 * (y : Int) - 208 * (m : Int)

def targetEnergy (a b c : Nat) : Int :=
  -93 * ((a - 1 : Nat) : Int) - 326 * ((b + c - 2 : Nat) : Int)

theorem ordinary_lower_bound (a b c x y : Nat)
    (hx : x ≤ a - 1) (hy : y ≤ b + c - 2) :
    targetEnergy a b c ≤ energy x y 0 := by
  unfold targetEnergy energy
  omega

theorem ordinary_strict_gap (a b c x y : Nat)
    (hx : x ≤ a - 1) (hy : y ≤ b + c - 2)
    (hstrict : x < a - 1 ∨ y < b + c - 2) :
    targetEnergy a b c + 93 ≤ energy x y 0 := by
  unfold targetEnergy energy
  omega

theorem mixed_gap (a b c x y : Nat)
    (hb : 3 ≤ b) (hc : 3 ≤ c)
    (hx : x ≤ a - 1) (hy : y ≤ c - 1) :
    targetEnergy a b c + 444 ≤ energy x y 1 := by
  unfold targetEnergy energy
  omega

/-- Equality reconstruction is supplied as a hypothesis, not silently assumed. -/
theorem distinct_gap (a b c x y m : Nat)
    (hb : 3 ≤ b) (hc : 3 ≤ c)
    (hx : x ≤ a - 1) (hy : y ≤ b + c - 2)
    (hm : m = 0 ∨ m = 1)
    (hMixed : m = 1 → y ≤ c - 1)
    (hDistinct : ¬ (x = a - 1 ∧ y = b + c - 2)) :
    targetEnergy a b c + 93 ≤ energy x y m := by
  rcases hm with hm | hm
  · subst m
    apply ordinary_strict_gap a b c x y hx hy
    omega
  · subst m
    have h := mixed_gap a b c x y hb hc hx (hMixed rfl)
    omega

theorem outer_pair_deletion_energy (a b c : Nat) (ha : 3 ≤ a) :
    energy (a - 2) (b + c - 2) 0 = targetEnergy a b c + 93 := by
  unfold energy targetEnergy
  omega

/-- Conditional lifting theorem over any type of folds and energy function.
    Every structural premise must be proved before applying this to RNA folds. -/
theorem unique_minimum_of_counts {Fold : Type} (legal : Fold → Prop)
    (target : Fold) (score : Fold → Int) (a b c : Nat)
    (countAU countGC countMixed : Fold → Nat)
    (hb : 3 ≤ b) (hc : 3 ≤ c)
    (target_legal : legal target)
    (target_score : score target = targetEnergy a b c)
    (classification : ∀ s, legal s → score s = energy (countAU s) (countGC s) (countMixed s))
    (au_bound : ∀ s, legal s → countAU s ≤ a - 1)
    (gc_bound : ∀ s, legal s → countGC s ≤ b + c - 2)
    (mixed_binary : ∀ s, legal s → countMixed s = 0 ∨ countMixed s = 1)
    (mixed_bound : ∀ s, legal s → countMixed s = 1 → countGC s ≤ c - 1)
    (reconstruction : ∀ s, legal s → countAU s = a - 1 → countGC s = b + c - 2 → s = target) :
    legal target ∧ ∀ s, legal s → s ≠ target → score target + 93 ≤ score s := by
  refine ⟨target_legal, ?_⟩
  intro s hs hne
  rw [target_score, classification s hs]
  apply distinct_gap a b c (countAU s) (countGC s) (countMixed s) hb hc
    (au_bound s hs) (gc_bound s hs) (mixed_binary s hs) (mixed_bound s hs)
  intro h
  exact hne (reconstruction s hs h.1 h.2)

/-- An admissible witness attaining the bound is additionally required for an exact gap. -/
theorem exact_gap_of_lower_bound {Fold : Type} (legal : Fold → Prop)
    (target witness : Fold) (score : Fold → Int)
    (lower : ∀ s, legal s → s ≠ target → score target + 93 ≤ score s)
    (witness_legal : legal witness) (witness_distinct : witness ≠ target)
    (witness_score : score witness = score target + 93) :
    (∀ s, legal s → s ≠ target → score target < score s) ∧
    (legal witness ∧ witness ≠ target ∧ score witness - score target = 93) := by
  constructor
  · intro s hs hne
    have h := lower s hs hne
    omega
  · exact ⟨witness_legal, witness_distinct, by omega⟩

#print axioms ordinary_lower_bound
#print axioms ordinary_strict_gap
#print axioms mixed_gap
#print axioms distinct_gap
#print axioms outer_pair_deletion_energy
#print axioms unique_minimum_of_counts
#print axioms exact_gap_of_lower_bound

end Stage4.Gap
