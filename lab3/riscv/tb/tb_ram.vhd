library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_ram is
end tb_ram;

architecture test of tb_ram is
	component ram is
		generic (
			N: integer := 32; -- data bit width
			A: integer := 32; -- address bit width
			W: integer := 16 -- number of words
		);
		port (
            clk: in std_logic;
            rst: in std_logic;
            address: in std_logic_vector(A-1 downto 0);
            wr: in std_logic; -- 1 for write, 0 for read
            datain: in std_logic_vector(N-1 downto 0);
            dataout: out std_logic_vector(N-1 downto 0)
        );
	end component ram;

	constant period: time := 10 ns; 

	signal clk, rst, wr: std_logic;
	signal address, datain, dataout: std_logic_vector(3 downto 0);
begin
	dut: ram
		generic map (
			N => 4,
			A => 4,
			W => 16
		)
		port map (
			clk => clk,
			rst => rst,
			address => address,
			wr => wr,
			datain => datain,
			dataout => dataout
		);

	clk_proc: process
	begin
		clk <= '1';
		wait for period/2;
		clk <= '0';
		wait for period/2;
	end process clk_proc;

	test_proc: process
	begin
		rst <= '0';
		address <= (others => '0');
		wr <= '0';
		wait for period + period/2;

		rst <= '1';

		-- read all 0s
		for i in 0 to 15 loop
			address <= std_logic_vector(to_unsigned(i, 4));
			wait for period;
		end loop;

		-- write values in memory
		wr <= '1';
		for i in 0 to 15 loop
			address <= std_logic_vector(to_unsigned(i, 4));
			datain <= std_logic_vector(to_unsigned(15-i, 4));
			wait for period;
		end loop;

		wr <= '0';
		-- read the memory content
		for i in 0 to 15 loop
			address <= std_logic_vector(to_unsigned(i, 4));
			wait for period;
		end loop;

		wait;
	end process test_proc;
end test;
