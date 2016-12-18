library IEEE;
use IEEE.std_logic_1164.all;

entity control_unit is
	port ( Clk: in STD_LOGIC; rst: in STD_LOGIC;
		X: in STD_LOGIC_vector(10 downto 0);
		Y: out STD_LOGIC_vector(25 downto 1));
end control_unit;

architecture control_unit of control_unit is
	-- Тип, использующий символьное кодирование состояний автомата
	type State_type is (a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16);
	signal State, NextState: State_type;
begin
	-- NextState logic (combinatorial)
	Sreg0_NextState: process (State, x)
	begin
		-- инициализация значений выходов
		y <= (others => '0');
		case State is
			when a0 => 
				if x(0) = '1' then
					NextState <= a1;
					y(1) <= '1';
					y(2) <= '1';
					y(3) <= '1';
					y(4) <= '1';
				else
					NextState <= a6;
					y(1) <= '1';
					y(14) <= '1';
				end if;
			
			when a1 =>
				NextState <= a2;
				if x(1) = '1' then
					y(5) <= '1';
				end if;
			
			when a2 =>
				NextState <= a3;
				y(6) <= '1';
				y(7) <= '1';
				y(8) <= '1';
			
			when a3 =>
				NextState <= a4;
				if x(2) = '1' then
					y(9) <= '1';
				else
					y(10) <= '1';
				end if;
			
			when a4 => 
				if x(3) = '0' then
					NextState <= a1;
				elsif x(4) = '1' then
					NextState <= a5;
					y(11) <= '1';
				else
					NextState <= a5;
				end if;			 
			
			when a5 =>
				NextState <= a0;
				y(12) <= '1';
				y(13) <= '1';
			
			when a6 =>
				if x(5) = '1' then
					NextState <= a0;
					y(24) <= '1';
				else
					NextState <= a7;
					y(15) <= '1';
					y(16) <= '1';
				end if;	
			
			when a7 =>
				if x(6) = '0' then
					NextState <= a8;
					y(17) <= '1';
				else
					NextState <= a9;
					y(18) <= '1';
				end if;
			
			when a8 =>
				if x(6) = '0' then
					NextState <= a0;
					y(25) <= '1';
				else
					NextState <= a10;
					y(3) <= '1';
					y(4) <= '1';
				end if;
			
			when a9 =>
				if x(6) = '1' then
					NextState <= a0;
					y(25) <= '1';
				else
					NextState <= a10;
					y(3) <= '1';
					y(4) <= '1';
				end if;
			
			when a10 =>
				if x(6) = '0' then
					NextState <= a11;
					y(19) <= '1';
				else
					NextState <= a11;
					y(20) <= '1';
				end if;
			
			when a11 =>
				NextState <= a12;
				y(8) <= '1';
			
			when a12 =>
				if x(3) = '0' then
					if x(6) = '0' then
						NextState <= a13;
						y(21) <= '1';
					else
						NextState <= a14;
						y(21) <= '1';
					end if;
				else
					if x(7) = '1' then
						NextState <= a15;
					elsif x(8) = '0' then
						NextState <= a15;
						y(18) <= '1';
					else
						NextState <= a15;
						y(17) <= '1';
					end if;
				end if;
			
			when a13 =>
				NextState <= a10;
				y(17) <= '1';
			
			when a14 =>
				NextState <= a10;
				y(18) <= '1';
			
			when a15 =>
				NextState <= a16;
				
				if x(9) = '0' then
					if x(4) = '1' and x(10) = '1' then
						y(22) <= '1';
					end if;
				else
					if x(4) = '1' then
						y(22) <= '1';
					elsif x(10) = '0' then
						y(22) <= '1';
					end if;
				end if;
			
			when a16 =>
				NextState <= a0;
				y(23) <= '1';	
			
			when others => NextState <= a0;
				-- присвоение значений выходам для состояния по умолчанию
			--Установка автомата в начальное состояние
		end case;
	end process;
	
	Sreg0_CurrentState: process (Clk, rst)
	begin
		if rst='0' then
			State <= a0; -- начальное состояние
		elsif rising_edge(clk) then
			State <= NextState;
		end if;
	end process;
end control_unit;