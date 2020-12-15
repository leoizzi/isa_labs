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
begin


end test;
