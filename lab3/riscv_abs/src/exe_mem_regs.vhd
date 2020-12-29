library ieee;
use ieee.std_logic_1164.all;

entity exe_mem_regs is
	port (
		clk: in std_logic;
		rst: in std_logic;

		alu_data_in: in std_logic_vector(31 downto 0);
		reg_data_in: in std_logic_vector(31 downto 0);
		rd_in: in std_logic_vector(4 downto 0);

		alu_data_en: in std_logic;
		reg_data_en: in std_logic;
		rd_en: in std_logic;

		alu_data_out: out std_logic_vector(31 downto 0);
		reg_data_out: out std_logic_vector(31 downto 0);
		rd_out: out std_logic_vector(4 downto 0)
	);
end exe_mem_regs;

architecture struct of exe_mem_regs is
	component reg_en is
		generic (
			N: integer := 32
		);
		port (
			d: in std_logic_vector(N-1 downto 0);
			en: in std_logic;
			clk: in std_logic;
			rst: in std_logic;
			q: out std_logic_vector(N-1 downto 0)	
		);
	end component reg_en;

	constant N: integer := 32;
	constant A: integer := 5;

begin

	alu_data_reg: reg_en
		generic map (
			N => N
		)
		port map (
			d => alu_data_in,
			en => alu_data_en,
			clk => clk,
			rst => rst,
			q => alu_data_out
	);

	reg_data_reg: reg_en
		generic map (
			N => N
		)
		port map (
			d => reg_data_in,
			en => reg_data_en,
			clk => clk,
			rst => rst,
			q => reg_data_out
	);

	rd_reg: reg_en
		generic map (
			N => A
		)
		port map (
			d => rd_in,
			en => rd_en,
			clk => clk,
			rst => rst,
			q => rd_out
	);

end struct;
