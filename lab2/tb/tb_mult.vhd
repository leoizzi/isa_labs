library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_mult is
end tb_mult;

architecture test of tb_mult is
	component mult is
		port (
			a: in std_logic_vector(31 downto 0);
			b: in std_logic_vector(31 downto 0);
			prod: out std_logic_vector(63 downto 0)
		);
	end component mult;

	signal a, b: std_logic_vector(31 downto 0);
	signal prod, prod_exp: std_logic_vector(63 downto 0);
begin
	dut: mult
		port map (
			a => a,
			b => b,
			prod => prod
		);
	
	test_proc: process
		variable n, m: unsigned(31 downto 0);
	begin
		n := (others => '0');
		m := (others => '0');

		for i in 0 to 20 loop
			for j in 0 to 30 loop
				a <= std_logic_vector(to_unsigned(i, 32));
				b <= std_logic_vector(to_unsigned(j, 32));
				prod_exp <= std_logic_vector(to_unsigned(i, 32)*to_unsigned(j, 32));
				wait for 1 ns;
				assert (prod = prod_exp) report "FANCULO PORCAMADONNA" severity FAILURE;
				m := m+j*7;
			end loop;

			n := n+i*3;
		end loop;
	end process test_proc;
end test;
