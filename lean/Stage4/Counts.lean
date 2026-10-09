import Model
import Classification
import Energy
import Gap
import CountAlgebra
/-!
Concrete stack counts use occupied adjacent-position edges of the three
complementary blocks. Matching makes edge support equivalent to exactly one
stack. The final theorem reconnects these counts to the original full energy
sum; no counting or structural hypothesis is added to admissibility.
-/
namespace Stage4
set_option maxHeartbeats 2000000

def uStart (p : Params) : Nat := p.a+2*p.b+2*p.c+p.u+p.v
def cStart (p : Params) : Nat := p.a+2*p.b+p.c+p.u+p.v
def rightSupport (p : Params) (f : Fold) (j : Nat) : Bool :=
  (List.range (length p)).any fun i => stackAt f i j
def leftSupport (p : Params) (f : Fold) (i : Nat) : Bool :=
  (List.range (length p)).any fun j => stackAt f i j
def edgeCount (n lo hi : Nat) (s : Nat → Bool) : Nat :=
  ((List.range n).map fun k => if lo ≤ k ∧ k < hi ∧ s k = true then 1 else 0).sum
def countAU (p : Params) (f : Fold) : Nat :=
  edgeCount (length p) (uStart p+1) (length p) (rightSupport p f)
def countLeftGC (p : Params) (f : Fold) : Nat :=
  edgeCount (length p) p.a (p.a+p.b-1) (leftSupport p f)
def countRightGC (p : Params) (f : Fold) : Nat :=
  edgeCount (length p) (cStart p+1) (uStart p) (rightSupport p f)
def countGC (p : Params) (f : Fold) : Nat := countLeftGC p f + countRightGC p f
def mixedI (p : Params) : Nat := p.a+p.b+p.u-1
def countMixed (p : Params) (f : Fold) : Nat :=
  if stackAt f (mixedI p) (uStart p) then 1 else 0

theorem rightSupport_iff (p : Params) (f : Fold) (hf : admissible p f) (j : Nat) :
    rightSupport p f j = true ↔ ∃ i, stackAt f i j = true := by
  simp only [rightSupport, List.any_eq_true, List.mem_range]
  constructor
  · rintro ⟨i, _, h⟩; exact ⟨i,h⟩
  · rintro ⟨i,h⟩
    have hs : f i j = true ∧ f (i+1) (j-1) = true := by simpa [stackAt] using h
    exact ⟨i,(hf.1 i j hs.1).1,h⟩
theorem leftSupport_iff (p : Params) (f : Fold) (hf : admissible p f) (i : Nat) :
    leftSupport p f i = true ↔ ∃ j, stackAt f i j = true := by
  simp only [leftSupport, List.any_eq_true, List.mem_range]
  constructor
  · rintro ⟨j, _, h⟩; exact ⟨j,h⟩
  · rintro ⟨j,h⟩
    have hs : f i j = true ∧ f (i+1) (j-1) = true := by simpa [stackAt] using h
    exact ⟨j,(hf.1 i j hs.1).2.1,h⟩

theorem nat_sum_map_congr (xs : List Nat) (f g : Nat → Nat)
    (h : ∀ k, k ∈ xs → f k = g k) : (xs.map f).sum = (xs.map g).sum := by
  induction xs with
  | nil => rfl
  | cons x xs ih =>
    simp only [List.map_cons, List.sum_cons]
    rw [h x (by simp), ih (fun k hk => h k (by simp [hk]))]
theorem int_sum_map_congr (xs : List Nat) (f g : Nat → Int)
    (h : ∀ k, k ∈ xs → f k = g k) : (xs.map f).sum = (xs.map g).sum := by
  induction xs with
  | nil => rfl
  | cons x xs ih =>
    simp only [List.map_cons, List.sum_cons]
    rw [h x (by simp), ih (fun k hk => h k (by simp [hk]))]
