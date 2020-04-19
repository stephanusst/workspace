REM ld –Ttext 0x7c00 --oformat=binary test.o –o test.bin
REM The –Ttext 0x7c00 tells the linker you want your "text" (code segment) address to be loaded to 0x7c00 and thus it calculates the correct address for absolute addressing.
REM The --oformat=binary switch tells the linker you want your output file to be a plain binary image (no startup code, no relocations, ...).
REM   You don't get this on Linux, because Linux uses ELF format object files, renot
REM PE, which apparently ld handles fine.  The solution is as described: link it
REM first, then use objcopy to extract the text section and convert to binary
REM format.  So, you need a link command like:
REM 
REM ld -r -Ttext 0x0 -e _start -s -o bootsect.out bootsect.o
REM (we use a relocatable '-r' link because a final link would add the
REM __CTOR_LIST__ and __DTOR_LIST__ data in the text section; a relocatable link
REM will resolve any stray relocs for us without adding those tables), followed by
REM an objcopy like so:
REM 
REM objcopy -O binary -j .text bootsect.out bootsect
REM 
REM Try the following patch to your makefile: it adds an intermediate linked stage
REM called bootsect.out and then extracts the raw binary boot sector from that.

ld -r -Ttext 0x7c00 -e _start -s o test.out test.out
