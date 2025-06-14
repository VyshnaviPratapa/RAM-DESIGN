// Simple Synchronous RAM - 8x8 (8 locations, 8-bit wide)
module sync_ram (
    input clk,                 // Clock
    input we,                  // Write Enable
    input [2:0] addr,          // 3-bit address (0 to 7)
    input [7:0] din,           // Data input
    output reg [7:0] dout      // Data output
);
    // 8x8 RAM
    reg [7:0] mem [7:0];

    always @(posedge clk) begin
        if (we)
            mem[addr] <= din;      // Write operation
        dout <= mem[addr];         // Read operation (synchronous)
    end
endmodule

//TESTBENCH
`timescale 1ns / 1ps

module tb_sync_ram();
    reg clk;
    reg we;
    reg [2:0] addr;
    reg [7:0] din;
    wire [7:0] dout;

    // Instantiate the RAM
    sync_ram uut (
        .clk(clk),
        .we(we),
        .addr(addr),
        .din(din),
        .dout(dout)
    );

    // Generate clock: 10ns period
    always #5 clk = ~clk;

    initial begin
        $display("Starting RAM Simulation...");
        $monitor("Time=%0t | WE=%b | Addr=%b | Din=%h | Dout=%h", $time, we, addr, din, dout);

        clk = 0;
        we = 0;
        addr = 0;
        din = 8'h00;

        // Write values into RAM
        #10 we = 1; addr = 3'b000; din = 8'hAA;
        #10 addr = 3'b001; din = 8'hBB;
        #10 addr = 3'b010; din = 8'hCC;

        // Stop writing
        #10 we = 0;

        // Read from RAM
        #10 addr = 3'b000;
        #10 addr = 3'b001;
        #10 addr = 3'b010;

        // End simulation
        #20 $finish;
    end
endmodule

