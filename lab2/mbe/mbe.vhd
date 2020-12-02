library ieee;
use ieee.std_logic_1164.all;

entity mbe is
	port (
		b: in std_logic_vector(2 downto 0); -- contains b_2j-1, b_2j and b_2j+1
		a: in std_logic_vector(31 downto 0);
		pj: out std_logic_vector(32 downto 0); -- partial product
		s: out std_logic -- used to perform sign extension
	);
end mbe;

architecture behavioral of mbe is
	constant zeros : std_logic_vector(32 downto 0) := (others  => '0');

	signal b_ext, q, pj_int: std_logic_vector(32 downto 0);
	signal cond_0, cond_a, cond_2a: std_logic;
begin
	cond_0 <= (not (b(1) xor b(0))) and (not (b(2) xor b(1)));
	cond_a <= b(1) xor b(0);
	cond_2a <= (not (b(1) xor b(0))) and (b(2) xor b(1));

	q <= a&'0' when cond_2a = '1' else
		 a(31)&a when cond_a = '1' else
		 zeros;

	b_ext <= (others => b(2));

	pj_int <= b_ext xor q;
	s <= pj_int(32);
	pj <= pj_int;
end behavioral;
