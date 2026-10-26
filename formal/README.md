# VyZX / Rocq formal proof demos

These two `.v` files use Coq 8.20.1 (the prover now called Rocq) to check mathematical proofs. The PyZX scripts in the repository root provide separate numerical experiments.

| File | Results | Scope |
| --- | --- | --- |
| [SpiderFusionRepro.v](SpiderFusionRepro.v) | Single-wire Z fusion, X fusion derived by color swapping, and two pi/4 examples | Arbitrary input/output arities and real phases; one connecting wire |
| [Supplementarity3.v](Supplementarity3.v) | Third-order cyclotomic supplementarity (SUP3) | Arbitrary real phase alpha; a fixed 0-to-1 state diagram |

All proofs end with `Qed`. Neither file uses `Admitted`, `Abort`, or new axiom declarations. The relation `∝=` denotes exact equality of matrix semantics, including the scalar.

## 1. Environment and dependencies

Versions used for validation:

- Coq 8.20.1, OCaml 4.14.1, Dune 3.23.1
- QuantumLib 1.8.0, SQIR 1.3.2, VOQC 1.3.2
- [Upstream VyZX](https://github.com/inQWIRE/VyZX) commit `10f8c16741952dbaa2bb7a73e13767945e696b8f`

On Linux or WSL, activate an opam environment with these dependencies installed:

```bash
eval "$(opam env)"
```

For a fresh installation, see the pinned [VyZX build instructions](https://github.com/inQWIRE/VyZX/tree/10f8c16741952dbaa2bb7a73e13767945e696b8f#building-vyzx). The versions above document the validated environment; a complete transitive dependency lockfile is not provided.

## 2. Obtain VyZX

Run the following commands from this repository's root. Skip this step if you already have a VyZX checkout at the required commit.

```bash
mkdir -p formal/.deps
git clone https://github.com/inQWIRE/VyZX.git formal/.deps/VyZX
git -C formal/.deps/VyZX checkout --detach 10f8c16741952dbaa2bb7a73e13767945e696b8f
```

## 3. Compile and check the proof objects

```bash
bash formal/verify.sh
```

Alternatively, provide the path to an existing VyZX checkout:

```bash
bash formal/verify.sh /path/to/VyZX
```

The script builds VyZX, compiles both files as modules in the `FormalDemos` namespace, and uses `coqchk` to recheck both proof objects and their dependencies. It does not copy the demos into or edit the VyZX source files.

On Windows, run `wsl -d Ubuntu-24.04` in PowerShell, navigate to this repository under its `/mnt/c/...` path in Ubuntu, and execute the Bash commands above. Substitute your installed distribution name if necessary.

A successful run ends with `PASS`. Full logs, including the output of `Print Assumptions`, are written to `formal/.build/`. A nonzero exit code indicates a failed check. Dune may produce no output when the build is already up to date.

During local validation, both files reported these foundational axiom dependencies:

- `ClassicalDedekindReals.sig_not_dec`
- `ClassicalDedekindReals.sig_forall_dec`
- `functional_extensionality_dep`

The proofs therefore rely on the foundational axioms used by the real-number and matrix semantics; they are not axiom-free.

Validation record (2026-10-25): `bash formal/verify.sh` was run with an existing VyZX checkout at the required revision. Both files compiled, the combined `coqchk` recheck passed, and the script returned exit code 0.

## 4. Mathematical content and sources

### Spider fusion

`repro_Z_single_wire_fusion` proves:

```coq
forall (n m : nat) (alpha beta : R),
  (Z n 1 alpha ⟷ Z 1 m beta) ∝= Z n m (alpha + beta).
```

The proof follows the semantic argument of the upstream lemma `Z_spider_1_1_fusion_eq` in `CoreData/ZXCore.v`: basis-state orthogonality eliminates the cross terms, and the complex exponential addition law combines the phases. It repeats that argument rather than directly applying an existing fusion theorem, while still using the library's foundational lemmas and tactics.

Source: [Section 5 of the VyZX paper](https://arxiv.org/html/2311.11571v4#S5). The copyright notice and MIT license for the adapted upstream code are preserved in [LICENSE-VyZX](LICENSE-VyZX).

### SUP3

Three Z states with phases alpha, alpha + 2*pi/3, and alpha + 4*pi/3 each connect to the same zero-phase X spider. They are equivalent to one Z spider with phase 3*alpha + 2*pi connected to that X spider by three wires:

```coq
((Z 0 1 alpha ↕ Z 0 1 (alpha + 2 * PI / 3))
     ↕ Z 0 1 (alpha + 4 * PI / 3)) ⟷ X 3 1 0
∝= Z 0 3 (3 * alpha + 2 * PI) ⟷ X 3 1 0.
```

The proof proceeds through a sum of roots of unity, a product of roots of unity, a polynomial identity, complex exponential products, and equality of the two output components of the diagrams.

Source: Jeandel, Perdrix, Vilmart, and Wang, [*ZX-Calculus: Cyclotomic Supplementarity and Incompleteness for Clifford+T quantum mechanics*](https://arxiv.org/pdf/1702.01945), Section 4, Proposition 5, and Appendix A.2.

Only the minimal state version with a fixed structure is proved here. This does not cover arbitrary common neighborhoods, arbitrary external arities, or general SUPn, and no claim of being the first formalization of the rule is made.
