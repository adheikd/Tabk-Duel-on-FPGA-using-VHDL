library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
USE work.tank_const.all;

entity pixelGenerator is
	port(clk, ROM_clk, rst_n, video_on, eof 			: in std_logic;
		pixel_row, pixel_column						    : in std_logic_vector(9 downto 0);
		P1_x,P1_y,P1B_x,P1B_y                           : in integer;
		P2_x,P2_y,P2B_x,P2B_y                           : in integer;
		game_over,winner,tie                            : in std_logic;
		red_out, green_out, blue_out					: out std_logic_vector(9 downto 0)
	);
end entity pixelGenerator;

architecture behavioral of pixelGenerator is
constant color_red 	 	 : std_logic_vector(2 downto 0) := "000";
constant color_green	 : std_logic_vector(2 downto 0) := "001";
constant color_blue 	 : std_logic_vector(2 downto 0) := "010";
constant color_yellow 	 : std_logic_vector(2 downto 0) := "011";
constant color_magenta 	 : std_logic_vector(2 downto 0) := "100";
constant color_cyan 	 : std_logic_vector(2 downto 0) := "101";
constant color_black 	 : std_logic_vector(2 downto 0) := "110";
constant color_white	 : std_logic_vector(2 downto 0) := "111";
component colorROM is
	port(
		address		: in std_logic_vector (2 downto 0);
		clock		: in std_logic  := '1';
		q			: out std_logic_vector (29 downto 0)
	);
end component colorROM;
signal colorAddress : std_logic_vector (2 downto 0);
signal color        : std_logic_vector (29 downto 0);
signal pixel_row_int, pixel_column_int : natural;
begin

	red_out <= color(29 downto 20);
	green_out <= color(19 downto 10);
	blue_out <= color(9 downto 0);
	pixel_row_int <= to_integer(unsigned(pixel_row));
	pixel_column_int <= to_integer(unsigned(pixel_column));
	
	colors : colorROM port map(colorAddress, ROM_clk, color);
	
	pixelDraw : process(clk, winner, game_over) is
	begin
		colorAddress <= color_white;
		if (game_over = '0') then	
			colorAddress <= color_black;
			if ((pixel_column_int >= P1_x) and (pixel_column_int < P1_x+t_size) and (pixel_row_int >= P1_y) and (pixel_row_int < P1_y+t_size)) then
				colorAddress <= color_blue;
			elsif ((pixel_column_int >= P1_x + 11) and (pixel_column_int < P1_x + 19) and (pixel_row_int >= P1_y-c_length) and (pixel_row_int <= P1_y)) then
				colorAddress <= color_blue;
			end if;
			if ((pixel_column_int >= P2_x) and (pixel_column_int < P2_x+t_size) and (pixel_row_int >= P2_y) and (pixel_row_int < P2_y+t_size)) then
				colorAddress <= color_red;
			elsif ((pixel_column_int >= P2_x + 11) and (pixel_column_int < P2_x + 19) and (pixel_row_int >= P2_y+t_size) and (pixel_row_int <= P2_y+t_size+c_length)) then
				colorAddress <= color_red;
			end if;
			if ((pixel_column_int >= P1B_x) and (pixel_column_int < P1B_x+b_width) and (pixel_row_int >= P1B_y) and (pixel_row_int < P1B_y+b_width)) then
			colorAddress <= color_blue;
			end if;
			if ((pixel_column_int >= P2B_x) and (pixel_column_int < P2B_x+b_width) and (pixel_row_int >= P2B_y) and (pixel_row_int < P2B_y+b_width)) then
			colorAddress <= color_red;
			end if;  
		elsif (game_over='1') then
			colorAddress <= color_white;
			if (tie='1') then
				colorAddress <= color_black;
			elsif (winner='0') then 
				if ((pixel_column_int >= P1_x) and (pixel_column_int < P1_x+t_size) and (pixel_row_int >= P1_y) and (pixel_row_int < P1_y+t_size)) then
					colorAddress <= color_blue;
				elsif ((pixel_column_int >= P1_x + 11) and (pixel_column_int < P1_x + 19) and (pixel_row_int >= P1_y-c_length) and (pixel_row_int <= P1_y)) then
					colorAddress <= color_blue;
				elsif ((pixel_column_int >= P1B_x) and (pixel_column_int < P1B_x+b_width) and (pixel_row_int >= P1B_y) and (pixel_row_int < P1B_y+b_width)) then
					colorAddress <= color_blue;
				else
				end if;
			else	
				if ((pixel_column_int >= P2_x) and (pixel_column_int < P2_x+t_size) and (pixel_row_int >= P2_y) and (pixel_row_int < P2_y+t_size)) then
					colorAddress <= color_red;
				elsif ((pixel_column_int >= P2_x + 11) and (pixel_column_int < P2_x + 19) and (pixel_row_int >= P2_y+t_size) and (pixel_row_int <= P2_y+t_size+c_length)) then
					colorAddress <= color_red;
				elsif ((pixel_column_int >= P2B_x) and (pixel_column_int < P2B_x+b_width) and (pixel_row_int >= P2B_y) and (pixel_row_int < P2B_y+b_width)) then
					colorAddress <= color_red;
			else
			end if;  			   
			end if;
		end if;
	end process pixelDraw;	
end architecture behavioral;		