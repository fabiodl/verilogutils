module multiplexer(inlines,
                   outlines,
                   channel
                );

   parameter BUSWIDTH=8;
   parameter CHANNELS=4;
   parameter CHANNELBITS=2;

   output [BUSWIDTH-1:0] outlines;
   input [CHANNELS*BUSWIDTH-1:0] inlines;
   input [CHANNELBITS-1:0]      channel;
   


   genvar                        i;
   
   
   
   generate
   for (i=0;i<BUSWIDTH;i=i+1)
     begin: generateSel
        assign outlines[i]=inlines[channel*BUSWIDTH+i];
     end
   endgenerate

   

   

endmodule




   
   
   
