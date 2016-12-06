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
		y : in STD_LOGIC_VECTOR(18 downto 1);
		d1 : in STD_LOGIC_VECTOR(2*N-1 downto 0);
		d2 : in STD_LOGIC_VECTOR(N-1 downto 0);
		r:out STD_LOGIC_VECTOR(N-1 downto 0);
		x:out STD_LOGIC_vector(7 downto 1);
		IRQ1, IRQ2: out std_logic
		);
end operational_unit;

architecture operational_unit of operational_unit is
	signal A,Ain: STD_LOGIC_VECTOR(2*N-1 downto 0) ;
	signal B,Bin: STD_LOGIC_VECTOR(N downto 0) ;
	signal TgS, TgSin: std_logic;
	signal CnT, CnTin: std_logic_vector(7 downto 0);
	signal C, Cin:  STD_LOGIC_VECTOR(N-1 downto 0) ;
begin
	process(clk,rst)is
	begin
		if rst='0' then
			a<=(others=>'0'); 
			b<=(others=>'0');
			TgS<='0';
			CnT<=(others=>'0');
		elsif rising_edge(clk)then
			A<=Ain;B<=Bin ;CnT <= CnTin;  C <= Cin; TgS <= TgSin;
		end if;
	end process;
	
	
	ain<= D1 when y(1)='1'
	else (A(2*N-1 downto N-1) + not B + 1) & A(N-2 downto 0) when y(6)='1' or y(14) = '1'
	else (A(2*N-1 downto N-1) + B) & A(N-2 downto 0) when y(7)='1' or y(15) = '1'
	else A(2*N-2 downto 0) & '0' when y(13) = '1'
	--else A + not B + 1 when y(14) = '1'
	--else A + B when y(15) = '1'
	else a;
	
	
	bin<= D2(N-1 downto 0) & '0' when y(2) = '1'
	else B(N) & B(N downto 1) when y(4) = '1'  
	else b;
	
	Cin <= (others=>'0') when y(8)='1'
	else C(N-2 downto 0) & '1' when y(10)='1'
	else C(N-2 downto 0) & '0' when y(11)='1'
	else C + 1 when y(16) = '1' 
	else C;	
	
	IRQ1 <= y(17);	
	IRQ2 <= y(18);
	
	CnTin <= conv_std_logic_vector(N, 8) when y(9) = '1'
	else CnT - 1 when y(12) = '1'
	else CnT;	
	
	r <= C;
	
	TgSin <= D2(N-1) when y(3) = '1'
	else A(2*N-1) when y(5) = '1'
	else TgS;
	
	x(1) <= '1' when B = 0 else '0'; 
	x(2) <= '1' when (A(2*N-1) xor B(N)) = '1' else '0';
	x(3) <= '1' when CnT = 0 else '0';
	x(4) <= '1' when B(N) = '1' else '0';
	x(5) <= '1' when (B(N) xor TgS) = '1' else '0';
	x(6) <= '1' when TgS = '1' else '0';
	x(7) <= '1' when A = 0 else '0';
end operational_unit;