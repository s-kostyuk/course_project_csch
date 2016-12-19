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
	signal x_decoded: std_logic_vector(10 downto 0);
begin
	process(rst,clk) is
		variable PCv:integer range 0 to 54;
	begin
		if rst='0' then PCv:=0;
		elsif rising_edge(clk) then
			if RegCom(11)='1' and (x_decoded and x) = "0000000000" then
				PCv:=conv_integer(RegCom(6 downto 1));
			else
				PCv:=PCv+1;
			end if;
		end if;
		RegCom<=ROM(PCv);
		PC<=PCv;
	end process;
	
	process (RegCom) is
		variable Y1: std_logic_vector (3 downto 0);
		variable Y2: std_logic_vector (2 downto 0);
		variable Y3: std_logic_vector (1 downto 0);
		variable Y4: std_logic_vector (1 downto 0);
		variable X_index: integer range 15 downto 0;
	begin
		y_buf <= (others => '0');
		Y1 := RegCom(10 downto 7);
		Y2 := RegCom(6  downto 4);
		Y3 := RegCom(3  downto 2);
		Y4 := RegCom(1  downto 0);
		X_index := conv_integer(RegCom(10 downto 7));
		x_decoded <= (others => '0');
		
		case Y1 is
			when "0001" => 
				y_buf(1) <= '1';
			
			when "0010" =>
				y_buf(5) <= '1';
			
			when "0011" =>
				y_buf(6) <= '1';
			
			when "0100" =>
				y_buf(9) <= '1';
			
			when "0101" =>
				y_buf(10) <= '1';
			
			when "0110" =>
				y_buf(12) <= '1';
			
			when "0111" =>
				y_buf(15) <= '1';
			
			when "1000" =>
				y_buf(20) <= '1';
			
			when "1001" =>
				y_buf(21) <= '1';
			
			when "1010" =>
				y_buf(22) <= '1';
			
			when "1011" =>
				y_buf(23) <= '1';
			
			when "1100" =>
				y_buf(24) <= '1';
			
			when "1101" =>
				y_buf(25) <= '1';
			
			when others => null; 
			
		end case;
		
		case Y2 is
			when "001" => 
				y_buf(2) <= '1';
			
			when "010" =>
				y_buf(11) <= '1';
			
			when "011" =>
				y_buf(13) <= '1';
			
			when "100" =>
				y_buf(14) <= '1';
			
			when "101" =>
				y_buf(16) <= '1';
			
			when "110" =>
				y_buf(17) <= '1';
			
			when "111" =>
				y_buf(18) <= '1';
			
			when others => null;
		end case;
		
		case Y3 is
			when "01" => 
				y_buf(3) <= '1';
			
			when "10" =>
				y_buf(7) <= '1';
			
			when "11" =>
				y_buf(19) <= '1';
			
			when others => null;
		end case;
		
		case Y4 is
			when "01" => 
				y_buf(4) <= '1';
			
			when "10" =>
				y_buf(8) <= '1';
			
			when "11" =>
				y_buf(20) <= '1';
			
			when others => null;
		end case;
		
		if (x_index = 0 or RegCom(11)='0') then
			x_decoded <= (others => '0');
		else 
			x_decoded(X_index - 1) <= '1';
		end if;
			
		
	end process;
	
	y<= y_buf when RegCom(11)='0' else (others=>'0');
end architecture control_unit;