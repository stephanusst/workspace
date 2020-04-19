http://cygwin.1069669.n5.nabble.com/ld-cannot-perform-PE-operations-on-non-PE-output-file-bootsect-td16790.html
> *ld: cannot perform PE operations on non PE output file 'bootsect'
"  This is a known problem with the linker.  It cannot link PE files and
convert to BINARY format at the same time.  You will need to link to a PE
format file first and then use OBJCOPY to convert it to BINARY format
afterwards.  "

  You don't get this on Linux, because Linux uses ELF format object files, not
PE, which apparently ld handles fine.  The solution is as described: link it
first, then use objcopy to extract the text section and convert to binary
format.  So, you need a link command like:

ld -r -Ttext 0x0 -e _start -s -o bootsect.out bootsect.o

(we use a relocatable '-r' link because a final link would add the
__CTOR_LIST__ and __DTOR_LIST__ data in the text section; a relocatable link
will resolve any stray relocs for us without adding those tables), followed by
an objcopy like so:

objcopy -O binary -j .text bootsect.out bootsect

Try the following patch to your makefile: it adds an intermediate linked stage
called bootsect.out and then extracts the raw binary boot sector from that.

--- Makefile.orig 2006-11-14 01:19:30.214928700 +0000
+++ Makefile 2006-11-14 01:19:56.636803700 +0000
@@ -1,11 +1,15 @@
 AS=as
 LD=ld
+OBJCOPY=objcopy
 
 all: bootsect
 
-bootsect: bootsect.o
+bootsect: bootsect.out
+ @$(OBJCOPY) -O binary -j .text $< $@
+
+bootsect.out: bootsect.o
  @echo "[LD] $@"
- @$(LD) -Ttext 0x0 -s --oformat binary -o $@ $<
+ @$(LD) -Ttext 0x0 -e _start -s -o $@ $<
 
 bootsect.o: bootsect.S
  @echo "[AS] $@"


========================================================================
That's because 'as' and 'ld' on Linux and Cygwin are not configured for
the same default targets.  On Linux they create ELF objects, whereas on
Cygwin the native format is PE.  Whatever tutorial or set of
instructions you are following seem to assume an ELF assembler and
linker.

You might be able to make it work with PE by using objcopy to convert
instead of --oformat, along the lines of:

ld -Ttext 0x0 -s -o bootsect.tmp bootsect.o && \
objcopy -I pei-386 -O binary bootsect.tmp bootsect && \
rm bootsect.tmp

But this will fail if you try to do anything non-trivial that makes use
of any kind of ELF assembler directives.  Perhaps the better way to
proceed would be to build and install a cross-binutils (configure
--target=i686-pc-linux) and then use 'i686-pc-linux-as' and
'i686-pc-linux-ld' instead of 'as' and 'ld' and your Makefiles and
whatever other tutorials/samples/guides ought to all work exactly as on
an ELF system.

Brian