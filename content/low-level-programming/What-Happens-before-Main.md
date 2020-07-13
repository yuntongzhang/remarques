---
title: "What Happens Before Main"
date: 2020-06-25T17:55:43+08:00
---

# What happens before `main()`?

For dynamically loaded x86 ELF files on Linux, what happens before `main()` gets to run? The following graph demonstrates the entire process, including things happened before `main` and after `main`. (It should be read in a depth-first manner.)

<img src="/low-level-programming/what-happens-before-main.png" alt="Function called before and after main()" width="90%" />


## How to get to `_start`?

When a program is run, the parent process calls `execve()`. The `execve()` call sets up the stack, and pushes onto it `argc`, `argv` and `envp`. The loader sets up relocations and calls the preinitializers. When everything is ready, the control is handed from the loader to the program by calling `_start()`.


## What does `__libc_start_main` do?

In general, the function `__libc_start_main` carrying out the following tasks:

- Takes can of some security problems with setuid setgid programs;
- Starts up threading;
- Registers the `fini` (for the program) and `rtld_fini` (for the runtime loader) arguments to get run by `at_exit` to run the program's and the loader's cleanup routines;
- Calls the `init` argument (set to `__libc_csu_init`);
- Calls `main`;
- Calls `exit` with the return value of `main`.


## The C level constructor: `__libc_csu_init`

Every executable gets a C level constructor `__libc_csu_init` and a C level destructor, `__libc_csu_fini`. Here is the actual code for `__libc_csu_init`:

```c
void __libc_csu_init(int argc, char **argv, char **envp) {
    _init();
    const size_t size = __init_array_end - __init_array_start;
    for (size_t i = 0; i < size; i++)
        (*__init_array_start [i])(argc, argv, envp);
}
```

There are two parts of this function. Firstly, `_init` calls the function `__do_global_ctors_aux`, which calls the constructors for global objects. Secondly, the loop runs functions in the `__init_array`, which is run after the constructors and we can also add some functions to run in this phase (example later on).


## Calling constructors for global objects: `__do_global_ctors_aux`

If there is some problem in a program before `main` starts, this is probably where it can happen. Constructors for global C++ objects are put in the `.CTORS` section in an ELF file, and `__do_global_ctors_aux` is the auxillary function which the compiler creates for walking through the `.CTORS` section and calling these constructors.

This is also where we can provide our own construtors to be executed. To tell `gcc` that the linker should stick a pointer to a customized function in the table used by `__do_global_ctors_aux`, we can use `__attribute__((constructor))`. Below is an example of inserting such a function (`__FUNCTION__` is filled in by the compiler with the name of the function):

```c
#include <stdio.h>
void __attribute__((constructor)) a_constructor() {
    printf("%s ", __FUNCTION__);
}
int main() {
    printf("%s", __FUNCTION__);
}
// result of execution:
// a_constructor main
```


## Now, what about `exit`?

After `main` returns, the result is passed to `exit` and `exit` is executed. `exit` does the following in order:

- Runs the functions registered with `at_exit` in the order they were added;
- Runs the functions in the `__fini_array`;
- Runs the destructors.


## What functions can we insert?

There are functions that can be inserted in these different phases. The example below demonstrates where and how these functions can be inserted, and also illustrates the sequences of the different stages:

```c
#include <stdio.h>
void preinit(int argc, char **argv, char **envp) {
    printf("%s\n", __FUNCTION__);
}
void init(int argc, char **argv, char **envp) {
    printf("%s\n", __FUNCTION__);
}
void fini() {
    printf("%s\n", __FUNCTION__);
}
__attribute__((section(".init_array"))) typeof(init) *__init = init;
__attribute__((section(".preinit_array"))) typeof(preinit) *__preinit = preinit;
__attribute__((section(".fini_array"))) typeof(fini) *__fini = fini;

void  __attribute__((constructor)) constructor() {
    printf("%s\n", __FUNCTION__);
}
void __attribute__((destructor)) destructor() {
    printf("%s\n", __FUNCTION__);
}
void my_atexit() {
    printf("%s\n", __FUNCTION__);
}
void my_atexit2() {
    printf("%s\n", __FUNCTION__);
}

int main() {
    atexit(my_atexit);
    atexit(my_atexit2);
}
```

The result of executing the program above is:

```bash
$ ./prog
preinit
constructor
init
my_atexit2
my_atexit
fini
destructor
```

This result is align with the graph at the beginning of this post.


## References

1. {{< remote "Post by Patrick Horgan on DBP Consulting" "http://dbp-consulting.com/tutorials/debugging/linuxProgramStartup.html" >}}
2. {{< remote "StackOverflow post on `__do_global_ctors_aux`" "https://stackoverflow.com/questions/6477494/do-global-dtors-aux-and-do-global-ctors-aux" >}}
