#!/usr/bin/env bash
# Session names with spaces must map to their workspace and be unregistered
# only when their own `# auto` line matches.
set -u

dir="$(cd "$(dirname "$0")/.." && pwd)"
tmpdir="$(mktemp -d "$dir/tests/.tmp.XXXXXX")"
trap 'rm -rf "$tmpdir"' EXIT
export WORKSPACES_CONF="$tmpdir/workspaces.conf"
cat > "$WORKSPACES_CONF" <<'EOF'
# comment line
EM2 3
2 HKDev 2
EM3-121 Gauges 3 # auto
EM3-121 Gauges Old 3 # auto
* 1
EOF

# shellcheck source=../workspaces.sh
. "$dir/workspaces.sh"

fail=0
check() { # <description> <expected> <actual>
  if [[ "$2" == "$3" ]]; then echo "ok   $1"; else echo "FAIL $1: expected '$2', got '$3'"; fail=1; fi
}

check "plain name"           3 "$(workspace_for_session EM2)"
check "name with space"      2 "$(workspace_for_session '2 HKDev')"
check "auto entry w/ spaces" 3 "$(workspace_for_session 'EM3-121 Gauges')"
check "prefix is no match"   1 "$(workspace_for_session '2')"
check "default"              1 "$(workspace_for_session 'Unknown')"
session_listed '2 HKDev'; check "listed with space" 0 $?
session_listed 'HKDev';   check "partial not listed" 1 $?

"$dir/workspaces-unregister" 'EM3-121 Gauges'
check "unregister removes own line" 0 "$(grep -c '^EM3-121 Gauges 3 # auto$' "$WORKSPACES_CONF")"
check "unregister keeps similar"    1 "$(grep -c '^EM3-121 Gauges Old 3' "$WORKSPACES_CONF")"
"$dir/workspaces-unregister" '2 HKDev'
check "manual line survives"        1 "$(grep -c '^2 HKDev 2$' "$WORKSPACES_CONF")"

exit "$fail"
