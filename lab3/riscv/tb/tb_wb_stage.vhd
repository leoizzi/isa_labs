library ieee;
use ieee.std_logic_1164.all;

entity tb_wb_stage is
end tb_wb_stage;

architecture tb of tb_wb_stage is

	component wb_stage is
		port (
			alu_data: in std_logic_vector(31 downto 0);
			mem_data: in std_logic_vector(31 downto 0);
			rd_in: in std_logic_vector(4 downto 0);
			data_sel: in std_logic;
			write_data: out std_logic_vector(31 downto 0);
			rd_out: out std_logic_vector(4 downto 0)
		);
	end component wb_stage;

	signal alu_data, mem_data, write_data: std_logic_vector(31 downto 0);
	signal rd_in, rd_out: std_logic_vector(4 downto 0);
	signal data_sel: std_logic;

begin

	dut: wb_stage
		port map (
			alu_data => alu_data,
			mem_data => mem_data,
			rd_in => rd_in,
			data_sel => data_sel,
			write_data => write_data,
			rd_out => rd_out
		);

	test_p: process
	begin
		alu_data <= X"22222222";
		mem_data <= X"44444444";
		data_sel <= '0';
		rd_in <= "01001";
		

		wait for 10 ns;
		alu_data <= X"66666666";
		mem_data <= X"99999999";
		data_sel <= '1';

		wait;
	end process test_p;
end tb;
