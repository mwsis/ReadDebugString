# ReadDebugString - Installation and Use <!-- omit in toc -->


## Building

The primary build method is **CMake**. From a Visual Studio developer
environment:

```powershell
cmake -S . -B _build
cmake --build _build --config Release
```

If **STLSoft** is not installed as a CMake package, provide its source-tree
root:

```powershell
cmake -S . -B _build -DSTLSOFT=C:\path\to\STLSoft
cmake --build _build --config Release
```

The resulting executable is installed with:

```powershell
cmake --install _build --config Release
```


## Command-line use

The program is intended to remain running while it reads messages from the
Windows debugger. Use `--help` or `--version` for commands that terminate
immediately:

```powershell
ReadDebugString.exe --help
ReadDebugString.exe --version
```


<!-- ########################### end of file ########################### -->