theorem nat_sum_map_le (xs : List Nat) (f g : Nat → Nat)
    (h : ∀ k, k ∈ xs → f k ≤ g k) : (xs.map f).sum ≤ (xs.map g).sum := by
  induction xs with
  | nil => simp
  | cons x xs ih =>
    have h1 := h x (by simp)
    have h2 := ih (fun k hk => h k (by simp [hk]))
    simp only [List.map_cons, List.sum_cons]; omega
theorem nat_sum_map_eq_of_le (xs : List Nat) (f g : Nat → Nat)
    (h : ∀ k, k ∈ xs → f k ≤ g k)
    (he : (xs.map f).sum = (xs.map g).sum) : ∀ k, k ∈ xs → f k = g k := by
  induction xs with
  | nil => simp
  | cons x xs ih =>
    have h1 := h x (by simp)
    have hle := nat_sum_map_le xs f g (fun k hk => h k (by simp [hk]))
    have he1 : f x = g x := by simp only [List.map_cons, List.sum_cons] at he; omega
    have he2 : (xs.map f).sum = (xs.map g).sum := by
      simp only [List.map_cons, List.sum_cons] at he; omega
    intro k hk
    rcases List.mem_cons.mp hk with rfl | hk
    · exact he1
    · exact ih (fun k hk => h k (by simp [hk])) he2 k hk
theorem nat_sum_append (xs ys : List Nat) : (xs ++ ys).sum = xs.sum + ys.sum := by
  induction xs with
  | nil => simp
  | cons x xs ih => simp [ih, Nat.add_assoc]
theorem nat_sum_range_interval (n lo hi : Nat) (h : lo ≤ hi) :
    ((List.range n).map fun k => if lo ≤ k ∧ k < hi then (1:Nat) else 0).sum =
      min n hi - min n lo := by
  induction n with
  | zero => simp
  | succ n ih =>
    rw [List.range_succ, List.map_append, nat_sum_append]
    simp only [List.map_cons, List.map_nil, List.sum_cons, List.sum_nil, Nat.add_zero]
    rw [ih]
    by_cases hl : lo ≤ n <;> by_cases hh : n < hi <;> simp [hl,hh] <;> omega

theorem edgeCount_bound (n lo hi : Nat) (s : Nat → Bool) (hl : lo ≤ hi) (hh : hi ≤ n) :
    edgeCount n lo hi s ≤ hi-lo := by
  have h := nat_sum_map_le (List.range n)
    (fun k => if lo ≤ k ∧ k < hi ∧ s k = true then 1 else 0)
    (fun k => if lo ≤ k ∧ k < hi then 1 else 0) (by
      intro k hk; dsimp; split <;> split <;> simp_all)
  rw [nat_sum_range_interval n lo hi hl] at h
  unfold edgeCount
  simpa [Nat.min_eq_right hh, Nat.min_eq_right (Nat.le_trans hl hh)] using h

theorem edgeCount_saturated (n lo hi : Nat) (s : Nat → Bool)
    (hl : lo ≤ hi) (hh : hi ≤ n) (he : edgeCount n lo hi s = hi-lo)
    (k : Nat) (hk0 : lo ≤ k) (hk1 : k < hi) : s k = true := by
  have hsum : ((List.range n).map fun k => if lo ≤ k ∧ k < hi then (1:Nat) else 0).sum = hi-lo := by
    rw [nat_sum_range_interval n lo hi hl]
    simp [Nat.min_eq_right hh, Nat.min_eq_right (Nat.le_trans hl hh)]
  have he' : ((List.range n).map fun k => if lo ≤ k ∧ k < hi ∧ s k = true then 1 else 0).sum =
      ((List.range n).map fun k => if lo ≤ k ∧ k < hi then 1 else 0).sum := by
    rw [hsum]; exact he
  have hpoint := nat_sum_map_eq_of_le (List.range n)
    (fun k => if lo ≤ k ∧ k < hi ∧ s k = true then 1 else 0)
    (fun k => if lo ≤ k ∧ k < hi then 1 else 0)
    (by intro k hk; dsimp; split <;> split <;> simp_all) he' k (by simp; omega)
  simpa [hk0,hk1] using hpoint

