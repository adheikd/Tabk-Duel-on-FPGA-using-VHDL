-- Copyright (C) 2022  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- *****************************************************************************
-- This file contains a Vhdl test bench with test vectors .The test vectors     
-- are exported from a vector file in the Quartus Waveform Editor and apply to  
-- the top level entity of the current Quartus project .The user can use this   
-- testbench to simulate his design using a third-party simulation tool .       
-- *****************************************************************************
-- Generated on "12/04/2022 17:40:04"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          tank_duel
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY tank_duel_vhd_vec_tst IS
PORT (
	DATA_BUS_tb : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	HORIZ_SYNC_tb : BUFFER STD_LOGIC;
	LCD_E_tb : BUFFER STD_LOGIC;
	LCD_ON_tb : BUFFER STD_LOGIC;
	LCD_RS_tb : BUFFER STD_LOGIC;
	LCD_RW_tb : BUFFER STD_LOGIC;
	led_show_tb : BUFFER STD_LOGIC_VECTOR(55 DOWNTO 0);
	light_tb : BUFFER STD_LOGIC;
	RESET_LED_tb : BUFFER STD_LOGIC;
	SEC_LED_tb : BUFFER STD_LOGIC;
	VERT_SYNC_tb : BUFFER STD_LOGIC;
	VGA_BLANK_tb : BUFFER STD_LOGIC;
	VGA_BLUE_tb : BUFFER STD_LOGIC_VECTOR(9 DOWNTO 0);
	VGA_CLK_tb : BUFFER STD_LOGIC;
	VGA_GREEN_tb : BUFFER STD_LOGIC_VECTOR(9 DOWNTO 0);
	VGA_RED_tb : BUFFER STD_LOGIC_VECTOR(9 DOWNTO 0)
);
END tank_duel_vhd_vec_tst;
ARCHITECTURE tank_duel_arch OF tank_duel_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk : STD_LOGIC;
SIGNAL reset_test : STD_LOGIC := '1';
SIGNAL start_test : STD_LOGIC := '0';
SIGNAL fire_bullet : STD_LOGIC := '0';
SIGNAL DATA_BUS : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL HORIZ_SYNC : STD_LOGIC;
SIGNAL keyboard_clk : STD_LOGIC;
SIGNAL keyboard_data : STD_LOGIC;
SIGNAL LCD_E : STD_LOGIC;
SIGNAL LCD_ON : STD_LOGIC;
SIGNAL LCD_RS : STD_LOGIC;
SIGNAL LCD_RW : STD_LOGIC;
SIGNAL led_show : STD_LOGIC_VECTOR(55 DOWNTO 0);
SIGNAL light : STD_LOGIC;
SIGNAL RESET_LED : STD_LOGIC;
SIGNAL SEC_LED : STD_LOGIC;
SIGNAL VERT_SYNC : STD_LOGIC;
SIGNAL VGA_BLANK : STD_LOGIC;
SIGNAL VGA_BLUE : STD_LOGIC_VECTOR(9 DOWNTO 0);
SIGNAL VGA_CLK : STD_LOGIC;
SIGNAL VGA_GREEN : STD_LOGIC_VECTOR(9 DOWNTO 0);
SIGNAL VGA_RED : STD_LOGIC_VECTOR(9 DOWNTO 0);
signal period : time := 20 ns;
COMPONENT tank_duel
	PORT (
	clk : IN STD_LOGIC;
	reset_test : in std_logic;
	start_test : in std_logic;
	fire_bullet : in std_logic;
	DATA_BUS : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	HORIZ_SYNC : BUFFER STD_LOGIC;
	keyboard_clk : IN STD_LOGIC;
	keyboard_data : IN STD_LOGIC;
	LCD_E : BUFFER STD_LOGIC;
	LCD_ON : BUFFER STD_LOGIC;
	LCD_RS : BUFFER STD_LOGIC;
	LCD_RW : BUFFER STD_LOGIC;
	led_show : BUFFER STD_LOGIC_VECTOR(55 DOWNTO 0);
	light : BUFFER STD_LOGIC;
	RESET_LED : BUFFER STD_LOGIC;
	SEC_LED : BUFFER STD_LOGIC;
	VERT_SYNC : BUFFER STD_LOGIC;
	VGA_BLANK : BUFFER STD_LOGIC;
	VGA_BLUE : BUFFER STD_LOGIC_VECTOR(9 DOWNTO 0);
	VGA_CLK : BUFFER STD_LOGIC;
	VGA_GREEN : BUFFER STD_LOGIC_VECTOR(9 DOWNTO 0);
	VGA_RED : BUFFER STD_LOGIC_VECTOR(9 DOWNTO 0)
);
END COMPONENT;
for all : tank_duel use entity work.tank_duel(behav_stimulate);
BEGIN
	i1 : tank_duel
	PORT MAP (
-- list connections between master ports and signals
	clk => clk,
	reset_test => reset_test,
	start_test => start_test,
	fire_bullet => fire_bullet,
	DATA_BUS => DATA_BUS_tb,
	HORIZ_SYNC => HORIZ_SYNC_tb,
	keyboard_clk => keyboard_clk,
	keyboard_data => keyboard_data,
	LCD_E => LCD_E_tb,
	LCD_ON => LCD_ON_tb,
	LCD_RS => LCD_RS_tb,
	LCD_RW => LCD_RW_tb,
	led_show => led_show_tb,
	light => light_tb,
	RESET_LED => RESET_LED_tb,
	SEC_LED => SEC_LED_tb,
	VERT_SYNC => VERT_SYNC_tb,
	VGA_BLANK => VGA_BLANK_tb,
	VGA_BLUE => VGA_BLUE_tb,
	VGA_CLK => VGA_CLK_tb,
	VGA_GREEN => VGA_GREEN_tb,
	VGA_RED => VGA_RED_tb
);

