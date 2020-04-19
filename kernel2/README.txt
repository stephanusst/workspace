Save the code as test.S file. On the command prompt type the below:

as test.S -o test.o
ld –Ttext 0x7c00 --oformat=binary test.o –o test.bin