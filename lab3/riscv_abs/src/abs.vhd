library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity abs_unit is
	generic (
		N: integer := 64
	);
	port (
		a: in std_logic_vector(N-1 downto 0);
		res: out std_logic_vector(N-1 downto 0)
	);
end abs_unit;

architecture behavioral of abs_unit is

begin
	res <= std_logic_vector(abs(signed(a)));

end behavioral;
