library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Perform generic arithmetic right shifts of rs by shamt
entity shifter is
	generic (
		N: integer := 64;
		S: integer := 5
	);
	port (
		rs: in std_logic_vector(N-1 downto 0);
		shamt: in std_logic_vector(S-1 downto 0);
		res: out std_logic_vector(N-1 downto 0)
	);
end shifter;

architecture behavioral of shifter is

begin
	res <= (to_stdlogicvector(to_bitvector(std_logic_vector(rs)) sra to_integer(unsigned(shamt))));
end architecture behavioral;
