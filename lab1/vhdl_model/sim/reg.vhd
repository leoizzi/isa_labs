library ieee;
use ieee.std_logic_1164.all;

entity reg is
	generic (
		N: integer := 12
	);
	port (
		clk: in std_logic;
		rst_n: in std_logic;
		en: in std_logic;
		d: in std_logic_vector(N-1 downto 0);
		q: out std_logic_vector(N-1 downto 0)
	);
end reg;

architecture behavioral of reg is

begin
	clk_proc: process(clk, rst_n)
	begin
		if (rst_n = '0') then
			q <= (others => '0');
		elsif (clk = '1' and clk'event) then
			if (en = '1') then
				q <= d;
			end if;
		end if;
	end process clk_proc;
end behavioral;
