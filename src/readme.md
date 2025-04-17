# src

This folder contains and organizes local source files. Matching IPXACT should be in ipxact with correct hierarchy.

Filelist should contain files for each source type.

Use Bender to generate file list.

For simulation:

```
bender -d ./sv/tb script -t sim flist > hdl-files.list
```

For synthesis
```
bender -d ./sv/tb script -t tsmc28 flist > hdl-files.list
```
