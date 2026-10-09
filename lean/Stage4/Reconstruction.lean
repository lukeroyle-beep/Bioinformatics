import Classification

namespace Stage4

set_option maxHeartbeats 2000000

/-- Saturation of left edges forces one contiguous reverse-paired helix. -/
theorem left_helix_from_edges (p : Params) (f : Fold) (hf : admissible p f)
    (s t : Nat) (ht : 2 ≤ t)
    (edges : ∀ i, s ≤ i → i+1 < s+t → ∃ j, stackAt f i j = true) :
    ∃ K, ∀ i, s ≤ i → i < s+t → ∃ j, f i j = true ∧ i+j = K := by
  obtain ⟨j0, hj0⟩ := edges s (by omega) (by omega)
  have hp0 : f s j0 = true ∧ f (s+1) (j0-1) = true := by simpa [stackAt] using hj0
  have chain : ∀ k, k < t → ∃ j, f (s+k) j = true ∧ j+k = j0 := by
    intro k
    induction k with
    | zero => intro _; exact ⟨j0, by simpa using hp0.1, by omega⟩
    | succ k ih =>
      intro hk
      obtain ⟨j, hp, he⟩ := ih (by omega)
      obtain ⟨q, hq⟩ := edges (s+k) (by omega) (by omega)
      have hpq : f (s+k) q = true ∧ f (s+k+1) (q-1) = true := by simpa [stackAt] using hq
      have hqj := pair_left_injective p f hf (s+k) q j hpq.1 hp
      have hallow := hf.1 (s+k) q hpq.1
      have hpos := hallow.2.2.2.1
      refine ⟨q-1, ?_, ?_⟩
      · simpa [Nat.add_assoc] using hpq.2
      · omega
  refine ⟨s+j0, ?_⟩
  intro i hi hi1
  obtain ⟨j, hp, he⟩ := chain (i-s) (by omega)
  have hsi : s+(i-s)=i := by omega
  rw [hsi] at hp
  exact ⟨j, hp, by omega⟩

/-- Saturation of right edges gives the same constant-sum description. -/
theorem right_helix_from_edges (p : Params) (f : Fold) (hf : admissible p f)
    (s t : Nat) (ht : 2 ≤ t)
    (edges : ∀ j, s < j → j < s+t → ∃ i, stackAt f i j = true) :
    ∃ K, ∀ j, s ≤ j → j < s+t → ∃ i, f i j = true ∧ i+j = K := by
  obtain ⟨i0, hi0⟩ := edges (s+t-1) (by omega) (by omega)
  have hp0 : f i0 (s+t-1) = true ∧ f (i0+1) (s+t-1-1) = true := by simpa [stackAt] using hi0
  have chain : ∀ k, k < t → ∃ i, f i (s+t-1-k) = true ∧ i = i0+k := by
    intro k
    induction k with
    | zero => intro _; exact ⟨i0, by simpa using hp0.1, by omega⟩
    | succ k ih =>
      intro hk
      obtain ⟨i, hp, he⟩ := ih (by omega)
      obtain ⟨q, hq⟩ := edges (s+t-1-k) (by omega) (by omega)
      have hpq : f q (s+t-1-k) = true ∧ f (q+1) (s+t-1-k-1) = true := by simpa [stackAt] using hq
      have hqi := pair_right_injective p f hf q (s+t-1-k) i hpq.1 hp
      refine ⟨q+1, ?_, by omega⟩
      have hidx : s+t-1-k-1 = s+t-1-(k+1) := by omega
      simpa [hidx] using hpq.2
  refine ⟨i0+(s+t-1), ?_⟩
  intro j hj hj1
  obtain ⟨i, hp, he⟩ := chain (s+t-1-j) (by omega)
  have hidx : s+t-1-(s+t-1-j) = j := by omega
  rw [hidx] at hp
  exact ⟨i, hp, by omega⟩

def LeftCSaturated (p : Params) (f : Fold) : Prop :=
  ∀ i, p.a ≤ i → i+1 < p.a+p.b → ∃ j, stackAt f i j = true

def RightCSaturated (p : Params) (f : Fold) : Prop :=
  ∀ j, p.a+2*p.b+p.c+p.u+p.v < j →
    j < p.a+2*p.b+2*p.c+p.u+p.v → ∃ i, stackAt f i j = true

def USaturated (p : Params) (f : Fold) : Prop :=
  ∀ j, p.a+2*p.b+2*p.c+p.u+p.v < j → j < length p → ∃ i, stackAt f i j = true

