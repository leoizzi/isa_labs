library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- This is the register file. It is composed of 32 64-bit registers. It has two read ports and a write port.
entity rf is
	generic (
		N: integer := 64 -- size of the registers
	);
	port (
		clk: in std_logic;
		rst: in std_logic;

		rp1_addr: in std_logic_vector(4 downto 0); -- register address for rp1
		rp2_addr: in std_logic_vector(4 downto 0); -- register address for rp2
		wp_addr: in std_logic_vector(4 downto 0); -- register addres for wp
		wp_en: in std_logic; -- write enable
		wp: in std_logic_vector(63 downto 0); -- data to be written
		rp1: out std_logic_vector(63 downto 0); -- read data on port 1
		rp2: out std_logic_vector(63 downto 0) -- read data on port 2
	);
end rf;

architecture behavioral of rf is
	component reg_en is
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
	end component reg_en;

	signal enable: std_logic_vector(31 downto 0);
	type data_arr is array (0 to 31) of std_logic_vector(N-1 downto 0);
	signal regout_arr: data_arr;
	signal clk_inv: std_logic;

begin
	
	regout_arr(0) <= (others => '0');

	clk_inv <= not(clk);

	-- Registers instantiation

	regs: for i in 1 to 31 generate
		reg_i: reg_en
			generic map (
				N => N
			)
			port map (
				d => wp,
				en => enable(i),
				clk => clk_inv,
				rst => rst,
				q => regout_arr(i)
			);
	end generate regs;

	comb_logic: process(rp1_addr, rp2_addr, wp_addr, wp_en, wp, regout_arr)
	begin
		enable <= (others  => '0');
		
		-- Enable the register that has to be written
		if (unsigned(wp_addr) /= 0 and wp_en = '1') then
			enable(to_integer(unsigned(wp_addr))) <= '1';
		end if;

		-- Read ports
		rp1 <= regout_arr(to_integer(unsigned(rp1_addr)));
		rp2 <= regout_arr(to_integer(unsigned(rp2_addr)));

	end process comb_logic;




end behavioral;
