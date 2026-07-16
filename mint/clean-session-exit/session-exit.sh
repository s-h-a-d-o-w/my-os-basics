#!/usr/bin/env bash
set -euo pipefail

ACTION="${1:-shutdown}"
APPLICATIONS=(
  brave
  cryptomator
  keepassxc
  serenade
)

quit_application() {
  local name="$1"
  pkill -TERM -x "$name" 2>/dev/null || true
}

wait_for_exit() {
  local name="$1"
  local i
  for i in {1..20}; do
    if ! pgrep -x "$name" >/dev/null; then
      return 0
    fi
    sleep 0.25
  done
}

for application in "${APPLICATIONS[@]}"; do
  quit_application "$application"
done

for application in "${APPLICATIONS[@]}"; do
  wait_for_exit "$application"
done

case "$ACTION" in
  shutdown)
    systemctl poweroff
    ;;
  reboot)
    systemctl reboot
    ;;
  logout)
    cinnamon-session-quit --logout --no-prompt
    ;;
  *)
    echo "Usage: $0 {shutdown|reboot|logout}" >&2
    exit 2
    ;;
esac

