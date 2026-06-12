# shellcheck shell=bash
# Sdílené funkce pro mapování tmux session → macOS workspace (Space).
# Config: řádek `<session> <workspace>`; `* <workspace>` je default;
# `#` zahajuje komentář. Používá tmux-claude-switcher.sh a workspaces-register.

WORKSPACES_CONF="$HOME/.tmux-local/workspaces.conf"

workspace_for_session() {
  local session="$1" name ws _rest default=""
  [[ -r "$WORKSPACES_CONF" ]] || return 1
  while read -r name ws _rest; do
    case "$name" in ''|\#*) continue ;; esac
    [[ "$name" == "*" ]] && { default="$ws"; continue; }
    [[ "$name" == "$session" ]] && { printf '%s\n' "$ws"; return 0; }
  done < "$WORKSPACES_CONF"
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
  local session="$1" name _rest
  [[ -r "$WORKSPACES_CONF" ]] || return 1
  while read -r name _rest; do
    [[ "$name" == "$session" ]] && return 0
  done < "$WORKSPACES_CONF"
  return 1
}
