(* First formal reproduction: single-wire spider fusion.
   Based on VyZX's Z_spider_1_1_fusion_eq in CoreData/ZXCore.v.
   Unlike applying that lemma, the proof below repeats its semantic argument.
   Phases are real angles in radians, not PyZX's multiples of pi. *)
Require Import CoreData.CoreData.

Open Scope ZX_scope.

(* Arbitrary input/output arities (including zero), arbitrary real phases.
   [∝=] is exact equality of denotations, including the scalar. *)
Lemma repro_Z_single_wire_fusion : forall (n m : nat) (alpha beta : R),
  (Z n 1 alpha ⟷ Z 1 m beta) ∝= Z n m (alpha + beta).
Proof.
  intros n m alpha beta.
  unfold proportional_by_1.
  (* Express spiders in bra-ket form, then evaluate composition. *)
  rewrite 2 ZX_semantic_equiv.
  simpl.
  Msimpl.
  restore_dims.
  autorewrite with scalar_move_db.
  (* Expand the two sums in the matrix product. *)
  repeat rewrite Mmult_plus_distr_l.
  repeat rewrite Mmult_plus_distr_r.
  autorewrite with scalar_move_db.
  restore_dims.
  repeat rewrite Mmult_assoc.
  restore_dims.
  repeat rewrite <- (Mmult_assoc ⟨0∣).
  repeat rewrite <- (Mmult_assoc ⟨1∣).
  (* Orthogonality kills the cross terms: <0|1> = <1|0> = 0. *)
  repeat rewrite Mmult00, Mmult10, Mmult01, Mmult11.
  Msimpl.
  restore_dims.
  Msimpl.
  autorewrite with scalar_move_db.
  (* exp(i*(alpha+beta)) = exp(i*alpha) * exp(i*beta). *)
  rewrite Cexp_add.
  reflexivity.
Qed.

(* Derive the color-swapped version from our own Z lemma. *)
Lemma repro_X_single_wire_fusion : forall (n m : nat) (alpha beta : R),
  (X n 1 alpha ⟷ X 1 m beta) ∝= X n m (alpha + beta).
Proof.
  intros n m alpha beta.
  apply colorswap_diagrams_eq.
  simpl.
  apply repro_Z_single_wire_fusion.
Qed.

(* Concrete one-input/one-output example matching the original demo. *)
Example repro_pi_quarter_fusion :
  (Z 1 1 (PI / 4) ⟷ Z 1 1 (PI / 4)) ∝= Z 1 1 (PI / 2).
Proof.
  replace (PI / 2)%R with (PI / 4 + PI / 4)%R by lra.
  apply repro_Z_single_wire_fusion.
Qed.

(* Same proof, with two inputs and two outputs: not restricted to circuits. *)
Example repro_two_input_two_output_fusion :
  (Z 2 1 (PI / 4) ⟷ Z 1 2 (PI / 4)) ∝= Z 2 2 (PI / 2).
Proof.
  replace (PI / 2)%R with (PI / 4 + PI / 4)%R by lra.
  apply repro_Z_single_wire_fusion.
Qed.

(* Record the actual axioms inherited from real/complex matrix semantics.
   Do not interpret these proofs as axiom-free. *)
Print Assumptions repro_Z_single_wire_fusion.
Print Assumptions repro_X_single_wire_fusion.
Print Assumptions repro_pi_quarter_fusion.
Print Assumptions repro_two_input_two_output_fusion.
