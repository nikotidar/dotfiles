
# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export _JAVA_AWT_WM_NONREPARENTING=1

# dbus-launch
if which dbus-launch >/dev/null && test -z "$DBUS_SESSION_BUS_ADDRESS";
then
	eval "$(dbus-launch --sh-syntax --exit-with-session)"
fi

# apps
wal -R &
sleep 0.2 ; xrdb -load ~/.Xresources &
compton --xrender-sync-fence --xrender-sync -b --backend glx --glx-no-rebind-pixmap -cCGb -r 20 -l -30 -t -10 -o 0.6 --vsync opengl-swc --no-fading-openclose --blur-method kawase &
xsetroot -cursor_name left_ptr &
urxvtd -q -f -o

# wm
sxhkd -c ~/.config/sxhkd/2bwmrc &
bash /home/betmenwasdie/.config/2bwm/panel/underpl-s &
exec 2bwm
