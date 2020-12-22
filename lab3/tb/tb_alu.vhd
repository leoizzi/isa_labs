library ieee;
use ieee.std_logic_1164.all;

entity tb_alu is
end tb_alu;

architecture test of tb_alu is
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

	constant period: time := 10 ns;

	constant ADD_CTRL : std_logic_vector(1 downto 0) := "00";
	constant LOG_CTRL : std_logic_vector(1 downto 0) := "01";
	constant SLT_CTRL : std_logic_vector(1 downto 0) := "10";
	constant SHT_CTRL : std_logic_vector(1 downto 0) := "11";

	constant AND_LOG : std_logic := '0';
	constant XOR_LOG : std_logic := '1'; 

	signal op_a, op_b, res: std_logic_vector(15 downto 0);
	signal ctrl: std_logic_vector(1 downto 0);
	signal log_type, zero: std_logic;

begin
	dut: alu
		generic map (
			N => 16
		)
		port map (
			op_a => op_a,
			op_b => op_b,
			ctrl => ctrl,
			log_type => log_type,
			zero => zero,
			res => res
		);

	test_proc: process
	begin
		op_a <= (others => '0');
		op_b <= (others => '0');
		ctrl <= LOG_CTRL;
		log_type <= XOR_LOG;
		wait for period;

		op_a <= (others => '1');
		op_b <= (others => '0');
		ctrl <= LOG_CTRL;
		log_type <= XOR_LOG;
		wait for period;

		op_a <= (others => '0');
		op_b <= (others => '1');
		ctrl <= LOG_CTRL;
		log_type <= AND_LOG;
		wait for period;

		op_a <= (others => '1');
		op_b <= (others => '1');
		ctrl <= LOG_CTRL;
		log_type <= AND_LOG;
		wait for period;

		op_a <= X"1234";
		op_b <= X"8765";
		ctrl <= ADD_CTRL;
		log_type <= XOR_LOG;
		wait for period;

		op_a <= X"1234";
		op_b <= X"7765";
		ctrl <= SLT_CTRL;
		log_type <= XOR_LOG;
		wait for period;

		op_a <= X"7765";
		op_b <= X"1234";
		ctrl <= SLT_CTRL;
		log_type <= XOR_LOG;
		wait for period;

		op_a <= X"8765";
		op_b <= X"1234";
		ctrl <= SLT_CTRL;
		log_type <= XOR_LOG;
		wait for period;

		op_a <= X"5555";
		op_b <= X"0005";
		ctrl <= SHT_CTRL;
		log_type <= XOR_LOG;
		wait for period;

		op_a <= X"F000";
		op_b <= X"0005";
		ctrl <= SHT_CTRL;
		log_type <= XOR_LOG;
		wait for period;

		op_a <= X"0001";
		op_b <= X"FFFF";
		ctrl <= ADD_CTRL;
		log_type <= XOR_LOG;
		wait;
	end process test_proc;
end test;
