library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;


entity tb_riscv is
end tb_riscv;

architecture test of tb_riscv is
	component riscv_sim is
		generic (
			A_ROM: integer := 8; -- address bit width
			W_ROM: integer := 256; -- number of words
			F_ROM: string := "C:\Users\leona\isa_projects\riscv-final\riscv-final.srcs\sim_1\new\bin_custom_new.txt"; -- input file path
			A_RAM: integer := 8; -- address bit width
			W_RAM: integer := 256; -- number of words
			F_RAM: string := "./samples";
			D_RAM: integer := 0
		);
		port (
			clk: in std_logic;
			rst: in std_logic;
			wb_data_out: out std_logic_vector(31 downto 0)
		);
	end component riscv_sim;

	constant period : time := 10 ns;

	signal clk, rst: std_logic;
	signal wb_data_out: std_logic_vector(31 downto 0); 
begin
	dut: riscv_sim
		generic map (
			A_ROM => 8,
			W_ROM => 256,
			F_ROM => "../sim/minv-rv_abs.txt",
			A_RAM => 10,
			W_RAM => 1024,
			F_RAM => "../sim/data.txt",
			D_RAM => 16781312
		)
		port map (
			clk => clk,
			rst => rst,
			wb_data_out => wb_data_out
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
		wait for period + period/2;
		rst <= '1';
		wait;
	end process test_proc;
end test;
