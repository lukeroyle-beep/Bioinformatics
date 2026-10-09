import Model
import Classification
import Energy
import Gap

namespace Stage4

/-- Integer sum over an initial interval of the full position range. -/
theorem sum_range_prefix (n k : Nat) (q : Int) :
    ((List.range n).map fun i => if i < k then q else 0).sum =
      (min n k : Nat) * q := by
  induction n with
  | zero => simp
  | succ n ih =>
    rw [List.range_succ, List.map_append, int_sum_append]
    simp only [List.map_cons, List.map_nil, List.sum_cons, List.sum_nil, Int.add_zero]
    rw [ih]
    by_cases h : n < k
    · have hn : min n k = n := by omega
      have hn1 : min (n+1) k = n+1 := by omega
      simp [h, hn, hn1, Int.add_mul]
    · have hn : min n k = k := by omega
      have hn1 : min (n+1) k = k := by omega
      simp [h, hn, hn1]

/-- Exact sum of a constant on any bounded interval of positions. -/
theorem sum_range_interval (n lo hi : Nat) (q : Int) (hlh : lo ≤ hi) (hhn : hi ≤ n) :
    ((List.range n).map fun i => if lo ≤ i ∧ i < hi then q else 0).sum =
      ((hi-lo : Nat) : Int) * q := by
  have point (i : Nat) : (if lo ≤ i ∧ i < hi then q else 0) =
      (if i < hi then q else 0) + (if i < lo then -q else 0) := by
    by_cases hhi : i < hi <;> by_cases hlo : i < lo <;>
      simp [hhi, hlo, show (lo ≤ i) ↔ ¬ i < lo by omega]
    all_goals omega
  simp only [point, sum_map_add, sum_range_prefix]
  have mh : min n hi = hi := by omega
  have ml : min n lo = lo := by omega
  rw [mh, ml]
  have hc : ((hi-lo : Nat) : Int) = (hi : Int) - (lo : Int) := by omega
  rw [hc, Int.sub_mul]
  simp [Int.mul_neg, Int.sub_eq_add_neg]

/-- One helix's stack contribution, with the outer-left index in a half-open interval. -/
def helixTerm (lo hi pairSum : Nat) (q : Int) (i j : Nat) : Int :=
  if lo ≤ i ∧ i < hi ∧ i+j+1 = pairSum then q else 0

