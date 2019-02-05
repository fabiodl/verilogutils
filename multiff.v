module multiff(inlines,
               outlines,
               channel,
               load
               
);

   parameter BUSWIDTH=8;
   parameter CHANNELS=4;
   parameter CHANNELBITS=2;

   output reg[CHANNELS*BUSWIDTH-1:0] outlines;
   input [BUSWIDTH-1:0] inlines;
   input [CHANNELBITS-1:0]      channel;
   input                        load;
   


   genvar                        i;
   
   generate
      for (i=0;i<CHANNELS;i=i+1)   
        begin: generateSel

        always @(posedge load)
          outlines[(i+1)*8-1:i*8]<=(i==channel)?inlines:outlines[(i+1)*8-1:i*8];                     
        end
      
   endgenerate
   
endmodule

