---
title: "ELF File on Linux"
date: 2020-06-25T16:18:47+08:00
draft: true
---

# ELF File on Linux

## Introduction

This {{< remote "post from Linux Audit" "https://linux-audit.com/elf-binaries-on-linux-understanding-and-analysis/" >}} offers a good introduction to ELF files.

## Details

Refer to the {{< remote "ELF file reference document" "http://www.skyfree.org/linux/references/ELF_Format.pdf" >}} for detailed documentation of ELF file format.

## Useful tools

To work with ELF file, there are a few useful tools:

- `readelf`: read information about different component of an ELF file.
- `dumpelf`: dump the entire internal ELF structure.
- `vbindiff`: find differences between two ELF files.
