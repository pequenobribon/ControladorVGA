
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity vga_initials is
port(

	mclk : in std_logic;
	btn : in std_logic;
	sw : in std_logic_vector(7 downto 0);
	hsync : out std_logic;
	vsync : out std_logic;
	red : out std_logic_vector(2 downto 0);
	green : out std_logic_vector(2 downto 0);
	blue : out std_logic_vector(1 downto 0));

end vga_initials;
architecture Behavioral of vga_initials is
component CLK_DIV is
    Port ( clk : in  STD_LOGIC;
           clr : in  STD_LOGIC;
           q1 : out  STD_LOGIC);
end component;

component Iniciales is 
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
end component;

component Vga_control is
	Port ( clk,clr : in STD_LOGIC;
			hsync : out std_logic;
			vsync : out std_logic;
			hc : out std_logic_vector(9 downto 0);
			vc : out std_logic_vector(9 downto 0);
			vidon : out std_logic);
end component;

component prom_DMH is
    Port ( addr : in  STD_LOGIC_VECTOR (3 downto 0);
           M : out  STD_LOGIC_VECTOR (0 to 53));
end component;


signal clr,clk25,vidon : std_logic;
signal hc,vc : std_logic_vector(9 downto 0);
signal M : std_logic_vector(0 to 53);
signal rom_addr4 : std_logic_vector(3 downto 0);
begin

clr <= btn;

U1: CLK_DIV port map(mclk,clr,clk25);
U2: Vga_control port map(clk25,clr,hsync,vsync,hc,vc,vidon);
U3: Iniciales port map(vidon,hc,vc,M,sw,rom_addr4,red,green,blue);
U4: prom_DMH port map(rom_addr4,M);

end Behavioral;

