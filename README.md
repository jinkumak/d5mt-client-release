# D5MT+ Client Release

Private distribution repository for the Double Giken D5MT+ ROS 2 client runtime.

## Target platform

- Raspberry Pi 5
- 4 GB RAM
- 32 GB microSD card
- ARM64 / aarch64
- Ubuntu 22.04 LTS
- ROS 2 Humble

## Repository purpose

This repository contains approved client-facing release artifacts, configuration templates, installation tools, documentation, and legal notices. Complete source code and internal development history must remain in the internal development repository.

## Release contents

```text
packages/   Signed ARM64 Debian package
config/     Client-editable configuration template
system/     systemd and udev integration
tools/      Installation and verification tools
docs/       Client installation guide and manuals
legal/      License, copyright, and third-party notices
manifest/   Release metadata, checksums, and SBOM
```

## Security rules

Never commit source workspaces, `.git` exports, tests, credentials, private keys, TLS keys, environment files, internal documents, debug data, or unapproved development artifacts.

The release package and PDF manual are added only after an approved build. Do not use empty placeholder files with release artifact names.

Copyright © 2026 Double Giken Co., Ltd. All rights reserved.
