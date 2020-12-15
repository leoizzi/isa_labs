library ieee;
use ieee.std_logic_1164.all;

-- These are the IF/ID pipeline registers. In this entity there is one register to store the next PC and one to store the instruction
-- loaded from the ROM.

entity if_id_regs is
	port (
		clk: in std_logic;
		rst: in std_logic;

		pc_in: in std_logic_vector(31 downto 0); -- PC
		npc_in: in std_logic_vector(31 downto 0); -- PC+4 
		instr_in: in std_logic_vector(31 downto 0); -- instruction loaded from the ROM

		-- enable signals
		pc_reg_en: in std_logic;
		npc_reg_en: in std_logic;
		instr_reg_en: in std_logic;

		pc_out: out std_logic_vector(31 downto 0);
		npc_out: out std_logic_vector(31 downto 0);
		instr_out: out std_logic_vector(31 downto 0)
	);
end if_id_regs;

architecture struct of if_id_regs is
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
begin

	pc_reg: reg_en
		generic map (
			N => 32
		)
		port map (
			d => pc_in,
			en => pc_reg_en,
			clk => clk,
			rst => rst,
			q => pc_out
		);

	npc_reg: reg_en
		generic map (
			N => 32
		)
		port map (
			d => npc_in,
			en => npc_reg_en,
			clk => clk,
			rst => rst,
			q => npc_out
		);

	instr_reg: reg_en
		generic map (
			N => 32
		)
		port map (
			d => instr_in,
			en => instr_reg_en,
			clk => clk,
			rst => rst,
			q => instr_out
		);
end struct;
