library ieee;
use ieee.std_logic_1164.all;

entity eq_comp is
	generic (
		N: integer := 64
	);
	port (
		a: in std_logic_vector(N-1 downto 0);
		b: in std_logic_vector(N-1 downto 0);
		eq: out std_logic
	);
end eq_comp;

architecture behavioral of eq_comp is

begin
	comblogic: process(a, b)
	begin
		if (a = b) then
			eq <= '1';
		else
			eq <= '0';
		end if;
	end process comblogic;

end behavioral;