theorem countAU_bound (p : Params) (f : Fold) : countAU p f ≤ p.a-1 := by
  have ha := p.ha
  have h := edgeCount_bound (length p) (uStart p+1) (length p) (rightSupport p f)
    (by unfold uStart length; omega) (by omega)
  unfold countAU
  have he : length p - (uStart p+1) = p.a-1 := by unfold length uStart; omega
  simpa [he] using h
theorem countLeftGC_bound (p : Params) (f : Fold) : countLeftGC p f ≤ p.b-1 := by
  have hb := p.hb
  have h := edgeCount_bound (length p) p.a (p.a+p.b-1) (leftSupport p f)
    (by omega) (by unfold length; omega)
  unfold countLeftGC
  have he : p.a+p.b-1-p.a = p.b-1 := by omega
  simpa [he] using h
theorem countRightGC_bound (p : Params) (f : Fold) : countRightGC p f ≤ p.c-1 := by
  have hc := p.hc
  have h := edgeCount_bound (length p) (cStart p+1) (uStart p) (rightSupport p f)
    (by unfold cStart uStart; omega) (by unfold uStart length; omega)
  unfold countRightGC
  have he : uStart p-(cStart p+1) = p.c-1 := by unfold uStart cStart; omega
  simpa [he] using h
theorem countGC_bound (p : Params) (f : Fold) : countGC p f ≤ p.b+p.c-2 := by
  have hb := p.hb; have hc := p.hc
  have hl := countLeftGC_bound p f; have hr := countRightGC_bound p f
  unfold countGC; omega
theorem countMixed_binary (p : Params) (f : Fold) : countMixed p f = 0 ∨ countMixed p f = 1 := by
  unfold countMixed; split <;> simp

def rightTerm (p : Params) (f : Fold) (lo hi : Nat) (q : Int) (i j : Nat) : Int :=
  if lo ≤ j ∧ j < hi then (if stackAt f i j then q else 0) else 0

def leftTerm (p : Params) (f : Fold) (lo hi : Nat) (q : Int) (i j : Nat) : Int :=
  if lo ≤ i ∧ i < hi then (if stackAt f i j then q else 0) else 0

def mixedTerm (p : Params) (f : Fold) (i j : Nat) : Int :=
  if i = mixedI p ∧ j = uStart p then (if stackAt f i j then -208 else 0) else 0

