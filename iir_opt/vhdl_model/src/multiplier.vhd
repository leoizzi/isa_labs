library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier is
	generic (
		N: integer := 12
	);
	port (
		a: in std_logic_vector(N-1 downto 0);
		b: in std_logic_vector(N-1 downto 0);
		res: out std_logic_vector(N-1 downto 0)
	);
end multiplier;

architecture behavioral of multiplier is

begin
	comblogic: process(a, b)
		variable tmp: std_logic_vector(2*N-1 downto 0);
	begin
		tmp := std_logic_vector(signed(a) * signed(b));
		res <= tmp(2*N-1 downto N);
	end process comblogic;
end behavioral;
