library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- behavioral adder. it doesn't have cin and cout because we didn't need them

entity adder is
	generic (
		N: integer := 12
	);
	port (
		a: in std_logic_vector(N-1 downto 0);
		b: in std_logic_vector(N-1 downto 0);
		sum: out std_logic_vector(N-1 downto 0)
	);
end adder;

architecture behavioral of adder is
    signal tmp_obj: std_logic_vector(N downto 0);
begin
	comblogic: process(a, b)
		variable tmp: signed(N downto 0);
		variable a_ext, b_ext: std_logic_vector(N downto 0);
	begin
		a_ext := a(N-1)&a;
		b_ext := b(N-1)&b;
		tmp := signed(a_ext) + signed(b_ext);
		--sum <= std_logic_vector(tmp(N-1 downto 0));
		sum <= std_logic_vector(tmp(N-1 downto 0));
		tmp_obj <= std_logic_vector(tmp);
		--sum <= std_logic_vector(signed(a) + signed(b));
	end process comblogic;

end behavioral;
