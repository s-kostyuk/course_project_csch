library IEEE;

use IEEE.STD_LOGIC_1164.all;

entity top is
	generic(
		N: integer := 4
		);
	port(		
		clk : in STD_LOGIC; 
		reset : in STD_LOGIC; 
		d1 : in STD_LOGIC_VECTOR(N-1 downto 0); 
		d2 : in STD_LOGIC_VECTOR(N-1 downto 0);
		r : out STD_LOGIC_VECTOR(2*N-1 downto 0)
		);
end top;

architecture top of top is 
	component control_unit
		port ( 
			clk,reset : in STD_LOGIC;
			X: in STD_LOGIC_vector(4 downto 1);
			Y: out STD_LOGIC_vector(12 downto 1)
			);
	end component; 
	
	component operational_unit port(			
			clk,rst : in STD_LOGIC;
			y : in STD_LOGIC_VECTOR(12 downto 1);
			d1 : in STD_LOGIC_VECTOR(N-1 downto 0);
			d2 : in STD_LOGIC_VECTOR(N-1 downto 0);
			r:out STD_LOGIC_VECTOR(2*N-1 downto 0);
			x:out STD_LOGIC_vector(4 downto 1)
			); 
	end component;
	
	signal y : std_logic_vector(12 downto 1); 
	signal x : std_logic_vector(4 downto 1);
	
begin
	dd1:control_unit port map (clk,reset,x,y);
	
	dd2:operational_unit port map (clk => clk ,rst => reset,d1 => d1, d2 =>d2, y=>y, x=>x, r =>r);
	
end top;