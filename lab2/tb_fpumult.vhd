library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity tb_fpumult is
	
end entity tb_fpumult;

architecture test of tb_fpumult is
	component data_maker is
		port (
		    CLK  : in  std_logic;
		    DATA : out std_logic_vector(31 downto 0));
	end component data_maker;

	component FPmul is
		PORT( 
	      FP_A : IN     std_logic_vector (31 DOWNTO 0);
	      FP_B : IN     std_logic_vector (31 DOWNTO 0);
	      clk  : IN     std_logic;
	      FP_Z : OUT    std_logic_vector (31 DOWNTO 0)
	   );
	end component FPmul;

	constant period : time := 10 ns;

	type arr is array (0 to 3) of std_logic_vector(31 downto 0);

	signal clk: std_logic;
	signal data, z: std_logic_vector(31 downto 0);
	signal curr_sr, next_sr: arr;
	signal eq: std_logic;

begin
	dm: data_maker
		port map (
			CLK => clk,
			DATA => data
		);

	mul: FPmul
		port map (
			FP_A => data,
			FP_B => data,
			clk => clk,
			FP_Z => z
		);

	clk_proc: process
	begin
		clk <= '1';
		wait for period/2;
		clk <= '0';
		wait for period/2;
	end process clk_proc;

	shift_regstate: process(clk)
	begin
		if (clk = '1' and clk'event) then
			curr_sr(3) <= next_sr(3);
			curr_sr(2) <= next_sr(2);
			curr_sr(1) <= next_sr(1);
			curr_sr(0) <= next_sr(0);
		end if;
	end process shift_regstate;

	read_proc: process(clk)
		file fp : text open read_mode is "./fp_prod.hex";
	    variable ptr : line;
	    variable val : std_logic_vector(31 downto 0);
	begin
		if clk'event and clk = '1' then  -- rising clock edge
	    	if (not(endfile(fp))) then
	    		readline(fp, ptr);
	        	hread(ptr, val); 
	        	next_sr(3) <= val;
	        	next_sr(2) <= next_sr(3);
	        	next_sr(1) <= next_sr(2);
	        	next_sr(0) <= next_sr(1);
	    	end if;
    	end if;
	end process read_proc;

	check_proc: process(z, curr_sr)
	begin
		if (z = curr_sr(0)) then
			eq <= '1';
		else
			eq <= '0';
		end if;
	end process check_proc;	
end architecture test;