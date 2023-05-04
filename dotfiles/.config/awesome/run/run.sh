source ~/.config/at-login.sh

dbus-update-activation-environment --all
gnome-keyring-daemon --start --components=secrets

exec dbus-launch --exit-with-session startx
