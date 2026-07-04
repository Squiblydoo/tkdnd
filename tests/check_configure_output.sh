#!/usr/bin/env bash
#
# check_configure_output.sh -- regression check for petasis/tkdnd issue #76.
#
#    configure used to run a dead intptr_t/uintptr_t AC_CHECK_TYPE block
#    (PTR2INT/INT2PTR are not used anywhere in this codebase) *after*
#    TEA_MAKE_LIB, at which point CFLAGS already contains unexpanded
#    ${CFLAGS_DEFAULT}/${CFLAGS_WARNING}/${SHLIB_CFLAGS} references, so every
#    compile check in that block failed and configure always reported
#    "checking for pointer-size ... integer type... none". The block was
#    removed entirely (see configure.ac). This script fails if it reappears
#    or if an equivalent probe is reintroduced.
#
# Usage: tests/check_configure_output.sh [path-to-config.log]
#        (defaults to ./config.log, i.e. run this from the directory where
#        `configure` was invoked)

set -euo pipefail

log="${1:-config.log}"

if [ ! -f "$log" ]; then
  echo "error: $log not found -- run ./configure first" >&2
  exit 2
fi

if grep -q "checking for intptr_t" "$log"; then
  echo "FAIL: configure still probes for intptr_t (issue #76 regression)" >&2
  exit 1
fi

echo "OK: configure does not probe for intptr_t/uintptr_t"
