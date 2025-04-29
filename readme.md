# KTH Subsystem - Edu4Chip

This project is a small FFT implementation developed at KTH using the **SiLago Framework**.

A library of all the coarse-grain components required to implement the FFT, such as the Butterfly Unit, Address Generation Unit (AGU), and Data Processing Unit (DPU) for complex numbers, has been created.

The **Vesyla-Suite ** uses this component library to generate the *subsystem* and the corresponding *binary file*.

🔗 For more details on Vesyla-Suite and the component library, visit:  
[https://github.com/silagokth/drra-components](https://github.com/silagokth/drra-components)

### Pin function table

| Name        | Direction | Function                   |
| ----------- | --------- | -------------------------- |
| `Clock`     | input     | clock                      |
| `Reset`     | input     | reset signal (active high) |
| `P<signal>` | input     | APB interface              |
| `irq_o`     | output    | unused                     |
| `sync_o`    | output    | synchronisation signal     |

