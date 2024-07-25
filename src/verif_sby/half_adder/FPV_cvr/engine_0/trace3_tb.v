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
  reg [0:0] PI_a;
  reg [0:0] PI_b;
  reg [0:0] PI_rstn;
  half_adder UUT (
    .clk(PI_clk),
    .a(PI_a),
    .b(PI_b),
    .rstn(PI_rstn)
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
    // UUT.$auto$async2sync.\cc:171:execute$157  = 1'b0;
    // UUT.$formal$half_adder.\sv:70$1_EN  = 1'b0;
    // UUT.$formal$half_adder.\sv:74$3_EN  = 1'b0;
    // UUT.$formal$half_adder.\sv:80$5_EN  = 1'b0;
    UUT._witness_.anyinit_procdff_124 = 1'b1;
    UUT._witness_.anyinit_procdff_126 = 1'b1;
    UUT._witness_.anyinit_procdff_128 = 1'b0;
    UUT._witness_.anyinit_procdff_130 = 1'b0;
    UUT._witness_.anyinit_procdff_132 = 1'b0;
    UUT._witness_.anyinit_procdff_134 = 1'b1;
    UUT._witness_.anyinit_procdff_136 = 1'b0;
    UUT._witness_.anyinit_procdff_138 = 1'b1;
    UUT._witness_.anyinit_procdff_140 = 1'b1;
    UUT._witness_.anyinit_procdff_142 = 1'b0;
    UUT._witness_.anyinit_procdff_144 = 1'b0;
    UUT._witness_.anyinit_procdff_146 = 1'b0;
    UUT._witness_.anyinit_procdff_148 = 1'b0;
    UUT._witness_.anyinit_procdff_149 = 1'b0;
    UUT._witness_.anyinit_procdff_151 = 1'b0;
    UUT._witness_.anyinit_procdff_152 = 1'b1;

    // state 0
    PI_a = 1'b0;
    PI_b = 1'b0;
    PI_rstn = 1'b0;
  end
  always @(posedge clock) begin
    // state 1
    if (cycle == 0) begin
      PI_a <= 1'b0;
      PI_b <= 1'b0;
      PI_rstn <= 1'b0;
    end

    genclock <= cycle < 1;
    cycle <= cycle + 1;
  end
endmodule
