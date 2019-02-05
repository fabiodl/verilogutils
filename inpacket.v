module inpacket(clk,
                rx,
                packetData,
                packetValid,
                packetReceived
                );

   parameter CLKDIVIDER=50;
   parameter BYTES=4;
   parameter COUNTERBITS=3;
   

   input clk,rx;
   output [BYTES*8-1:0] packetData;
   output reg           packetValid;
   output wire          packetReceived;
   
   
   reg [COUNTERBITS-1:0]    cnt;
   

   wire [7:0]               rxData;
   wire                     rxValid;
   
   UART_RX #(.g_CLKS_PER_BIT(CLKDIVIDER)) urx(.i_Clk(clk),
                                              .i_RX_Serial(rx),
                                              .o_RX_DV(rxValid),
                                              .o_RX_Byte(rxData));
   
   
   multiff #(.BUSWIDTH(8),.CHANNELS(BYTES),.CHANNELBITS(COUNTERBITS))
   packet(.inlines(rxData),
          .outlines(packetData),
          .channel(BYTES-1-cnt),
          .load(rxValid && cnt<BYTES ));
   

   reg [7:0]                csum;


   always@(posedge rxValid)
     begin
        if (cnt==0)          
          csum<=rxData;
        else
          csum<=csum^rxData;                        
     end
   
     

   always @(negedge rxValid)
     begin
        if (cnt==BYTES)
          begin
             cnt<=0;
             packetValid<=csum==8'h00;             
          end
        else
          begin
             cnt<=cnt+1;
             packetValid<=1'b0;             
          end
     end
   

   transitionDetector td(.clk(clk),.sig(cnt==BYTES&&rxValid),.out(packetReceived));
   

   
endmodule
