module transitionDetector(clk,sig,out);
   
   input clk;
   input sig;
   output out;
   
   reg   s;   
   reg prevS;   



   

   always @(posedge clk)
     begin
        s<=sig;
        prevS<=s;               
     end
 

   assign out=(s==1'b1)&&(prevS==1'b0);
   
endmodule
