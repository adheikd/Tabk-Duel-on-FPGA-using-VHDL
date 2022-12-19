library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity const_clock is
	port(
		clock_50MHz, reset : in std_logic;
		clk_event		   : out std_logic
	);
end const_clock;

architecture behav of const_clock is
signal counter: integer := 0;
begin
-- clock<=temp_clock;
process (clock_50MHz,reset) is 
begin
	if (reset = '1') then
		counter <= 0;
		clk_event <= '0';
	elsif (rising_edge(clock_50MHz)) then
		counter <= counter + 1;
		if (counter > 250000) then
			clk_event <= '1';
			counter <= 0;
		else
			clk_event <= '0';
		end if;

		--if(counter>250000) then
		--	counter := 0;
		--	temp_clock<=not temp_clock;
		--end if;
		--counter:=counter+1;
	end if;
end process;
End behav; 