# ZX Calculus Project

Small PyZX demos and VyZX/Rocq formal proofs for learning ZX calculus.

## Formal proofs (VyZX / Rocq)

Two machine-checked demos are available in [formal/](formal/README.md):

- [Spider fusion](formal/SpiderFusionRepro.v): single-wire Z/X fusion and concrete pi/4 examples.
- [SUP3](formal/Supplementarity3.v): the minimal state version of cyclotomic supplementarity for arbitrary real phase.

See the [formal proof instructions](formal/README.md) for dependencies, theorem scope, and the script that compiles both demos and rechecks their proof objects with `coqchk`.

## Demos

| File | What it explores |
| --- | --- |
| `demo_hh.py` | Two consecutive Hadamard gates simplify to the identity. |
| `demo_spider_fusion.py` | Two Z phases of pi/4 fuse into a phase of pi/2. |
| `demo_change_spider.py` | A reusable circuit analysis example using `H-Z(pi)-H`, ZX reduction, circuit extraction, and equivalence checks. |

Each demo prints circuit statistics and displays the original and simplified ZX diagrams. Close a diagram window to continue to the next one.

## Run locally

Use Python 3.12. In PowerShell, from this folder:

```powershell
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
.\.venv\Scripts\python.exe demo_hh.py
```

Replace `demo_hh.py` with another demo filename to run it.

## Project status

The PyZX scripts are introductory numerical exercises. The `formal/` directory contains the two formal proof demos described above; it does not reproduce the entire VyZX paper.
