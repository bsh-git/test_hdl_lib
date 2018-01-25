`timescale 1 ns / 1 ps

module peripheral_test #
    (
     // Users to add parameters here

     // User parameters ends
     // Do not modify the parameters beyond this line


     // Parameters of Axi Slave Bus Interface S00_AXI
     parameter integer C_S00_AXI_DATA_WIDTH = 32,
     parameter integer C_S00_AXI_ADDR_WIDTH = 4
     )
    (
     // Users to add ports here
     output wire [7:0]                           LED,
     input wire [7:0]                            SW,
     input wire                                  PB1,
     input wire                                  PB2,
     // User ports ends
     // Do not modify the ports beyond this line


     // Ports of Axi Slave Bus Interface S00_AXI
     input wire                                  s00_axi_aclk,
     input wire                                  s00_axi_aresetn,
     input wire [C_S00_AXI_ADDR_WIDTH-1 : 0]     s00_axi_awaddr,
     input wire [2 : 0]                          s00_axi_awprot,
     input wire                                  s00_axi_awvalid,
     output wire                                 s00_axi_awready,
     input wire [C_S00_AXI_DATA_WIDTH-1 : 0]     s00_axi_wdata,
     input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
     input wire                                  s00_axi_wvalid,
     output wire                                 s00_axi_wready,
     output wire [1 : 0]                         s00_axi_bresp,
     output wire                                 s00_axi_bvalid,
     input wire                                  s00_axi_bready,
     input wire [C_S00_AXI_ADDR_WIDTH-1 : 0]     s00_axi_araddr,
     input wire [2 : 0]                          s00_axi_arprot,
     input wire                                  s00_axi_arvalid,
     output wire                                 s00_axi_arready,
     output wire [C_S00_AXI_DATA_WIDTH-1 : 0]    s00_axi_rdata,
     output wire [1 : 0]                         s00_axi_rresp,
     output wire                                 s00_axi_rvalid,
     input wire                                  s00_axi_rready
     );

    wire [15:0]                               tc;
    reg                                       s0 = 0;
    reg                                       s1 = 0;
    wire                                      clr0, clr1;

    // Instantiation of Axi Bus Interface S00_AXI
    peripheral_test_regs # (
		            .C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		            .C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	                    ) myip_v1_0_S00_AXI_inst (
	                                              .tc(tc),
                                                      .r0(s0),
                                                      .r1(s1),
                                                      .sw(SW),
                                                      .clr0(clr0),
                                                      .clr1(clr1),
		                                      .S_AXI_ACLK(s00_axi_aclk),
		                                      .S_AXI_ARESETN(s00_axi_aresetn),
		                                      .S_AXI_AWADDR(s00_axi_awaddr),
		                                      .S_AXI_AWPROT(s00_axi_awprot),
		                                      .S_AXI_AWVALID(s00_axi_awvalid),
		                                      .S_AXI_AWREADY(s00_axi_awready),
		                                      .S_AXI_WDATA(s00_axi_wdata),
		                                      .S_AXI_WSTRB(s00_axi_wstrb),
		                                      .S_AXI_WVALID(s00_axi_wvalid),
		                                      .S_AXI_WREADY(s00_axi_wready),
		                                      .S_AXI_BRESP(s00_axi_bresp),
		                                      .S_AXI_BVALID(s00_axi_bvalid),
		                                      .S_AXI_BREADY(s00_axi_bready),
		                                      .S_AXI_ARADDR(s00_axi_araddr),
		                                      .S_AXI_ARPROT(s00_axi_arprot),
		                                      .S_AXI_ARVALID(s00_axi_arvalid),
		                                      .S_AXI_ARREADY(s00_axi_arready),
		                                      .S_AXI_RDATA(s00_axi_rdata),
		                                      .S_AXI_RRESP(s00_axi_rresp),
		                                      .S_AXI_RVALID(s00_axi_rvalid),
		                                      .S_AXI_RREADY(s00_axi_rready)
	                                              );

    // Add user logic here

    wire                                      clk0, pb1, pb2;

    //aclk is 100MHz
    divider #(24) div0(.clk_in(s00_axi_aclk), .load(24'd100_000), .clk_out(clk0));
    divider #(16) div1(.clk_in(clk0), .load(tc), .clk_out(LED[7]));

    edge_detector det0(.sig_in(PB1), .clk(s00_axi_aclk), .reset_n(s00_axi_aresetn), .rising(pb1));
    edge_detector det1(.sig_in(PB2), .clk(s00_axi_aclk), .reset_n(s00_axi_aresetn), .rising(pb2));

    always @(posedge s00_axi_aclk) begin
        casez ({pb1, clr0})
          2'b01: s0 <= 0;
          2'b1?: s0 <= 1;
          default: s0 <= s0;
        endcase

        casez ({pb2, clr1})
          2'b01: s1 <= 0;
          2'b1?: s1 <= 1;
          default: s1 <= s1;
        endcase
    end

    assign LED[0] = s0;
    assign LED[1] = s1;

    // User logic ends

endmodule
