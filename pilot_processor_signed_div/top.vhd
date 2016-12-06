library IEEE;

use IEEE.STD_LOGIC_1164.all;

entity top is
	generic(
		N: integer := 4
		);
	port(		
		clk : in STD_LOGIC; 
		reset : in STD_LOGIC; 
		d1 : in STD_LOGIC_VECTOR(2*N-1 downto 0); 
		d2 : in STD_LOGIC_VECTOR(N-1 downto 0);
		r : out STD_LOGIC_VECTOR(N-1 downto 0);
		IRQ1, IRQ2 : out std_logic
		);
end top;

architecture top of top is 
	component control_unit
		port(
			clk : in std_logic; 
			reset : in std_logic;
			x : in std_logic_vector(8 downto 1);
			y : out STD_LOGIC_VECTOR(16 downto 1)
			);
	end component; 
	
	component operational_unit port(			
			clk,rst : in STD_LOGIC;
			y : in STD_LOGIC_VECTOR(16 downto 1);
			d1 : in STD_LOGIC_VECTOR(2*N-1 downto 0);
			d2 : in STD_LOGIC_VECTOR(N-1 downto 0);
			r:out STD_LOGIC_VECTOR(N-1 downto 0);
			x:out STD_LOGIC_vector(8 downto 1);
			IRQ1, IRQ2: out std_logic
			); 
	end component;
	
	signal y : std_logic_vector(16 downto 1); 
	signal x : std_logic_vector(8 downto 1);
	signal nclk:std_logic;
	
begin
	nclk<=not clk;
	
	dd1:control_unit port map (clk,reset,x,y);
	
	dd2:operational_unit port map (clk => nclk ,rst => reset,d1 => d1, d2 =>d2, y=>y, x=>x, r =>r, IRQ1 => IRQ1, IRQ2 => IRQ2);
	
end top;