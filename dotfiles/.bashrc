# Start fish, except when bash was executed inside of fish
if [[ $(ps --no-header --pid=$PPID --format=comm) != "fish" && -z ${BASH_EXECUTION_STRING} ]]
then
	exec fish
fi
source ~/.config/at-login.sh
source ~/.config/aliases.sh
