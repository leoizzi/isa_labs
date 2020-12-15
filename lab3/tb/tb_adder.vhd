library ieee;
use ieee.std_logic_1164.all;

entity tb_adder is
end tb_adder;

architecture test of tb_adder is
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

	constant period: time := 10 ns;

	signal a, b, s: std_logic_vector(15 downto 0);
	signal cin, cout: std_logic;
begin
	dut: adder
		generic map (
			N => 16
		)
		port map (
			a => a,
			b => b,
			cin => cin,
			s => s,
			cout => cout
		);

	test_proc: process
	begin
		a <= X"0000";
		b <= X"0000";
		cin <= '0';
		wait for period;

		a <= X"0000";
		b <= X"0000";
		cin <= '1';
		wait for period;

		a <= X"FFFF";
		b <= X"0000";
		cin <= '1';
		wait for period;

		a <= X"0001";
		b <= X"FFFF";
		cin <= '0';
		wait for period;

		a <= X"AAAA";
		b <= X"5555";
		cin <= '1';
		wait for period;

		a <= X"AAAA";
		b <= X"5555";
		cin <= '0';
		wait for period;

		a <= X"1234";
		b <= X"ABCD";
		cin <= '0';
		wait;
	end process test_proc;

end test;
