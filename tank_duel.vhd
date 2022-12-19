library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.tank_const.all;

entity tank_duel is 
port( 
    keyboard_clk, keyboard_data, clk 			    : in std_logic;
    reset_test,start_test, fire_bullet              : in std_logic;
    LCD_RS, LCD_E, LCD_ON, RESET_LED, SEC_LED,light	: out std_logic;
    LCD_RW											: buffer std_logic;
    DATA_BUS										: inout	std_logic_vector(7 DOWNTO 0);
    VGA_RED, VGA_GREEN, VGA_BLUE 					: out std_logic_vector(9 downto 0); 
    HORIZ_SYNC, VERT_SYNC, VGA_BLANK, VGA_CLK		: out std_logic;
    led_show										: out std_logic_vector (55 downto 0)
); 
end entity tank_duel;

architecture behavs1 of tank_duel is
component de2lcd is
port(
    tie,waiting,game_over,winner,reset, clk_50Mhz		: in	std_logic;
    LCD_RS, LCD_E, LCD_ON, RESET_LED, SEC_LED,light		: out	std_logic;
    LCD_RW												: buffer std_logic;
    DATA_BUS											: inout	std_logic_vector(7 DOWNTO 0)
);
end component;
component tank is
port(
    clk, clk_event, rst, tankdirection               : in std_logic;
    tankspeed                                  : in integer;
    tankposX, tankposY                      : out integer;
    tankstartposX, tankstartposY            : in integer
);
end component;
component bullet is
port(
    clk, clk_event, rst                         : in std_logic;
    bulletshot                               : in std_logic;
    bullethit                         : out std_logic;
    bulletdirection                                  : in std_logic;
    bulletposX, bulletposY                  : out integer;
    bulletstartposX, bulletstartposY        : in integer
);
end component;
component VGA_top_level is
port(
    CLOCK_50 									: in std_logic;
    RESET_N										: in std_logic;
    P1_x,P1_y,P1B_x,P1B_y                       : in integer;
    P2_x,P2_y,P2B_x,P2B_y                       : in integer;
    game_over,winner,tie                        : in std_logic;
    --VGA 
    VGA_RED, VGA_GREEN, VGA_BLUE 				: out std_logic_vector(9 DOWNTO 0); 
    HORIZ_SYNC, VERT_SYNC, VGA_BLANK, VGA_CLK	: out std_logic
);
end component;
component leddcd is
port(
    data_in 	  	: in std_logic_vector(3 DOWNTO 0);
    segments_out 	: out std_logic_vector(6 DOWNTO 0)
    );
end component leddcd;	
component ps2 is 
port( 
    keyboard_clk, keyboard_data, clock_50MHz,reset 		: in std_logic;
    scan_code 										    : out std_logic_vector( 7 downto 0 );
    scan_readyo 									    : out std_logic;
    hist3 												: out std_logic_vector(7 downto 0);
    hist2 												: out std_logic_vector(7 downto 0);
    hist1 												: out std_logic_vector(7 downto 0);
    hist0 												: out std_logic_vector(7 downto 0);
    led_show											: out std_logic_vector(55 downto 0)
    );
end component;
component const_clock is
port(
    clock_50MHz, reset 		: in std_logic;
    clk_event 			   	: out std_logic
    );
end component const_clock;

