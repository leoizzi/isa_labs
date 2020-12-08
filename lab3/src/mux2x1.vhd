library ieee;
use ieee.std_logic_1164.all;

entity mux2x1 is
	generic (
		N: integer := 32
	);
	port (
		a: in std_logic_vector(N-1 downto 0);
		b: in std_logic_vector(N-1 downto 0);
		sel: in std_logic;
		o: out std_logic_vector(N-1 downto 0)
	);
end mux2x1;

architecture struct of mux2x1 is

begin
	
	o <= a when sel = '0' else
		 b;

end struct;
