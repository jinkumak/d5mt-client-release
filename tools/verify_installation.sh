#!/usr/bin/env bash
set -euo pipefail

failed=0

check() {
  local description="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    printf '[OK] %s\n' "${description}"
  else
    printf '[FAIL] %s\n' "${description}" >&2
    failed=1
  fi
}

check "Ubuntu 24.04 installed"   bash -c 'source /etc/os-release && [[ "$ID" == "ubuntu" && "$VERSION_ID" == "24.04" ]]'
check "ARM64 architecture"   bash -c '[[ "$(dpkg --print-architecture)" == "arm64" ]]'
check "ROS 2 Jazzy installed"   test -f /opt/ros/jazzy/setup.bash
check "D5MT+ service account available"   id d5mt
check "D5MT+ package installed"   dpkg-query -W d5mt-client
check "Configuration installed"   test -f /etc/d5mt/d5mt.yaml
check "Runtime launcher installed"   test -x /opt/double-giken/d5mt/bin/d5mt-launch
check "Service enabled"   systemctl is-enabled d5mt.service
check "Service active"   systemctl is-active d5mt.service
check "Device link available"   test -e /dev/d5mt

exit "${failed}"
