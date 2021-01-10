library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

-- Single port RAM
entity ram is
	generic (
		N: integer := 64; -- data bit width
		A: integer := 32; -- address bit width
		W: integer := 16; -- number of words
		F: string := "./samples"; -- init file
		D: integer := 0 -- start address of data segment
	);
	port (
		clk: in std_logic;
		rst: in std_logic;
		address: in std_logic_vector(A-1 downto 0);
		wr: in std_logic; -- 1 for write, 0 for read
		datain: in std_logic_vector(N-1 downto 0);
		dataout: out std_logic_vector(N-1 downto 0)
	);
end ram;

architecture behavioral of ram is
	type mem is array(0 to W) of std_logic_vector(N-1 downto 0);
	constant start_data_address : integer := D mod W; 

	signal curr_mem, next_mem: mem;
begin
	reg_state: process(clk)
		file fp: text;
		variable l: line;
		variable i: integer := start_data_address;
		variable tmp: std_logic_vector(N-1 downto 0);
	begin
		if (clk = '1' and clk'event) then
			if (rst = '0') then
				curr_mem <= (others => (others => '0'));
				i := start_data_address;
				file_open(fp, F, read_mode);
				while not endfile(fp) loop
					readline(fp, l);
					hread(l, tmp);
					curr_mem(i) <= tmp;
					i := i + 4;
				end loop;
				file_close(fp);
			else
				curr_mem <= next_mem;
			end if;
		end if;
	end process reg_state;

	comblogic: process(curr_mem, address, wr, datain)
	begin
		next_mem <= curr_mem;
		dataout <= curr_mem(to_integer(unsigned(address)));

		if (wr = '1') then
			next_mem(to_integer(unsigned(address))) <= datain;
		end if;
	end process comblogic;
end behavioral;
