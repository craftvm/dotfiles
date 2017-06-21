#
# Mizzen theme
# https://github.com/bgrrtt/mizzen-theme

mizzen_user() {
  print "%(!.$on_color.$off_color)$prompt_char%f"
}

mizzen_jobs() {
  print "%(1j.$on_color.$off_color)$prompt_char%f"
}

mizzen_vimode(){
  local ret=""

  case $KEYMAP in
    main|viins)
      ret+="$on_color"
      ;;
    vicmd)
      ret+="$off_color"
      ;;
  esac

  ret+="$prompt_char%f"

  print "$ret"
}

mizzen_status() {
  print "%(0?.$on_color.$err_color)$prompt_char%f"
}

mizzen_path() {
  local path_color="%F{244}"
  local rsc="%f"
  local sep="$rsc/$path_color"

  print "$path_color$(sed s_/_${sep}_g <<< $(short_pwd))$rsc"
}

function zle-line-init zle-line-finish zle-keymap-select {
  zle reset-prompt
  zle -R
}

prompt_mizzen_precmd() {
  zle -N zle-line-init
  zle -N zle-keymap-select
  zle -N zle-line-finish

  PROMPT='$(mizzen_user)$(mizzen_jobs)$(mizzen_vimode)$(mizzen_status) '
  RPROMPT='$(mizzen_path)'
}

prompt_mizzen_setup() {
  prompt_char="❯"
  on_color="%F{green}"
  off_color="%f"
  err_color="%F{red}"

  autoload -Uz add-zsh-hook

  add-zsh-hook precmd prompt_mizzen_precmd
  prompt_opts=(cr subst percent)
}

prompt_mizzen_setup "$@"
