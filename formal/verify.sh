#!/usr/bin/env bash
# Run from Linux/WSL with the Coq/opam environment activated.
set -euo pipefail

formal_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
vyzx_input="${1:-$formal_dir/.deps/VyZX}"
expected_revision="10f8c16741952dbaa2bb7a73e13767945e696b8f"

if [[ ! -d "$vyzx_input/.git" ]]; then
  printf 'VyZX checkout not found: %s\nSee formal/README.md, or pass its path as the first argument.\n' "$vyzx_input" >&2
  exit 1
fi
vyzx_dir="$(cd -- "$vyzx_input" && pwd)"
actual_revision="$(git -C "$vyzx_dir" rev-parse HEAD)"
if [[ "$actual_revision" != "$expected_revision" ]]; then
  printf 'Expected VyZX %s, found %s.\n' "$expected_revision" "$actual_revision" >&2
  exit 1
fi
for executable in coqc coqchk dune; do
  command -v "$executable" >/dev/null || {
    printf 'Missing %s. Activate the Coq/opam environment first.\n' "$executable" >&2
    exit 1
  }
done

mkdir -p "$formal_dir/.build"
printf 'Building pinned VyZX dependencies...\n'
if ! (cd -- "$vyzx_dir" && dune build -j "${JOBS:-2}") >"$formal_dir/.build/vyzx.log" 2>&1; then
  cat "$formal_dir/.build/vyzx.log" >&2
  exit 1
fi

load_path=(-R "$vyzx_dir/_build/default/src" VyZX -Q "$formal_dir" FormalDemos)
for module in SpiderFusionRepro Supplementarity3; do
  if ! coqc "${load_path[@]}" "$formal_dir/$module.v" >"$formal_dir/.build/$module.log" 2>&1; then
    cat "$formal_dir/.build/$module.log" >&2
    exit 1
  fi
  printf 'Compiled: %s\n' "$module"
done

printf 'Rechecking both proof objects with coqchk (may take a minute)...\n'
if ! coqchk -silent "${load_path[@]}" \
  FormalDemos.SpiderFusionRepro FormalDemos.Supplementarity3 \
  >"$formal_dir/.build/coqchk.log" 2>&1; then
  cat "$formal_dir/.build/coqchk.log" >&2
  exit 1
fi
printf 'PASS: both demos compiled and coqchk completed.\nLogs and Print Assumptions output: %s/.build/\n' "$formal_dir"
