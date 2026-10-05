# ZX Calculus Project

Small PyZX demos for learning ZX calculus and quantum circuit simplification.

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

These demos are introductory exercises. Reproducing results from the VyZX paper is a possible next step; it is not part of this repository yet.