theorem contribution_four_terms (p : Params) (f : Fold) (hf : admissible p f) (i j : Nat) :
    contribution p f i j =
      rightTerm p f (uStart p+1) (length p) (-93) i j +
      leftTerm p f p.a (p.a+p.b-1) (-326) i j +
      rightTerm p f (cStart p+1) (uStart p) (-326) i j +
      mixedTerm p f i j := by
  have ha := p.ha; have hb := p.hb; have hc := p.hc
  have hu := p.hu; have hv := p.hv
  cases hs : stackAt f i j
  · simp [contribution, rightTerm, leftTerm, mixedTerm, hs]
  · have hp : f i j = true ∧ f (i+1) (j-1) = true := by simpa [stackAt] using hs
    have ho := hf.1 i j hp.1
    have hn := hf.1 (i+1) (j-1) hp.2
    unfold allowed at ho hn
    have cls := stack_classification p f hf i j hs
    rcases cls with ⟨hi,hi1,hj,hj1⟩ | ⟨hi,hi1,hj,hj1⟩ | ⟨hi,hi1,hj,hj1⟩ | ⟨hi,hi1,hj,hj1⟩
    · have ia := (seq_A_iff p i).mp hi
      have iu := (seq_U_iff p j).mp hj
      have iu1 := (seq_U_iff p (j-1)).mp hj1
      have hU : uStart p+1 ≤ j ∧ j < length p := by unfold uStart; omega
      have hL : ¬ (p.a ≤ i ∧ i < p.a+p.b-1) := by omega
      have hR : ¬ (cStart p+1 ≤ j ∧ j < uStart p) := by unfold cStart uStart; omega
      have hM : ¬ (i = mixedI p ∧ j = uStart p) := by unfold mixedI uStart; omega
      simp only [contribution, hs, if_true, hi, hi1, hj, hj1, stackEnergy]
      unfold rightTerm leftTerm mixedTerm
      rw [if_pos hU, if_neg hL, if_neg hR, if_neg hM]
      simp [hs]
    · have ic := (seq_C_iff p i).mp hi
      have ic1 := (seq_C_iff p (i+1)).mp hi1
      have jg := (seq_G_iff p j).mp hj
      have hU : ¬ (uStart p+1 ≤ j ∧ j < length p) := by unfold uStart; omega
      have hL : p.a ≤ i ∧ i < p.a+p.b-1 := by omega
      have hR : ¬ (cStart p+1 ≤ j ∧ j < uStart p) := by unfold cStart uStart; omega
      have hM : ¬ (i = mixedI p ∧ j = uStart p) := by unfold mixedI uStart; omega
      simp only [contribution, hs, if_true, hi, hi1, hj, hj1, stackEnergy]
      unfold rightTerm leftTerm mixedTerm
      rw [if_neg hU, if_pos hL, if_neg hR, if_neg hM]
      simp [hs]
    · have ig := (seq_G_iff p i).mp hi
      have jc := (seq_C_iff p j).mp hj
      have jc1 := (seq_C_iff p (j-1)).mp hj1
      have hU : ¬ (uStart p+1 ≤ j ∧ j < length p) := by unfold uStart; omega
      have hL : ¬ (p.a ≤ i ∧ i < p.a+p.b-1) := by omega
      have hR : cStart p+1 ≤ j ∧ j < uStart p := by unfold cStart uStart; omega
      have hM : ¬ (i = mixedI p ∧ j = uStart p) := by unfold mixedI uStart; omega
      simp only [contribution, hs, if_true, hi, hi1, hj, hj1, stackEnergy]
      unfold rightTerm leftTerm mixedTerm
      rw [if_neg hU, if_neg hL, if_pos hR, if_neg hM]
      simp [hs]
    · have hm := mixed_stack_position p f hf i j hs hi hi1
      have hU : ¬ (uStart p+1 ≤ j ∧ j < length p) := by unfold uStart; omega
      have hL : ¬ (p.a ≤ i ∧ i < p.a+p.b-1) := by omega
      have hR : ¬ (cStart p+1 ≤ j ∧ j < uStart p) := by unfold cStart uStart; omega
      have hM : i = mixedI p ∧ j = uStart p := by unfold mixedI uStart; omega
      simp only [contribution, hs, if_true, hi, hi1, hj, hj1, stackEnergy]
      unfold rightTerm leftTerm mixedTerm
      rw [if_neg hU, if_neg hL, if_neg hR, if_pos hM]
      simp [hs]


theorem edgeCount_weight (n lo hi : Nat) (s : Nat → Bool) (q : Int) :
    ((List.range n).map fun k =>
      if lo ≤ k ∧ k < hi then (if s k then q else 0) else 0).sum =
      q * (edgeCount n lo hi s : Int) := by
  unfold edgeCount
  rw [natCast_sum_map, ← sum_map_mul]
  apply int_sum_map_congr
  intro k hk
  by_cases hl : lo ≤ k <;> by_cases hh : k < hi <;> by_cases hs : s k = true <;> simp [hl,hh,hs]

theorem rightTerm_sum (p : Params) (f : Fold) (hf : admissible p f) (lo hi : Nat) (q : Int) :
    ((List.range (length p)).map fun i =>
      ((List.range (length p)).map fun j => rightTerm p f lo hi q i j).sum).sum =
      q * (edgeCount (length p) lo hi (rightSupport p f) : Int) := by
  rw [double_sum_swap]
  calc
    _ = ((List.range (length p)).map fun j =>
        if lo ≤ j ∧ j < hi then (if rightSupport p f j then q else 0) else 0).sum := by
      apply int_sum_map_congr
      intro j hj
      by_cases h : lo ≤ j ∧ j < hi
      · simp only [rightTerm, h, if_true]
        exact sum_range_unique_support (length p) (fun i => stackAt f i j) q
          (fun i k _ _ hs ht => stack_right_injective p f hf i j k hs ht)
      · simp [rightTerm,h,sum_map_zero]
    _ = _ := edgeCount_weight _ _ _ _ _

