library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity Iniciales is 
port(	vidon : in std_logic;
		hc : in std_logic_vector(9 downto 0);
		vc : in std_logic_vector(9 downto 0);
		M : in std_logic_vector(53 downto 0);
		SW : in std_logic_vector(7 downto 0);
		rom_addr4 : out std_logic_vector(3 downto 0);
		red : out std_logic_vector(2 downto 0);
		green : out std_logic_vector(2 downto 0);
		blue : out std_logic_vector(1 downto 0)
		);
end Iniciales;

architecture vga_iniciales of Iniciales is
constant hbp : std_logic_vector(9 downto 0) := "0010010000";
constant vbp : std_logic_vector(9 downto 0) := "0000011111";
constant w : integer := 54;
constant h : integer := 16;
signal C1, R1 : std_logic_vector(10 downto 0);
signal rom_addr, rom_pix : std_logic_vector(10 downto 0);
signal spriteon ,R,G,B : std_logic;

begin
	C1 <= "00" & SW(3 downto 0) & "00001";
	R1 <= "00" & SW(7 downto 4) & "00001";
	rom_addr <= vc - vbp - R1;
	rom_pix <= hc - hbp - C1;
	rom_addr4 <= rom_addr(3 downto 0);
	
	spriteon <= '1' when (((hc >= C1 +hbp) and (hc < C1 +hbp + w))
			and ((vc >= R1 +vbp) and (vc < R1 +vbp + h))) else '0';
			
	process(spriteon,vidon,rom_pix,M)
	variable j : integer;
	begin
		red <= "000";
		green <= "000";
		blue <= "00";
		
		if spriteon = '1' and vidon = '1' then
			
			j := conv_integer(rom_pix);
			R <= M(j);
			G <= M(j);
			B <= M(j);
			red <= R & R & R;
			green <= G & G & G;
			blue <= B & B;
			
		end if;
	end process;
		
end vga_iniciales;