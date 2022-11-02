
module parcial2 (clk, entrada, entrada_sal, motor, salida, salida_sal, reset, LEDS, LEDS_DEC);

//entradas y salidas
input clk, entrada, entrada_sal, salida_sal, reset, salida;
output reg motor;
output reg [7:0]LEDS;
output reg [7:0]LEDS_DEC;

//Registro para las veces que cuenta el pulsador
reg [7:0] count;
reg [7:0] abrir;
reg [7:0] count_dec;
reg [31:0] cont; //contador de 32 bits

//3 more registers used for debounce since the button will oscillate a few times when pressed
reg [24:0]counter_pressed, counter_not_pressed;
reg [24:0]counter_pressed_rest, counter_not_pressed_rest;
reg button_state = 1'b1;
reg button_state_rest = 1'b1;

//Valores iniciales a los registros, para evitar errores
initial begin
count <= 0;
cont <= 0; 
abrir <= 0; 
count_dec <= 0;
counter_pressed <= 25'b0;
counter_not_pressed <= 25'b0;
counter_pressed_rest <= 25'b0;
counter_not_pressed_rest <= 25'b0;
end


//Each positive edge of the clock (50MHz in this case), we enter this part of code
always @ (posedge clk or negedge reset)
begin
	if(!reset)//Si se presiona el botón de reset
		begin
		count = 0;
		count_dec = 0;
		counter_pressed<= 25'b0;
		counter_not_pressed<= 25'b0;
		counter_pressed_rest <= 25'b0;
		counter_not_pressed_rest <= 25'b0;
		case (count)
			0: LEDS <= 8'b11000000;
		endcase
		case (count_dec)
			0: LEDS_DEC <= 8'b11000000;
		endcase
		end
	else
		begin
		//se presiona el boton and status is low we start counting	
		if(!entrada & !button_state)
			begin
			counter_pressed <= counter_pressed + 1'b1;		//cuenta
			end

		else
			begin
			counter_pressed <= 25'b0; //Sino, se resetea el contador
			end

		if(counter_pressed == 25'd2000000)//Cuando se alcanzan los 2M de pulsos, aumentamos el contador de pulsaciones en uno y reseteamos los demás
			begin
			count = count + 1;
			counter_pressed <= 25'b0;
			button_state = 1'b1;
				case (count)
				0: LEDS <= 8'b11000000;
				1: LEDS <= 8'b11111001;
				2: LEDS <= 8'b10100100;
				3: LEDS <= 8'b10110000;
				4: LEDS <= 8'b10011001;
				5: LEDS <= 8'b10010010;
				6: LEDS <= 8'b10000011;
				endcase
			end
			if (abrir == 0)
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
			end
			if (count > 6)
			begin
			button_state = 1'b1;
			abrir = 1;
			count=6;
			end
			if(entrada & button_state)
			begin
			counter_not_pressed <= counter_not_pressed + 1'b1;		
			end
		else
			begin
			counter_not_pressed <= 25'b0;
			end
		if(counter_not_pressed == 25'd2000000)
			begin
			counter_not_pressed <= 25'b0;
			button_state = 1'b0;
			end
			if(!salida & !button_state_rest)
				begin
				counter_pressed_rest <= counter_pressed_rest + 1'b1;		//cuenta
				end
			else
				begin
				counter_pressed_rest <= 25'b0; //Sino, se resetea el contador
				end
			if(counter_pressed_rest == 25'd2000000)//Cuando se alcanzan los 2M de pulsos, aumentamos el contador de pulsaciones en uno y reseteamos los demás
				begin
				count = count - 1;
				abrir = 0;
				counter_pressed_rest <= 25'b0;
				button_state_rest = 1'b1;
				case (count)
				0: LEDS <= 8'b11000000;
				1: LEDS <= 8'b11111001;
				2: LEDS <= 8'b10100100;
				3: LEDS <= 8'b10110000;
				4: LEDS <= 8'b10011001;
				5: LEDS <= 8'b10010010;
				6: LEDS <= 8'b10000011;
				endcase
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
			if (count == 0)
				begin
				button_state_rest = 1'b1;
				end
			if(salida & button_state_rest)
				begin
				counter_not_pressed_rest <= counter_not_pressed_rest + 1'b1;		
				end	
			else
				begin
				counter_not_pressed_rest <= 25'b0;
				end
			if(counter_not_pressed_rest == 25'd2000000)
				begin
				counter_not_pressed_rest <= 25'b0;
				button_state_rest = 1'b0;
				end
		end
end//end of always


endmodule 