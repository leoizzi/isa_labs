library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_shifter is
end tb_shifter;

architecture test of tb_shifter is
	component shifter is
		generic (
			N: integer := 64;
			S: integer := 5
		);
		port (
			rs: in std_logic_vector(N-1 downto 0);
			shamt: in std_logic_vector(S-1 downto 0);
			res: out std_logic_vector(N-1 downto 0)
		);
	end component shifter;

	constant period: time := 10 ns; 

	signal rs: std_logic_vector(63 downto 0);
	signal shamt: std_logic_vector(4 downto 0);
	signal res: std_logic_vector(63 downto 0);
begin
	dut: shifter
		generic map (
			N => 64,
			S => 5
		)
		port map (
			rs => rs,
			shamt => shamt,
			res => res
		);

	test_proc: process
	begin
		rs <= (63 => '1', others => '0');
		for i in 0 to 31 loop
			shamt <= std_logic_vector(to_unsigned(i, 5));
			wait for period;
		end loop;

		rs <= (63 => '0', others => '1');
		for i in 0 to 31 loop
			shamt <= std_logic_vector(to_unsigned(i, 5));
			wait for period;
		end loop;
		
		wait;
	end process test_proc;
end test;
