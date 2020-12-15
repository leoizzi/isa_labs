library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
	generic (
		N: integer := 64
	);
	port (
		a: in std_logic_vector(N-1 downto 0);
		b: in std_logic_vector(N-1 downto 0);
		cin: in std_logic;
		s: out std_logic_vector(N-1 downto 0);
		cout: out std_logic
	);
end adder;

architecture behavioral of adder is
	signal tmp: std_logic_vector(N downto 0);
	signal cin_tmp: std_logic_vector(N downto 0);
begin
    cin_tmp <= ( 0 => cin, others => '0');
	tmp <= std_logic_vector(unsigned('0'&a) + unsigned('0'&b) + unsigned(cin_tmp));
	s <= tmp(N-1 downto 0);
	cout <= tmp(N);
end behavioral;
