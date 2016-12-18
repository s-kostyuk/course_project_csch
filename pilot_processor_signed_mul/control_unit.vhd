library IEEE;
use IEEE.std_logic_1164.all;

entity control_unit is
	port ( Clk: in STD_LOGIC; Reset: in STD_LOGIC;
		X: in STD_LOGIC_vector(4 downto 1);
		Y: out STD_LOGIC_vector(12 downto 1));
end control_unit;

architecture control_unit of control_unit is
	-- Тип, использующий символьное кодирование состояний автомата
	type State_type is (a1, a2, a3, a4, a5, a6);
	signal State, NextState: State_type;
begin
	-- NextState logic (combinatorial)
	Sreg0_NextState: process (State, x)
	begin
		-- инициализация значений выходов
		y <= (others => '0');
		case State is
			when a1 =>
				NextState <= a2;
				y(1) <= '1';
				y(2) <= '1';
				y(3) <= '1';
				y(4) <= '1';
			
			when a2=>
				NextState <= a3;
				
				if x(1) = '1' then
					y(5) <= '1';
				end if;
			
			when a3=>
				NextState <= a4;
				y(6) <= '1';
				y(7) <= '1';
				y(8) <= '1';
				
			when a4=>
				NextState <= a5;

				if x(2) = '1' then
					y(9) <= '1';
				else
					y(10) <= '1';
				end if;
			
			when a5=>
				if x(3) = '0' then
					NextState <= a2;
				elsif x(4) = '1' then
					NextState <= a6;
					y(11) <= '1';
				else
					NextState <= a6;
				end if;
			
			when a6=>
				NextState <= a1;
				y(12) <= '1';
			
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