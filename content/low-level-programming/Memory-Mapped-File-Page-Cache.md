---
title: "Memory Mapped File Page Cache"
date: 2020-06-21T18:35:37+08:00
---

# Memory-mapped File and Page Cache

## Memory-mapped file

A memory-mapped file is a segment of **virtual memory** that has been assgined a direct byte-for-byte correlation with some portions of a file or file-like resource. This _file-like resource_ can be:

- (Typically) a file that is physically present on disk;
- A device;
- A shared memory object;
- (Some) other resource that OS can reference through a file descriptor.

This correlation between the **virtual memory space** and the **file** permits applications to treat the mapped portion as if it were primary memory. With this abstraction, any operation over that memory will be reflected to the file.

Memory maps are always aligned to the page size (typically 4KB).

### Benefits

#### Lazy loading

With memory-mapped files, it is possible to only use a small amount of RAM for very large file. Page-sized sections can be loaded as data is being edited, as memory-mapped files are loaded into memory one entire page at a time.

#### I/O performance

The main benefit of memory mapping is increasing I/O performance, especially on large files. (For small files, memory-mapped files can rsult in waste due to the page alignment requirement.)

The improved performance on read and write is because in most OS, the memory region mapped is actually the kernel's **page cache**, which means that no copies are needed to be created in user space. In contrast, if memory-mapped file is not used but a system call such as `pread()` is used, the kernel needs to copy the data from page cache into user space. The extra copying takes time and decreases the effectiveness of CPU cache by accessing this extra copy of data. 

Nevertheless, the performance boost depends on whether the actual data have to be read from the disk. If that is the case, the OS still has to read from disk, and a page fault would also incur cost although a system call is saved. But if the data is already in page cache, there should be improvement in performance.

### Common uses

#### Process loading

When a process is started, OS uses a memory-mapped file to bring the executable file nad other loadable modules into memory for execution. With {{< remote "demand paging" "https://en.wikipedia.org/wiki/Demand_paging" >}}, the OS can selectively load only those portions of a process image that actually need to be executed.

#### Share memory between processes

Two or more applications can simultaneously map a single physical file into memory and access this memory. However, since syncrhonization on the file access is not provided, the applcations have to implement mechanisms to avoid race conditions.


## Page cache

A page cache is a transparent cache for the pages originating from disk. The OS keeps a page cache in unused portions of the RAM, resulting in quicker access to the contents of cached pages.

Usually all physical memory not directly allocated to applications is used by OS for page cache.

Executable binaries are typically accessed through page cache. `mmap` would map the binary in page cache to the virtual memory space of an individual process. This enables sharing of binaries between separate processes, as well as the fast loading of program code.


## References

1. {{< remote "Wikipedia page on memory-mapped file" "https://en.wikipedia.org/wiki/Memory-mapped_file" >}}
2. {{< remote "C# Valut post on memory-mapped file" "https://csharpvault.com/memory-mapped-files/" >}}
3. {{< remote "StackOverflow answer" "https://stackoverflow.com/questions/192527/what-are-the-advantages-of-memory-mapped-files" >}}
4. {{< remote "Wikipedia page on page cache" "https://en.wikipedia.org/wiki/Page_cache" >}}
5. {{< remote "Blog post on page cache" "https://manybutfinite.com/post/page-cache-the-affair-between-memory-and-files/" >}}
