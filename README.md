# My Kernel - OnePlus Ace 5 Race

Custom Linux 6.1 kernel for **OnePlus Ace 5 Race** (MediaTek Dimensity 9300 / MT6989 / Project 24825).

## Features

- **Upstream Base**: Linux 6.1-android14 (OnePlus OSS)
- **Root & Stealth**: [BakaSU](https://github.com/Baka-SU/BakaSU) + [SUSFS](https://gitlab.com/simonpunk/susfs4ksu) v2.3.0
- **Device Tree**: Complete reconstructed monolithic DTS (`oplus6989_24825_complete.dts`)
- **Memory**: ZRAM with ARMv8-optimized LZ4 assembly (`lz4armv8.S`) + ZSTD + Writeback
- **Compatibility**: OKI (OxygenOS / ColorOS 15 & 16)
- **Signature**: Official build watermark `--by javsaia`

## Device Info

| Device | Model | SoC | Project |
| :--- | :--- | :--- | :--- |
| OnePlus Ace 5 Race | PLF110 | MediaTek Dimensity 9300 (MT6989) | 24825 |

## Building

### Requirements
- Linux x86_64
- Clang 17.0.2+ (Android NDK r26 / AOSP Clang)
- Standard build essentials (`make`, `bison`, `flex`, `libssl-dev`, `zip`)

### Build & Package
```bash
./build.sh
```

Output flashable zip will be generated in the root directory:
```
AnyKernel3-MyKernel-OnePlus-Ace5Race-MT6989-JavSaia-BakaSU-SUSFS.zip
```

## License

Licensed under [GPL-2.0](LICENSE). Contains strictly open-source code and reconstructed Device Tree definitions.
