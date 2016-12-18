library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_signed.all;
use IEEE.STD_logic_arith.all;

entity operational_unit is
	generic(
		N: integer := 4;
		M: integer := 8
		);
	port(
		clk,rst : in STD_LOGIC;
		y : in STD_LOGIC_VECTOR(25 downto 1);
		COP : in std_logic;
		d1 : in STD_LOGIC_VECTOR(2*N-1 downto 0);
		d2 : in STD_LOGIC_VECTOR(N-1 downto 0);
		rl, rh : out STD_LOGIC_VECTOR(N-1 downto 0);
		x : out STD_LOGIC_vector(10 downto 0);
		IRQ1, IRQ2 : out std_logic
		);
end operational_unit;

architecture operational_unit of operational_unit is
	signal A,Ain: STD_LOGIC_VECTOR(2*N-1 downto 0) ;
	signal B1,B1in: STD_LOGIC_VECTOR(N-1 downto 0) ;
	signal B2,B2in: STD_LOGIC_VECTOR(N downto 0) ;
	signal CnT, CnTin: std_logic_vector(M-1 downto 0);
	signal C, Cin:  STD_LOGIC_VECTOR(N-1 downto 0) ;
	signal overflow, carry: std_logic;
	signal of_in, cf_in: std_logic;
	signal of_sum, cf_sum: std_logic;
	signal TgS, TgSin: std_logic;
	signal sum_result: std_logic_vector(N-1 downto 0);
	
	component adder is
		generic(
			N: integer := 4
			);
		port(A, B: in std_logic_vector(N-1 downto 0);
			Cin: in std_logic;
			S: out std_logic_vector(N-1 downto 0);
			Cout: out std_logic;
			overflow: out std_logic);  
	end component;
	
begin
	process(clk,rst)is
	begin
		if rst='0' then
			A <= (others=>'0'); 
			B1 <= (others=>'0');
			B2 <= (others=>'0');
			TgS <= '0';
			Overflow <= '0';
			Carry <= '0';
			CnT <= (others=>'0');
		elsif rising_edge(clk)then
			A <= Ain;
			B1 <= B1in;
			B2 <= B2in;
			CnT <= CnTin;
			C <= Cin;
			Overflow <= of_in;
			Carry <= cf_in;
		end if;
	end process;
	
	-- Подключение сумматора
	SUM : adder port map(A => C, B => A(N-1 downto 0), Cin => '0', Cout => cf_sum, overflow => of_sum, S => sum_result);
	
	-- Реализация микроопераций
	Ain <= D1 when y(1)='1'
	else (A(2*N-1 downto N-1) + not B2 + 1) & A(N-2 downto 0) when y(17) = '1'
	else (A(2*N-1 downto N-1) + B2) & A(N-2 downto 0) when y(18) = '1'
	else A(2*N-2 downto 0) & '0' when y(21) = '1'
	else A;
		
	B1in <= D2 when y(2) = '1' 
	else C(0) & B1(N-1 downto 1) when y(7) = '1'
	else B1;
		
	Cin <= (others => '0') when y(3) = '1'
	else sum_result when y(5) = '1'
	else carry & C(N-1 downto 1) when y(9) = '1'
	else C(N-1)& C(N-1 downto 1) when y(10) = '1'
	else C + not A(N-1 downto 0) + 1 when y(11) = '1'
	else C(N-2 downto 0) & '1' when y(19) = '1'
	else C(N-2 downto 0) & '0' when y(20) = '1'
	else C + 1 when y(22) = '1'
	else C;	
		
	cf_in <= cf_sum when y(5) = '1'
	else carry;
		
	of_in <= of_sum when y(5) = '1'
	else overflow;
		
	CnTin <= conv_std_logic_vector(N, M) when y(3) = '1'
	else CnT - 1 when y(8) = '1'
	else CnT;
		
	TgSin <= B1(0) when y(6) = '1'
	else A(2*N-1) when y(15) = '1'
	else TgS;
		
	RL <= B1 when y(12) = '1'
	else C when y(23) = '1'
	else (others => 'Z');
		
	RH <= C when y(13) = '1'
	else (others => 'Z');
		
	B2in <= D2 & '0' when y(14) = '1'
	else B2(N) & B2(N downto 1) when y(16) = '1'
	else B2;
		
	IRQ1 <= '1' when y(24) = '1'
	else '0';
		
	IRQ2 <= '1' when y(25) = '1'
	else '0';
	
	-- Осведомительные сигналы
	x(0)  <= COP;
	x(1)  <= B1(0);
	x(2)  <= overflow;
	x(3)  <= '1' when CnT = 0 else '0';
	x(4)  <= TgS;
	x(5)  <= '1' when B2 = 0 else '0';
	x(6)  <= A(2*N-1) xor B2(N);
	x(7)  <= A(2*N-1) xor TgS;
	x(8)  <= B2(N);
	x(9)  <= B2(N) xor TgS;
	x(10) <= '1' when A = 0 else '0';
		
end operational_unit;