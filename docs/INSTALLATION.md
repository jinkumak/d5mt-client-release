# D5MT+ Client Installation

## Supported target

- Raspberry Pi 5 with 4 GB RAM
- 32 GB microSD card
- Ubuntu 24.04.5 LTS Desktop, 64-bit ARM
- ROS 2 Jazzy
- ARM64 / aarch64 architecture

Ubuntu 22.04 and ROS 2 Humble packages are not compatible with this release.

## 1. Verify the target platform

Run:

```bash
lsb_release -ds
uname -m
test -f /opt/ros/jazzy/setup.bash && echo "ROS 2 Jazzy found"
```

Expected:

```text
Ubuntu 24.04.5 LTS
aarch64
ROS 2 Jazzy found
```

Stop the installation if the architecture is not `aarch64` or ROS 2 Jazzy is not installed.

## 2. Verify the D5MT+ USB adapter

Connect the hand and find its serial device:

```bash
lsusb
ls -l /dev/ttyACM* /dev/ttyUSB* 2>/dev/null
```

Inspect the selected device, for example:

```bash
udevadm info --query=property --name=/dev/ttyACM0 | \
  grep -E 'ID_VENDOR_ID|ID_MODEL_ID|ID_SERIAL_SHORT'
```

Replace `XXXX` and `YYYY` in `system/99-d5mt.rules` with the verified vendor and product IDs. If multiple identical adapters may be connected, also match the adapter serial number.

## 3. Prepare the approved release

1. Copy the approved ARM64 Debian package into `packages/`.
2. Confirm its name follows `d5mt-client_<version>_arm64.deb`.
3. Add its SHA-256 checksum to `manifest/SHA256SUMS`.
4. Confirm `manifest/RELEASE.json` matches the package version and build.
5. Confirm the license and third-party notices are complete.

Verify the checksum:

```bash
sha256sum -c manifest/SHA256SUMS
```

## 4. Install

```bash
chmod +x tools/*.sh
sudo ./tools/install.sh
```

The installer checks Ubuntu 24.04, ARM64, and ROS 2 Jazzy before installing the package.

## 5. Configure

Edit:

```bash
sudo nano /etc/d5mt/d5mt.yaml
```

Only approved operational settings should be changed. The default serial link is `/dev/d5mt`.

## 6. Verify

```bash
sudo ./tools/verify_installation.sh
```

All checks should report `[OK]`.

## 7. Service commands

```bash
sudo systemctl status d5mt.service
sudo systemctl restart d5mt.service
journalctl -u d5mt.service -f
```

## 8. Open the Web interface

Find the Raspberry Pi IP address:

```bash
hostname -I
```

Open:

```text
http://RASPBERRY_PI_IP:8080
```

## 9. Uninstall

```bash
sudo ./tools/uninstall.sh
```

The uninstaller preserves configuration and operational data.
