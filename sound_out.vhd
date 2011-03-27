--
-- Copyright 2011, Kevin Lindsey
-- See LICENSE file for licensing information
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity SoundOut is
	port(
		clock: in std_logic;
      analog_out: out std_logic
	);
end SoundOut;

architecture behavioral of SoundOut is
	component Timer
		generic(
			TIMER_FREQUENCY: positive
		);
		port(
			clock: in std_logic;
			reset: in std_logic;
			tick: out std_logic
		);
	end component;
	component dac
		port(
			clk: in std_logic;
			reset: in std_logic;
			DACin: in std_logic_vector(7 downto 0);
			DACout: out std_logic
		);
	end component;
	signal tick: std_logic := '0';
	signal wave: std_logic_vector(7 downto 0) := "01000000";
begin
	fundamental: Timer
		generic map(
			TIMER_FREQUENCY => 880 -- 2x concert A
		)
		port map(
			clock => clock,
			reset => '0',
			tick => tick
		);
	
	sd: dac
		port map(
			clk => clock,
			reset => '0',
			DACin => wave,
			DACout => analog_out
		);
	
	toggle: process(clock, tick)
	begin
		if clock'event and clock = '1' then
			if tick = '1' then
				wave <= 255 - wave;
			end if;
		end if;
	end process;
end behavioral;
