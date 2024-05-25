# Makefile: upOS Makefile.
# Licensed under the MIT license.

# Toolchain
AS = nasm

ASFLAGS = \
	-f bin

IMAGE_NAME = upOS

all: dirs build link run

dirs:
	mkdir -p bin
	touch bin/bootloader.bin
	touch bin/kernel.bin

build:
	$(AS) $(ASFLAGS) -o bin/bootloader.bin src/bootloader/stage0.S
	$(AS) $(ASFLAGS) -o bin/kernel.bin src/kernel/entry.S

link:
	cat bin/bootloader.bin bin/kernel.bin > bin/$(IMAGE_NAME).img

run:
	qemu-system-i386 -drive format=raw,file=bin/$(IMAGE_NAME).img

clean:
	rm -rf bin