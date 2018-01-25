`timescale 1ns / 1ps
/* verilator lint_off STMTDLY */

module peripheral_sim ();


    parameter integer N_LEDS = 8;
    wire [N_LEDS-1:0] led;

    reg [7:0]        sw;
    reg              pb1 = 0, pb2 = 0;

    reg               aclk = 0;
    reg               aresetn = 0;
    reg [3:0]         awaddr = 0;
    reg [2:0]         awprot = 0;
    reg               awvalid = 0;
    wire              awready;
    reg [31:0]        wdata = 0;
    reg [3:0]         wstrb = 0;
    reg               wvalid = 0;
    wire              wready;
    wire [1:0]        bresp;
    wire              bvalid;
    reg               bready;
    reg [3:0]         araddr = 0;
    reg [2:0]         arprot = 0;
    reg               arvalid = 0;
    wire              arready;
    wire [31:0]       rdata;
    wire [1:0]        rresp;
    wire              rvalid;
    reg               rready = 0;

    peripheral_test periph(.LED(led), .SW(sw), .PB1(pb1), .PB2(pb2),
                           .s00_axi_aclk(aclk),
                           .s00_axi_aresetn(aresetn),
                           .s00_axi_awaddr(awaddr),
                           .s00_axi_awprot(awprot),
                           .s00_axi_awvalid(awvalid),
                           .s00_axi_awready(awready),
                           .s00_axi_wdata(wdata),
                           .s00_axi_wstrb(wstrb),
                           .s00_axi_wvalid(wvalid),
                           .s00_axi_wready(wready),
                           .s00_axi_bresp(bresp),
                           .s00_axi_bvalid(bvalid),
                           .s00_axi_bready(bready),
                           .s00_axi_araddr(araddr),
                           .s00_axi_arprot(arprot),
                           .s00_axi_arvalid(arvalid),
                           .s00_axi_arready(arready),
                           .s00_axi_rdata(rdata),
                           .s00_axi_rresp(rresp),
                           .s00_axi_rvalid(rvalid),
                           .s00_axi_rready(rready));

    reg [32:0]        rdata_copy = 0;
    reg               rvalid_copy = 0;

    always #5 begin
        aclk  <= !aclk;
    end

`define READ(ADDR)	rdata_copy = {1'b1, 32'h0}; \
    araddr = ADDR; \
    #20 arvalid = 1;

`define READ_EXPECT(ADDR, DATA) `READ(ADDR); \
    #30 $display("READ(%x)=%x", ADDR, rdata_copy); \
    `ASSERT(rdata_copy == {1'b0, DATA})

`define WRITE32(ADDR, DATA) \
    awaddr = ADDR; \
        #10 awvalid = 1; \
        wdata = DATA; \
        wstrb = 4'b1111; \
        #10 wvalid = 1; \
        #30 wvalid = 0; \
        awvalid = 0; \

`define ASSERT(exp)	if (!(exp)) \
    $display("%s(%d) Assertion failed at #%d: %s", `__FILE__, `__LINE__, $time, `"exp`")

    always @(negedge rvalid) begin
        rdata_copy = {1'b0, rdata};
    end

    always @(posedge rvalid) begin
        arvalid = 0;
    end

    initial begin
        $display("simulation start");
        sw = 'h55;
        bready = 1;
        rready = 1;

        #50 aresetn = 1;
        #20 `READ_EXPECT(0, 32'hdeadbeef);
        #20 `READ(4);
        #20 `READ_EXPECT(8, 32'h5500);
        #20 `READ(4'hc);

        `WRITE32(0, 32'h1234abcd);
        `WRITE32(12, 32'hdeadbeef);
        #20 `READ_EXPECT(0, 32'h1234abcd);

        `WRITE32(4, 32'h456789ab);
        #20 `READ_EXPECT(4, 32'h89ab);

        #20 pb1 = 1;
        #100 pb1 = 0;

        `READ_EXPECT(8, 32'h5501);

        #20 `READ_EXPECT(8, 32'h5500);

        #20 pb2 = 1;
        #100 pb2 = 0;

        `READ_EXPECT(8, 32'h5502);

        #20 `READ_EXPECT(8, 32'h5502);

        `WRITE32(8, 1);

        #20 `READ_EXPECT(8, 32'h5502);

        `WRITE32(8, 2);

        #20 `READ_EXPECT(8, 32'h5500);

        $finish;
    end

endmodule
