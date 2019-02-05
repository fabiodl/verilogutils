module outpacket(clk,
                 tx,
                 packetData,
                 packetValid,
                 packetSent
);

   parameter CLKDIVIDER=50;
   parameter BYTES=4;
   parameter COUNTERBITS=3;
   
   
   input clk,packetValid;
   input [BYTES*8-1:0] packetData;   
   output              tx;
   output reg          packetSent;


   reg [COUNTERBITS-1:0] idx=0;

   wire [7:0]            txData;
   reg [7:0]             csum=8'h00;   
   reg                   txDv;
   wire                  txActive,txDone;
   reg [0:0]             state=STATE_IDLE;
   
   localparam STATE_IDLE=0;
   localparam STATE_SENDING=1;
     
   
   
   multiplexer #(.BUSWIDTH(8),
                 .CHANNELS(BYTES+1),
                 .CHANNELBITS(COUNTERBITS)) mux(.inlines({packetData,csum}),
                                                .outlines(txData),
                                                .channel(BYTES-idx));
   
                   
   UART_TX #(.g_CLKS_PER_BIT(CLKDIVIDER)) utx(.i_Clk(clk),
                                              .i_TX_DV(txDv),
                                              .i_TX_Byte(txData),
                                              .o_TX_Serial(tx),
                                              .o_TX_Active(txActive),
                                              .o_TX_Done(txDone));
   



   always @(negedge clk)
     begin
        packetSent<=1'b0;        
        case (state)
          STATE_IDLE:
            if (packetValid)
              begin
                 txDv<=1;
                 state<=STATE_SENDING;
                 idx<=0;
                 csum<=0;                 
              end
          STATE_SENDING:
            if (txDone)
              begin
                 if (idx<=BYTES)
                   begin
                      csum<=csum^txData;                      
                      idx<=idx+1;
                   end          
                 else
                   begin
                      txDv<=0;                      
                      packetSent<=1'b1;
                      state<=STATE_IDLE;                 
                   end
              end
        endcase
          
        
     end
   

   
   
endmodule
