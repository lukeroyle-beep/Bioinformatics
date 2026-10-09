import Energy

namespace Stage4

/-- A finite integer double sum can be exchanged without changing its terms. -/
theorem double_sum_swap (xs ys : List Nat) (h : Nat → Nat → Int) :
    (xs.map fun i => (ys.map fun j => h i j).sum).sum =
      (ys.map fun j => (xs.map fun i => h i j).sum).sum := by
  induction xs with
  | nil => simp [sum_map_zero]
  | cons x xs ih =>
    simp only [List.map_cons, List.sum_cons]
    rw [sum_map_add, ih]

/-- Constant multiplication distributes over the actual list sum. -/
theorem sum_map_mul (xs : List Nat) (c : Int) (g : Nat → Int) :
    (xs.map fun k => c * g k).sum = c * (xs.map g).sum := by
  induction xs with
  | nil => simp
  | cons x xs ih => simp [ih, Int.mul_add]

/-- Natural counts are embedded in the integer energy sum without loss. -/
theorem natCast_sum_map (xs : List Nat) (g : Nat → Nat) :
    (((xs.map g).sum : Nat) : Int) = (xs.map fun k => (g k : Int)).sum := by
  induction xs with
  | nil => simp
  | cons x xs ih => simp [ih]

/-- A row with at most one selected position contributes once iff it is nonempty. -/
theorem sum_range_unique_support (n : Nat) (r : Nat → Bool) (q : Int)
    (unique : ∀ i j, i < n → j < n → r i = true → r j = true → i = j) :
    ((List.range n).map fun i => if r i then q else 0).sum =
      if (List.range n).any r then q else 0 := by
  by_cases ha : (List.range n).any r = true
  · obtain ⟨k, hk, hrk⟩ := List.any_eq_true.mp ha
    have hkn : k < n := List.mem_range.mp hk
    have heq : (List.range n).map (fun i => if r i then q else 0) =
        (List.range n).map (fun i => if i = k then q else 0) := by
      apply List.map_congr_left
      intro i hi
      have hin : i < n := List.mem_range.mp hi
      by_cases hir : r i = true
      · have hik := unique i k hin hkn hir hrk
        simp [hik, hrk]
      · have hik : i ≠ k := by
          intro hik
          subst i
          exact hir hrk
        simp [hir, hik]
    rw [heq, sum_range_indicator]
    simp [hkn, ha]
  · have heq : (List.range n).map (fun i => if r i then q else 0) =
        (List.range n).map (fun _ => (0 : Int)) := by
      apply List.map_congr_left
      intro i hi
      have hir : ¬ r i = true := by
        intro hir
        exact ha (List.any_eq_true.mpr ⟨i, hi, hir⟩)
      simp [hir]
    rw [heq, sum_map_zero]
    simp [ha]

#print axioms double_sum_swap
#print axioms sum_map_mul
#print axioms natCast_sum_map
#print axioms sum_range_unique_support

end Stage4
