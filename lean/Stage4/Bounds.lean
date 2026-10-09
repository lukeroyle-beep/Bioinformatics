import Counts

namespace Stage4

/-- A saturated U-edge count supplies a stack at every U edge. -/
theorem saturated_au (p : Params) (f : Fold) (hf : admissible p f)
    (h : countAU p f = p.a-1) :
    ∀ j, p.a+2*p.b+2*p.c+p.u+p.v < j → j < length p →
      ∃ i, stackAt f i j = true := by
  have ha := p.ha
  have he : edgeCount (length p) (uStart p+1) (length p) (rightSupport p f) =
      length p-(uStart p+1) := by
    change countAU p f = _
    rw [h]
    unfold length uStart
    omega
  intro j hj0 hj1
  apply (rightSupport_iff p f hf j).mp
  apply edgeCount_saturated (length p) (uStart p+1) (length p) (rightSupport p f)
    (by unfold length uStart; omega) (by omega) he j
  · unfold uStart
    omega
  · exact hj1

/-- Saturation of the total GC count forces saturation of each C block. -/
theorem countGC_saturated_components (p : Params) (f : Fold)
    (h : countGC p f = p.b+p.c-2) :
    countLeftGC p f = p.b-1 ∧ countRightGC p f = p.c-1 := by
  have hb := p.hb
  have hc := p.hc
  have hl := countLeftGC_bound p f
  have hr := countRightGC_bound p f
  unfold countGC at h
  omega

/-- Saturated GC counts supply a stack at every adjacent edge of the left C block. -/
theorem saturated_gc_left (p : Params) (f : Fold) (hf : admissible p f)
    (h : countGC p f = p.b+p.c-2) :
    ∀ i, p.a ≤ i → i+1 < p.a+p.b → ∃ j, stackAt f i j = true := by
  have hb := p.hb
  have he : edgeCount (length p) p.a (p.a+p.b-1) (leftSupport p f) =
      p.a+p.b-1-p.a := by
    change countLeftGC p f = _
    rw [(countGC_saturated_components p f h).1]
    omega
  intro i hi0 hi1
  apply (leftSupport_iff p f hf i).mp
  apply edgeCount_saturated (length p) p.a (p.a+p.b-1) (leftSupport p f)
    (by omega) (by unfold length; omega) he i hi0
  omega

/-- Saturated GC counts supply a stack at every adjacent edge of the right C block. -/
theorem saturated_gc_right (p : Params) (f : Fold) (hf : admissible p f)
    (h : countGC p f = p.b+p.c-2) :
    ∀ j, p.a+2*p.b+p.c+p.u+p.v < j →
      j < p.a+2*p.b+2*p.c+p.u+p.v → ∃ i, stackAt f i j = true := by
  have hc := p.hc
  have he : edgeCount (length p) (cStart p+1) (uStart p) (rightSupport p f) =
      uStart p-(cStart p+1) := by
    change countRightGC p f = _
    rw [(countGC_saturated_components p f h).2]
    unfold cStart uStart
    omega
  intro j hj0 hj1
  apply (rightSupport_iff p f hf j).mp
  apply edgeCount_saturated (length p) (cStart p+1) (uStart p) (rightSupport p f)
    (by unfold cStart uStart; omega) (by unfold length uStart; omega) he j
  · unfold cStart
    omega
  · exact hj1

/-- A mixed stack removes all counted stacks from the left C block. -/
theorem mixed_countLeftGC_zero (p : Params) (f : Fold) (hf : admissible p f)
    (hm : countMixed p f = 1) : countLeftGC p f = 0 := by
  have hb := p.hb
  have hu := p.hu
  have hs : stackAt f (mixedI p) (uStart p) = true := by
    unfold countMixed at hm
    cases h : stackAt f (mixedI p) (uStart p) <;> simp_all
  have hi : seq p (mixedI p) = .A := by
    apply (seq_A_iff p (mixedI p)).mpr
    apply Or.inr
    apply Or.inl
    unfold mixedI
    omega
  have hi1 : seq p (mixedI p+1) = .G := by
    apply (seq_G_iff p (mixedI p+1)).mpr
    have hc := p.hc
    unfold mixedI
    omega
  have point (k : Nat) :
      (if p.a ≤ k ∧ k < p.a+p.b-1 ∧ leftSupport p f k = true then (1 : Nat) else 0) = 0 := by
    split
    · rename_i h
      obtain ⟨j, hj⟩ := (leftSupport_iff p f hf k).mp h.2.2
      have hz := mixed_excludes_left_C p f hf (mixedI p) (uStart p) hs hi hi1
        k j h.1 (by omega)
      have hpair : f k j = true ∧ f (k+1) (j-1) = true := by
        simpa only [stackAt, Bool.and_eq_true] using hj
      simp_all
    · rfl
  unfold countLeftGC edgeCount
  simp only [point]
  induction List.range (length p) with
  | nil => rfl
  | cons k ks ih => simp [ih]

/-- With a mixed stack, only the right C block can contribute GC stacks. -/
theorem mixed_count_bound (p : Params) (f : Fold) (hf : admissible p f)
    (hm : countMixed p f = 1) : countGC p f ≤ p.c-1 := by
  have hl := mixed_countLeftGC_zero p f hf hm
  have hr := countRightGC_bound p f
  unfold countGC
  omega

#print axioms saturated_au
#print axioms countGC_saturated_components
#print axioms saturated_gc_left
#print axioms saturated_gc_right
#print axioms mixed_countLeftGC_zero
#print axioms mixed_count_bound

end Stage4
