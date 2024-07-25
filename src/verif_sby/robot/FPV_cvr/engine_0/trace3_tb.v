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
  reg [0:0] PI_rstn;
  reg [15:0] PI_dist_v;
  robot UUT (
    .clk(PI_clk),
    .rstn(PI_rstn),
    .dist_v(PI_dist_v)
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
    // UUT.$auto$async2sync.\cc:171:execute$142  = 1'b0;
    // UUT.$formal$robot.\sv:82$1_EN  = 1'b0;
    // UUT.$formal$robot.\sv:86$3_EN  = 1'b0;
    // UUT.$formal$robot.\sv:89$4_EN  = 1'b0;
    // UUT.$formal$robot.\sv:93$5_EN  = 1'b0;
    UUT._witness_.anyinit_procdff_110 = 1'b1;
    UUT._witness_.anyinit_procdff_112 = 1'b0;
    UUT._witness_.anyinit_procdff_114 = 1'b0;
    UUT._witness_.anyinit_procdff_116 = 1'b0;
    UUT._witness_.anyinit_procdff_118 = 1'b0;
    UUT._witness_.anyinit_procdff_120 = 1'b1;
    UUT._witness_.anyinit_procdff_122 = 1'b0;
    UUT._witness_.anyinit_procdff_124 = 1'b1;
    UUT._witness_.anyinit_procdff_126 = 1'b1;
    UUT._witness_.anyinit_procdff_128 = 1'b0;
    UUT._witness_.anyinit_procdff_130 = 1'b0;
    UUT._witness_.anyinit_procdff_131 = 1'b0;
    UUT._witness_.anyinit_procdff_136 = 1'b1;
    UUT._witness_.anyinit_procdff_137 = 1'b0;
    UUT.f_past_past_valid = 1'b0;

    // state 0
    PI_rstn = 1'b1;
    PI_dist_v = 16'b0111111111111111;
  end
  always @(posedge clock) begin
    // state 1
    if (cycle == 0) begin
      PI_rstn <= 1'b1;
      PI_dist_v <= 16'b0111111111111111;
    end

    genclock <= cycle < 1;
    cycle <= cycle + 1;
  end
endmodule
