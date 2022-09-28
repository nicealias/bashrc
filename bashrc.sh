# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

#echo ".bashrc for user '$(basename $HOME)'"
echo ".bashrc for user '${SUDO_USER:-$USER}'"
echo "  Ctrl+A/E (line start/end), Ctrl+L (clear), Ctrl+U/K (delete to start/end), Alt+D/Bksp (delete fw/bw), Ctrl+_ (undo)"
echo "  Ctrl+W (delete prev arg), Alt+<n> Ctrl+Alt+Y (prev nth arg), Alt+. (prev last arg), !!:<n> (substitute prev nth arg)"
echo "  Ctrl+V (escape next char), Ctrl(+Alt)+] (jump to char fw/bw), Alt+R (revert), Ctrl+XX (rejump), Alt+T (swap words)"
echo "  Alt+/ (complete filename), Ctrl+Alt+E (expand), Ctrl+X Ctrl+E (edit in vi + execute), !!:0-$:s/<find>/<replace>/:g"
echo "  History: Ins (mcfly), Ctrl+↑ (hstr), PgUp (find b.), PgDn (find f.) - Folders: 'cd -', j=autojump, z=smart+tab"

iscommand() {
  [ -n "$(type "$1" 2>/dev/null)" ]
}
isfunction() {
  case "$(type -t "$1" 2>/dev/null)" in
            "") return 1; ;;
    *function*) return 0; ;;
             *) return 1; ;;
  esac
}
includefile() {
  if [ -f "$1" ]; then
    . "$1"
  fi
}

includefile ~/.bash.d/path
includefile ~/.bash.d/history.opts
includefile ~/.bash.d/shell.opts
includefile ~/.bash.d/prompt

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
# start timing + 0.190

includefile ~/.bash.d/aliases
for f in ~/.bash.d/*.func; do
  . $f
done
unset f
includefile ~/.bash.d/export.vars
# start timing + 0.253

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
complete -f sudo   # -cf
# start timing + 0.289

includefile ~/.bash.d/addons

if [ -n "$PROMPT_COMMAND" ]; then
  echo "PROMPT_COMMAND not empty: ($PROMPT_COMMAND)"
fi

trap "{ . $HOME/.bash.d/close; exit; }" EXIT
trap "{ . $HOME/.bash.d/stop HUP; }" HUP
trap "{ . $HOME/.bash.d/stop TERM; }" TERM
