library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lt_comp is
	generic (
		N: integer := 64
	);
	port (
		a: in std_logic_vector(N-1 downto 0);
		b: in std_logic_vector(N-1 downto 0);
		lt: out std_logic
	);
end lt_comp;

architecture behavioral of lt_comp is

begin
	comblogic: process(a, b)
	begin
		if (signed(a) < signed(b)) then
			lt <= '1';
		else
			lt <= '0';
		end if;
	end process comblogic;

end behavioral;
