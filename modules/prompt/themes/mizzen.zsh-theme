#
# Mizzen theme
# https://github.com/bgrrtt/mizzen-theme

#
# Minimal theme
# https://github.com/S1cK94/minimal
#

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

git_branch_name() {
  local branch_name="$(command git rev-parse --abbrev-ref HEAD 2> /dev/null)"
  [[ -n $branch_name ]] && print "$branch_name"
}

git_repo_status(){
  local rs="$(command git status --porcelain -b)"

  if $(print "$rs" | grep -v '^##' &> /dev/null); then # is dirty
    print "%F{red}"
  elif $(print "$rs" | grep '^## .*diverged' &> /dev/null); then # has diverged
    print "%F{red}"
  elif $(print "$rs" | grep '^## .*behind' &> /dev/null); then # is behind
    print "%F{11}"
  elif $(print "$rs" | grep '^## .*ahead' &> /dev/null); then # is ahead
    print "%f"
  else # is clean
    print "%F{green}"
  fi
}

mizzen_git() {
  local bname=$(git_branch_name)
  if [[ -n ${bname} ]]; then
    local infos="$(git_repo_status)${bname}%f"
    print " $infos"
  fi
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
  RPROMPT='$(mizzen_path)$(mizzen_git)'
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


#
#
# minimal_user() {
#   print "%(!.$on_color.$off_color)$prompt_char%f"
# }
#
# minimal_jobs() {
#   print "%(1j.$on_color.$off_color)$prompt_char%f"
# }
#
# minimal_vimode(){
#   local ret=""
#
#   case $KEYMAP in
#     main|viins)
#       ret+="$on_color"
#       ;;
#     vicmd)
#       ret+="$off_color"
#       ;;
#   esac
#
#   ret+="$prompt_char%f"
#
#   print "$ret"
# }
#
# mizzen_arrow() {
#   local start_color="%F{red}"
#   local yield_color="%F{yellow}"
#   print " $start_color$prompt_char$yield_color$prompt_char%f"
# }
#
# minimal_status() {
#   print "%(0?.$on_color.$err_color)$prompt_char%f"
# }
#
# minimal_path() {
#   local path_color="%F{blue}"
#   local rsc="%f"
#   local sep="$path_color/$path_color"
#
#   print "%M $path_color$(sed s_/_${sep}_g <<< $(short_pwd))$rsc"
# }
#
# git_branch_name() {
#   local branch_name="$(command git rev-parse --abbrev-ref HEAD 2> /dev/null)"
#   [[ -n $branch_name ]] && print "$branch_name"
# }
#
# git_repo_status(){
#   local rs="$(command git status --porcelain -b)"
#
#   if $(print "$rs" | grep -v '^##' &> /dev/null); then # is dirty
#     print "%F{red}"
#   elif $(print "$rs" | grep '^## .*diverged' &> /dev/null); then # has diverged
#     print "%F{red}"
#   elif $(print "$rs" | grep '^## .*behind' &> /dev/null); then # is behind
#     print "%F{11}"
#   elif $(print "$rs" | grep '^## .*ahead' &> /dev/null); then # is ahead
#     print "%f"
#   else # is clean
#     print "%F{green}"
#   fi
# }
#
# minimal_git() {
#   local bname=$(git_branch_name)
#   if [[ -n ${bname} ]]; then
#     local infos="$(git_repo_status)${bname}%f"
#     print " $infos"
#   fi
# }
#
# mizzen_git_info() {
#   print "%f"
# }
#
# function zle-line-init zle-line-finish zle-keymap-select {
#   zle reset-prompt
#   zle -R
# }
#
# prompt_minimal_precmd() {
#   zle -N zle-line-init
#   zle -N zle-keymap-select
#   zle -N zle-line-finish
#   git-info
# }
#
# prompt_minimal_setup() {
#   prompt_char="❯"
#   on_color="%F{green}"
#   off_color="%f"
#   err_color="%F{red}"
#
#   autoload -Uz add-zsh-hook
#
#   add-zsh-hook precmd prompt_minimal_precmd
#
#   zstyle ':zim:git-info' verbose 'yes'
#   zstyle ':zim:git-info:action' format '%F{7}:%f%%B%F{9}%s%f%%b'
#   zstyle ':zim:git-info:added' format ' %%B%F{2}✚%f%%b'
#   zstyle ':zim:git-info:ahead' format ' %%B%F{13}⬆%f%%b'
#   zstyle ':zim:git-info:behind' format ' %%B%F{13}⬇%f%%b'
#   zstyle ':zim:git-info:branch' format ' %%B%F{2}%b%f%%b'
#   zstyle ':zim:git-info:commit' format ' %%B%F{3}%.7c%f%%b'
#   zstyle ':zim:git-info:deleted' format ' %%B%F{1}✖%f%%b'
#   zstyle ':zim:git-info:modified' format ' %%B%F{4}✱%f%%b'
#   zstyle ':zim:git-info:position' format ' %%B%F{13}%p%f%%b'
#   zstyle ':zim:git-info:renamed' format ' %%B%F{5}➜%f%%b'
#   zstyle ':zim:git-info:stashed' format ' %%B%F{6}✭%f%%b'
#   zstyle ':zim:git-info:unmerged' format ' %%B%F{3}═%f%%b'
#
#
#
#   zstyle ':zim:git-info:branch' format ' branch:%b'
#   zstyle ':zim:git-info:commit' format ' commit:%c'
#   zstyle ':zim:git-info:remote' format ' remote:%R'
#
#   zstyle ':zim:git-info:indexed' format '%F{blue}:%i'
#   zstyle ':zim:git-info:unindexed' format '%F{blue}:%I'
#
#   zstyle ':zim:git-info:dirty' format ' %F{blue}✱'
#
#   zstyle ':zim:git-info:ahead' format ' %F{green}⬆:%A'
#   zstyle ':zim:git-info:behind' format ' %F{green}⬇:%B'
#   zstyle ':zim:git-info:untracked' format ' %F{white}◼:%u'
#
#   zstyle ':zim:git-info:keys' format \
#     'status_info' '%c' \
#     'status_symbols' '%D%i%I%u%A%C'
#
#   PROMPT='$(minimal_path)$(mizzen_arrow)$(minimal_status) '
#   RPROMPT='$(minimal_git)$git_info[status_info]$git_info[status_symbols]'
#
#   prompt_opts=(cr subst percent)
# }
#
# prompt_minimal_setup "$@"
