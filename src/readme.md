# src

This folder contains and organizes the local source files for a 16-point FFT implementation using a single SiLago cell.

Use Bender to generate file list.

For simulation:

```
bender -d ./tb script -t sim flist > hdl_files.list
```

For synthesis
```
bender -d ./tb script -t gf22 flist > hdl_files.list
```
