library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;

entity tb_exe_stage is
end tb_exe_stage;

architecture test of tb_exe_stage is
	component exe_stage is
		port (
			npc: in std_logic_vector(31 downto 0); -- pc+4
			pc: in std_logic_vector(31 downto 0); -- instruction's pc
			a: in std_logic_vector(31 downto 0);
			b: in std_logic_vector(31 downto 0);
			imm: in std_logic_vector(31 downto 0);

			a_sel: in std_logic; -- 0 to select a, 1 to select NPC
			b_sel: in std_logic; -- 0 to select b, 1 to select imm

			-- 00 to select adder
			-- 01 to select logicals
			-- 10 to select set less than
			-- 11 to select shifter
			ctrl: in std_logic_vector(1 downto 0);
			log_type: in std_logic; -- if 0 and is selected, if 1 xor
			jmp_enable: in std_logic; -- if set to 1 enables the possibility to jump

			res: out std_logic_vector(31 downto 0);
			pc_out: out std_logic_vector(31 downto 0);
			pc_sel: out std_logic -- used by the IF stage to determine which PC must be used
		);
	end component exe_stage;

	constant period: time := 10 ns;

	signal npc, pc, a, b, imm, res, pc_out: std_logic_vector(31 downto 0);
	signal ctrl: std_logic_vector(1 downto 0);
	signal a_sel, b_sel, log_type, jmp_enable, pc_sel: std_logic;
begin
	dut: exe_stage
		port map (
			npc => npc,
			pc => pc,
			a => a,
			b => b,
			imm => imm,
			a_sel => a_sel,
			b_sel => b_sel,
			ctrl => ctrl,
			log_type => log_type,
			jmp_enable => jmp_enable,
			res => res,
			pc_out => pc_out,
			pc_sel => pc_sel
		);

	-- automatically calculate pc+4
	pc_proc: process(pc)
	begin
		npc <= std_logic_vector(unsigned(pc) + 4);
	end process pc_proc;

	test_proc: process
	begin
		pc <= X"0000ABC0";
		a <= X"12345678";
		b <= X"9ABCDEF0";
		imm <= X"91827364";

		-- test ALU connections
		a_sel <= MUX_A_SEL_REG;
		b_sel <= MUX_B_SEL_REG;
		ctrl <= ADD_CTRL;
		log_type <= AND_LOG;
		jmp_enable <= NO_JMP_ENABLE;
		wait for period;

		a_sel <= MUX_A_SEL_NPC;
		b_sel <= MUX_B_SEL_REG;
		ctrl <= LOG_CTRL;
		wait for period;

		a_sel <= MUX_A_SEL_NPC;
		b_sel <= MUX_B_SEL_IMM;
		log_type <= XOR_LOG;
		wait for period;

		imm <= X"FFFF0004";
		jmp_enable <= YES_JMP_ENABLE;
		wait for period;

		a <= (others => '0');
		b <= (others => '0');
		a_sel <= MUX_A_SEL_REG;
		b_sel <= MUX_B_SEL_REG;
		wait;
	end process test_proc;

end test;
