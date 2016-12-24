library IEEE;

use IEEE.STD_LOGIC_1164.all;

entity top is
	generic(
		N: integer := 4;
		M: integer := 8
		);
	port(		
		clk : in STD_LOGIC; 
		rst : in STD_LOGIC;
		COP : in std_logic;
		d1 : in STD_LOGIC_VECTOR(2*N-1 downto 0); 
		d2 : in STD_LOGIC_VECTOR(N-1 downto 0);
		r : out STD_LOGIC_VECTOR(2*N-1 downto 0);
		IRQ1, IRQ2 : out std_logic
		);
end top;

architecture top of top is 
	component control_unit
		port ( 
			clk,rst : in STD_LOGIC;
			X: in STD_LOGIC_vector(10 downto 1);
			Y: out STD_LOGIC_vector(25 downto 1);
			COP : in std_logic);
	end component; 
	
	component operational_unit port(			
			clk,rst : in STD_LOGIC;
			y : in STD_LOGIC_VECTOR(25 downto 1);
			
			d1 : in STD_LOGIC_VECTOR(2*N-1 downto 0);
			d2 : in STD_LOGIC_VECTOR(N-1 downto 0);
			rl, rh : out STD_LOGIC_VECTOR(N-1 downto 0);
			x : out STD_LOGIC_vector(10 downto 1);
			IRQ1, IRQ2 : out std_logic
			); 
	end component;
	
	signal y : std_logic_vector(25 downto 1); 
	signal x : std_logic_vector(10 downto 1);
	signal nclk : std_logic;
	signal rl, rh : std_logic_vector(N-1 downto 0);
	
begin
	nclk <= not clk;
	
	dd1 : control_unit port map (clk=>clk, rst=>rst, x=>x, y=>y, COP=>COP);
	
	dd2 : operational_unit port map (
		clk => nclk, rst => rst, d1 => d1, d2 => d2,
		y => y, x => x, rl => rl, rh => rh,
		IRQ1 => IRQ1, IRQ2 => IRQ2
		);
	
	r <= rh & rl;
	
end top;