PROMPT="%B%F{white}%~%f%b %F{#888888}λ%f "

mcd()
{
    mkdir -p -- "$1" &&
    cd "$1"
}

r () {
  NAME="$1"
  shift 1 && nix run --impure "nixpkgs#$NAME" -- "$@"
}

s () {
  ARGS=("$@")
  nix shell --impure ${ARGS[@]/#/nixpkgs#}
}

fhs () {
  ARGS="$@"
  nix-shell --expr "let pkgs = import <nixpkgs> {}; in (pkgs.buildFHSUserEnv { name = \"fhs\"; targetPkgs = pkgs: with pkgs; [$ARGS]; }).env"
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
