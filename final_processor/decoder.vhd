library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity decoder is
	generic(
		M: integer := 4
		);
	port(D: in std_logic_vector (M-1 downto 0);
		En: in std_logic;
		Q: out std_logic_vector (2**M -1 downto 0)
		); 
end entity;

architecture decoder of decoder is
begin
	process(D, En) is
		variable vQ: std_logic_vector(2**M - 1 downto 0);
	begin
		vQ := (others => '0');
		
		if (En = '1') then -- Прямой En
			vQ(conv_integer(D)) := '1';
		end if;
		
		Q <= vQ;
	end process;
end architecture;