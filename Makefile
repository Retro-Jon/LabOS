CC = i686-w64-mingw32-gcc

BIN_DIR = bin

BOOTLOADER_DIR = src/bootloader
LABOS_DIR = src/labos

BOOTLOADER_SRC = $(BOOTLOADER_DIR)/mbr.asm
KERNEL_SRC = $(wildcard $(LABOS_DIR)/kernel/*.c)

KERNEL_ENTRY_SRC = $(LABOS_DIR)/kernel/kernel_entry.asm
KERNEL_ENTRY_OBJECT = kernel_entry.o

BOOTLOADER_TARGET = mbr.bin
KERNEL_OBJECT = kernel.o

KERNEL_BIN = kernel.bin

OS_TARGET = os.bin

IMAGE = labos.img

all: $(BOOTLOADER_TARGET) $(KERNEL_OBJECT) $(OS_TARGET) $(IMAGE)

all-db-qrun: all db-qrun

all-qrun: all qrun

all-vrun: all vrun

$(BOOTLOADER_TARGET): $(BOOTLOADER_SRC)
	nasm -f bin $^ -o $(BIN_DIR)/$@

$(KERNEL_OBJECT): $(KERNEL_SRC)
	$(CC) -ffreestanding -no-pie -c $^ -o $(BIN_DIR)/$@

$(OS_TARGET): $(BIN_DIR)/$(KERNEL_OBJECT)
	objcopy -O binary -j .text $^ $(BIN_DIR)/$@

$(IMAGE):
	copy /B $(BIN_DIR)\$(BOOTLOADER_TARGET) + $(BIN_DIR)\$(OS_TARGET) $(BIN_DIR)\$@

db-qrun:
	qemu-system-i386 -hda $(BIN_DIR)/$(IMAGE) -d in_asm,int -no-reboot

qrun:
	qemu-system-i386 -hda $(BIN_DIR)/$(IMAGE)

vrun:
	vboxmanage startvm "LabOS"
