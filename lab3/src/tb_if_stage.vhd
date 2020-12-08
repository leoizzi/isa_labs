library ieee;
use ieee.std_logic_1164.all;

entity tb_if_stage is
end tb_if_stage;

architecture tb of tb_if_stage is

	component if_stage is
		generic (
			N: integer := 32  -- data bit width
		);
		port (
			clk: in std_logic;
			rst: in std_logic;

			target_pc: in std_logic_vector(N-1 downto 0); -- target address coming from the alu
			pc_sel: in std_logic; -- PC selector
			pc_en: in std_logic;

			-- ROM interface
			address: out std_logic_vector(N-1 downto 0); -- address of the instruction to be loaded from the ROM

			-- output to be saved in the pipeline registers
			next_pc: out std_logic_vector(N-1 downto 0)

		);
	end component if_stage;

	component if_id_regs is
		port (
			clk: in std_logic;
			rst: in std_logic;

			next_pc_in: in std_logic_vector(63 downto 0); -- next PC
			instr_in: in std_logic_vector(31 downto 0); -- instruction loaded from the ROM

			-- enable signals
			pc_reg_en: in std_logic;
			instr_reg_en: in std_logic;

			next_pc_out: out std_logic_vector(63 downto 0);
			instr_out: out std_logic_vector(31 downto 0)
		);
	end component if_id_regs;

	component rom is
		generic (
			N: integer := 32; -- data bit width
			A: integer := 32; -- address bit width
			W: integer := 32; -- number of words
			F: string := "./samples.txt" -- input file path
		);

		port (
			rst: in std_logic;
			address: in std_logic_vector(A-1 downto 0);
			data: out std_logic_vector(N-1 downto 0)
		);
	end component rom;

	constant N: integer := 64;
	constant A: integer := 10;
	constant W: integer := 1024;
	constant F: string := "./samples.txt"; -- TODO: insert the correct path

	signal clk, rst: std_logic;

	-- internal signals
	signal instr_int, next_pc_int, address_int: std_logic_vector(N-1 downto 0);

	-- signals coming from the CU
	signal target_pc: std_logic_vector(N-1 downto 0);
	signal pc_sel, pc_en, pc_reg_en, instr_reg_en: std_logic;

	-- signals going to the id stage
	signal next_pc_id, instr_id: std_logic_vector(N-1 downto 0);

begin

	if_stg: if_stage
		generic map (
			N => N
		)
		port map (
			clk => clk,
			rst => rst,
			target_pc => target_pc,
			pc_sel => pc_sel,
			pc_en => pc_en,
			address => address_int,
			next_pc => next_pc_int
		);

	regs: if_id_regs
		port map(
			clk => clk,
			rst => rst,
			next_pc_in => next_pc_int,
			instr_in => instr_int,
			pc_reg_en => pc_reg_en,
			instr_reg_en => instr_reg_en,
			next_pc_out => next_pc_id,
			instr_out => instr_id
	);

	irom: rom
		generic map (
			N => N,
			A => A,
			W  => W,
			F => F
		)
		port map (
			rst => rst,
			address => address_int(A-1 downto 0),
			data => instr_int
		);

end tb;
