import Counts
import Bounds
import Reconstruction
import TargetEnergy

namespace Stage4

/-- Equality of the actual finite counts determines the entire arbitrary fold. -/
theorem reconstruction_of_counts (p : Params) (f : Fold) (hf : admissible p f)
    (hAU : countAU p f = p.a-1) (hGC : countGC p f = p.b+p.c-2) : f = target p := by
  exact reconstruction_from_saturated_edges p f hf
    (saturated_gc_left p f hf hGC) (saturated_gc_right p f hf hGC)
    (saturated_au p f hf hAU)

/-- Unconditional all-length lower bound against every admissible distinct fold. -/
theorem gap_lower_bound (p : Params) (f : Fold) (hf : admissible p f)
    (hne : f ≠ target p) : energy p (target p) + 93 ≤ energy p f := by
  rw [target_energy, energy_eq_counts p f hf]
  apply Gap.distinct_gap p.a p.b p.c (countAU p f) (countGC p f) (countMixed p f)
    p.hb p.hc (countAU_bound p f) (countGC_bound p f) (countMixed_binary p f)
    (mixed_count_bound p f hf)
  intro h
  exact hne (reconstruction_of_counts p f hf h.1 h.2)

/-- The target is the unique minimum for the actual frozen-model energy. -/
theorem unique_minimum (p : Params) : admissible p (target p) ∧
    ∀ f, admissible p f → f ≠ target p → energy p (target p) < energy p f := by
  refine ⟨target_admissible p, ?_⟩
  intro f hf hne
  have h := gap_lower_bound p f hf hne
  omega

/-- The all-length gap lower bound is attained by a distinct admissible fold. -/
theorem exact_gap (p : Params) :
    (∀ f, admissible p f → f ≠ target p → energy p (target p) + 93 ≤ energy p f) ∧
    ∃ f, admissible p f ∧ f ≠ target p ∧ energy p f = energy p (target p) + 93 := by
  exact ⟨gap_lower_bound p, deleteOutermost p, deleteOutermost_admissible p,
    deleteOutermost_distinct p, deleteOutermost_energy p⟩

#print axioms reconstruction_of_counts
#print axioms gap_lower_bound
#print axioms unique_minimum
#print axioms exact_gap

end Stage4
