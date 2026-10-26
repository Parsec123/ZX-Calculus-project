(* SUP_3, smallest state version: three Z states feed one X spider.
   Reference: Jeandel et al., arXiv:1702.01945, Proposition 5.
   Angles are radians; all equalities preserve the complete scalar. *)
Require Import CoreData.CoreData.
Require Import CoreRules.CoreRules.
Require Import Reals.Rtrigo_calc.

Local Open Scope C_scope.

Lemma sup3_roots_sum :
  1 + Cexp (2 * PI / 3) + Cexp (4 * PI / 3) = 0.
Proof.
  replace (2 * PI / 3)%R with (PI - PI / 3)%R by lra.
  replace (4 * PI / 3)%R with (PI + PI / 3)%R by lra.
  unfold Cexp.
  apply c_proj_eq; simpl;
    rewrite ?cos_minus, ?sin_minus, ?cos_plus, ?sin_plus,
      ?cos_PI, ?sin_PI, ?cos_PI3.
  all: lra.
Qed.

Lemma sup3_roots_product :
  Cexp (2 * PI / 3) * Cexp (4 * PI / 3) = 1.
Proof.
  rewrite <- Cexp_add.
  replace (2 * PI / 3 + 4 * PI / 3)%R with (2 * PI)%R by lra.
  apply Cexp_2PI.
Qed.

Lemma sup3_polynomial (z a b : C) :
  1 + a + b = 0 -> a * b = 1 ->
  (1 + z) * (1 + z * a) * (1 + z * b) = 1 + z * z * z.
Proof.
  intros Hsum Hprod.
  replace ((1 + z) * (1 + z * a) * (1 + z * b))
    with (1 + z * (1 + a + b) + z * z * (a + b + a * b)
            + z * z * z * (a * b)) by ring.
  rewrite Hsum, Hprod.
  replace (a + b + 1) with (1 + a + b) by ring.
  rewrite Hsum; ring.
Qed.

Lemma sup3_phase_products (alpha : R) :
  let x := Cexp alpha in
  let y := Cexp (alpha + 2 * PI / 3) in
  let z := Cexp (alpha + 4 * PI / 3) in
  let t := Cexp (3 * alpha + 2 * PI) in
  (1 + x) * (1 + y) * (1 + z) = 1 + t /\
  (1 - x) * (1 - y) * (1 - z) = 1 - t.
Proof.
  cbn zeta.
  assert (Hcube : Cexp alpha * Cexp alpha * Cexp alpha =
                  Cexp (3 * alpha + 2 * PI)).
  { rewrite <- 2 Cexp_add.
    replace (3 * alpha + 2 * PI)%R with
      ((alpha + alpha + alpha) + 2 * PI)%R by lra.
    rewrite (Cexp_add (alpha + alpha + alpha) (2 * PI)), Cexp_2PI; ring. }
  pose proof (sup3_polynomial (Cexp alpha)
    (Cexp (2 * PI / 3)) (Cexp (4 * PI / 3))
    sup3_roots_sum sup3_roots_product) as Hp.
  pose proof (sup3_polynomial (- Cexp alpha)
    (Cexp (2 * PI / 3)) (Cexp (4 * PI / 3))
    sup3_roots_sum sup3_roots_product) as Hm.
  split.
  - rewrite (Cexp_add alpha (2 * PI / 3)), (Cexp_add alpha (4 * PI / 3)).
    rewrite Hp, Hcube; reflexivity.
  - rewrite (Cexp_add alpha (2 * PI / 3)),
      (Cexp_add alpha (4 * PI / 3)).
    replace ((1 - Cexp alpha) *
      (1 - Cexp alpha * Cexp (2 * PI / 3)) *
      (1 - Cexp alpha * Cexp (4 * PI / 3))) with
      ((1 + - Cexp alpha) *
      (1 + - Cexp alpha * Cexp (2 * PI / 3)) *
      (1 + - Cexp alpha * Cexp (4 * PI / 3))) by ring.
    rewrite Hm, <- Hcube; ring.
Qed.

Local Open Scope ZX_scope.

Theorem supplementarity_3 (alpha : R) :
  ((Z 0 1 alpha ↕ Z 0 1 (alpha + 2 * PI / 3))
       ↕ Z 0 1 (alpha + 4 * PI / 3)) ⟷ X 3 1 0
  ∝= Z 0 3 (3 * alpha + 2 * PI) ⟷ X 3 1 0.
Proof.
  unfold proportional_by_1.
  cbn [ZX_semantics Nat.add].
  unfold X_semantics.
  solve_matrix.
  all: rewrite Cexp_0.
  all: destruct (sup3_phase_products alpha) as [Hp Hm].
  - transitivity
      ((/ √ 2) * (/ C2 * / √ 2) *
        ((1 + Cexp alpha) * (1 + Cexp (alpha + 2 * PI / 3)) *
          (1 + Cexp (alpha + 4 * PI / 3))) +
       (/ √ 2) * (/ C2 * / √ 2) *
        ((1 - Cexp alpha) * (1 - Cexp (alpha + 2 * PI / 3)) *
          (1 - Cexp (alpha + 4 * PI / 3))))%C.
    + ring.
    + rewrite Hp, Hm; ring.
  - transitivity
      ((/ √ 2) * (/ C2 * / √ 2) *
        ((1 + Cexp alpha) * (1 + Cexp (alpha + 2 * PI / 3)) *
          (1 + Cexp (alpha + 4 * PI / 3))) -
       (/ √ 2) * (/ C2 * / √ 2) *
        ((1 - Cexp alpha) * (1 - Cexp (alpha + 2 * PI / 3)) *
          (1 - Cexp (alpha + 4 * PI / 3))))%C.
    + ring.
    + rewrite Hp, Hm; ring.
Qed.

Print Assumptions supplementarity_3.
