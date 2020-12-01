library ieee;
use ieee.std_logic_1164.all;

entity reg_en is
	generic (
		N: integer := 32
	);
	port (
		d: in std_logic_vector(N-1 downto 0);
		en: in std_logic;
		clk: in std_logic;
		rst: in std_logic;
		q: out std_logic_vector(N-1 downto 0)	
	);
end entity reg_en;

architecture behavioral of reg_en is

begin
	
	state_p: process(clk)
		begin
			if (clk = '1' and clk'event) then
				if (rst = '0') then
					q <= (others => '0');
				else if (en = '1') then
						q <= d;
					end if;
				end if;
			end if;
		end process state_p;
end architecture behavioral;