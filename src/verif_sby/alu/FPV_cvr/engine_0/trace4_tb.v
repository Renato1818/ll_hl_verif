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
  reg [3:0] PI_OP2;
  reg [3:0] PI_OP1;
  reg [0:0] PI_rstn;
  reg [2:0] PI_OPCODE;
  wire [0:0] PI_clk = clock;
  alu UUT (
    .OP2(PI_OP2),
    .OP1(PI_OP1),
    .rstn(PI_rstn),
    .OPCODE(PI_OPCODE),
    .clk(PI_clk)
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
    // UUT.$auto$async2sync.\cc:171:execute$4531  = 1'b0;
    // UUT.$formal$alu.\sv:311$75_EN  = 1'b0;
    // UUT.$formal$alu.\sv:317$78_EN  = 1'b0;
    // UUT.$formal$alu.\sv:323$80_EN  = 1'b0;
    // UUT.$formal$alu.\sv:326$81_EN  = 1'b0;
    // UUT.$formal$alu.\sv:329$82_EN  = 1'b0;
    // UUT.$formal$alu.\sv:332$83_EN  = 1'b0;
    // UUT.$formal$alu.\sv:335$84_EN  = 1'b0;
    // UUT.$formal$alu.\sv:338$85_EN  = 1'b0;
    // UUT.$formal$alu.\sv:341$86_EN  = 1'b0;
    // UUT.$formal$alu.\sv:344$87_EN  = 1'b0;
    // UUT.$formal$alu.\sv:352$88_EN  = 1'b0;
    // UUT.$formal$alu.\sv:382$103_EN  = 1'b0;
    // UUT.$formal$alu.\sv:385$104_EN  = 1'b0;
    // UUT.$formal$alu.\sv:388$105_EN  = 1'b0;
    // UUT.$formal$alu.\sv:391$106_EN  = 1'b0;
    // UUT.$formal$alu.\sv:394$107_EN  = 1'b0;
    // UUT.$formal$alu.\sv:397$108_EN  = 1'b0;
    // UUT.$formal$alu.\sv:400$109_EN  = 1'b0;
    // UUT.$formal$alu.\sv:403$110_EN  = 1'b0;
    UUT._witness_.anyinit_procdff_4441 = 1'b1;
    UUT._witness_.anyinit_procdff_4443 = 1'b1;
    UUT._witness_.anyinit_procdff_4445 = 1'b1;
    UUT._witness_.anyinit_procdff_4447 = 1'b1;
    UUT._witness_.anyinit_procdff_4449 = 1'b1;
    UUT._witness_.anyinit_procdff_4451 = 1'b1;
    UUT._witness_.anyinit_procdff_4453 = 1'b0;
    UUT._witness_.anyinit_procdff_4455 = 1'b1;
    UUT._witness_.anyinit_procdff_4457 = 1'b0;
    UUT._witness_.anyinit_procdff_4459 = 1'b0;
    UUT._witness_.anyinit_procdff_4461 = 1'b0;
    UUT._witness_.anyinit_procdff_4463 = 1'b1;
    UUT._witness_.anyinit_procdff_4465 = 1'b1;
    UUT._witness_.anyinit_procdff_4467 = 1'b0;
    UUT._witness_.anyinit_procdff_4469 = 1'b0;
    UUT._witness_.anyinit_procdff_4471 = 1'b0;
    UUT._witness_.anyinit_procdff_4473 = 1'b0;
    UUT._witness_.anyinit_procdff_4475 = 1'b1;
    UUT._witness_.anyinit_procdff_4477 = 1'b0;
    UUT._witness_.anyinit_procdff_4479 = 1'b0;
    UUT._witness_.anyinit_procdff_4481 = 1'b0;
    UUT._witness_.anyinit_procdff_4483 = 1'b0;
    UUT._witness_.anyinit_procdff_4485 = 1'b0;
    UUT._witness_.anyinit_procdff_4487 = 1'b1;
    UUT._witness_.anyinit_procdff_4489 = 1'b0;
    UUT._witness_.anyinit_procdff_4491 = 1'b1;
    UUT._witness_.anyinit_procdff_4493 = 1'b1;
    UUT._witness_.anyinit_procdff_4495 = 1'b0;
    UUT._witness_.anyinit_procdff_4497 = 1'b0;
    UUT._witness_.anyinit_procdff_4499 = 1'b1;
    UUT._witness_.anyinit_procdff_4501 = 1'b0;
    UUT._witness_.anyinit_procdff_4503 = 1'b1;
    UUT._witness_.anyinit_procdff_4505 = 1'b1;
    UUT._witness_.anyinit_procdff_4507 = 1'b1;
    UUT._witness_.anyinit_procdff_4509 = 1'b0;
    UUT._witness_.anyinit_procdff_4511 = 1'b1;
    UUT._witness_.anyinit_procdff_4513 = 4'b1000;
    UUT._witness_.anyinit_procdff_4514 = 4'b0000;
    UUT._witness_.anyinit_procdff_4515 = 3'b000;
    UUT._witness_.anyinit_procdff_4517 = 4'b1111;
    UUT._witness_.anyinit_procdff_4518 = 1'b1;
    UUT._witness_.anyinit_procdff_4519 = 1'b1;

    // state 0
    PI_OP2 = 4'b0000;
    PI_OP1 = 4'b0100;
    PI_rstn = 1'b0;
    PI_OPCODE = 3'b100;
  end
  always @(posedge clock) begin
    // state 1
    if (cycle == 0) begin
      PI_OP2 <= 4'b0000;
      PI_OP1 <= 4'b0100;
      PI_rstn <= 1'b0;
      PI_OPCODE <= 3'b100;
    end

    genclock <= cycle < 1;
    cycle <= cycle + 1;
  end
endmodule
