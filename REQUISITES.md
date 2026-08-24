# ReadDebugString - Requisites <!-- omit in toc -->


## Introduction

Building **ReadDebugString** requires **CMake** 3.20 or later and a Windows
C++ toolchain supporting C++17.


## Required dependencies

**ReadDebugString** depends on:

* [**STLSoft**](https://github.com/synesissoftware/STLSoft) 1.11.1 or later;

An installed **STLSoft** CMake package is used by default. An uninstalled
source tree may be supplied through the **STLSOFT** CMake variable, the
**STLSOFT** environment variable, or **prepare_cmake.sh --stlsoft-root-dir**.


## Operating system

The program targets Microsoft Windows and uses the Windows debugger APIs.


<!-- ########################### end of file ########################### -->
