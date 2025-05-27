# KTH Subsystem - Edu4Chip

This project is a 16-point FFT implementation developed using the **SiLago Workflow** at KTH.


### Pin function table

| Name        | Direction | Function                   |
| ----------- | --------- | -------------------------- |
| `clk_in`    | input     | clock                      |
| `reset_int` | input     | reset signal (active high) |
| `PADDRP<32>`| input     | APB address bus            |
| `PENABLE`   | input     | APB transfer enable        |
| `PSEL`      | input     | APB select                 |
| `PWDATA<32>`| input     | APB write data bus         |
| `PWRITE`    | input     | APB direction              |
| `PRDATA<32>`| output    | APB read data bus          |
| `PREADY`    | output    | APB ready signal           |
| `PSLVERR`   | output    | APB transfer error         |


