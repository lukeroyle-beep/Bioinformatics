import Model

namespace Stage4

set_option maxHeartbeats 2000000

theorem seq_A_iff (p : Params) (i : Nat) :
    seq p i = .A ↔ i < p.a ∨
      (p.a + p.b ≤ i ∧ i < p.a + p.b + p.u) ∨
      (p.a + 2*p.b + p.c + p.u ≤ i ∧ i < p.a + 2*p.b + p.c + p.u + p.v) := by
  have hb := p.hb
  have hc := p.hc
  have hu := p.hu
  have hv := p.hv
  unfold seq
  repeat (any_goals split)
  all_goals (simp_all <;> omega)

theorem seq_C_iff (p : Params) (i : Nat) :
    seq p i = .C ↔ (p.a ≤ i ∧ i < p.a + p.b) ∨
      (p.a + 2*p.b + p.c + p.u + p.v ≤ i ∧
       i < p.a + 2*p.b + 2*p.c + p.u + p.v) := by
  have hb := p.hb
  have hc := p.hc
  have hu := p.hu
  have hv := p.hv
  unfold seq
  repeat (any_goals split)
  all_goals (simp_all <;> omega)

theorem seq_G_iff (p : Params) (i : Nat) :
    seq p i = .G ↔ p.a + p.b + p.u ≤ i ∧ i < p.a + 2*p.b + p.c + p.u := by
  have hb := p.hb
  have hc := p.hc
  have hu := p.hu
  have hv := p.hv
  unfold seq
  repeat (any_goals split)
  all_goals (simp_all <;> omega)

theorem seq_U_iff (p : Params) (i : Nat) :
    seq p i = .U ↔ p.a + 2*p.b + 2*p.c + p.u + p.v ≤ i := by
  have hb := p.hb
  have hc := p.hc
  have hu := p.hu
  have hv := p.hv
  unfold seq
  repeat (any_goals split)
  all_goals (simp_all <;> omega)

def physicalDinucleotides : List (Base × Base) :=
  [(.A,.A), (.A,.C), (.C,.C), (.C,.A), (.A,.G),
   (.G,.G), (.G,.A), (.C,.U), (.U,.U)]

theorem dinucleotide_complete (p : Params) (i : Nat) :
    (seq p i, seq p (i+1)) ∈ physicalDinucleotides := by
  have ha := p.ha
  have hb := p.hb
  have hc := p.hc
  have hu := p.hu
  have hv := p.hv
  unfold seq
  repeat (any_goals split)
  all_goals (simp_all [physicalDinucleotides] <;> omega)

theorem allowed_pair_class (p : Params) (i j : Nat) (h : allowed p i j) :
    (seq p i = .A ∧ seq p j = .U) ∨
    (seq p i = .C ∧ seq p j = .G) ∨
    (seq p i = .G ∧ seq p j = .C) := by
  have hw := h.2.2.2.2
  cases hi : seq p i <;> cases hj : seq p j <;> simp_all [wc]
  have hi' := (seq_U_iff p i).mp hi
  have hj' := (seq_A_iff p j).mp hj
  have ho := h.2.2.1
  have hb := p.hb
  have hc := p.hc
  have hu := p.hu
  have hv := p.hv
  omega

def StackClass (p : Params) (i j : Nat) : Prop :=
  (seq p i = .A ∧ seq p (i+1) = .A ∧ seq p j = .U ∧ seq p (j-1) = .U) ∨
  (seq p i = .C ∧ seq p (i+1) = .C ∧ seq p j = .G ∧ seq p (j-1) = .G) ∨
  (seq p i = .G ∧ seq p (i+1) = .G ∧ seq p j = .C ∧ seq p (j-1) = .C) ∨
  (seq p i = .A ∧ seq p (i+1) = .G ∧ seq p j = .U ∧ seq p (j-1) = .C)

