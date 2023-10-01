set -o vi
bindkey ^R history-incremental-pattern-search-backward
bindkey '^[[Z' reverse-menu-complete # Shift-Tab

autoload run-help
unalias run-help

source ~/.zaliases
source ~/.zfunctions
source ~/.zpath

export HISTFILE=~/.histfile
export HISTSIZE=10000
export SAVEHIST=10000

[ -n "$NEWPWD" ] && cd "$NEWPWD"

preexec() {
	# set window title
	1="$(sed s/%/%%/g<<<"$1")"
	printf "\x1b]0;$1\a"

	initial_seconds=$SECONDS
}

precmd() {
	[[ "$(fc -l -1)" = *pacman*-S* ]] && rehash

	printf "\x1b]0;Untitled\a"

	if [ -n "$initial_seconds" ]; then
		elapsed=$(($SECONDS - $initial_seconds))
		if (( $elapsed > 0 )); then
			format_elapsed=', command took %B'$elapsed's'
		else
			format_elapsed=
		fi
	fi

	# beautiful prompt
	export PROMPT='%B%(!.%F{9}.%F{6})%n%b%F{white} on %B%F{5}%m%b%f'$format_elapsed$'\n''%# %b'
	# show exit code
	export RPROMPT='%B%F{9}%(?..%?)'

	unset format_elapsed initial_seconds
}

printf '\033[5 q\r'
autoload -U add-zle-hook-widget
change_cursor() {
	case "$KEYMAP" in
		vicmd)
			# block cursor
			printf '\033[2 q\r'
			;;
		viins|main)
			# I-beam cursor
			printf '\033[5 q\r'
			;;
	esac
	zle reset-prompt
}
add-zle-hook-widget zle-keymap-select change_cursor

if [[ $(tty) == /dev/pts/* ]]; then
	for plugin in ~/.zplugins/*/*.plugin.zsh; do source "$plugin"; done

	# fast-syntax-highlighting shows
	# weird errors while typing `man`, workaround:
	FAST_HIGHLIGHT[chroma-man]=

	# https://github.com/marlonrichert/zsh-autocomplete#make-tab-go-straight-to-the-menu-and-cycle-there
	bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
	bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete
	# disable zsh-autocomplete history
	bindkey -a k up-line-or-history
	bindkey -a j down-line-or-history
	bindkey "^[[A" up-line-or-history
	bindkey "^[[B" down-line-or-history

	chpwd() {
		awesome-client "
			for _, master in pairs(tab_masters) do
				for _, tab in ipairs(master.tabs) do
					if tab.client == client.focus then
						tab.pwd = [[$PWD]]
					end
				end
			end
		"
	}
fi
