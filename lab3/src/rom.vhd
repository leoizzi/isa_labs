library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

-- Simple ROM taking its values from a file
entity rom is
	generic (
		N: integer := 32; -- data bit width
		A: integer := 32; -- address bit width
		W: integer := 32; -- number of words
		F: string := "./samples.txt" -- input file path
	);

	port (
		rst: in std_logic;
		address: in std_logic_vector(A-1 downto 0);
		data: out std_logic_vector(N-1 downto 0)
	);
end rom;

architecture behavioral of rom is

type mem_arr is array (0 to W) of std_logic_vector(N-1 downto 0);

signal mem: mem_arr;
	
begin
	rst_proc: process(rst)
		file fp: text;
		variable l: line;
		variable i: integer := 0;
		variable tmp: std_logic_vector(N-1 downto 0);
	begin
		if (rst = '0') then
			file_open(fp, F, read_mode);
			while not endfile(fp) loop
				readline(fp, l);
				hread(l, tmp);
				mem(i) <= tmp;
				i := i + 1;
			end loop;
			file_close(fp);
		end if;
	end process rst_proc;

	comblogic: process(address)
	begin
		data <= mem(to_integer(unsigned(address)));
	end process comblogic;

end behavioral;
