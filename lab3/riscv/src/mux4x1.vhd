library ieee;
use ieee.std_logic_1164.all;

entity mux4x1 is
	generic (
		N: integer := 64
	);
	port (
		a: in std_logic_vector(N-1 downto 0);
		b: in std_logic_vector(N-1 downto 0);
		c: in std_logic_vector(N-1 downto 0);
		d: in std_logic_vector(N-1 downto 0);
		s: in std_logic_vector(1 downto 0);
		o: out std_logic_vector(N-1 downto 0)
	);
end mux4x1;

architecture behavioral of mux4x1 is

begin
	with s select o <= 
		a when "00",
		b when "01",
		c when "10",
		d when others;
		
end behavioral;
