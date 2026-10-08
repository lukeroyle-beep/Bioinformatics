import Model

namespace Stage4

/-- Finite sum linearity for integer-valued functions, proved directly. -/
theorem sum_map_add (xs : List Nat) (f g : Nat → Int) :
    (xs.map (fun i => f i + g i)).sum = (xs.map f).sum + (xs.map g).sum := by
  induction xs with
  | nil => simp
  | cons x xs ih => simp [ih, Int.add_assoc, Int.add_comm, Int.add_left_comm]

theorem int_sum_append (xs ys : List Int) : (xs ++ ys).sum = xs.sum + ys.sum := by
  induction xs with
  | nil => simp
  | cons x xs ih => simp [ih, Int.add_assoc]

/-- A selected index contributes exactly once in the full position range. -/
theorem sum_range_indicator (n k : Nat) (q : Int) :
    ((List.range n).map fun i => if i = k then q else 0).sum =
      if k < n then q else 0 := by
  induction n with
  | zero => simp
  | succ n ih =>
    rw [List.range_succ, List.map_append, int_sum_append]
    simp only [List.map_cons, List.map_nil, List.sum_cons, List.sum_nil, Int.add_zero]
    rw [ih]
    by_cases hk : k < n
    · simp [hk, show k < n+1 by omega, show ¬ n = k by omega]
    · by_cases he : n = k
      · subst k
        simp
      · simp [hk, he, show ¬ k < n+1 by omega]

theorem seq_final_U (p : Params) (j : Nat)
    (h : p.a+2*p.b+2*p.c+p.u+p.v ≤ j) : seq p j = .U := by
  simp [seq, show ¬ j < p.a by omega, show ¬ j < p.a+p.b by omega,
    show ¬ j < p.a+p.b+p.u by omega,
    show ¬ j < p.a+2*p.b+p.c+p.u by omega,
    show ¬ j < p.a+2*p.b+p.c+p.u+p.v by omega, show ¬ j < p.a+2*p.b+2*p.c+p.u+p.v by omega]

theorem target_outermost_contribution (p : Params) :
    contribution p (target p) 0 (length p - 1) = -93 := by
  have ha := p.ha
  have hstack : stackAt (target p) 0 (length p - 1) = true := by
    apply (target_stack_iff p 0 (length p - 1)).mpr
    apply Or.inl
    unfold helixPair length
    omega
  have hs0 : seq p 0 = .A := by simp [seq, show 0 < p.a by omega]
  have hs1 : seq p 1 = .A := by simp [seq, show 1 < p.a by omega]
  have hs2 : seq p (length p - 1) = .U := by
    apply seq_final_U
    unfold length
    omega
  have hs3 : seq p (length p - 1 - 1) = .U := by
    apply seq_final_U
    unfold length
    omega
  simp [contribution, hstack, hs0, hs1, hs2, hs3, stackEnergy]

theorem stack_without_zero (f : Fold) (s i j : Nat) :
    stackAt (withoutPair 0 s f) i j =
      (stackAt f i j && !(decide (i = 0 ∧ j = s))) := by
  simp [stackAt, withoutPair, Bool.and_assoc, Bool.and_comm, Bool.and_left_comm]

theorem deleteOutermost_contribution (p : Params) (i j : Nat) :
    contribution p (deleteOutermost p) i j = contribution p (target p) i j +
      (if i = 0 ∧ j = length p - 1 then 93 else 0) := by
  by_cases h : i = 0 ∧ j = length p - 1
  · rcases h with ⟨rfl, rfl⟩
    rw [target_outermost_contribution]
    simp [contribution, deleteOutermost, stack_without_zero]
  · simp [contribution, deleteOutermost, stack_without_zero, h]

/-- Deleting the outermost AU pair loses exactly its one -93 stack term.
This uses the model's actual sum over every ordered position pair. -/
theorem deleteOutermost_energy (p : Params) :
    energy p (deleteOutermost p) = energy p (target p) + 93 := by
  have ha := p.ha
  have hn : 0 < length p := by unfold length; omega
  have hlast : length p - 1 < length p := by omega
  have row (i : Nat) :
      ((List.range (length p)).map fun j =>
        if i = 0 ∧ j = length p - 1 then (93 : Int) else 0).sum =
        if i = 0 then 93 else 0 := by
    by_cases hi : i = 0
    · subst i
      simpa [hlast] using sum_range_indicator (length p) (length p - 1) 93
    · simp [hi, sum_map_zero]
  unfold energy
  simp only [deleteOutermost_contribution, sum_map_add, row]
  rw [sum_range_indicator]
  simp [hn]

#print axioms deleteOutermost_energy

#print axioms seq_final_U
#print axioms target_outermost_contribution
#print axioms stack_without_zero
#print axioms deleteOutermost_contribution

#print axioms int_sum_append
#print axioms sum_map_add
#print axioms sum_range_indicator

end Stage4
