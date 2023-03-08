PROMPT="%B%F{white}%~%f%b %F{#888888}λ%f "

mcd()
{
    mkdir -p -- "$1" &&
    cd "$1"
}

r () {
  NAME="$1"
  shift 1 && nix run "nixpkgs#$NAME" "$@"
}

s () {
  ARGS=("$@")
  nix shell ${ARGS[@]/#/nixpkgs#}
}

typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[default]='fg=#bbbbbb'
ZSH_HIGHLIGHT_STYLES[command]='fg=white,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=white,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=white,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=white,bold'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#888888'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#888888'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#8b8b8b'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#8b8b8b'
ZSH_HIGHLIGHT_STYLES[path]='fg=#8b8b8b'
