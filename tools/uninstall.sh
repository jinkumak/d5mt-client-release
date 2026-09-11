#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run this uninstaller with sudo." >&2
  exit 1
fi

systemctl disable --now d5mt.service 2>/dev/null || true
apt-get remove -y d5mt-client
rm -f /etc/systemd/system/d5mt.service
rm -f /etc/udev/rules.d/99-d5mt.rules
systemctl daemon-reload
udevadm control --reload-rules

echo "Software removed. Configuration and operational data were preserved."
