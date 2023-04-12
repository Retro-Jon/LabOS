CC = i686-w64-mingw32-gcc

BIN_DIR = bin

BOOTLOADER_DIR = src/bootloader
LABOS_DIR = src/labos

BOOTLOADER_SRC = $(BOOTLOADER_DIR)/mbr.asm
KERNEL_SRC = $(wildcard $(LABOS_DIR)/kernel/*.c)

BOOTLOADER_TARGET = mbr.bin
KERNEL_OBJECT = kernel.o

OS_TARGET = os.bin

IMAGE = labos.img

all: bootloader kernel os-image

all-qrun: all qrun

all-vrun: all vrun

bootloader:
	nasm -f bin $(BOOTLOADER_SRC) -o $(BIN_DIR)/$(BOOTLOADER_TARGET)

kernel:
	$(CC) -Wall -ffreestanding -m32 -c $(KERNEL_SRC) -o $(BIN_DIR)/$(KERNEL_OBJECT)

	objcopy -O binary -j .text $(BIN_DIR)\$(KERNEL_OBJECT) $(BIN_DIR)\$(OS_TARGET)

os-image:
	copy /B $(BIN_DIR)\$(BOOTLOADER_TARGET) + $(BIN_DIR)\$(OS_TARGET) $(BIN_DIR)\$(IMAGE)

qrun:
	qemu-system-i386 -hda $(BIN_DIR)\$(IMAGE)

vrun:
	vboxmanage startvm "LabOS"