/-- The two saturated C blocks force exactly the target GC helices. -/
theorem gc_helices_from_saturation (p : Params) (f : Fold) (hf : admissible p f)
    (hl : LeftCSaturated p f) (hr : RightCSaturated p f) :
    (∀ i, p.a ≤ i → i < p.a+p.b →
      ∃ j, f i j = true ∧ i+j+1 = 2*p.a+2*p.b+p.u) ∧
    (∀ j, p.a+2*p.b+p.c+p.u+p.v ≤ j →
      j < p.a+2*p.b+2*p.c+p.u+p.v →
      ∃ i, f i j = true ∧ i+j+1 = 2*(p.a+2*p.b+p.u)+2*p.c+p.v) := by
  have ha := p.ha
  have hb := p.hb
  have hc := p.hc
  have hu := p.hu
  have hv := p.hv
  obtain ⟨KL, left⟩ := left_helix_from_edges p f hf p.a p.b (by omega) hl
  obtain ⟨KR, right⟩ := right_helix_from_edges p f hf
    (p.a+2*p.b+p.c+p.u+p.v) p.c (by omega) (by
      intro j h0 h1; apply hr j h0; omega)
  obtain ⟨J, hJ, eJ⟩ := left p.a (by omega) (by omega)
  obtain ⟨ell, hell, eell⟩ := left (p.a+p.b-1) (by omega) (by omega)
  obtain ⟨H, hH, eH⟩ := right (p.a+2*p.b+p.c+p.u+p.v) (by omega) (by omega)
  obtain ⟨h, hh, eh⟩ := right (p.a+2*p.b+2*p.c+p.u+p.v-1) (by omega) (by omega)
  have leftG (r q : Nat) (r0 : p.a ≤ r) (r1 : r < p.a+p.b) (hp : f r q = true) :
      p.a+p.b+p.u ≤ q ∧ q < p.a+2*p.b+p.c+p.u := by
    have rc : seq p r = .C := (seq_C_iff p r).mpr (Or.inl ⟨r0,r1⟩)
    have hpclass := allowed_pair_class p r q (hf.1 r q hp)
    have qg : seq p q = .G := by simpa [rc] using hpclass
    exact (seq_G_iff p q).mp qg
  have rightG (r q : Nat)
      (r0 : p.a+2*p.b+p.c+p.u+p.v ≤ r)
      (r1 : r < p.a+2*p.b+2*p.c+p.u+p.v) (hp : f q r = true) :
      p.a+p.b+p.u ≤ q ∧ q < p.a+2*p.b+p.c+p.u := by
    have rc : seq p r = .C := (seq_C_iff p r).mpr (Or.inr ⟨r0,r1⟩)
    have hpclass := allowed_pair_class p q r (hf.1 q r hp)
    have qg : seq p q = .G := by simpa [rc] using hpclass
    exact (seq_G_iff p q).mp qg
  have bJ := leftG p.a J (by omega) (by omega) hJ
  have bell := leftG (p.a+p.b-1) ell (by omega) (by omega) hell
  have bH := rightG (p.a+2*p.b+p.c+p.u+p.v) H (by omega) (by omega) hH
  have bh := rightG (p.a+2*p.b+2*p.c+p.u+p.v-1) h (by omega) (by omega) hh
  have hne : J ≠ h := by
    have hd := hf.2.1 p.a J h (p.a+2*p.b+2*p.c+p.u+p.v-1) hJ hh
    unfold endpointsDisjoint at hd
    omega
  have horder : J < h := by
    have hn := hf.2.2 p.a J h (p.a+2*p.b+2*p.c+p.u+p.v-1) hJ hh
    omega
  have hKL : KL+1 = 2*p.a+2*p.b+p.u := by omega
  have hKR : KR+1 = 2*(p.a+2*p.b+p.u)+2*p.c+p.v := by omega
  constructor
  · intro i hi hi1
    obtain ⟨j,hp,he⟩ := left i hi hi1
    exact ⟨j,hp,by omega⟩
  · intro j hj hj1
    obtain ⟨i,hp,he⟩ := right j hj (by omega)
    exact ⟨i,hp,by omega⟩

/-- Fixed GC hairpins prevent loop As from pairing to the U suffix. -/
theorem au_left_in_first_block (p : Params) (f : Fold) (hf : admissible p f)
    (hl : LeftCSaturated p f) (hr : RightCSaturated p f)
    (i j : Nat) (hp : f i j = true) (hi : seq p i = .A) (hj : seq p j = .U) : i < p.a := by
  have ha := p.ha
  have hb := p.hb
  have hc := p.hc
  have hu := p.hu
  have hv := p.hv
  have hs := gc_helices_from_saturation p f hf hl hr
  obtain ⟨gl,hgl,egl⟩ := hs.1 p.a (by omega) (by omega)
  obtain ⟨gr,hgr,egr⟩ := hs.2 (p.a+2*p.b+2*p.c+p.u+p.v-1) (by omega) (by omega)
  have ir := (seq_A_iff p i).mp hi
  have jr := (seq_U_iff p j).mp hj
  have ncL := hf.2.2 p.a gl i j hgl hp
  have ncR := hf.2.2 gr (p.a+2*p.b+2*p.c+p.u+p.v-1) i j hgr hp
  omega

