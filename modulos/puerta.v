module pwm (clk, led, motor,entrada,salida,entrada_sal,salida_sal);

input clk;
input entrada;
input salida;
input entrada_sal;
input salida_sal;
output reg led;
output reg motor;

reg [31:0] cont; //contador de 32 bits
reg [32:0] tiempo;


initial begin //asigno valores iniciales
cont <= 32'b0;
tiempo <= 32'b0;
end

always @ (posedge clk) 
begin
if(!entrada)
begin
cont <= cont + 1'b1;
if (cont < 75000)
begin
motor = !(motor);
end
else
begin 
motor = 0;
end
if(cont > 1000000)
begin 
cont <= 32'b0;
end
end
if(!entrada_sal)
begin
cont <= cont + 1'b1;
if(cont <= 25000)
begin
motor = !(motor);
end
else
begin
motor = 0;
end
if(cont > 1000000)
begin
cont <= 0;
end
end

if(!salida)
begin
cont <= cont + 1'b1;
if (cont < 75000)
begin
motor = !(motor);
end
else
begin 
motor = 0;
end
if(cont > 1000000)
begin 
cont <= 32'b0;
end
end
if(!salida_sal)
begin
cont <= cont + 1'b1;
if(cont <= 25000)
begin
motor = !(motor);
end
else
begin
motor = 0;
end
if(cont > 1000000)
begin
cont <= 0;
end
end

end

endmodule 