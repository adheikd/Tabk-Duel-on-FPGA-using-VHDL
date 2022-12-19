library ieee;
use ieee.std_logic_1164.all;
use WORK.tank_const.all;

entity bullet is
port(
    clk,clk_event,rst                : in std_logic;
    bulletshot                     : in std_logic;
    bullethit              : out std_logic; 
    bulletdirection                       : in std_logic;
    bulletposX, bulletposY           : out integer;
    bulletstartposX, bulletstartposY : in integer
);
end entity bullet;

architecture behav of bullet is
type bullet_states is (ammo,fired,fireddown,tankdown);
signal current_state : bullet_states := ammo;
signal next_state : bullet_states := ammo;
signal bulletposX_s : integer := bulletstartposX;
signal bulletposX_c : integer := bulletstartposX;
signal bulletposY_s : integer := bulletstartposY;
signal bulletposY_c : integer := bulletstartposY;
signal bullethit_seq : std_logic := '0';
signal bullethit_com : std_logic := '0';
begin
    fsm_process: process(clk_event,current_state,bulletposX_s,bulletposY_s,bulletstartposX,bulletstartposY)
    variable bulletshot_local : std_logic := bulletshot;
    begin
        if(rising_edge(clk_event)) then
            bulletposY_c <= bulletposY_s; 
            bullethit_com <= bullethit_seq;
            next_state <= current_state;
            case current_state is
                when ammo =>
                    bulletshot_local := bulletshot;
                    bullethit_com <= '0';
                    bulletposX_c <= bulletstartposX;
                    bulletposY_c <= bulletstartposY;
                    if(bulletshot_local = '1') then
                        bulletshot_local := '0';
                        if(bulletdirection = '0') then
                            next_state <= fired;
                        else
                            next_state <= fireddown;
                        end if;
                    end if;
                when fired =>
                    bulletposX_c <= bulletposX_s;
                    bulletposY_c <= bulletposY_s - bullet_travel;
                    if(bulletposY_s < bullet_travel) then
                        next_state <= tankdown;
                    else
                        next_state <= fired;
                    end if;
                when fireddown =>
                    bulletposX_c <= bulletposX_s;
                    bulletposY_c <= bulletposY_s + bullet_travel;
                    if(bulletposY_s > 479-bullet_travel) then
                        next_state <= tankdown;
                    else
                        next_state <= fireddown;
                    end if;
                when tankdown =>
                    bullethit_com <= '1';
                    bulletposX_c <= 655;   --re-hide/delete bullet
                    bulletposY_c <= 495;
                    next_state <= ammo;
                when others =>
                    bullethit_com <= '0';
                    bulletposX_c <= 655;   --re-hide/delete bullet
                    bulletposY_c <= 495;
                    next_state <= ammo;
            end case;
        end if;
    end process;

    clk_process : process(clk, rst, bulletstartposX, bulletstartposY)
    begin
        if rst='1' then
            current_state <= ammo;
            bulletposX_s <= bulletstartposX;
            bulletposY_s <= bulletstartposY;
            bullethit_seq <= '0';
        elsif (rising_edge(clk)) then
            bulletposX_s <= bulletposX_c;
            bulletposY_s <= bulletposY_c;
            bullethit_seq <= bullethit_com;
            current_state <= next_state;
        end if;
    end process;
    bulletposX <= bulletposX_s;
    bulletposY <= bulletposY_s;
    bullethit <= bullethit_seq;
end architecture;