theorem stack_classification (p : Params) (f : Fold) (hf : admissible p f)
    (i j : Nat) (hs : stackAt f i j = true) : StackClass p i j := by
  have hp : f i j = true ∧ f (i+1) (j-1) = true := by simpa [stackAt] using hs
  have ho := hf.1 i j hp.1
  have hn := hf.1 (i+1) (j-1) hp.2
  have hleft := dinucleotide_complete p i
  have hright := dinucleotide_complete p (j-1)
  have hj : j-1+1 = j := by have := ho.2.2.2.1; omega
  rw [hj] at hright
  have houter := allowed_pair_class p i j ho
  have hinner := allowed_pair_class p (i+1) (j-1) hn
  rcases houter with h | h | h <;> rcases hinner with g | g | g <;>
    simp_all [physicalDinucleotides, StackClass]

/-- The only mixed stack is fixed at the two stated block boundaries. -/
theorem mixed_stack_position (p : Params) (f : Fold) (hf : admissible p f)
    (i j : Nat) (hs : stackAt f i j = true)
    (hi : seq p i = .A) (hi1 : seq p (i+1) = .G) :
    i+1 = p.a+p.b+p.u ∧ j = p.a+2*p.b+2*p.c+p.u+p.v := by
  have hc := stack_classification p f hf i j hs
  simp [StackClass, hi, hi1] at hc
  have ia := (seq_A_iff p i).mp hi
  have ig := (seq_G_iff p (i+1)).mp hi1
  have ju := (seq_U_iff p j).mp hc.1
  have jc := (seq_C_iff p (j-1)).mp hc.2
  have hb := p.hb
  have hcc := p.hc
  have hu := p.hu
  have hv := p.hv
  omega

/-- Any mixed stack prevents every pair from a left C to a later position. -/
theorem mixed_excludes_left_C (p : Params) (f : Fold) (hf : admissible p f)
    (i j : Nat) (hs : stackAt f i j = true)
    (hi : seq p i = .A) (hi1 : seq p (i+1) = .G)
    (r s : Nat) (hr0 : p.a ≤ r) (hr1 : r < p.a+p.b) : f r s = false := by
  have pos := mixed_stack_position p f hf i j hs hi hi1
  have hpair : f i j = true ∧ f (i+1) (j-1) = true := by simpa [stackAt] using hs
  have hp := hpair.1
  have hb := p.hb
  have hc := p.hc
  have hu := p.hu
  have hv := p.hv
  have rc : seq p r = .C := (seq_C_iff p r).mpr (Or.inl ⟨hr0, hr1⟩)
  cases hrs : f r s
  · rfl
  · have allowed := hf.1 r s hrs
    have cls := allowed_pair_class p r s allowed
    have sg : seq p s = .G := by simpa [rc] using cls
    have sb := (seq_G_iff p s).mp sg
    have cross := hf.2.2 r s i j hrs hp
    exfalso
    apply cross
    omega

/-- A left C cannot be a right endpoint, even without a mixed stack. -/
theorem no_pair_to_left_C (p : Params) (f : Fold) (hf : admissible p f)
    (r s : Nat) (hr0 : p.a ≤ r) (hr1 : r < p.a+p.b) : f s r = false := by
  have rc : seq p r = .C := (seq_C_iff p r).mpr (Or.inl ⟨hr0, hr1⟩)
  cases hsr : f s r
  · rfl
  · have allowed := hf.1 s r hsr
    have cls := allowed_pair_class p s r allowed
    have sg : seq p s = .G := by simpa [rc] using cls
    have sb := (seq_G_iff p s).mp sg
    have ho := allowed.2.2.1
    omega

/-- In particular, the mixed-stack occurrence is unique. -/
theorem mixed_stack_unique (p : Params) (f : Fold) (hf : admissible p f)
    (i j k l : Nat) (hs : stackAt f i j = true) (ht : stackAt f k l = true)
    (hi : seq p i = .A) (hi1 : seq p (i+1) = .G)
    (hk : seq p k = .A) (hk1 : seq p (k+1) = .G) : i = k ∧ j = l := by
  have h := mixed_stack_position p f hf i j hs hi hi1
  have g := mixed_stack_position p f hf k l ht hk hk1
  omega

#print axioms mixed_stack_position
#print axioms mixed_excludes_left_C
#print axioms no_pair_to_left_C
#print axioms mixed_stack_unique
#print axioms seq_A_iff
#print axioms seq_C_iff
#print axioms seq_G_iff
#print axioms seq_U_iff
#print axioms dinucleotide_complete
#print axioms allowed_pair_class
#print axioms stack_classification

end Stage4
