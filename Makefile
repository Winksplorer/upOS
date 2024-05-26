# Makefile: upOS Makefile.
# Licensed under the MIT license.

# Toolchain
CC = gcc
AS = nasm

CCFLAGS = \
	-g \
	-O0 \
	-m32 \
	-std=c99 \
	-Wall \
	-I src \
	-Wextra \
	-fno-pie \
	-nostdlib \
	-ffreestanding \
	-fno-stack-protector

ASFLAGS = \
	-f elf

BOOTSECT_SRCS = \
	src/stage0.S

BOOTSECT_OBJS = $(addprefix bin/, $(notdir $(BOOTSECT_SRCS:.S=.o)))

KERNEL_C_SRCS = $(wildcard src/*.c)
KERNEL_S_SRCS = $(filter-out $(BOOTSECT_SRCS), $(wildcard src/*.S))

KERNEL_OBJS = $(addprefix bin/, $(notdir $(KERNEL_C_SRCS:.c=.o) $(KERNEL_S_SRCS:.S=.o)))

IMAGE_NAME = upOS

all: dirs hdd run

run:
	qemu-system-i386 -debugcon stdio -drive file=upOS.hdd,format=raw | xxd

dirs:
	mkdir -p bin

clean: clean_objs
	rm -rf bin

clean_objs:
	rm -f $(BOOTSECT_OBJS) $(KERNEL_OBJS)

bin/%.o: src/%.S
	$(AS) $(ASFLAGS) -o $@ $<

bin/%.o: src/%.c
	$(CC) -o $@ -c $< $(CCFLAGS)

bootsect: $(BOOTSECT_OBJS)
	$(LD) -m elf_i386 -o bin/bootsect.bin $^ -Ttext 0x7C00 --oformat=binary

kernel: $(KERNEL_OBJS)
	$(LD) -m elf_i386 -nostdlib -o bin/kernel.bin $^ -Tsrc/link.ld

hdd: bootsect kernel
	dd if=/dev/zero of=upOS.hdd bs=512 count=2880
	dd if=bin/bootsect.bin of=upOS.hdd conv=notrunc bs=512 seek=0 count=1
	dd if=bin/kernel.bin of=upOS.hdd conv=notrunc bs=512 seek=1 count=2048