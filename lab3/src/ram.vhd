library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Single port RAM
entity ram is
	generic (
		N: integer := 64; -- data bit width
		A: integer := 32; -- address bit width
		W: integer := 16 -- number of words
	);
	port (
		clk: in std_logic;
		rst: in std_logic;
		address: in std_logic_vector(A-1 downto 0);
		wr: in std_logic; -- 1 for write, 0 for read
		data: inout std_logic_vector(N-1 downto 0)
	);
end ram;

architecture behavioral of ram is
	type mem is array(0 to W) of std_logic_vector(N-1 downto 0);

	signal curr_mem, next_mem: mem;
begin
	reg_state: process(clk)
	begin
		if (clk = '1' and clk'event) then
			if (rst = '0') then
				curr_mem <= (others => (others => '0'));
			else
				curr_mem <= next_mem;
			end if;
		end if;
	end process reg_state;

	comblogic: process(address, wr, data)
	begin
		data <= (others => 'Z');
		next_mem <= curr_mem;

		if (wr = '0') then
			data <= curr_mem(to_integer(unsigned(address)));
		else
			next_mem(to_integer(unsigned(address))) <= data;
		end if;
	end process comblogic;
end behavioral;
