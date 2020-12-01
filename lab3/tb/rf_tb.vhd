library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rf_tb is
end rf_tb;

architecture behavioral of rf_tb is

	component rf is
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
	end component rf;

	constant N: integer := 64;
	constant period: time := 10 ns;

	signal rp1_addr,rp2_addr, wp_addr: std_logic_vector(4 downto 0);
	signal wp_en, clk, rst: std_logic;
	signal wp, rp1, rp2: std_logic_vector(N-1 downto 0);

begin

	reg_file: rf
		generic map (
			N => N
		)
		port map (
			clk => clk,
			rst => rst,
			rp1_addr => rp1_addr,
			rp2_addr => rp2_addr,
			wp_addr => wp_addr,
			wp_en => wp_en,
			wp => wp,
			rp1 => rp1,
			rp2 => rp2
		);
	
	clk_p: process
	begin
		clk <= '1';
		wait for period/2;
		clk <= '0';
		wait for period/2;
	end process clk_p;

	test_p: process
	begin
		wait for period/2;
		rst <= '0';
		wait for period;
		rst <= '1';
		wait for period/2;

		wp_en <= '0';
		wp <= (others => '0');

		read_loop0 : for i in 0 to 15 loop
			rp1_addr <= std_logic_vector(to_unsigned(i,5));
			rp2_addr <= std_logic_vector(to_unsigned(i+16,5));
			wait for period;
		end loop read_loop0;

		write_loop : for i in 0 to 31 loop
			wp <= std_logic_vector(to_unsigned(i+1,64));
			wp_en <= '1';
			wp_addr <= std_logic_vector(to_unsigned(i,5));
			wait for period;
		end loop write_loop;

		read_loop1 : for i in 0 to 15 loop
			rp1_addr <= std_logic_vector(to_unsigned(i,5));
			rp2_addr <= std_logic_vector(to_unsigned(i+16,5));
			wait for period;
		end loop read_loop1;
        wait;
	end process test_p;
end behavioral;
