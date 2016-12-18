library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity adder is
	generic(
		N: integer := 4
		);
	port(A, B: in std_logic_vector(N-1 downto 0);
		Cin: in std_logic;
		S: out std_logic_vector(N-1 downto 0);
		Cout: out std_logic;
		overflow: out std_logic);
end entity;

architecture adder_struct of adder is
	component full_adder is
		port(
			A, B, Cin: in std_logic;
			S, Cout: out std_logic
			);
	end component;
	
	signal C: std_logic_vector(0 to N);
	
begin
	C(0) <= Cin;
	Cout <=	C(N);
	overflow <= C(N-1) xor C(N);
	
	gen_adders:
		for I in 0 to N-1 generate
		gen_fa : full_adder	port map(
			A => A(I), B => B(I), Cin => C(I),
			S => S(I), Cout => C(I+1)
			);
	end generate;
	
end architecture;