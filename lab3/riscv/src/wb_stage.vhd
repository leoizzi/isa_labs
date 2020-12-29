library ieee;
use ieee.std_logic_1164.all;

entity wb_stage is
	port (
		alu_data: in std_logic_vector(31 downto 0);
		mem_data: in std_logic_vector(31 downto 0);
		rd_in: in std_logic_vector(4 downto 0);
		data_sel: in std_logic;
		write_data: out std_logic_vector(31 downto 0);
		rd_out: out std_logic_vector(4 downto 0)
	);
end wb_stage;

architecture struct of wb_stage is

	component mux2x1 is
		generic (
			N: integer := 32
		);
		port (
			a: in std_logic_vector(N-1 downto 0);
			b: in std_logic_vector(N-1 downto 0);
			sel: in std_logic;
			o: out std_logic_vector(N-1 downto 0)
		);
	end component mux2x1;

	constant N: integer := 32;

begin

	data_mux: mux2x1
		generic map (
			N => N
		)
		port map (
			a => alu_data,
			b => mem_data,
			sel => data_sel,
			o => write_data
		);

	rd_out <= rd_in;

end struct;
