# D5MT+ Client Installation

## Supported target

- Raspberry Pi 5 with 4 GB RAM
- 32 GB microSD card
- Ubuntu 22.04 LTS, 64-bit
- ROS 2 Humble
- ARM64 architecture

## Before installation

1. Confirm the operating system and ROS 2 versions.
2. Connect the D5MT+ hand and confirm its USB vendor and product IDs.
3. Replace `XXXX` and `YYYY` in `system/99-d5mt.rules`.
4. Copy the approved Debian package into `packages/`.
5. Verify the package against `manifest/SHA256SUMS`.

## Install

```bash
chmod +x tools/*.sh
sudo ./tools/install.sh
```

## Configure

Edit `/etc/d5mt/d5mt.yaml`. Only approved operational settings should be changed.

## Verify

```bash
sudo ./tools/verify_installation.sh
```

## Service commands

```bash
sudo systemctl status d5mt
sudo systemctl restart d5mt
journalctl -u d5mt
```

## Uninstall

```bash
sudo ./tools/uninstall.sh
```

The uninstaller preserves configuration and operational data.
