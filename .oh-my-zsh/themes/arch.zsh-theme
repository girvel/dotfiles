#!/usr/bin/env zsh

# setopt prompt_subst
# chpwd() {
#   if [[ `git.exe rev-parse --is-inside-work-tree 2>/dev/null` == "true" ]]
#   then
#     relpath=`realpath --relative-to="$(git rev-parse --show-toplevel)/.." .`
#     branch=`git.exe rev-parse --abbrev-ref HEAD 2>/dev/null`
#     relpath="%B%F{blue}$relpath%F{yellow}[$branch]%f%b"
#     if ! git.exe diff-index --quiet HEAD --
#     then
#       relpath=$relpath"%B%F{blue}+%f%b"
#     fi
#   else
#     relpath="%~"
#   fi
# 
#   export PROMPT="
# %B%F{red}%n%b%F{white}@%m ${relpath} %# "
# }
# 
# chpwd
# 
# autoload -U add-zsh-hook
# add-zsh-hook precmd chpwd
export PROMPT="
%B%F{red}%n%b%F{white}@%m %~ %# "
