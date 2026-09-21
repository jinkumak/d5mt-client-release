#!/usr/bin/env bash
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  echo "Run this installer with sudo." >&2
  exit 1
fi

if [[ ! -r /etc/os-release ]]; then
  echo "Cannot identify the operating system." >&2
  exit 1
fi

# shellcheck disable=SC1091
source /etc/os-release

if [[ "${ID:-}" != "ubuntu" || "${VERSION_ID:-}" != "24.04" ]]; then
  echo "Unsupported OS. Ubuntu 24.04 LTS is required." >&2
  exit 1
fi

ARCH="$(dpkg --print-architecture)"
if [[ "${ARCH}" != "arm64" ]]; then
  echo "Unsupported architecture: ${ARCH}. ARM64 is required." >&2
  exit 1
fi

if [[ ! -f /opt/ros/jazzy/setup.bash ]]; then
  echo "ROS 2 Jazzy was not found at /opt/ros/jazzy." >&2
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PACKAGE="$(find "${ROOT_DIR}/packages" -maxdepth 1 -type f -name 'd5mt-client_*_arm64.deb' -print -quit)"

if [[ -z "${PACKAGE}" ]]; then
  echo "Approved ARM64 D5MT+ Debian package not found." >&2
  exit 1
fi

if grep -q 'XXXX\|YYYY' "${ROOT_DIR}/system/99-d5mt.rules"; then
  echo "Replace XXXX and YYYY in system/99-d5mt.rules before installation." >&2
  exit 1
fi

if ! getent group d5mt >/dev/null; then
  groupadd --system d5mt
fi

if ! id d5mt >/dev/null 2>&1; then
  useradd     --system     --gid d5mt     --home-dir /var/lib/d5mt     --shell /usr/sbin/nologin     d5mt
fi

usermod -aG dialout d5mt

install -d -m 0755 /etc/d5mt
install -d -o d5mt -g d5mt -m 0755 /var/lib/d5mt /var/log/d5mt

if [[ ! -f /etc/d5mt/d5mt.yaml ]]; then
  install -o root -g d5mt -m 0640     "${ROOT_DIR}/config/d5mt.yaml.example"     /etc/d5mt/d5mt.yaml
fi

install -m 0644   "${ROOT_DIR}/system/d5mt.service"   /etc/systemd/system/d5mt.service

install -m 0644   "${ROOT_DIR}/system/99-d5mt.rules"   /etc/udev/rules.d/99-d5mt.rules

udevadm control --reload-rules
udevadm trigger

apt-get install -y "${PACKAGE}"

systemctl daemon-reload
systemctl enable --now d5mt.service

echo "D5MT+ client installation completed."