theorem leftTerm_sum (p : Params) (f : Fold) (hf : admissible p f) (lo hi : Nat) (q : Int) :
    ((List.range (length p)).map fun i =>
      ((List.range (length p)).map fun j => leftTerm p f lo hi q i j).sum).sum =
      q * (edgeCount (length p) lo hi (leftSupport p f) : Int) := by
  calc
    _ = ((List.range (length p)).map fun i =>
        if lo ≤ i ∧ i < hi then (if leftSupport p f i then q else 0) else 0).sum := by
      apply int_sum_map_congr
      intro i hi'
      by_cases h : lo ≤ i ∧ i < hi
      · simp only [leftTerm, h, if_true]
        exact sum_range_unique_support (length p) (fun j => stackAt f i j) q
          (fun j l _ _ hs ht => stack_left_injective p f hf i j l hs ht)
      · simp [leftTerm,h,sum_map_zero]
    _ = _ := edgeCount_weight _ _ _ _ _

theorem mixedTerm_sum (p : Params) (f : Fold) :
    ((List.range (length p)).map fun i =>
      ((List.range (length p)).map fun j => mixedTerm p f i j).sum).sum =
      -208 * (countMixed p f : Int) := by
  have ha := p.ha; have hb := p.hb; have hu := p.hu
  have hi : mixedI p < length p := by unfold mixedI length; omega
  have hj : uStart p < length p := by unfold uStart length; omega
  let q : Int := if stackAt f (mixedI p) (uStart p) then -208 else 0
  have point (i j : Nat) : mixedTerm p f i j =
      if i = mixedI p then (if j = uStart p then q else 0) else 0 := by
    by_cases hi' : i = mixedI p <;> by_cases hj' : j = uStart p <;>
      simp [mixedTerm, hi', hj', q]
  have row (i : Nat) :
      ((List.range (length p)).map fun j => mixedTerm p f i j).sum =
        if i = mixedI p then q else 0 := by
    simp only [point]
    by_cases hi' : i = mixedI p
    · simp only [hi',if_true]
      rw [sum_range_indicator]
      simp [hj]
    · simp [hi',sum_map_zero]
  simp only [row]
  rw [sum_range_indicator]
  simp only [hi,if_true]
  unfold q countMixed
  cases stackAt f (mixedI p) (uStart p) <;> simp

/-- Full stacking energy equals the three concrete finite edge counts. -/
theorem energy_eq_counts (p : Params) (f : Fold) (hf : admissible p f) :
    energy p f = Gap.energy (countAU p f) (countGC p f) (countMixed p f) := by
  unfold energy
  simp only [contribution_four_terms p f hf, sum_map_add]
  rw [rightTerm_sum p f hf, leftTerm_sum p f hf, rightTerm_sum p f hf, mixedTerm_sum]
  unfold countAU countGC countLeftGC countRightGC Gap.energy
  simp only [Int.natCast_add, Int.mul_add]
  omega

#print axioms rightSupport_iff
#print axioms leftSupport_iff
#print axioms nat_sum_map_congr
#print axioms int_sum_map_congr
#print axioms nat_sum_map_le
#print axioms nat_sum_map_eq_of_le
#print axioms nat_sum_append
#print axioms nat_sum_range_interval
#print axioms edgeCount_bound
#print axioms edgeCount_saturated
#print axioms countAU_bound
#print axioms countLeftGC_bound
#print axioms countRightGC_bound
#print axioms countGC_bound
#print axioms countMixed_binary
#print axioms contribution_four_terms
#print axioms edgeCount_weight
#print axioms rightTerm_sum
#print axioms leftTerm_sum
#print axioms mixedTerm_sum
#print axioms energy_eq_counts

end Stage4
