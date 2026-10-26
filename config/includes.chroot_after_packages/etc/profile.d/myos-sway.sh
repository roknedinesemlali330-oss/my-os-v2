# عند الدخول على الشاشة الأولى (tty1) شغّل sway تلقائياً.
if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
  exec sway
fi
