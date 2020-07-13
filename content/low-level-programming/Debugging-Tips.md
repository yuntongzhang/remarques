---
title: "Debugging Tips"
date: 2020-06-22T10:25:12+08:00
---

# Debugging Tips

Some debugging tips and tricks with GDB and other tools.

## List all mapped memory regions

```c
(gdb) help info proc
Show /proc process information about any running process.
Specify any process id, or use the program being debugged by default.
Specify any of the following keywords for detailed info:
  mappings -- list of mapped memory regions.
  stat     -- list a bunch of random process info.
  status   -- list a different bunch of random process info.
  all      -- list all available /proc info.
```

To list all the mapped memory regions (when there is `/proc`), use:

```c
(gdb) info proc mappings
```

When there is no `/proc` (such as during post-mortem debugging), use:

```c
(gdb) maintenance info sections
```


## Recover from corrupted stack frame

Sometimes, the program receives `SIGSEGV` and `backtrace` shows very small addresses (such as `0x00000000`) as the PC values pointing to the stack frames. Most likely, this is due to calling through a bogus function pointer which results in the stack frame being corrupted.

Often times, an indirect call instruction pushes the PC after the call onto the stack and then sets the PC to the target value (which is the bogus address). Debugging information shown is usually not useful in this case, but we can recover the backtrace information by undoing the function call and manually popping the PC off the stack. On 64-bit x86 machine, the steps are:

```c
(gdb) set $rip = *(void **)$rsp
(gdb) set $rsp = $rsp + 8
```

Afterwards, `backtrace` should give more useful information and show where the execution really is. If the above does not work, repeat it a few times may help.


## Display each instruction executed

Sometimes we want to see all the instructions executed starting from one point in the program. This applies to several senarios, such as:

- A bug appears in the place where we do not have access to source or symbols;
- We want to understand the flow of execution better.

We can achieve it by first setting breakpoint at the place we want to start printing instructions, and then use the following commands:

```c
# not required but nice to have log
(gdb) set logging on
# ask gdb to not stop every screen-full
(gdb) set height 0
# start printing executed instructions
(gdb) while 1
 > x/i $rip
 > stepi
 > end
```


## Compare two binary files

When working with binary rewritting or some other applications, it is useful to compare two binaries and check the differences between them.

If only want to know **whether** two binaries are different, we can use:

```sh
$ diff 1.bin 2.bin
Binary files 1.bin and 2.bin differ
```

However, if we want to see the places where the two binaries differ, we should use `vbindiff` instead:

```sh
$ vbindiff 1.bin 2.bin
```


## References

1. {{< remote "GDB: Listing all mapped memory regions for a crashed process" "https://stackoverflow.com/questions/5691193/gdb-listing-all-mapped-memory-regions-for-a-crashed-process" >}}
2. {{< remote "GDB corrupted stack frame - How to debug?" "https://stackoverflow.com/questions/9809810/gdb-corrupted-stack-frame-how-to-debug" >}}
3. {{< remote "Displaying each assembly instruction executed in gdb" "https://stackoverflow.com/questions/8841373/displaying-each-assembly-instruction-executed-in-gdb" >}}
4. {{< remote "How to compare binary files to check if they are the same?" "https://stackoverflow.com/questions/12118403/how-to-compare-binary-files-to-check-if-they-are-the-same" >}}