/-- Saturated U edges reconstruct the target outer AU helix once GC is fixed. -/
theorem au_helix_from_saturation (p : Params) (f : Fold) (hf : admissible p f)
    (hl : LeftCSaturated p f) (hr : RightCSaturated p f) (hu : USaturated p f) :
    ∀ j, p.a+2*p.b+2*p.c+p.u+p.v ≤ j → j < length p →
      ∃ i, f i j = true ∧ i < p.a ∧ i+j+1 = length p := by
  have ha := p.ha
  have hb := p.hb
  have hc := p.hc
  have hpu := p.hu
  have hv := p.hv
  let s := p.a+2*p.b+2*p.c+p.u+p.v
  have hn : s+p.a = length p := by dsimp [s]; unfold length; omega
  obtain ⟨K, right⟩ := right_helix_from_edges p f hf s p.a (by omega) (by
    intro j hj hj1; apply hu j hj; omega)
  have partner (i j : Nat) (hp : f i j = true) (hj : s ≤ j) : i < p.a := by
    have ju : seq p j = .U := (seq_U_iff p j).mpr hj
    have pc := allowed_pair_class p i j (hf.1 i j hp)
    have ia : seq p i = .A := by simpa [ju] using pc
    exact au_left_in_first_block p f hf hl hr i j hp ia ju
  obtain ⟨H,hH,eH⟩ := right s (by omega) (by omega)
  obtain ⟨h,hh,eh⟩ := right (length p-1) (by omega) (by omega)
  have bH := partner H s hH (by omega)
  have bh := partner h (length p-1) hh (by omega)
  have hK : K+1 = length p := by omega
  intro j hj hj1
  obtain ⟨i,hp,he⟩ := right j hj (by omega)
  exact ⟨i,hp,partner i j hp hj,by omega⟩

/-- Equality reconstruction includes every admissible competitor, including
isolated pairs. The three explicit edge-saturation hypotheses must later be
derived from equality of the actual finite counts. -/
theorem reconstruction_from_saturated_edges (p : Params) (f : Fold)
    (hf : admissible p f) (hl : LeftCSaturated p f)
    (hr : RightCSaturated p f) (hu : USaturated p f) : f = target p := by
  have ha := p.ha
  have hb := p.hb
  have hc := p.hc
  have hpu := p.hu
  have hv := p.hv
  have gc := gc_helices_from_saturation p f hf hl hr
  have au := au_helix_from_saturation p f hf hl hr hu
  have forward : ∀ i j, f i j = true → target p i j = true := by
    intro i j hp
    have allow := hf.1 i j hp
    have cls := allowed_pair_class p i j allow
    apply (target_iff p i j).mpr
    rcases cls with cls | cls | cls
    · have jr := (seq_U_iff p j).mp cls.2
      obtain ⟨q,hq,hqa,he⟩ := au j jr allow.2.1
      have eq := pair_right_injective p f hf i j q hp hq
      apply Or.inl
      unfold helixPair length at *
      omega
    · have ir := (seq_C_iff p i).mp cls.1
      have jr := (seq_G_iff p j).mp cls.2
      have ho := allow.2.2.1
      have ib : p.a ≤ i ∧ i < p.a+p.b := by omega
      obtain ⟨q,hq,he⟩ := gc.1 i ib.1 ib.2
      have eq := pair_left_injective p f hf i j q hp hq
      apply Or.inr; apply Or.inl
      unfold helixPair
      omega
    · have ir := (seq_G_iff p i).mp cls.1
      have jr := (seq_C_iff p j).mp cls.2
      have ho := allow.2.2.1
      have jb : p.a+2*p.b+p.c+p.u+p.v ≤ j ∧ j < p.a+2*p.b+2*p.c+p.u+p.v := by omega
      obtain ⟨q,hq,he⟩ := gc.2 j jb.1 jb.2
      have eq := pair_right_injective p f hf i j q hp hq
      apply Or.inr; apply Or.inr
      unfold helixPair
      omega
  have backward : ∀ i j, target p i j = true → f i j = true := by
    intro i j hp
    have tp := (target_iff p i j).mp hp
    unfold targetPair helixPair at tp
    rcases tp with tp | tp | tp
    · have jb : p.a+2*p.b+2*p.c+p.u+p.v ≤ j ∧ j < length p := by unfold length; omega
      obtain ⟨q,hq,hqa,he⟩ := au j jb.1 jb.2
      have eq : q = i := by unfold length at he; omega
      simpa [eq] using hq
    · obtain ⟨q,hq,he⟩ := gc.1 i tp.1 tp.2.1
      have eq : q = j := by omega
      simpa [eq] using hq
    · have jb : p.a+2*p.b+p.c+p.u+p.v ≤ j ∧ j < p.a+2*p.b+2*p.c+p.u+p.v := by omega
      obtain ⟨q,hq,he⟩ := gc.2 j jb.1 jb.2
      have eq : q = i := by omega
      simpa [eq] using hq
  funext i j
  cases hfi : f i j <;> cases hti : target p i j
  · rfl
  · have h := backward i j hti; simp [hfi] at h
  · have h := forward i j hfi; simp [hti] at h
  · rfl

#print axioms au_left_in_first_block
#print axioms au_helix_from_saturation
#print axioms reconstruction_from_saturated_edges
#print axioms left_helix_from_edges
#print axioms right_helix_from_edges
#print axioms gc_helices_from_saturation

end Stage4
