library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_adder is
	generic (
		N: integer := 32
	);
	port (
		a: in std_logic_vector(N-1 downto 0);
		b: in std_logic_vector(N-1 downto 0);
		sum: out std_logic_vector(N-1 downto 0)
	);
end pc_adder;

architecture struct of pc_adder is

begin

	sum <= std_logic_vector(unsigned(a) + unsigned(b));

end struct;
