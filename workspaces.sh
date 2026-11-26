# shellcheck shell=bash
# Sdílené funkce pro mapování tmux session → macOS workspace (Space).
# Config: řádek `<session> <workspace>`; jméno session smí obsahovat mezery,
# workspace je poslední slovo řádku; `* <workspace>` je default;
# `#` zahajuje komentář. Používá tmux-claude-switcher.sh a workspaces-register.

WORKSPACES_CONF="${WORKSPACES_CONF:-$HOME/.tmux-local/workspaces.conf}"

# Prints one `<session>\t<workspace>` line per config entry.
workspace_entries() {
  [[ -r "$WORKSPACES_CONF" ]] || return 1
  awk '
    { sub(/[ \t]*#.*$/, "") }
    /^[ \t]*$/ { next }
    {
      ws = $NF
      name = $0
      sub(/[ \t]+[^ \t]+[ \t]*$/, "", name)
      sub(/^[ \t]+/, "", name)
      print name "\t" ws
    }
  ' "$WORKSPACES_CONF"
}

workspace_for_session() {
  local session="$1" name ws default=""
  while IFS=$'\t' read -r name ws; do
    [[ "$name" == "*" ]] && { default="$ws"; continue; }
    [[ "$name" == "$session" ]] && { printf '%s\n' "$ws"; return 0; }
  done < <(workspace_entries)
  [[ -n "$default" ]] && { printf '%s\n' "$default"; return 0; }
  return 1
}

# macOS neumí říct, na které Space okno leží, takže okno workspace N
# odvodíme z configu: klient (Ghostty okno), který právě zobrazuje session
# mapovanou na workspace N, je okno workspace N.
client_for_workspace() {
  local ws="$1" ctty csess
  while IFS=$'\t' read -r ctty csess; do
    [[ "$(workspace_for_session "$csess")" == "$ws" ]] && { printf '%s\n' "$ctty"; return 0; }
  done < <(tmux list-clients -F '#{client_tty}	#{client_session}')
  return 1
}

# Je session v configu vyjmenovaná explicitně (ne jen přes `*` default)?
session_listed() {
  local session="$1" name _ws
  while IFS=$'\t' read -r name _ws; do
    [[ "$name" == "$session" ]] && return 0
  done < <(workspace_entries)
  return 1
}
