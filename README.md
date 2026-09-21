# D5MT+ Client Release

Private distribution repository for the Double Giken D5MT+ ROS 2 client runtime.

## Target platform

- Raspberry Pi 5
- 4 GB RAM
- 32 GB microSD card
- ARM64 / aarch64
- Ubuntu 24.04.5 LTS Desktop
- ROS 2 Jazzy

The approved client package must be built on ARM64 for Ubuntu 24.04 and ROS 2 Jazzy. Packages built for Ubuntu 22.04 / ROS 2 Humble are not supported by this release.

## Repository purpose

This repository contains approved client-facing release artifacts, configuration templates, installation tools, documentation, and legal notices. Complete source code and internal development history must remain in the internal development repository.

## Release contents

```text
packages/   Signed ARM64 Debian package
config/     Client-editable configuration template
system/     systemd and udev integration
tools/      Installation and verification tools
docs/       Client user manuals
legal/      License, copyright, and third-party notices
manifest/   Release metadata, checksums, and SBOM
```

## Client installation

Before installation, verify the target:

```bash
lsb_release -ds
uname -m
test -f /opt/ros/jazzy/setup.bash
```

Expected platform:

```text
Ubuntu 24.04.5 LTS
aarch64
ROS 2 Jazzy installed at /opt/ros/jazzy
```

Install and verify the approved package with the repository tools:

```bash
chmod +x tools/*.sh
sudo ./tools/install.sh
sudo ./tools/verify_installation.sh
```

The package installs and enables `d5mt.service`. Check it with:

```bash
systemctl is-enabled d5mt.service
systemctl is-active d5mt.service
sudo journalctl -u d5mt.service -n 100 --no-pager
```

Open the client Web interface at:

```text
https://192.168.0.210:8080/
```

A self-signed certificate warning may appear during the first connection.

## Documentation

- [5DMT+ ロボットハンド ユーザーマニュアル（日本語）](docs/5DMT_PLUS_USER_MANUAL_JA.md)

## Security rules

Never commit source workspaces, `.git` exports, tests, credentials, private keys, TLS keys, environment files, internal documents, debug data, or unapproved development artifacts.

Python, HTML, CSS, and JavaScript files included in a Debian package can be inspected by the recipient. Proprietary serial-control, command-validation, and safety logic should be distributed as approved compiled C++ binaries.

The release package and PDF manual are added only after an approved build. Do not use empty placeholder files with release artifact names.

Copyright © 2026 Double Giken Co., Ltd. All rights reserved.
