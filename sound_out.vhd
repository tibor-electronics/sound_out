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
		audio_left, audio_right: out std_logic
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
	signal wave: std_logic_vector(7 downto 0) := "01110000";
	signal tick2: std_logic := '0';
	signal wave2: std_logic_vector(7 downto 0) := "01110000";
begin
	-- left
	fundamental_left: Timer
		generic map(
			TIMER_FREQUENCY => 880 -- 2x concert A
		)
		port map(
			clock => clock,
			reset => '0',
			tick => tick
		);

	sd_left: dac
		port map(
			clk => clock,
			reset => '0',
			DACin => wave,
			DACout => audio_left
		);

	toggle_left: process(clock, tick)
	begin
		if clock'event and clock = '1' then
			if tick = '1' then
				wave <= 255 - wave;
			end if;
		end if;
	end process;

	-- right
	fundamental_right: Timer
		generic map(
			TIMER_FREQUENCY => 875
		)
		port map(
			clock => clock,
			reset => '0',
			tick => tick2
		);

	sd_right: dac
		port map(
			clk => clock,
			reset => '0',
			DACin => wave2,
			DACout => audio_right
		);

	toggle_right: process(clock, tick2)
	begin
		if clock'event and clock = '1' then
			if tick2 = '1' then
				wave2 <= 255 - wave2;
			end if;
		end if;
	end process;
end behavioral;
