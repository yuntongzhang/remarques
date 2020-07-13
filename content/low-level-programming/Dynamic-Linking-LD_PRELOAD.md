---
title: "LD_PRELOAD Trick"
date: 2020-06-04T13:09:10+08:00
draft: true
---

# Dynamic Linking and LD_PRELOAD

## Dynamic Linker

- A special part of an operating system that loads external shared libraries into a running process and then binds those shared libraries dynamically to the running process.
- Copies the content of libraries from disk to RAM, fills jump table and relocates pointers.

### Implementation in Unix-like systems

- An external executable (`ld.so` in Linux).
- At link time, path to the dynamic linker is embedded into the executable image.
- An run time, kernel first loads and executes the dynamic linker in a process address space newly constructed as a result of calling `exec` like functions. The dynamic linker then loads the initial executable image and all the dynamically-linked libraries on which it depends, and starts the executable.

#### Systems using ELF

- Dynamically loaded shared libraries can be identified by the filename suffix `.so` (shared object).
- The path of the dynamic linker im embedded at link time into the `.interp` section of the executable's `PT_INTERP` segment.

##### Checking shared object dependencies

The `ldd` command can be used to print out the shared object dependencies required by each program or shared object. `ldd` invokes the standard dynamic linker (`ld.so` in Linux) with the `LD_TRACE_LOADED_OBJECTS` env variable set to 1. This causes the dynamic linker to inspect the program's dynamic dependencies, find and load the dependencies objects. For each dependency, `ldd` also displays the location of the matching object and the (hex) address at which it is loaded.

##### Modify dynamic linker behavior

The dynamic linker can be influenced into modifying its behavior during either the program's linking or the program's execution. Typical modification is the use the use of `LD_LIBRARY_PATH` and `LD_PRELOAD` environment variables, which both adjust the runtime linking process.

`LD_LIBRARY_PATH` enables searching for shared libraries at alternate locations; `LD_PRELOAD` forcibly loads and links libraries that would otherwise not be used.


## The LD_PRELOAD Trick

With `LD_PRELOAD`, we can inject our own definitions to symbols which will be referenced by the executable. This is because `LD_PRELOAD` tells the linker to bind symbols provided by a certain shared library _before any other libraries_ (including the C runtime, `libc.so`).

### Usage

If we want to use a custom `malloc()` instead of that provided by `libc.so` in our program, we can write out our own definition of `malloc()` in a file such as `custom-malloc.c` and compile it to a shared library like so:

```bash
$ gcc -shared -fPIC -o custom-malloc.so custom-malloc.c
```

Then we can use `LD_PRELOAD` to make a program use our own `malloc()` definition:

```bash
$ LD_PRELOAD=$PWD/custom-malloc.so ./a.out
```

If want to load multiple (more than one) shared libraries, connect them with `:` in the `LD_PRELOAD` environment variable:

```bash
$ LD_PRELOAD=$PWD/custom-malloc.so:$PWD/another-library.so ./a.out
```


## Further Reading

This {{< remote "article by IBM" "https://developer.ibm.com/tutorials/l-dynamic-libraries/" >}} provides an excellent explanation on dynamic linking and dynamic loading in Linux.


## References

1. Linux `man` page
2. {{< remote "Wikipedia page on dynamic linker" "https://en.wikipedia.org/wiki/Dynamic_linker" >}}
3. {{< remote "StackOverflow answer" "https://stackoverflow.com/questions/426230/what-is-the-ld-preload-trick" >}}
4. {{< remote "Blog post by Peter Goldsborough" "http://www.goldsborough.me/c/low-level/kernel/2016/08/29/16-48-53-the_-ld_preload-_trick/" >}}
