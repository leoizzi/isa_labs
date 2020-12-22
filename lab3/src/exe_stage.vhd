library ieee;
use ieee.std_logic_1164.all;

-- RISC-V EXE stage, it embeds an ALU and an adder for calculating PC addresses
entity exe_stage is
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
end exe_stage;

architecture structural of exe_stage is
	component alu is
		generic (
			N: integer := 64
		);
		port (
			op_a: in std_logic_vector(N-1 downto 0);
			op_b: in std_logic_vector(N-1 downto 0);

			-- 00 to select adder
			-- 01 to select logicals
			-- 10 to select set less than
			-- 11 to select shifter
			ctrl: in std_logic_vector(1 downto 0);
			log_type: in std_logic; -- if 0 and is selected, if 1 xor
			zero: out std_logic;
			res: out std_logic_vector(N-1 downto 0)
		);
	end component alu;

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

	signal op_a, op_b, imm_sht: std_logic_vector(31 downto 0);
	signal zero: std_logic;
begin
	op_a_sel: mux2x1
		generic map (
			N => 32
		)
		port map (
			a => a,
			b => npc,
			sel => a_sel,
			o => op_a
		);

	op_b_sel: mux2x1
		generic map (
			N => 32
		)
		port map (
			a => b,
			b => imm,
			sel => b_sel,
			o => op_b
		);

	alu_inst: alu
		generic map (
			N => 32
		)
		port map (
			op_a => op_a,
			op_b => op_b,
			ctrl => ctrl,
			log_type => log_type,
			zero => zero,
			res => res
		);

	-- allow any jmp iff the instruction being executed actually modify the PC
	-- this is needed since 'zero' will be 1 everytime a == b, regardless of the ALU operation being executed
	pc_sel <= zero and jmp_enable;
	imm_sht <= imm(30 downto 0)&'0';

	pc_add: pc_adder
		generic map (
			N => 32
		)
		port map (
			a => pc,
			b => imm_sht,
			sum => pc_out
		);


end structural;
