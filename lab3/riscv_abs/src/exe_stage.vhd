library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;

-- RISC-V EXE stage, it embeds an ALU and an adder for calculating PC addresses
entity exe_stage is
	port (
		npc: in std_logic_vector(31 downto 0); -- pc+4
		pc: in std_logic_vector(31 downto 0); -- instruction's pc
		a: in std_logic_vector(31 downto 0);
		b: in std_logic_vector(31 downto 0);
		imm: in std_logic_vector(31 downto 0);

		-- 00 to select a
		-- 01 to select NPC
		-- 10 to select PC
		-- 11 to select all 0s
		a_sel: in std_logic_vector(1 downto 0);
		-- 00 to select b
		-- 01 to select imm
		-- 10 to select all 0s
		-- 11 to select all 0s
		b_sel: in std_logic_vector(1 downto 0);

		-- 000 to select adder
		-- 001 to select logicals
		-- 010 to select set less than
		-- 011 to select shifter
		-- 100 to select ABS unit
		ctrl: in std_logic_vector(2 downto 0);
		log_type: in std_logic; -- if 0 and is selected, if 1 xor
		jmp_enable: in std_logic; -- if set to 1 enables the possibility to jump

		res: out std_logic_vector(31 downto 0);
		reg_out: out std_logic_vector(31 downto 0);
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

			-- 000 to select adder
			-- 001 to select logicals
			-- 010 to select set less than
			-- 011 to select shifter
			-- 100 to select ABS unit
			ctrl: in std_logic_vector(2 downto 0);
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

	component mux4x1 is
		generic (
			N: integer := 64
		);
		port (
			a: in std_logic_vector(N-1 downto 0);
			b: in std_logic_vector(N-1 downto 0);
			c: in std_logic_vector(N-1 downto 0);
			d: in std_logic_vector(N-1 downto 0);
			s: in std_logic_vector(1 downto 0);
			o: out std_logic_vector(N-1 downto 0)
		);
	end component mux4x1;

	constant zeros : std_logic_vector(31 downto 0) := (others => '0'); 

	signal op_a, op_b, imm_sht: std_logic_vector(31 downto 0);
	signal zero: std_logic;
begin
	op_a_sel: mux4x1
		generic map (
			N => 32
		)
		port map (
			a => a,
			b => npc,
			c => pc,
			d => zeros,
			s => a_sel,
			o => op_a
		);

	op_b_sel: mux4x1
		generic map (
			N => 32
		)
		port map (
			a => b,
			b => imm,
			c => zeros,
			d => zeros,
			s => b_sel,
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

	pc_sel <= 	'1' when ((a_sel = MUX_A_NPC and b_sel = MUX_B_0) or zero = '1') and jmp_enable = '1' else
				'0';

	-- allow any jmp iff the instruction being executed actually modify the PC
	-- this is needed since 'zero' will be 1 everytime a == b, regardless of the ALU operation being executed
	--pc_sel <= (zero or (a_sel = MUX_A_NPC and b_sel = MUX_B_0)) and jmp_enable;
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

		reg_out <= b;
end structural;
