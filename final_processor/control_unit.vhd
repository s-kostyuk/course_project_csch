library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity control_unit is
	port(
		clk, rst : in STD_LOGIC;
		x : in STD_LOGIC_VECTOR(10 downto 0);
		y : out STD_LOGIC_VECTOR(25 downto 1)
		);
end control_unit;
architecture control_unit of control_unit is
	use ieee.std_logic_unsigned.all;
	subtype TCommand is std_logic_vector(11 downto 0);
	type TROM is array(0 to 54) of TCommand;
	constant ROM:TROM := (
	-- p, y1, y2, y3, y4
	-- p, x, a
	"1" & "0001" & "001" & "11" & "00", -- 0
	"0" & "0001" & "001" & "01" & "01", -- 1
	"1" & "0010" & "000" & "10" & "00", -- 2
	"0" & "0010" & "000" & "00" & "00", -- 3
	"0" & "0011" & "000" & "10" & "10", -- 4
	"1" & "0011" & "001" & "10" & "00", -- 5
	"0" & "0100" & "000" & "00" & "00", -- 6
	"1" & "0100" & "000" & "01" & "00", -- 7
	"1" & "0101" & "001" & "01" & "00", -- 8
	"0" & "0000" & "010" & "00" & "00", -- 9
	"0" & "0110" & "011" & "00" & "00", --10
	"1" & "0000" & "000" & "00" & "00", --11
	"0" & "0101" & "000" & "00" & "00", --12
	"1" & "0000" & "000" & "11" & "10", --13
	"0" & "0001" & "100" & "00" & "00", --14
	"1" & "0110" & "010" & "01" & "00", --15
	"0" & "1100" & "000" & "00" & "00", --16
	"1" & "0000" & "000" & "00" & "00", --17
	"0" & "0111" & "101" & "00" & "00", --18
	"1" & "0111" & "011" & "00" & "00", --19
	"0" & "0000" & "111" & "00" & "11", --20
	"1" & "0111" & "011" & "01" & "00", --21
	"0" & "1101" & "000" & "00" & "00", --22
	"1" & "0000" & "000" & "00" & "00", --23
	"0" & "0000" & "110" & "00" & "00", --24
	"1" & "0111" & "010" & "11" & "00", --25
	"0" & "0000" & "000" & "01" & "01", --26
	"1" & "0111" & "100" & "10" & "10", --27
	"0" & "1000" & "000" & "00" & "00", --28
	"0" & "0000" & "000" & "00" & "10", --29
	"1" & "0100" & "100" & "11" & "10", --30
	"1" & "1000" & "101" & "11" & "00", --31
	"1" & "1010" & "110" & "01" & "10", --32
	"1" & "0101" & "110" & "10" & "10", --33
	"1" & "1011" & "110" & "10" & "10", --34
	"0" & "1011" & "000" & "00" & "00", --35
	"1" & "0000" & "000" & "00" & "00", --36
	"0" & "0000" & "000" & "11" & "00", --37
	"1" & "0000" & "011" & "10" & "10", --38
	"1" & "0111" & "101" & "01" & "10", --39
	"0" & "1001" & "000" & "00" & "00", --40
	"0" & "0000" & "111" & "00" & "00", --41
	"1" & "0000" & "011" & "01" & "10", --42
	"0" & "1001" & "000" & "00" & "00", --43
	"0" & "0000" & "110" & "00" & "00", --44
	"1" & "0000" & "011" & "01" & "10", --45
	"1" & "1001" & "110" & "00" & "10", --46
	"0" & "0000" & "110" & "00" & "00", --47
	"1" & "0000" & "100" & "00" & "00", --48
	"0" & "0000" & "111" & "00" & "00", --49
	"1" & "0000" & "100" & "00" & "00", --50
	"1" & "0101" & "100" & "01" & "10", --51
	"1" & "1011" & "100" & "01" & "10", --52
	"0" & "1010" & "000" & "00" & "00", --53
	"1" & "0000" & "100" & "01" & "10"  --54
	);
	signal RegCom:TCommand;
	signal PC:integer;
	signal y_buf: std_logic_vector(25 downto 1);
	signal x_decoded: std_logic_vector(15 downto 0);
	signal y1_decoded: std_logic_vector(15 downto 0);
	signal y2_decoded: std_logic_vector(7 downto 0);
	signal y3_decoded: std_logic_vector(3 downto 0);
	signal y4_decoded: std_logic_vector(3 downto 0);
	signal not_p: std_logic;
	
	component decoder is
		generic(
			N: integer := 4
			);
		port(D: in std_logic_vector (N-1 downto 0);
			En: in std_logic;
			Q: out std_logic_vector (2**N -1 downto 0)
			); 
	end component;
begin
	not_p <= not RegCom(11);
	
	x_dc: decoder
		generic map(N => 4)
		port map(D => RegCom(10 downto 7), En => not_p, Q => x_decoded);
	
	y1_dc: decoder
		generic map(N => 4)
		port map(D => RegCom(10 downto 7), En => RegCom(11), Q => y1_decoded);
		
	y2_dc: decoder
		generic map(N => 3)
		port map(D => RegCom(6 downto 4), En => RegCom(11), Q => y2_decoded);
		
	y3_dc: decoder
		generic map(N => 2)
		port map(D => RegCom(3 downto 2), En => RegCom(11), Q => y3_decoded);
		
	y4_dc: decoder
		generic map(N => 2)
		port map(D => RegCom(1 downto 0), En => RegCom(11), Q => y4_decoded);
	
	
	process(rst,clk) is
		variable PCv:integer range 0 to 54;
	begin
		if rst='0' then PCv:=0;
		elsif rising_edge(clk) then
			if RegCom(11)='1' and (x_decoded(11 downto 1) and x) = 0 then
				PCv:=conv_integer(RegCom(6 downto 1));
			else
				PCv:=PCv+1;
			end if;
		end if;
		RegCom<=ROM(PCv);
		PC<=PCv;
	end process;
	
	y(1)  <= y1_decoded(1);
	y(5)  <= y1_decoded(2);
	y(6)  <= y1_decoded(3);
	y(9)  <= y1_decoded(4);
	y(10) <= y1_decoded(5);
	y(12) <= y1_decoded(6);
	y(15) <= y1_decoded(7);
	y(20) <= y1_decoded(8);
	y(21) <= y1_decoded(9);
	y(22) <= y1_decoded(10);
	y(23) <= y1_decoded(11);
	y(24) <= y1_decoded(12);
	y(25) <= y1_decoded(13);
	
	y(2)  <= y2_decoded(1);
	y(11) <= y2_decoded(2);
	y(13) <= y2_decoded(3);
	y(14) <= y2_decoded(4);
	y(16) <= y2_decoded(5);
	y(17) <= y2_decoded(6);
	y(18) <= y2_decoded(7);
	
	y(3)  <= y3_decoded(1);
	y(7)  <= y3_decoded(2);
	y(19) <= y3_decoded(3);
	
	y(4)  <= y4_decoded(1);
	y(8)  <= y4_decoded(2);
end architecture control_unit;