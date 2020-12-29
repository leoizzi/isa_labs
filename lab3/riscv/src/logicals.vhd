library ieee;
use ieee.std_logic_1164.all;

-- unit that calculates logic operations (AND and XOR)
entity logicals is
	generic (
		N: integer := 64
	);
	port (
		op1: in std_logic_vector(N-1 downto 0);
		op2: in std_logic_vector(N-1 downto 0);
		op_type: in std_logic; -- 0 for AND, 1 for XOR
		res: out std_logic_vector(N-1 downto 0)
	);
end logicals;

architecture structural of logicals is

begin
	with op_type select res <= 
		op1 and op2 when '0',
		op1 xor op2 when others;
end structural;
