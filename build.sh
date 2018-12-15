#!/bin/bash

set -e
rm -rf lk
git clone https://github.com/littlekernel/lk.git

readonly url="https://releases.linaro.org/components/toolchain/binaries/7.3-2018.05/aarch64-elf/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-elf.tar.xz"

toolchain_path=lk/toolchain
tool_name=gcc-aarch64-elf.tar.xz
if [ -d "${toolchain_path}" ]; then
	rm -rf -- "${toolchain_path}"
fi
mkdir -p ${toolchain_path}
rm -f -- "${tool_name}"
echo "Downloading ${url}"
curl -continue-at=- --location --output "${tool_name}" "${url}"
echo "Unpacking ${tool_name}"
tar -xf ${tool_name} -C ${toolchain_path}
rm -f -- "${tool_name}"
sed -i '1i-include config.mk' lk/engine.mk
echo 'DEFAULT_PROJECT ?= rpi3-test' > lk/lk_inc.mk
echo 'ARCH_arm64_TOOLCHAIN_PREFIX := ./toolchain/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-elf/bin/aarch64-elf-' >lk/config.mk
cd lk
make
