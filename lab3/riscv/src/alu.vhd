library ieee;
use ieee.std_logic_1164.all;
use work.fun_pack.all;

-- Small ALU capable of doing additions, set-less-than ops, AND, XOR and arithmetic right shifts
entity alu is
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
end alu;

architecture structural of alu is
	component adder is
		generic (
			N: integer := 64
		);
		port (
			a: in std_logic_vector(N-1 downto 0);
			b: in std_logic_vector(N-1 downto 0);
			cin: in std_logic;
			s: out std_logic_vector(N-1 downto 0);
			cout: out std_logic
		);
	end component adder;

	component eq_comp is
		generic (
			N: integer := 64
		);
		port (
			a: in std_logic_vector(N-1 downto 0);
			b: in std_logic_vector(N-1 downto 0);
			eq: out std_logic
		);
	end component eq_comp;

	component logicals is
		generic (
			N: integer := 64
		);
		port (
			op1: in std_logic_vector(N-1 downto 0);
			op2: in std_logic_vector(N-1 downto 0);
			op_type: in std_logic; -- 0 for AND, 1 for XOR
			res: out std_logic_vector(N-1 downto 0)
		);
	end component logicals;

	component lt_comp is
		generic (
			N: integer := 64
		);
		port (
			a: in std_logic_vector(N-1 downto 0);
			b: in std_logic_vector(N-1 downto 0);
			lt: out std_logic
		);
	end component lt_comp;

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

	component shifter is
		generic (
			N: integer := 64;
			S: integer := 5
		);
		port (
			rs: in std_logic_vector(N-1 downto 0);
			shamt: in std_logic_vector(S-1 downto 0);
			res: out std_logic_vector(N-1 downto 0)
		);
	end component shifter;

	constant zeros: std_logic_vector(N-1 downto 0) := (others  => '0'); 

	signal slt_sb: std_logic;
	signal add_res, log_res, slt_res, shift_res: std_logic_vector(N-1 downto 0);
begin
	add: adder
		generic map (
			N => N
		)
		port map (
			a => op_a,
			b => op_b,
			cin => '0',
			s => add_res,
			cout => open
		);

	logs: logicals
		generic map (
			N => N
		)
		port map (
			op1 => op_a,
			op2 => op_b,
			op_type => log_type,
			res => log_res
		);

	slt: lt_comp
		generic map (
			N => N
		)
		port map (
			a => op_a,
			b => op_b,
			lt => slt_sb
		);

	slt_res <= (0 => slt_sb, others => '0');

	shft: shifter
		generic map (
			N => N,
			S => n_width(N)
		)
		port map (
			rs => op_a,
			shamt => op_b(n_width(N)-1 downto 0),
			res => shift_res
		);

	res_sel: mux4x1
		generic map (
			N => N
		)
		port map (
			a => add_res,
			b => log_res,
			c => slt_res,
			d => shift_res,
			s => ctrl,
			o => res
		);

	eq_cmp: eq_comp
		generic map (
			N => N
		)
		port map (
			a => op_a,
			b => op_b,
			eq => zero
		);
end structural;
