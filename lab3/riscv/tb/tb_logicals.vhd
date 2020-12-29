library ieee;
use ieee.std_logic_1164.all;

entity tb_logicals is
end tb_logicals;

architecture test of tb_logicals is
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

	constant period: time := 10 ns; 

	signal op1, op2, res: std_logic_vector(63 downto 0);
	signal op_type: std_logic;
begin
	dut: logicals
			generic map (
				N => 64
			)
			port map (
				op1 => op1,
				op2 => op2,
				op_type => op_type,
				res => res
			);

	test_proc: process
	begin
		op1 <= (others => '0');
		op2 <= (others => '0');
		op_type <= '0';
		wait for period;

		op1 <= (others => '0');
		op2 <= (others => '0');
		op_type <= '1';
		wait for period;

		op1 <= (others => '1');
		op2 <= (others => '0');
		op_type <= '0';
		wait for period;

		op1 <= (others => '1');
		op2 <= (others => '0');
		op_type <= '1';
		wait for period;

		op1 <= (others => '1');
		op2 <= (others => '1');
		op_type <= '0';
		wait for period;

		op1 <= (others => '1');
		op2 <= (others => '1');
		op_type <= '1';
		wait for period;

		op1 <= X"5555555555555555";
		op2 <= X"AAAAAAAAAAAAAAAA";
		op_type <= '0';
		wait for period;

		op1 <= X"5555555555555555";
		op2 <= X"AAAAAAAAAAAAAAAA";
		op_type <= '1';
		wait for period;

		op1 <= X"5555555555555555";
		op2 <= X"555555555AAAAAAA";
		op_type <= '0';
		wait for period;

		op1 <= X"5555555555555555";
		op2 <= X"555555555AAAAAAA";
		op_type <= '1';
		wait;
	end process test_proc;

end test;
