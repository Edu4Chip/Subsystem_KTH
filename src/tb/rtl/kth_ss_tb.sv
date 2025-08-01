`timescale 1ps/1fs;

module kth_ss_tb();
  
  // no top params allowed

  localparam INSTR_BASE_ADDR     = kth_ss_inst.INSTR_BASE_ADDR;
  localparam INSTR_SIZE_BYTES    = kth_ss_inst.INSTR_SIZE_BYTES;
  localparam DATA_IN_BASE_ADDR   = kth_ss_inst.DATA_IN_BASE_ADDR;
  localparam DATA_IN_SIZE_BYTES  = kth_ss_inst.DATA_IN_SIZE_BYTES;
  localparam DATA_OUT_BASE_ADDR  = kth_ss_inst.DATA_OUT_BASE_ADDR;
  localparam DATA_OUT_SIZE_BYTES = kth_ss_inst.DATA_OUT_SIZE_BYTES;
  localparam CTRL_BASE_ADDR      = kth_ss_inst.CTRL_BASE_ADDR;
  localparam CTRL_SIZE_BYTES     = kth_ss_inst.CTRL_SIZE_BYTES;

  logic [31:0] PADDR;
  logic        PENABLE;
  logic        PSEL;
  logic [31:0] PWDATA;
  logic        PWRITE;
  logic [31:0] PRDATA;
  logic        PREADY;
  logic        PSLVERR;
  logic        clk_in;
  logic        reset_int;
  logic        high_speed_clk;             
  logic        irq_3;                      
  logic        irq_en_3;                   
  logic [7:0]  ss_ctrl_3;                  
  logic [15:0] pmod_gpi;                  
  logic [15:0] pmod_gpo;                  
  logic [15:0] pmod_gpio_oe; 
  
  int index;
  int r, c;
  int fd;
  logic [31:0] temp_instruction;
  logic [255:0] temp_data;
  realtime start_time, end_time;

  kth_ss kth_ss_inst (
      .PADDR(PADDR),
      .PENABLE(PENABLE),
      .PSEL(PSEL),
      .PWDATA(PWDATA),
      .PWRITE(PWRITE),
      .PRDATA(PRDATA),
      .PREADY(PREADY),
      .PSLVERR(PSLVERR),

      .clk_in(clk_in),
      .reset_int(reset_int),

      .high_speed_clk(high_speed_clk),             
      .irq_3(irq_3),                      
      .irq_en_3(irq_en_3),                   
      .ss_ctrl_3(ss_ctrl_3),                  
      .pmod_gpi(pmod_gpi),                  
      .pmod_gpo(pmod_gpo),                  
      .pmod_gpio_oe(pmod_gpio_oe)                      
  );


  initial begin
    clk_in = 0;
    forever #500 clk_in = ~clk_in; 
  end

  initial begin
    PSEL = 0;
    PENABLE = 0;
    PWRITE = 0;
    PADDR = 0;
    PWDATA = 0;
    reset_int = 0;

    @(negedge clk_in) reset_int = 1;
    
    ///////////////////////////// Test case 1 - instruction loader - riscv writes instructions /////////////////////////////
    PENABLE = 1;
    PSEL    = 1;
    PWRITE  = 1;
    PADDR = CTRL_BASE_ADDR;
    PWDATA = 32'h00000000; // Row = 0 & Col = 0
    @(negedge clk_in);


    index = 0;
    r = 0;
    c = 0;

    fd = $fopen("instr.bin", "r");
    while (!$feof(
        fd
    )) begin
      if ($fscanf(fd, "cell %d %d", r, c)) begin
        $display("cell %d %d", r, c);
        index = 0;
      end else if ($fscanf(fd, "%b", temp_instruction)) begin
        $display("instr_data_in[%d][%d] = %b", r, c, temp_instruction);
        PWDATA = temp_instruction;
        PADDR = INSTR_BASE_ADDR + index * 4;
        index = index + 1;
        @(negedge clk_in);
      end
    end
    $fclose(fd);

    // // wait for ret to be 1
    // @(posedge ret_all);
    // // record simulation time
    // @(negedge clk_in) end_time = $realtime;
    // $display("Simulation ends! Total cycles = %d", (end_time - start_time) / 10);

    // // display all the output buffer and write it to a file
    // $display("Output Buffers:");
    // fd = $fopen("sram_image_out.bin", "w+");
    // foreach (output_buffer[i]) begin
    //   for (int x = 0; x < 16; x = x + 1) begin
    //     ob_line[x] = output_buffer[i][16*x+:16];
    //   end
    //   $display("OB[%d] = %s", i, $sformatf("%p", ob_line));
    //   $fwrite(fd, "%d %b\n", i, output_buffer[i]);
    // end
    // $finish;


    fd = $fopen("sram_image_in.bin", "r");
    $display("Loading input buffer");
    while (!$feof(
        fd
    )) begin
      $fscanf(fd, "%d %b", index, temp_data);
      $display("index = %d, data = %b", index, temp_data);
      for (int i = 0; i < 8; i++) begin
        PADDR = DATA_IN_BASE_ADDR + ((32 * index) + (i * 4));
        PWDATA = temp_data[i*32+:32];
        @(negedge clk_in);
      end
    end
    $fclose(fd);

    ///////////////////////////// Test case 3 - control register - rsicv calls all drra cells /////////////////////////////  
    PADDR = CTRL_BASE_ADDR + 32'h4;
    PWDATA = 32'h00000001; // call = 1
    @(negedge clk_in);
    start_time = $realtime;

    PENABLE = 0;
    PSEL    = 0;
    PWRITE  = 0;
    ///////////////////////////// Test case 4 - status register - rsicv reads the ret register /////////////////////////////  
    @(posedge kth_ss_inst.fabric_wrapper_inst.apb_slave_interface_inst.ret[0]);
    @(negedge clk_in) end_time = $realtime;
    $display("Simulation ends! Total cycles = %d", (end_time - start_time) / 10);
    PADDR = CTRL_BASE_ADDR + 32'h8;
    PENABLE = 1;
    PSEL    = 1;
    PWRITE  = 0;
    
    ///////////////////////////// Test case 5 - output buffer - rsicv reads output data /////////////////////////////    
    for (int i = 0; i < 8*2; i++) begin
      PENABLE = 0;
      PWRITE  = 0;
      PADDR = DATA_OUT_BASE_ADDR + i * 4;
      @(negedge clk_in);
    end
    
    PENABLE = 0;
    PSEL    = 0;
    PWRITE  = 0;
    @(negedge clk_in);

    #50000;
    $stop;   
  end

  // always @((posedge kth_ss_inst.fabric_wrapper_inst.apb_slave_interface_inst.io_addr_out[0]) or (negedge kth_ss_inst.fabric_wrapper_inst.apb_slave_interface_inst.io_en_out[0])) begin
  //   $display("io_data_out = %h", kth_ss_inst.fabric_wrapper_inst.apb_slave_interface_inst.io_data_out[0]);
  //   $display("io_addr_out = %h", kth_ss_inst.fabric_wrapper_inst.apb_slave_interface_inst.io_addr_out[0]);
  // end

endmodule
