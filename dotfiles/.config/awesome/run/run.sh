source ~/.config/at_login.sh

dbus-update-activation-environment --all
gnome-keyring-daemon --start --components=secrets

exec dbus-run-session startx