type collisionstates is (tank1point,tank2point,playing);
type gamestates is (winnertank1,winnertank2,game_tie,playing);
signal currentcollisionstate : collisionstates := playing;
signal nextcollisionstate : collisionstates;
signal tank1posX                      : integer;
signal tank1posY                      : integer;
signal tank2posX                      : integer;
signal tank2posY                      : integer;
signal tank1startposX                 : integer:= 320-t_size/2;
signal tank1startposY                 : integer:= 480-t_size;
signal tank2startposX                 : integer:= 320-t_size/2;
signal tank2startposY                 : integer:= 0;
signal tank1bulletposX 		        : integer:= 655;
signal tank1bulletposY 	 	        : integer:= 495;
signal tank2bulletposX 		        : integer:= 655;
signal tank2bulletposY    	 	    : integer:= 495;
signal bullet1shot                    : std_logic:='0';
signal bullet1hit             : std_logic:='0';
signal bullet2shot                    : std_logic:='0';
signal bullet2hit             : std_logic:='0';
signal P1_x  							: integer;
signal P1_y  							: integer;
signal P2_x  							: integer;
signal P2_y  							: integer;
signal P1_speed  			     		: integer := 0;
signal P2_speed       					: integer := 0;
signal c_clock    						: std_logic;
signal scan_readyo    					: std_logic;
signal winner         					: std_logic := 'X';
signal game_over    			  	    : std_logic := '0';
signal over           				    : std_logic := '0';
signal reset, tie	  					: std_logic := '0';
signal tank1bullet, tank2hit 			: std_logic;
signal tank2bullet, tank1hit 			: std_logic;
signal init                             : std_logic :='0';
signal res_lcd                          : std_logic:='0';
signal waiting                          : std_logic:='0';
signal go 								: std_logic;
signal LEDs			  					: std_logic_vector(55 downto 0);
signal temp_1 		  					: std_logic_vector(5 downto 0);
signal hist3, hist2, hist1, hist0 	    : std_logic_vector(7 downto 0);
signal P1score		  					: std_logic_vector(3 downto 0) := "0000";
signal P1score_s		  				: std_logic_vector(3 downto 0) := "0000";
signal P1score_c		  				: std_logic_vector(3 downto 0) := "0000";
signal P2score		  					: std_logic_vector(3 downto 0) := "0000";
signal P2score_s		  				: std_logic_vector(3 downto 0) := "0000";
signal P2score_c		  				: std_logic_vector(3 downto 0) := "0000";
signal scan_code      					: std_logic_vector(7 downto 0);
begin 
    LCD         : de2lcd port MAP (tie,waiting,game_over,winner,res_lcd,clk,LCD_RS,LCD_E, LCD_ON, RESET_LED, SEC_LED,light,LCD_RW,DATA_BUS);
    keyboard_0 	: ps2 port MAP (keyboard_clk, keyboard_data, clk, '1', scan_code, scan_readyo, hist3, hist2, hist1, hist0, LEDs);
    vga_0 		: VGA_top_level port MAP (clk, reset,P1_x, P1_y, tank1bulletposX, tank1bulletposY, P2_x, P2_y, tank2bulletposX, tank2bulletposY,  game_over, winner, tie, VGA_RED, VGA_GREEN, VGA_BLUE, HORIZ_SYNC, VERT_SYNC, VGA_BLANK, VGA_CLK);
    clock_map	: const_clock port MAP(clock_50MHz=> clk, reset=>init, clk_event => c_clock);

    conv0 		: leddcd port MAP (P1score,led_show(48 downto 42));
    conv1 		: leddcd port MAP (P2score,led_show(34 downto 28));
    conv2 		: leddcd port MAP ("0000",led_show(55 downto 49));
    conv3 		: leddcd port MAP ("0000",led_show(41 downto 35));
    led_show(27 downto 0) <= LEDs(27 downto 0);

    tank1 : tank port map(clk=>clk, clk_event=>c_clock, rst=>init, tankspeed=>P1_speed, tankdirection=>'0', tankposX=>tank1posX, tankposY=>tank1posY, tankstartposX=>tank1startposX, tankstartposY=>tank1startposY);

    tank2 : tank port map(clk=>clk, clk_event=>c_clock, rst=>init, tankspeed=>P2_speed, tankdirection=>'0', tankposX=>tank2posX, tankposY=>tank2posY, tankstartposX=>tank2startposX, tankstartposY=>tank2startposY);

    bullet1 : bullet port map(clk=>clk, clk_event=>c_clock, rst=>init, bulletshot=>bullet1shot, bullethit=>bullet1hit, bulletdirection=>'0', bulletposX=>tank1bulletposX,bulletposY=>tank1bulletposY, bulletstartposX=>tank1startposX, bulletstartposY=>tank1startposY);

    bullet2 : bullet port map(clk=>clk, clk_event=>c_clock, rst=>init, bulletshot=>bullet2shot, bullethit=>bullet2hit, bulletdirection=>'1', bulletposX=>tank2bulletposX,bulletposY=>tank2bulletposY, bulletstartposX=>tank2posX, bulletstartposY=>tank2posY);

    col_fsm: process(tank2bullet, tank1bullet, tank1bulletposX, tank2posX, tank2bulletposX, tank1posX, tank2bulletposY, tank1posY, tank1bulletposY, tank2posY, P1score_s, P2score_s, currentcollisionstate) is
    begin
        nextcollisionstate <= currentcollisionstate;
        P1score_c <= P1score_s;
        P2score_c <= P2score_s;
        case currentcollisionstate is
            when playing =>
                if((tank2bulletposX >= tank1posX) and (tank2bulletposX < tank1posX+t_size) and (tank2bulletposY >= tank1posY) and (tank2bulletposY < tank1posY+t_size)) then
                    nextcollisionstate <= tank2point;
                elsif((tank1bulletposX >= tank2posX) and (tank1bulletposX < tank2posX+t_size) and (tank1bulletposY >= tank2posY) and (tank1bulletposY < tank2posY+t_size)) then
                    nextcollisionstate <= tank1point;
                else
                    nextcollisionstate <= playing;
                end if;
            when tank1point =>
                P1score_c <= std_logic_vector(unsigned(P1score_s) +to_unsigned(1,P1score_s'length));
                nextcollisionstate <= playing;
            when tank2point =>
                P2score_c <= std_logic_vector(unsigned(P2score_s) +to_unsigned(1,P2score_s'length));
                nextcollisionstate <= playing;
        end case;
    end process col_fsm;
    collisionfsm: process(c_clock) is
    begin
        if(reset = '1') then
            P2score_s 	<= "0000";
            P1score_s 	<= "0000";
        elsif(rising_edge(c_clock)) then
            currentcollisionstate <= nextcollisionstate;
            P1score_s <= P1score_c;
            P2score_s <= P2score_c;
        end if;
    end process collisionfsm;
    P2score <= std_logic_vector(unsigned(P2score_s)/2);
    P1score <= std_logic_vector(unsigned(P1score_s)/2);

    final_process: process(c_clock,P1score,P2score) is
    begin
        if(reset = '1') then
            winner <= 'X';
            game_over <= '0';
            over <= '0';   
        elsif(rising_edge(c_clock)) then
            if (unsigned(P1score) = 3) then
                game_over <= '1';
                winner    <= '0';
                over <= '1';
            end if;	
            if (unsigned(P2score) = 3) then
                game_over <= '1';
                winner    <= '1';
                over <= '1';
            end if;
            if ((unsigned(P2score) = 3) and (unsigned(P1score) = 3)) then 
                tie<='1';
                over <= '1';
            end if;
        end if;
    end process final_process;

    start: process(reset_test,start_test,clk,tank1posX,tank1posY) is
    variable bullet1hit : std_logic:= '0';
    begin
        if(rising_edge(clk)) then
            res_lcd <= '1';
            waiting <= '0';
            if (reset = '1') then
                P1_speed <= 0;
                P2_speed <= 0;
                tank1startposX <= 320-t_size/2;
                tank1startposY <= 480-t_size;
                tank2startposX <= 320-t_size/2;
                tank2startposY <= 0;
                init <= '1';
                waiting <= '1';
                over <= '0';
                reset <= '0';
            elsif(start_test = '1') then
                bullet1shot <= '1';
            end if;
        end if;
        P1_x <= tank1startposX;
        P1_y <= tank1startposY;
        P2_x <= tank2startposX;
        P2_y <= tank2startposY;
    end process start;
end architecture behavs1;

architecture behav of tank_duel is
component de2lcd is
port(
    tie,waiting,game_over,winner,reset, clk_50Mhz		: in	std_logic;
    LCD_RS, LCD_E, LCD_ON, RESET_LED, SEC_LED,light		: out	std_logic;
    LCD_RW												: buffer std_logic;
    DATA_BUS											: inout	std_logic_vector(7 DOWNTO 0)
);
end component;
component tank is
port(
    clk, clk_event, rst, tankdirection               : in std_logic;
    tankspeed                                  : in integer;
    tankposX, tankposY                      : out integer;
    tankstartposX, tankstartposY            : in integer
);
end component;
component bullet is
port(
    clk, clk_event, rst                         : in std_logic;
    bulletshot                               : in std_logic;
    bullethit                         : out std_logic;
    bulletdirection                                  : in std_logic;
    bulletposX, bulletposY                  : out integer;
    bulletstartposX, bulletstartposY        : in integer
);
end component;
component VGA_top_level is
port(
    CLOCK_50 									: in std_logic;
    RESET_N										: in std_logic;
    P1_x,P1_y,P1B_x,P1B_y                       : in integer;
    P2_x,P2_y,P2B_x,P2B_y                       : in integer;
    game_over,winner,tie                        : in std_logic;
    --VGA 
    VGA_RED, VGA_GREEN, VGA_BLUE 				: out std_logic_vector(9 DOWNTO 0); 
    HORIZ_SYNC, VERT_SYNC, VGA_BLANK, VGA_CLK	: out std_logic
);
end component;
component leddcd is
port(
    data_in 	  	: in std_logic_vector(3 DOWNTO 0);
    segments_out 	: out std_logic_vector(6 DOWNTO 0)
    );
end component leddcd;	
component ps2 is 
port( 
    keyboard_clk, keyboard_data, clock_50MHz,reset 		: in std_logic;
    scan_code 										    : out std_logic_vector( 7 downto 0 );
    scan_readyo 									    : out std_logic;
    hist3 												: out std_logic_vector(7 downto 0);
    hist2 												: out std_logic_vector(7 downto 0);
    hist1 												: out std_logic_vector(7 downto 0);
    hist0 												: out std_logic_vector(7 downto 0);
    led_show											: out std_logic_vector(55 downto 0)
    );
end component;
component const_clock is
port(
    clock_50MHz, reset 		: in std_logic;
    clk_event 			   	: out std_logic
    );
end component const_clock;

type collisionstates is (tank1point,tank2point,playing);
type gamestates is (winnertank1,winnertank2,game_tie,playing);
signal currentcollisionstate : collisionstates := playing;
signal nextcollisionstate : collisionstates;
signal tank1posX                      : integer;
signal tank1posY                      : integer;
signal tank2posX                      : integer;
signal tank2posY                      : integer;
signal tank1startposX                 : integer := 320-t_size/2;
signal tank1startposY                 : integer := 480-t_size;
signal tank2startposX                 : integer := 320-t_size/2;
signal tank2startposY                 : integer := 0;
signal tank1bulletposX 		        : integer:= 655;
signal tank1bulletposY 	 	        : integer:= 495;
signal tank2bulletposX 		        : integer:= 655;
signal tank2bulletposY    	 	    : integer:= 495;
signal bullet1shot                    : std_logic:='0';
signal bullet1hit             : std_logic:='0';
signal bullet2shot                    : std_logic:='0';
signal bullet2hit             : std_logic:='0';
signal P1_x  							: integer;
signal P1_y  							: integer;
signal P2_x  							: integer;
signal P2_y  							: integer;
signal P1_speed  			     		: integer := 2;
signal P2_speed       					: integer := 2;
signal c_clock    						: std_logic;
signal scan_readyo    					: std_logic;
signal winner         					: std_logic := 'X';
signal game_over    			  	    : std_logic := '0';
signal over           				    : std_logic := '0';
signal reset, tie	  					: std_logic := '0';
signal tank1bullet, tank2hit 			: std_logic;
signal tank2bullet, tank1hit 			: std_logic;
signal init                             : std_logic :='0';
signal res_lcd                          : std_logic:='0';
signal waiting                          : std_logic:='0';
signal go 								: std_logic;
signal LEDs			  					: std_logic_vector(55 downto 0);
signal temp_1 		  					: std_logic_vector(5 downto 0);
signal hist3, hist2, hist1, hist0 	    : std_logic_vector(7 downto 0);
signal P1score		  					: std_logic_vector(3 downto 0) := "0000";
signal P1score_s		  				: std_logic_vector(3 downto 0) := "0000";
signal P1score_c		  				: std_logic_vector(3 downto 0) := "0000";
signal P2score		  					: std_logic_vector(3 downto 0) := "0000";
signal P2score_s		  				: std_logic_vector(3 downto 0) := "0000";
signal P2score_c		  				: std_logic_vector(3 downto 0) := "0000";
signal scan_code      					: std_logic_vector(7 downto 0);
begin 
    LCD         : de2lcd port MAP (tie,waiting,game_over,winner,res_lcd,clk,LCD_RS,LCD_E, LCD_ON, RESET_LED, SEC_LED,light,LCD_RW,DATA_BUS);
    keyboard_0 	: ps2 port MAP (keyboard_clk, keyboard_data, clk, '1', scan_code, scan_readyo, hist3, hist2, hist1, hist0, LEDs);
    vga_0 		: VGA_top_level port MAP (clk, reset,P1_x, P1_y, tank1bulletposX, tank1bulletposY, P2_x, P2_y, tank2bulletposX, tank2bulletposY,  game_over, winner, tie, VGA_RED, VGA_GREEN, VGA_BLUE, HORIZ_SYNC, VERT_SYNC, VGA_BLANK, VGA_CLK);
    clock_map	: const_clock port MAP(clock_50MHz=> clk, reset=>init, clk_event => c_clock);

    conv0 		: leddcd port MAP (P1score,led_show(48 downto 42));
    conv1 		: leddcd port MAP (P2score,led_show(34 downto 28));
    conv2 		: leddcd port MAP ("0000",led_show(55 downto 49));
    conv3 		: leddcd port MAP ("0000",led_show(41 downto 35));
    led_show(27 downto 0) <= LEDs(27 downto 0);

    tank1 : tank port map(clk=>clk, clk_event=>c_clock, rst=>init, tankspeed=>P1_speed, tankdirection=>'0', tankposX=>tank1posX, tankposY=>tank1posY, tankstartposX=>tank1startposX, tankstartposY=>tank1startposY);

    tank2 : tank port map(clk=>clk, clk_event=>c_clock, rst=>init, tankspeed=>P2_speed, tankdirection=>'1', tankposX=>tank2posX, tankposY=>tank2posY, tankstartposX=>tank2startposX, tankstartposY=>tank2startposY);

    bullet1 : bullet port map(clk=>clk, clk_event=>c_clock, rst=>init, bulletshot=>bullet1shot, bullethit=>bullet1hit, bulletdirection=>'0', bulletposX=>tank1bulletposX,bulletposY=>tank1bulletposY, bulletstartposX=>tank1posX, bulletstartposY=>tank1posY);

    bullet2 : bullet port map(clk=>clk, clk_event=>c_clock, rst=>init, bulletshot=>bullet2shot, bullethit=>bullet2hit, bulletdirection=>'1', bulletposX=>tank2bulletposX,bulletposY=>tank2bulletposY, bulletstartposX=>tank2posX, bulletstartposY=>tank2posY);

    col_fsm: process(tank2bullet, tank2bulletposX, tank1posX, tank1bullet, tank1bulletposX, tank2posX, tank2bulletposX, tank1posX, tank2bulletposY, tank1posY, tank1bulletposY, tank2posY, P1score_s, P2score_s, currentcollisionstate) is
    begin
        nextcollisionstate <= currentcollisionstate;
        P1score_c <= P1score_s;
        P2score_c <= P2score_s;
        case currentcollisionstate is
            when playing =>
                if((tank2bulletposX >= tank1posX) and (tank2bulletposX < tank1posX+t_size) and (tank2bulletposY >= tank1posY) and (tank2bulletposY < tank1posY+t_size)) then
                    nextcollisionstate <= tank2point;
                elsif((tank1bulletposX >= tank2posX) and (tank1bulletposX < tank2posX+t_size) and (tank1bulletposY >= tank2posY) and (tank1bulletposY < tank2posY+t_size)) then
                    nextcollisionstate <= tank1point;
                else
                    nextcollisionstate <= playing;
                end if;
            when tank1point =>
                P1score_c <= std_logic_vector(unsigned(P1score_s) +to_unsigned(1,P1score_s'length));
                nextcollisionstate <= playing;
            when tank2point =>
                P2score_c <= std_logic_vector(unsigned(P2score_s) +to_unsigned(1,P2score_s'length));
                nextcollisionstate <= playing;
        end case;
    end process col_fsm;
    collisionfsm: process(c_clock) is
    begin
        if(reset = '1') then
            P2score_s 	<= "0000";
            P1score_s 	<= "0000";
        elsif(rising_edge(c_clock)) then
            currentcollisionstate <= nextcollisionstate;
            P1score_s <= P1score_c;
            P2score_s <= P2score_c;
        end if;
    end process collisionfsm;
    P2score <= std_logic_vector(unsigned(P2score_s)/2);
    P1score <= std_logic_vector(unsigned(P1score_s)/2);

    final_process: process(c_clock,P1score,P2score) is
    begin
        if(reset = '1') then
            winner <= 'X';
            game_over <= '0';
            over <= '0';   
        elsif(rising_edge(c_clock)) then
            if (unsigned(P1score) = 3) then
                game_over <= '1';
                winner    <= '0';
                over <= '1';
            end if;	
            if (unsigned(P2score) = 3) then
                game_over <= '1';
                winner    <= '1';
                over <= '1';
            end if;
            if ((unsigned(P2score) = 3) and (unsigned(P1score) = 3)) then 
                tie<='1';
                over <= '1';
            end if;
        end if;
    end process final_process;

    start: process(reset_test,clk,tank1posX,tank1posY) is
    variable bullet1hit : std_logic:= '0';
    begin
        if(rising_edge(clk)) then
            res_lcd <= '1';
            waiting <= '0';
            if ((hist1=X"00" and hist0=X"00") or reset = '1') then
                P1_speed <= 2;
                P2_speed <= 2;
                tank1startposX <= 320-t_size/2;
                tank1startposY <= 480-t_size;
                tank2startposX <= 320-t_size/2;
                tank2startposY <= 0;
                init <= '1';
                waiting <= '1';
                over <= '0';
                reset <= '0';
            elsif(hist1=X"F0") then
                init <= '0';
                go <= '1';
                waiting <= '0';
                reset <= '0';
            end if;
            case hist0 is
                when X"16" =>					
                    P1_speed <= 2;
                when X"1E" =>					
                    P1_speed <= 3;
                when X"26" =>					
                    P1_speed <= 4;
                when X"69" =>					
                    P2_speed <= 2;
                when X"72" =>					
                    P2_speed <= 3;
                when X"7A" =>					
                    P2_speed <= 4;
                when X"29" =>  				    
                    bullet1shot <= '1';
                when X"70" =>				    
                    bullet2shot <= '1';
                when X"66" => 					
                    go <= '0';
                    res_lcd <= '0';
                    reset <= '1';
                when others =>
                    null;
            end case;
            if(bullet1hit = '1') then
                bullet1shot <= '0';
            end if;
        end if;
        P1_x <= tank1posX;
        P1_y <= tank1posY;
        P2_x <= tank2posX;
        P2_y <= tank2posY;
    end process start;
end architecture behav;