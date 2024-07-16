`timescale 1ms/10ps

module tb_assembly;
    
logic clk, nrst, enable, keyenc, right_in, left_in, up_in, down_in, start_in;
logic [7:0] d_out, lcd8_out;
logic wr_out, dcx_out, song_out, rert_out, rs_out, rw_out, en_out;



    initial clk = 0;
    always clk = #50 ~clk;


    initial begin
// make sure to dump the signals so we can see them in the waveform
    $dumpfile("sim.vcd");
    $dumpvars(0, tb_assembly);

assembly (.clk(clk),  .nrst(nrst),  .enable(enable), .keyenc(keyenc) ,.button_right_in(right_in), .button_left_in(left_in),
    .button_up_in(up_in), .button_down_in(down_in), .button_start_pause_in(start_in), .d(d_out),  .lcd8(lcd8_out), .wr(wr_out), .dcx(dcx_out),
     .song(song_out), .rert(rert_out), .rs(rs_out), .rw(rw_out), .en(en_out));

// power on reset
nrst = 1;
enable = 1;
keyenc = 1;
right_in = 0;
left_in = 0;
up_in = 0;
down_in = 0;
start_in = 0;
#100;
nrst = 0;
enable = 1;
keyenc = 1;
right_in = 0;
left_in = 0;
up_in = 0;
down_in = 0;
start_in = 0;
#100;
nrst = 1;
enable = 1;
keyenc = 1;
right_in = 0;
left_in = 0;
up_in = 0;
down_in = 0;
start_in = 0;
#100;
// enable off
nrst = 1;
enable = 0;
keyenc = 1;
right_in = 1;
left_in = 0;
up_in = 0;
down_in = 0;
start_in = 0;
#100;
nrst = 1;
enable = 0;
keyenc = 1;
right_in = 0;
left_in = 0;
up_in = 0;
down_in = 1;
start_in = 1;
#100;

// enable on
nrst = 1;
enable = 1;
keyenc = 1;
right_in = 1;
left_in = 0;
up_in = 0;
down_in = 0;
start_in = 1;
#100;
nrst = 1;
enable = 1;
keyenc = 0;
right_in = 0;
left_in = 1;
up_in = 0;
down_in = 1;
start_in = 0;
#100;
end
#1 $finish;
endmodule