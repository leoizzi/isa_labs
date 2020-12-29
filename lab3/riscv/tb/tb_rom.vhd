library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_rom is
end tb_rom;

architecture tb of tb_rom is

	component rom is
		generic (
			N: integer := 32; -- data bit width
			A: integer := 32; -- address bit width
			W: integer := 32; -- number of words
			F: string := ".\samples.txt" -- input file path
		);

		port (
			rst: in std_logic;
			address: in std_logic_vector(A-1 downto 0);
			data: out std_logic_vector(N-1 downto 0)
		);
	end component rom;

	constant N: integer := 32;
	constant A: integer := 5;
	constant W: integer := 32;
	constant F: string := "C:\Users\Nicole\Desktop\Vivado\rom\rom.srcs\sim_1\new\samples.txt";
	
	constant period: time := 10 ns;

	signal clk, rst: std_logic;
	signal address: std_logic_vector(A-1 downto 0);
	signal data: std_logic_vector(N-1 downto 0);

begin
	
	rom_mem: rom
		generic map (
			N => N,
			A => A,
			W => W,
			F => F
		)
		port map (
			rst => rst,
			address => address,
			data => data
		);

	clk_p: process
	begin
		clk <= '1';
		wait for period/2;
		clk <= '0';
		wait for period/2;
	end process clk_p;

	test_p: process
	begin
		wait for period/2;
		rst <= '0';
		wait for period;
		rst <= '1';
		read_loop : for i in 0 to W-1 loop
			address <= std_logic_vector(to_unsigned(i,A));
			wait for period;
		end loop read_loop;
		wait;
	end process test_p;


end tb;
