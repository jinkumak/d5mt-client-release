#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run this installer with sudo." >&2
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PACKAGE="$(find "${ROOT_DIR}/packages" -maxdepth 1 -type f -name 'd5mt-client_*_arm64.deb' -print -quit)"

if [[ -z "${PACKAGE}" ]]; then
  echo "Approved ARM64 D5MT+ Debian package not found." >&2
  exit 1
fi

install -d -m 0755 /etc/d5mt /var/lib/d5mt /var/log/d5mt
if [[ ! -f /etc/d5mt/d5mt.yaml ]]; then
  install -m 0640 "${ROOT_DIR}/config/d5mt.yaml.example" /etc/d5mt/d5mt.yaml
fi
install -m 0644 "${ROOT_DIR}/system/d5mt.service" /etc/systemd/system/d5mt.service

if ! grep -q 'XXXX\|YYYY' "${ROOT_DIR}/system/99-d5mt.rules"; then
  install -m 0644 "${ROOT_DIR}/system/99-d5mt.rules" /etc/udev/rules.d/99-d5mt.rules
  udevadm control --reload-rules
fi

apt-get install -y "${PACKAGE}"
systemctl daemon-reload
systemctl enable --now d5mt.service

echo "D5MT+ client installation completed."
