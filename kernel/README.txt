-ffreestanding
	Assert that compilation targets a freestanding environment. This implies
	‘-fno-builtin’. A freestanding environment is one in which the standard
	library may not exist, and program startup may not necessarily be at
	main. The most obvious example is an OS kernel. This is equivalent to
	‘-fno-hosted’.
	See Chapter 2 [Language Standards Supported by GCC], page 5, for details of
	freestanding and hosted environments.

1. void main() diganti start()

The first thing you'll need to is change the name of you function. If you call it main the MinGW version of GCC will insert a call to __main to do initialization. For example:

start() {
   char *video_memory = 0xb8000;
   *video_memory = 'X';
}
2. gcc -ffreestanding -c kernel.c -o kernel.o
Ada problem gcc tidak bisa eksekusi cc1 di subystem windows, jadi kita pakai cygwin.


This means you'll also have to edit kernel_entry.asm accordingly:

[bits 32]
[extern _start]
call _start
jmp $ 
Next compile and assemble the two files as you did before, and link it with these commands:

ld -o basic.bin -Ttext 0x0 --oformat binary basic.o
3. ndisasm -b 32 basic.bin > basic.dis
4. cat boot sect.bin kernel.bin > os-image


ld -T NUL -o kernel.tmp -Ttext 0x1000 kernel_entry.o kernel.o
objcopy -O binary -j .text  kernel.tmp kernel.bin 
The first command links the objects as a PECOFF executable, and then the second command converts it to a binary. Now combine the binary with the boot loader:

copy /b boot_sect.bin+kernel.bin os-image