library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity vga_ScreenSaver is
    Port ( vidon : in  STD_LOGIC;
           hc : in  STD_LOGIC_VECTOR (9 downto 0);
           vc : in  STD_LOGIC_VECTOR (9 downto 0);
           M : in  STD_LOGIC_VECTOR (7 downto 0);
           C1 : in  STD_LOGIC_VECTOR (9 downto 0);
           R1 : in  STD_LOGIC_VECTOR (9 downto 0);
           rom_addr16 : out  STD_LOGIC_VECTOR (15 downto 0);
           red : out  STD_LOGIC_VECTOR (2 downto 0);
           green : out  STD_LOGIC_VECTOR (2 downto 0);
           blue : out  STD_LOGIC_VECTOR (1 downto 0));
end vga_ScreenSaver;

architecture Behavioral of vga_ScreenSaver is
constant hbp : std_logic_vector(9 downto 0) := "0010010000";
constant vbp : std_logic_vector(9 downto 0) := "0000011111";
--Tamaño de la figura
constant w : integer := 240;
constant h : integer := 160;
signal xpix, ypix : std_logic_vector(9 downto 0);
signal spriteon : std_logic;

begin
	ypix <= vc - vbp - R1;
	xpix <= hc - hbp - C1;
	
	spriteon <= '1' when (((hc >= C1 + hbp) and (hc < C1 + hbp + w))
				and ((vc >= R1 + vbp) and (vc < R1 + vbp + h ))) else '0';
				
				process(xpix,ypix)
				variable rom_addr1, rom_addr2 : std_logic_vector(16 downto 0);
				begin
					rom_addr1 := (ypix & "0000000") + ('0' & ypix & "000000") 
					+ ("00" & ypix & "00000") + ("000" & ypix & "0000");
					
					rom_addr2 := rom_addr1 + ("0000000" & xpix);
					rom_addr16 <= rom_addr2(15 downto 0);
				end process;
				
				process(spriteon, vidon, M)
				variable j : integer;
				
				begin 
					red <= "000";
					green <= "000";
					blue <= "00";
					
					if spriteon = '1' and vidon = '1' then
						red <= M(7 downto 5);
						green <= M(4 downto 2);
						blue <= M(1 downto 0);
					end if;
				end process;
				
				

end Behavioral;

