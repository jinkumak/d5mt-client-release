# Release manifest

At release time, generate:

- `SHA256SUMS` for every delivered artifact
- `SBOM.spdx.json` from the final staged package
- completed values in `RELEASE.json`

Do not create empty checksum or SBOM placeholders.
