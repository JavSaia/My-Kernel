#!/usr/bin/env bash
# My Kernel - Build & Packaging Script for OnePlus Ace 5 Race (MT6989 / 24825)
set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KERNEL_SRC="$PROJECT_ROOT/kernel_source"
AK3_DIR="$PROJECT_ROOT/AnyKernel3"
OUT_ZIP="$PROJECT_ROOT/AnyKernel3-MyKernel-OnePlus-Ace5Race-MT6989-JavSaia-BakaSU-SUSFS.zip"

echo "=========================================================="
echo " My Kernel - OnePlus Ace 5 Race (MT6989 / 24825) Builder"
echo " Features: BakaSU + SUSFS + Reconstructed Device Tree"
echo " Signature: --by javsaia"
echo "=========================================================="

# 1. Compiler Toolchain Setup (Android Clang 17.0.2 from NDK 26)
export PATH="/home/hanbao/Android/Sdk/ndk/26.1.10909125/toolchains/llvm/prebuilt/linux-x86_64/bin:$PATH"

export ARCH=arm64
export SUBARCH=arm64
export LLVM=1
export LLVM_IAS=1
export CROSS_COMPILE=aarch64-linux-gnu-

# Set Kernel Versioning & Identity
export KBUILD_BUILD_USER="JavSaia"
export KBUILD_BUILD_HOST="OnePlus"
export LOCALVERSION="-MyKernel-oki-BakaSU-susfs"

cd "$KERNEL_SRC"

# 2. Defconfig check & generation
if [ ! -f ".config" ]; then
    echo ">> Generating .config from gki_defconfig..."
    make -j$(nproc) gki_defconfig
fi

# 3. Compile Device Tree Blob
echo ">> Compiling Reconstructed Device Tree Blob..."
make -j$(nproc) mediatek/oplus6989_24825_complete.dtb

# 4. Compile Kernel Image (with built-in optimized ZRAM)
echo ">> Compiling Kernel Image..."
make -j$(nproc) Image

if [ ! -f "arch/arm64/boot/Image" ]; then
    echo "[-] Error: Kernel Image not found!"
    exit 1
fi

echo "[+] Kernel compiled successfully: arch/arm64/boot/Image"

# Check for zram.ko if built as module
ZRAM_KO=$(find . -name "zram.ko" | head -n 1)
if [ -n "$ZRAM_KO" ]; then
    echo "[+] Found optimized ZRAM module: $ZRAM_KO"
    cp "$ZRAM_KO" "$PROJECT_ROOT/zram.ko"
    cp "$ZRAM_KO" "$AK3_DIR/zram.ko" 2>/dev/null || true
fi

# 5. Package into AnyKernel3
echo ">> Packaging AnyKernel3 zip..."
cp arch/arm64/boot/Image "$AK3_DIR/Image"
cp arch/arm64/boot/dts/mediatek/oplus6989_24825_complete.dtb "$AK3_DIR/dtb" 2>/dev/null || true

cd "$AK3_DIR"
rm -f "$OUT_ZIP"
zip -r9 "$OUT_ZIP" . -x ".*" -x "*/.*"

# Copy to Desktop for easy access
cp "$OUT_ZIP" "/home/hanbao/桌面/$(basename "$OUT_ZIP")" 2>/dev/null || true

echo "=========================================================="
echo "[+] SUCCESS: Flashable kernel zip created at:"
echo "    $OUT_ZIP"
if [ -f "$PROJECT_ROOT/zram.ko" ]; then
    echo "[+] Optimized ZRAM module: $PROJECT_ROOT/zram.ko"
fi
echo "=========================================================="
