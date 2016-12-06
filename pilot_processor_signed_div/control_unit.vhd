library IEEE;
use IEEE.std_logic_1164.all;

entity control_unit is
	port ( Clk: in STD_LOGIC; Reset: in STD_LOGIC;
		X: in STD_LOGIC_vector(8 downto 1);
		Y: out STD_LOGIC_vector(16 downto 1));
end control_unit;

architecture control_unit of control_unit is
	-- Тип, использующий символьное кодирование состояний автомата
	type State_type is (a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12);
	signal State, NextState: State_type;
begin
	-- NextState logic (combinatorial)
	Sreg0_NextState: process (State)
	begin
		-- инициализация значений выходов
		y <= (others => '0');
		case State is
			when a1 =>
				NextState <= a2;
				y(1) <= '1';
				y(2) <= '1';
			
			when a2=>
				if x(1) = '0' then
					NextState <= a3;
					y(3) <= '1';
					y(4) <= '1';
				else
					NextState <= a11;
					y(15) <= '1';
				end if;
			
			when a3=>
				if x(2) = '0' then
					NextState <= a4;
					y(5) <= '1';
				else
					NextState <= a5;
					y(6) <= '1';
				end if;
			
			when a4=>
				if x(2) = '1' then
					NextState <= a6;
					y(7) <= '1';
					y(8) <= '1';
				else
					NextState <= a1;
					y(16) <= '1';
				end if;
			
			when a5=>
				if x(2) = '0' then
					NextState <= a6;
					y(7) <= '1';
					y(8) <= '1';
				else
					NextState <= a1;
					y(16) <= '1';
				end if;
			
			when a6=>
				if x(2) = '0' then
					NextState <= a7;
					y(9) <= '1';
				else
					NextState <= a7;
					y(10) <= '1';
				end if;
			
			when a7=>
				NextState <= a8;
				y(11) <= '1';
			
			when a8=>
				if x(3) = '0' then
					if x(2) = '0' then
						NextState <= a9;
						y(12) <= '1';
					else 
						NextState <= a10;
						y(12) <= '1';
					end if;
				else
					NextState <= a11;
					if x(4) = '0' then
						if x(5) = '0' then
							y(6) <= '1';
						else
							y(5) <= '1';
						end if;
					end if;
				end if;
			
			when a9=>
				NextState <= a6;
				y(5) <= '1';
			
			when a10=>
				NextState <= a6;
				y(6) <= '1';
			
			when a11=>
				NextState <= a12;
				if x(6) = '0' then
					if x(7) = '1' then
						if x(8) = '1' then
							y(13) <= '1';
						end if;
					end if;
					
				else
					if x(7) = '0' then
						y(13) <= '1';
					elsif x(8) = '0' then
						y(13) <= '1';
					end if;
					
				end if;
			
			when a12=>
				NextState <= a1;
				y(14) <= '1';
			
			when others => NextState <= a1;
				-- присвоение значений выходам для состояния по умолчанию
			--Установка автомата в начальное состояние
		end case;
	end process;
	
	Sreg0_CurrentState: process (Clk, reset)
	begin
		if Reset='0' then
			State <= a1; -- начальное состояние
		elsif rising_edge(clk) then
			State <= NextState;
		end if;
	end process;
	
end control_unit;