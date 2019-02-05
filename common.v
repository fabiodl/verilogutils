module common(clk,tx,packetValid,packetSent);
output tx;
input clk;
input packetValid;

output packetSent;


outpacket  out(.clk(clk),
               .tx(tx),
               .packetData({32'hDEADBEEF}),
               .packetValid(packetValid),
               .packetSent(packetSent)
);







endmodule