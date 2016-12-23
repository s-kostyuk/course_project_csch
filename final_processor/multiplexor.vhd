library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity mx is
	generic(
		N: integer := 4
		);
	port(
		A: in std_logic_vector(N-1 downto 0);
		D: in std_logic_vector(2**N-1 downto 0);
		En: in std_logic;
		Q: out std_logic
		);
end entity;

architecture mx of mx is
signal index: integer := 0;
begin
	index <= conv_integer(A);
	Q <= d(index) when En = '0'
	else '0';
end architecture;