-- DATA_BUS[7]
-- t_prcs_DATA_BUS_7: PROCESS
-- BEGIN
-- 	DATA_BUS(7) <= 'Z';
-- WAIT;
-- END PROCESS t_prcs_DATA_BUS_7;
-- -- DATA_BUS[6]
-- t_prcs_DATA_BUS_6: PROCESS
-- BEGIN
-- 	DATA_BUS(6) <= 'Z';
-- WAIT;
-- END PROCESS t_prcs_DATA_BUS_6;
-- -- DATA_BUS[5]
-- t_prcs_DATA_BUS_5: PROCESS
-- BEGIN
-- 	DATA_BUS(5) <= 'Z';
-- WAIT;
-- END PROCESS t_prcs_DATA_BUS_5;
-- -- DATA_BUS[4]
-- t_prcs_DATA_BUS_4: PROCESS
-- BEGIN
-- 	DATA_BUS(4) <= 'Z';
-- WAIT;
-- END PROCESS t_prcs_DATA_BUS_4;
-- -- DATA_BUS[3]
-- t_prcs_DATA_BUS_3: PROCESS
-- BEGIN
-- 	DATA_BUS(3) <= 'Z';
-- WAIT;
-- END PROCESS t_prcs_DATA_BUS_3;
-- -- DATA_BUS[2]
-- t_prcs_DATA_BUS_2: PROCESS
-- BEGIN
-- 	DATA_BUS(2) <= 'Z';
-- WAIT;
-- END PROCESS t_prcs_DATA_BUS_2;
-- -- DATA_BUS[1]
-- t_prcs_DATA_BUS_1: PROCESS
-- BEGIN
-- 	DATA_BUS(1) <= 'Z';
-- WAIT;
-- END PROCESS t_prcs_DATA_BUS_1;
-- -- DATA_BUS[0]
-- t_prcs_DATA_BUS_0: PROCESS
-- BEGIN
-- 	DATA_BUS(0) <= 'Z';
-- WAIT;
-- END PROCESS t_prcs_DATA_BUS_0;

-- -- keyboard_clk
-- t_prcs_keyboard_clk: PROCESS
-- BEGIN
-- 	keyboard_clk <= '0';
-- WAIT;
-- END PROCESS t_prcs_keyboard_clk;

-- -- keyboard_data
t_prcs_keyboard_data: PROCESS is
BEGIN
	-- wait for period;
	wait for 2*period;
	reset_test <= '0';
	start_test <= '1';
	fire_bullet <= '1';
	-- wait for 1 ps;
	-- fire_bullet <= '0';
	-- wait for period;
	-- start_test <= '0';
	-- keyboard_data <= '1';
END PROCESS t_prcs_keyboard_data;
clk_process: process
	begin
		clk <= '1';
		wait for (period/2);
		clk <= '0';
		wait for (period/2);
end process clk_process;
END tank_duel_arch;
