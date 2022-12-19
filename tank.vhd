library ieee;
use ieee.std_logic_1164.all;
use WORK.tank_const.all;

entity tank is
port(
    clk,clk_event,rst, tankdirection      : in std_logic;
    tankspeed                       : in integer;
    tankposX, tankposY           : out integer;
    tankstartposX, tankstartposY : in integer
);
end entity tank;

architecture behav of tank is
type tankstates is (start,leftmove,rightmove,turnwall);
signal current_state : tankstates := start;
signal next_state : tankstates := start;
signal tankpositionX_s : integer := tankstartposX;
signal tankpositionX_c : integer := tankstartposX;
signal tankpositionY_s : integer := tankstartposY;
signal tankpositionY_c : integer := tankstartposY;
begin
    fsm_process: process(clk_event,current_state,tankpositionX_s,tankpositionY_s,tankstartposX,tankstartposY,tankspeed,tankdirection)
    variable tankdirection_local : std_logic := tankdirection;
    begin
        if(rising_edge(clk_event)) then
            tankpositionX_c <= tankpositionX_s; 
            tankpositionY_c <= tankpositionY_s; 
            next_state <= current_state;
            case current_state is
                when start =>
                    tankdirection_local := tankdirection;
                    tankpositionX_c <= tankstartposX;
                    tankpositionY_c <= tankstartposY;
                    if(tankdirection_local = '0') then
                        next_state <= leftmove;
                    elsif(tankdirection_local = '1') then
                        next_state <= rightmove;
                    end if;
                when leftmove =>
                    tankpositionX_c <= tankpositionX_s - tankspeed;
                    tankpositionY_c <= tankpositionY_s;
                    if((tankpositionX_s < tankspeed)) then
                        next_state <= turnwall;
                    else
                        next_state <= leftmove;
                    end if;
                    -- increment based on speed
                when rightmove => 
                    tankpositionX_c <= tankpositionX_s + tankspeed;
                    tankpositionY_c <= tankpositionY_s;
                    if((tankpositionX_s > 639-t_size-tankspeed)) then
                        next_state <= turnwall;
                    else
                        next_state <= rightmove;
                    end if;
                when turnwall =>
                    tankpositionX_c <= tankpositionX_s;
                    tankpositionY_c <= tankpositionY_s;
                    if(tankdirection_local = '0') then
                        next_state <= rightmove;
                    elsif(tankdirection_local = '1') then
                        next_state <= leftmove;
                    end if;
                    tankdirection_local := not tankdirection_local;
                when others =>
                    tankpositionX_c <= tankstartposX;
                    tankpositionY_c <= tankstartposY;
                    next_state <= start;
            end case;
        end if;
    end process;

    clk_process : process(clk, rst,tankstartposX,tankstartposY)
    begin
        if rst='1' then
            current_state <= start;
            tankpositionX_s <= tankstartposX;
            tankpositionY_s <= tankstartposY;
        elsif (rising_edge(clk)) then
            tankpositionX_s <= tankpositionX_c;
            tankpositionY_s <= tankpositionY_c;
            current_state <= next_state;
        end if;
    end process;
    tankposX <= tankpositionX_s;
    tankposY <= tankpositionY_s;
end architecture;