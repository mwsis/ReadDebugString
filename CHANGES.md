# ReadDebugString - Changes <!-- omit in toc -->


## 0.0.1 - 24th August 2026

* Replaced the initial executable scaffold with a Windows debugger message reader;
* Added process identification to reader output;
* Improved error handling for Windows file-mapping and debugger access failures;
* Improved CMake flexibility for uninstalled **STLSoft** source trees supplied via **STLSOFT**;
* Added validation and an imported **STLSoft::STLSoft** target for local STLSoft source trees;
* Added Windows **cl** and MinGW CI configuration with STLSoft source checkout;
* Added an installation smoke test using **--version** so the long-running reader is not started;
* Added a section-1 reference page and installed it with CMake;


## 0.0.0 - 16th August 2026

* Added the initial Windows-only **ReadDebugString** executable scaffold;
* Added **--help** and **--version** command-line handling;
* Added CMake configuration, helper scripts, and editor settings;


<!-- ########################### end of file ########################### -->
