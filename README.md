# ReadDebugString <!-- omit in toc -->

Reads messages from the Windows debugger.


![C](https://img.shields.io/badge/C-00599C?style=flat&logo=c&logoColor=white)
![Windows](https://img.shields.io/badge/OS-Windows-0078D6?style=flat&logo=windows&logoColor=white)
[![License](https://img.shields.io/badge/License-BSD_3--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)
[![GitHub release](https://img.shields.io/github/v/release/sistools/ReadDebugString.svg)](https://github.com/sistools/ReadDebugString/releases/latest)
[![Last Commit](https://img.shields.io/github/last-commit/sistools/ReadDebugString)](https://github.com/sistools/ReadDebugString/commits/master)
[![CI](https://github.com/sistools/ReadDebugString/actions/workflows/ci.yml/badge.svg)](https://github.com/sistools/ReadDebugString/actions/workflows/ci.yml)


## Table of Contents <!-- omit in toc -->

- [Introduction](#introduction)
- [Installation](#installation)
- [Components](#components)
- [Examples](#examples)
- [Project Information](#project-information)
  - [Where to get help](#where-to-get-help)
  - [Contribution guidelines](#contribution-guidelines)
  - [Related projects](#related-projects)
  - [License](#license)


## Introduction

**ReadDebugString** is a small Windows-only utility that reads messages from
the Windows debugger.

The current implementation is a minimal buildable scaffold. Its debugger
message-reading behaviour is still being developed.


## Installation

The project uses CMake. From the project directory:

```powershell
cmake -S . -B _build
cmake --build _build --config Release
```


## Components

The project creates a single executable program, **ReadDebugString**.


## Examples

The current scaffold does not yet expose command-line options or produce
debugger output.


## Project Information


### Where to get help

[GitHub Page](https://github.com/sistools/ReadDebugString "GitHub Page")


### Contribution guidelines

Defect reports, feature requests, and pull requests are welcome on [the
**ReadDebugString** GitHub page](https://github.com/sistools/ReadDebugString).


### Related projects

Other **sistools** projects include:

* [**chomp**](https://github.com/sistools/chomp);
* [**errni**](https://github.com/sistools/errni) (errno on all platforms, and also GetLastError codes on Windows);
* [**lnunique**](https://github.com/sistools/lnunique);
* [**lslocales**](https://github.com/sistools/lslocales);
* [**lstrip**](https://github.com/sistools/lstrip);
* [**mksock**](https://github.com/sistools/mksock) (Unix-only);
* [**realpath**](https://github.com/sistools/realpath) (Windows-only);
* [**rstrip**](https://github.com/sistools/rstrip);
* [**WriteDebugString**](https://github.com/sistools/WriteDebugString) (Windows-only);


### License

**ReadDebugString** is released under the 3-clause BSD license. See [LICENSE](./LICENSE)
for details.


<!-- ########################### end of file ########################### -->