/-- Summation of a helix term uses its unique right partner for each left index. -/
theorem helixTerm_row (n lo hi pairSum i : Nat) (q : Int)
    (hpartner : lo ≤ i → i < hi → i < pairSum ∧ pairSum-i-1 < n) :
    ((List.range n).map fun j => helixTerm lo hi pairSum q i j).sum =
      if lo ≤ i ∧ i < hi then q else 0 := by
  by_cases hi' : lo ≤ i ∧ i < hi
  · obtain ⟨hs, hn⟩ := hpartner hi'.1 hi'.2
    have eq (j : Nat) : (i+j+1 = pairSum) ↔ j = pairSum-i-1 := by omega
    simp only [helixTerm, hi'.1, hi'.2, true_and, eq]
    rw [sum_range_indicator]
    simp [hn]
  · have point (j : Nat) : helixTerm lo hi pairSum q i j = 0 := by
      simp [helixTerm, show ¬ (lo ≤ i ∧ i < hi ∧ i+j+1 = pairSum) by omega]
    simp only [point, sum_map_zero, if_neg hi']

/-- Direct frozen-table evaluation of every stack in the three target helices. -/
theorem target_stack_weight (p : Params) (i j : Nat) (h : targetStackPair p i j) :
    stackEnergy (seq p i) (seq p (i+1)) (seq p j) (seq p (j-1)) =
      if i < p.a then -93 else -326 := by
  have ha := p.ha
  have hb := p.hb
  have hc := p.hc
  have hu := p.hu
  have hv := p.hv
  unfold targetStackPair helixPair at h
  rcases h with h | h | h
  · have si : seq p i = .A := (seq_A_iff p i).mpr (Or.inl (by omega))
    have si1 : seq p (i+1) = .A := (seq_A_iff p (i+1)).mpr (Or.inl (by omega))
    have sj : seq p j = .U := (seq_U_iff p j).mpr (by omega)
    have sj1 : seq p (j-1) = .U := (seq_U_iff p (j-1)).mpr (by omega)
    simp [si, si1, sj, sj1, stackEnergy, show i < p.a by omega]
  · have si : seq p i = .C := (seq_C_iff p i).mpr (Or.inl (by omega))
    have si1 : seq p (i+1) = .C := (seq_C_iff p (i+1)).mpr (Or.inl (by omega))
    have sj : seq p j = .G := (seq_G_iff p j).mpr (by omega)
    have sj1 : seq p (j-1) = .G := (seq_G_iff p (j-1)).mpr (by omega)
    simp [si, si1, sj, sj1, stackEnergy, show ¬ i < p.a by omega]
  · have si : seq p i = .G := (seq_G_iff p i).mpr (by omega)
    have si1 : seq p (i+1) = .G := (seq_G_iff p (i+1)).mpr (by omega)
    have sj : seq p j = .C := (seq_C_iff p j).mpr (Or.inr (by omega))
    have sj1 : seq p (j-1) = .C := (seq_C_iff p (j-1)).mpr (Or.inr (by omega))
    simp [si, si1, sj, sj1, stackEnergy, show ¬ i < p.a by omega]

/-- Pointwise decomposition of the actual target contribution into three helices. -/
theorem target_contribution (p : Params) (i j : Nat) :
    contribution p (target p) i j =
      helixTerm 0 (p.a-1) (length p) (-93) i j +
      helixTerm p.a (p.a+p.b-1) (2*p.a+2*p.b+p.u) (-326) i j +
      helixTerm (p.a+2*p.b+p.u) (p.a+2*p.b+p.u+p.c-1)
        (2*(p.a+2*p.b+p.u)+2*p.c+p.v) (-326) i j := by
  have ha := p.ha
  have hb := p.hb
  have hc := p.hc
  have hu := p.hu
  have hv := p.hv
  by_cases hs : stackAt (target p) i j = true
  · have h := (target_stack_iff p i j).mp hs
    have hw := target_stack_weight p i j h
    unfold targetStackPair helixPair at h
    simp only [contribution, hs, ↓reduceIte, hw]
    rcases h with h | h | h
    · have h1 : 0 ≤ i ∧ i < p.a-1 ∧ i+j+1 = length p := by unfold length; omega
      have h2 : ¬ (p.a ≤ i ∧ i < p.a+p.b-1 ∧ i+j+1 = 2*p.a+2*p.b+p.u) := by omega
      have h3 : ¬ (p.a+2*p.b+p.u ≤ i ∧ i < p.a+2*p.b+p.u+p.c-1 ∧
          i+j+1 = 2*(p.a+2*p.b+p.u)+2*p.c+p.v) := by omega
      simp only [helixTerm, if_pos h1, if_neg h2, if_neg h3,
        if_pos (show i < p.a by omega)]
      omega
    · have h1 : ¬ (0 ≤ i ∧ i < p.a-1 ∧ i+j+1 = length p) := by omega
      have h2 : p.a ≤ i ∧ i < p.a+p.b-1 ∧ i+j+1 = 2*p.a+2*p.b+p.u := by omega
      have h3 : ¬ (p.a+2*p.b+p.u ≤ i ∧ i < p.a+2*p.b+p.u+p.c-1 ∧
          i+j+1 = 2*(p.a+2*p.b+p.u)+2*p.c+p.v) := by omega
      simp only [helixTerm, if_neg h1, if_pos h2, if_neg h3,
        if_neg (show ¬ i < p.a by omega)]
      omega
    · have h1 : ¬ (0 ≤ i ∧ i < p.a-1 ∧ i+j+1 = length p) := by omega
      have h2 : ¬ (p.a ≤ i ∧ i < p.a+p.b-1 ∧ i+j+1 = 2*p.a+2*p.b+p.u) := by omega
      have h3 : p.a+2*p.b+p.u ≤ i ∧ i < p.a+2*p.b+p.u+p.c-1 ∧
          i+j+1 = 2*(p.a+2*p.b+p.u)+2*p.c+p.v := by omega
      simp only [helixTerm, if_neg h1, if_neg h2, if_pos h3,
        if_neg (show ¬ i < p.a by omega)]
      omega
  · have h : ¬ targetStackPair p i j := by
      intro h
      exact hs ((target_stack_iff p i j).mpr h)
    unfold targetStackPair helixPair at h
    have h1 : ¬ (0 ≤ i ∧ i < p.a-1 ∧ i+j+1 = length p) := by unfold length; omega
    have h2 : ¬ (p.a ≤ i ∧ i < p.a+p.b-1 ∧ i+j+1 = 2*p.a+2*p.b+p.u) := by omega
    have h3 : ¬ (p.a+2*p.b+p.u ≤ i ∧ i < p.a+2*p.b+p.u+p.c-1 ∧
        i+j+1 = 2*(p.a+2*p.b+p.u)+2*p.c+p.v) := by omega
    simp only [contribution, if_neg hs, helixTerm, if_neg h1, if_neg h2, if_neg h3]
    omega

/-- Exact double sum for one helix, with every right partner inside the strand. -/
theorem helixTerm_sum (n lo hi pairSum : Nat) (q : Int)
    (hlh : lo ≤ hi) (hhn : hi ≤ n)
    (hpartner : ∀ i, lo ≤ i → i < hi → i < pairSum ∧ pairSum-i-1 < n) :
    ((List.range n).map fun i =>
      ((List.range n).map fun j => helixTerm lo hi pairSum q i j).sum).sum =
      ((hi-lo : Nat) : Int) * q := by
  have row (i : Nat) := helixTerm_row n lo hi pairSum i q (hpartner i)
  simp only [row]
  exact sum_range_interval n lo hi q hlh hhn

/-- The unbounded target's actual energy under the frozen full stack table. -/
theorem target_energy (p : Params) :
    energy p (target p) = Gap.targetEnergy p.a p.b p.c := by
  have ha := p.ha
  have hb := p.hb
  have hc := p.hc
  have hu := p.hu
  have hv := p.hv
  have e1 := helixTerm_sum (length p) 0 (p.a-1) (length p) (-93)
    (by omega) (by unfold length; omega)
    (by intro i h0 h1; unfold length; omega)
  have e2 := helixTerm_sum (length p) p.a (p.a+p.b-1) (2*p.a+2*p.b+p.u) (-326)
    (by omega) (by unfold length; omega)
    (by intro i h0 h1; unfold length; omega)
  have e3 := helixTerm_sum (length p) (p.a+2*p.b+p.u) (p.a+2*p.b+p.u+p.c-1)
    (2*(p.a+2*p.b+p.u)+2*p.c+p.v) (-326)
    (by omega) (by unfold length; omega)
    (by intro i h0 h1; unfold length; omega)
  unfold energy
  simp only [target_contribution, sum_map_add]
  rw [e1, e2, e3]
  unfold Gap.targetEnergy
  omega

#print axioms helixTerm_sum
#print axioms target_energy

#print axioms target_stack_weight
#print axioms target_contribution

#print axioms sum_range_prefix
#print axioms sum_range_interval
#print axioms helixTerm_row

end Stage4
