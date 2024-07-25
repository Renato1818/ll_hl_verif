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
  reg [0:0] PI_carry_in;
  reg [0:0] PI_rstn;
  reg [0:0] PI_b;
  wire [0:0] PI_clk = clock;
  reg [0:0] PI_a;
  full_adder UUT (
    .carry_in(PI_carry_in),
    .rstn(PI_rstn),
    .b(PI_b),
    .clk(PI_clk),
    .a(PI_a)
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
    // UUT.$auto$async2sync.\cc:171:execute$259  = 1'b0;
    // UUT.$auto$async2sync.\cc:171:execute$261  = 1'b0;
    // UUT.$auto$async2sync.\cc:171:execute$263  = 1'b0;
    // UUT.$auto$async2sync.\cc:171:execute$271  = 1'b0;
    // UUT.$auto$async2sync.\cc:171:execute$273  = 1'b0;
    // UUT.$auto$async2sync.\cc:171:execute$275  = 1'b0;
    // UUT.$formal$full_adder.\sv:164$1_EN  = 1'b0;
    // UUT.$formal$full_adder.\sv:168$3_EN  = 1'b0;
    // UUT.$formal$full_adder.\sv:174$5_EN  = 1'b0;
    UUT._witness_.anyinit_procdff_191 = 1'b1;
    UUT._witness_.anyinit_procdff_193 = 1'b1;
    UUT._witness_.anyinit_procdff_195 = 1'b0;
    UUT._witness_.anyinit_procdff_197 = 1'b0;
    UUT._witness_.anyinit_procdff_199 = 1'b0;
    UUT._witness_.anyinit_procdff_201 = 1'b1;
    UUT._witness_.anyinit_procdff_203 = 1'b0;
    UUT._witness_.anyinit_procdff_205 = 1'b1;
    UUT._witness_.anyinit_procdff_207 = 1'b0;
    UUT._witness_.anyinit_procdff_209 = 1'b0;
    UUT._witness_.anyinit_procdff_211 = 1'b0;
    UUT._witness_.anyinit_procdff_213 = 1'b0;
    UUT._witness_.anyinit_procdff_215 = 1'b0;
    UUT._witness_.anyinit_procdff_217 = 1'b1;
    UUT._witness_.anyinit_procdff_219 = 1'b0;
    UUT._witness_.anyinit_procdff_221 = 1'b0;
    UUT._witness_.anyinit_procdff_226 = 1'b1;
    UUT._witness_.anyinit_procdff_227 = 1'b0;
    UUT._witness_.anyinit_procdff_228 = 1'b1;
    UUT._witness_.anyinit_procdff_232 = 1'b0;
    UUT._witness_.anyinit_procdff_233 = 1'b0;
    UUT._witness_.anyinit_procdff_234 = 1'b0;
    UUT._witness_.anyinit_procdff_235 = 1'b0;
    UUT._witness_.anyinit_procdff_236 = 1'b1;
    UUT._witness_.anyinit_procdff_237 = 1'b0;
    UUT._witness_.anyinit_procdff_238 = 1'b0;
    UUT._witness_.anyinit_procdff_239 = 1'b1;
    UUT._witness_.anyinit_procdff_240 = 1'b0;

    // state 0
    PI_carry_in = 1'b1;
    PI_rstn = 1'b0;
    PI_b = 1'b0;
    PI_a = 1'b1;
  end
  always @(posedge clock) begin
    // state 1
    if (cycle == 0) begin
      PI_carry_in <= 1'b1;
      PI_rstn <= 1'b0;
      PI_b <= 1'b0;
      PI_a <= 1'b1;
    end

    genclock <= cycle < 1;
    cycle <= cycle + 1;
  end
endmodule
