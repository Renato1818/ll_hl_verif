`ifndef VERILATOR
module testbench;
  reg [4095:0] vcdfile;
  reg clock;
`else
module testbench(input clock, output reg genclock);
  initial genclock = 1;
`endif
  reg genclock = 1;
  reg [31:0] cycle = 0;
  wire [0:0] PI_clk = clock;
  reg [0:0] PI_rst;
  reg [0:0] PI_ren;
  reg [7:0] PI_wdata;
  reg [0:0] PI_wen;
  fifo UUT (
    .clk(PI_clk),
    .rst(PI_rst),
    .ren(PI_ren),
    .wdata(PI_wdata),
    .wen(PI_wen)
  );
`ifndef VERILATOR
  initial begin
    if ($value$plusargs("vcd=%s", vcdfile)) begin
      $dumpfile(vcdfile);
      $dumpvars(0, testbench);
    end
    #5 clock = 0;
    while (genclock) begin
      #5 clock = 0;
      #5 clock = 1;
    end
  end
`endif
  initial begin
`ifndef VERILATOR
    #1;
`endif
    // UUT.$auto$async2sync.\cc:171:execute$410  = 5'b00000;
    // UUT.$formal$fifo.\sv:134$24_EN  = 1'b0;
    // UUT.$formal$fifo.\sv:189$28_EN  = 1'b0;
    UUT._witness_.anyinit_procdff_353 = 4'b0000;
    UUT._witness_.anyinit_procdff_354 = 1'b0;
    UUT._witness_.anyinit_procdff_357 = 4'b0000;
    UUT._witness_.anyinit_procdff_358 = 1'b1;
    UUT._witness_.anyinit_procdff_360 = 5'b00000;
    UUT._witness_.anyinit_procdff_361 = 5'b00000;
    UUT._witness_.anyinit_procdff_362 = 5'b00000;
    UUT._witness_.anyinit_procdff_363 = 4'b0000;
    UUT._witness_.anyinit_procdff_364 = 32'b00000000000000000000000000000001;
    UUT._witness_.anyinit_procdff_365 = 4'b0000;
    UUT._witness_.anyinit_procdff_366 = 32'b00000000000000000000000000000001;
    UUT._witness_.anyinit_procdff_367 = 1'b0;
    UUT._witness_.anyinit_procdff_369 = 1'b0;
    UUT._witness_.anyinit_procdff_371 = 1'b0;
    UUT._witness_.anyinit_procdff_373 = 1'b0;
    UUT._witness_.anyinit_procdff_375 = 1'b0;
    UUT._witness_.anyinit_procdff_377 = 1'b0;
    UUT._witness_.anyinit_procdff_379 = 1'b0;
    UUT._witness_.anyinit_procdff_381 = 1'b0;
    UUT._witness_.anyinit_procdff_383 = 1'b0;
    UUT._witness_.anyinit_procdff_385 = 1'b0;
    UUT._witness_.anyinit_procdff_387 = 1'b1;
    UUT._witness_.anyinit_procdff_389 = 1'b0;
    UUT._witness_.anyinit_procdff_391 = 1'b0;
    UUT._witness_.anyinit_procdff_393 = 1'b1;
    UUT._witness_.anyinit_procdff_395 = 1'b1;
    UUT._witness_.anyinit_procdff_397 = 1'b1;
    // UUT.fifo_reader.$auto$async2sync.\cc:171:execute$412  = 4'b0000;
    // UUT.fifo_writer.$auto$async2sync.\cc:171:execute$412  = 4'b0000;
    UUT.past_nren = 1'b0;
    UUT.past_nwen = 1'b0;
    UUT.data[4'b0000] = 8'b00000010;

    // state 0
    PI_rst = 1'b1;
    PI_ren = 1'b1;
    PI_wdata = 8'b00000001;
    PI_wen = 1'b1;
  end
  always @(posedge clock) begin
    // state 1
    if (cycle == 0) begin
      PI_rst <= 1'b0;
      PI_ren <= 1'b0;
      PI_wdata <= 8'b00000001;
      PI_wen <= 1'b0;
    end

    genclock <= cycle < 1;
    cycle <= cycle + 1;
  end
endmodule
