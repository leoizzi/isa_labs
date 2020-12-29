library ieee;
use ieee.std_logic_1164.all;

entity mux5x1 is
	generic (
		N: integer := 64
	);
	port (
		a: in std_logic_vector(N-1 downto 0);
		b: in std_logic_vector(N-1 downto 0);
		c: in std_logic_vector(N-1 downto 0);
		d: in std_logic_vector(N-1 downto 0);
		e: in std_logic_vector(N-1 downto 0);
		s: in std_logic_vector(2 downto 0);
		o: out std_logic_vector(N-1 downto 0)
	);
end mux5x1;

architecture behavioral of mux5x1 is

begin
	with s select o <= 
		a when "000",
		b when "001",
		c when "010",
		d when "011",
		e when others;

end behavioral;
