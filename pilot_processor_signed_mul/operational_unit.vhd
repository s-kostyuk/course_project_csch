library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_signed.all;
use IEEE.STD_logic_arith.all;

entity operational_unit is
	generic(
		N: integer := 4
		);
	port(
		clk,rst : in STD_LOGIC;
		y : in STD_LOGIC_VECTOR(12 downto 1);
		d1 : in STD_LOGIC_VECTOR(N-1 downto 0);
		d2 : in STD_LOGIC_VECTOR(N-1 downto 0);
		r:out STD_LOGIC_VECTOR(2*N-1 downto 0);
		x:out STD_LOGIC_vector(4 downto 1)
		);
end operational_unit;

architecture operational_unit of operational_unit is
	signal A,Ain: STD_LOGIC_VECTOR(N-1 downto 0) ;
	signal B,Bin: STD_LOGIC_VECTOR(N-1 downto 0) ;
	signal CnT, CnTin: std_logic_vector(7 downto 0);
	signal C, Cin:  STD_LOGIC_VECTOR(N-1 downto 0) ;
	signal overflow: std_logic;
	signal TgB, TgBin: std_logic;
	
begin
	process(clk,rst)is
	begin
		if rst='0' then
			a<=(others=>'0'); 
			b<=(others=>'0');
			TgB<='0';
			overflow<='0';
			CnT<=(others=>'0');
		elsif rising_edge(clk)then
			A<=Ain;B<=Bin ;CnT <= CnTin;  C <= Cin; TgB <= TgBin;
		end if;
	end process;
	
	
	ain<= D1 when y(1)='1'
	else a;
	
	
	bin<= D2 when y(2) = '1'
	else C(0) & B(N-1 downto 1) when y(7) = '1'  
	else b;
	
	Cin <= (others=>'0') when y(3)='1'
	else C + A when y(5) = '1'
	else overflow & C(N-1 downto 1) when y(9) = '1'
	else C(N-1) & C(N-1 downto 1) when y(10) = '1'
	else C + not A + 1 when y(11) = '1'
	else C;	
	
	overflow <= (not C(N-1) and not A(N-1) and Cin(N-1)) or (C(N-1) and A(N-1) and not Cin(N-1));	
		
	CnTin <= conv_std_logic_vector(N, 8) when y(4) = '1'
	else CnT - 1 when y(8) = '1'
	else CnT;
		
	TgBin <= B(0) when y(6) = '1'
	else TgB;
	
	R <= C & B when y(12) = '1'
	else (others => 'Z');
		
	
	
	x(1) <= '1' when B(0) = '1' else '0'; 
	x(2) <= '1' when overflow = '1' else '0';
	x(3) <= '1' when CnT = 0 else '0';
	x(4) <= '1' when TgB = '1' else '0';
end operational_unit;