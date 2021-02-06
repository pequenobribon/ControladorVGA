
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Union_vga is
	port( CLK : in std_logic;
			btn : in std_logic;
			btngo : in std_logic;
			HSYNC : out std_logic;
			VSYNC : out std_logic;
			RED : out std_logic_vector(2 downto 0);
			GREEN : out std_logic_vector(2 downto 0);
			BLUE : out std_logic_vector(1 downto 0));

end Union_vga;

architecture Behavioral of Union_vga is

component CLK_DIV is
    Port ( clk : in  STD_LOGIC;
           clr : in  STD_LOGIC;
           q1 : out  STD_LOGIC;
			  q190 : out std_logic);
end component;

component Vga_control is
	Port ( clk,clr : in STD_LOGIC;
			hsync : out std_logic;
			vsync : out std_logic;
			hc : out std_logic_vector(9 downto 0);
			vc : out std_logic_vector(9 downto 0);
			vidon : out std_logic);
end component;


component blk_mem_gen_v7_3NombEscom IS
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END component;

component vga_ScreenSaver is
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
end component;

component vga_bounce is
    Port ( cclk : in  STD_LOGIC;
           clr : in  STD_LOGIC;
           go : in  STD_LOGIC;
           c1 : out  STD_LOGIC_VECTOR (9 downto 0);
           r1 : out  STD_LOGIC_VECTOR (9 downto 0));
end component;

component E_reb is
    Port ( clk : in  STD_LOGIC;
           clr : in  STD_LOGIC;
           ent : in  STD_LOGIC;
           sal : out  STD_LOGIC);
end component;

--Señales
signal clr,clk_aux,clk_aux190,vidon,go1 : std_logic;
signal hc,vc,C1,R1 : std_logic_vector(9 downto 0);
signal M : std_logic_vector(7 downto 0);
signal rom_addr16 : std_logic_vector(15 downto 0);
begin
clr <= btn;
U1 : CLK_DIV port map(CLK,clr,clk_aux,clk_aux190);
U2 : Vga_control port map(clk_aux,clr,HSYNC,VSYNC,hc,vc,vidon);
U3 : vga_bounce port map(clk_aux190,clr,go1,C1,R1);
U4: vga_ScreenSaver port map(vidon,hc,vc,M,C1,R1,rom_addr16,RED,GREEN,BLUE);
U5 : blk_mem_gen_v7_3NombEscom port map(clk_aux,rom_addr16,M);
U6 : E_reb port map(clk_aux190,clr,btngo,go1);
end Behavioral;
