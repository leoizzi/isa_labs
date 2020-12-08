library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- This is the if stage of the pipeline. It computes the PC + 4 and based on the PC_sel signal it chooses between
-- this value and the one coming from the alu. The second one is the target address computed when a branch instruction
-- has to be performed. The instruction loaded from the ROM is directly sent to the pipeline register.

entity if_stage is
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
end if_stage;

architecture struct of if_stage is
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

	component pc_adder is
		generic (
			N: integer := 32
		);
		port (
			a: in std_logic_vector(N-1 downto 0);
			b: in std_logic_vector(N-1 downto 0);
			sum: out std_logic_vector(N-1 downto 0)
		);
	end component pc_adder;

	constant four: integer := 4;
	signal pc, pc_int, pc_plus_4: std_logic_vector(N-1 downto 0);


begin


	pc_mux: mux2x1
		generic map (
			N => N
		)
		port map(
			a => pc_plus_4,
			b => target_pc,
			sel => pc_sel,
			o => pc
		);

	pc_reg: reg_en
		generic map (
			N => N
		)
		port map (
			d => pc,
			en => pc_en,
			clk => clk,
			rst => rst,
			q => pc_int
		);

	address <= pc_int;
	next_pc <= pc_int;

	pc_add: pc_adder
		generic map (
			N => N
		)
		port map (
			a => pc_int,
			b => std_logic_vector(to_unsigned(four, N)),
			sum => pc_plus_4
		);


end struct;
