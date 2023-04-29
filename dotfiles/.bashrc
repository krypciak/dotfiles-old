# Start fish, except when bash was executed inside of fish
if [[ $(ps --no-header --pid=$PPID --format=comm) != "fish" && -z ${BASH_EXECUTION_STRING} ]]
then
	exec fish
fi

source /usr/share/autojump/autojump.bash

source ~/.config/at-login.sh
source ~/.config/aliases.sh

[[ -f ~/.bash-preexec.sh ]] && source ~/.config/.bash-preexec.sh
eval "$(atuin init bash)"
