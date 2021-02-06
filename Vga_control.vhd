library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Vga_control is
	Port ( clk,clr : in STD_LOGIC;
			hsync : out std_logic;
			vsync : out std_logic;
			hc : out std_logic_vector(9 downto 0);
			vc : out std_logic_vector(9 downto 0);
			vidon : out std_logic);
end Vga_control;

architecture VGA of Vga_control is
	
	constant hpixels: std_logic_vector(9 downto 0) := "1100100000";
	constant vlines : std_logic_vector(9 downto 0) := "1000001001";
	constant hbp : std_logic_vector(9 downto 0) := "0010010000";
	constant hfp : std_logic_vector(9 downto 0) := "1100010000";
	constant vbp : std_logic_vector(9 downto 0) := "0000011111";
	constant vfp : std_logic_vector(9 downto 0) := "0111111111";
	signal hcs, vcs: std_logic_vector(9 downto 0);
	signal vsenable : std_logic;
	
	begin
	process(clk,clr)
	
	begin
		if clr = '1' then
			hcs <= "0000000000";
		elsif(clk'event and clk = '1')then
			if hcs = hpixels -1 then
				hcs <= "0000000000";
				vsenable <= '1';
			else
				hcs <= hcs+1;
				vsenable <='0';
			end if;
		end if;
	end process;
	hsync <= '0' when hcs <128 else '1';
	
	process(clk,clr,vsenable)
	begin 
		if clr ='1' then
			vcs <= "0000000000";
		elsif(clk'event and clk ='1' and vsenable ='1')then
			
			if vcs = vlines - 1 then
				vcs <= "0000000000";
			else
				vcs <= vcs+1;
			end if;
		end if;
	end process;
	
	vsync <= '0' when vcs < 2 else '1';
	vidon <= '1' when (((hcs < hfp)and(hcs >= hbp))
						and ((vcs < vfp) and (vcs >= vbp))) else '0';
		hc <= hcs;
		vc <= vcs;
end VGA;