library ieee;
use ieee.std_logic_1164.all;

entity riscv_sim is
	generic (
		A_ROM: integer := 8; -- address bit width
		W_ROM: integer := 256; -- number of words
		F_ROM: string := "C:\Users\leona\isa_projects\riscv-final\riscv-final.srcs\sim_1\new\bin_code.txt"; -- input file path
		A_RAM: integer := 8; -- address bit width
		W_RAM: integer := 256; -- number of words
		F_RAM: string := "./samples";
		D_RAM: integer := 0
	);
	port (
		clk: in std_logic;
		rst: in std_logic;
		wb_data_out: out std_logic_vector(31 downto 0)
	);
end riscv_sim;

architecture structural of riscv_sim is
	component core is
		port (
			clk: in std_logic;
			rst: in std_logic;
			
			-- Output
		    wb_data_out: out std_logic_vector(31 downto 0);
			
			-- ROM interface
			rom_instr: in std_logic_vector(31 downto 0);
			rom_address: out std_logic_vector(31 downto 0);
			
			-- RAM interface
			ram_wr: out std_logic; -- 1 for write, 0 for read
			ram_datain: in std_logic_vector(31 downto 0);
			ram_dataout: out std_logic_vector(31 downto 0);
			ram_address: out std_logic_vector(31 downto 0)
		);
	end component core;

	component rom is
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
	end component rom;

	component ram is
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
	end component ram;

	signal rom_instr, rom_address: std_logic_vector(31 downto 0);

	signal ram_wr: std_logic; -- 1 for write, 0 for read
	signal ram_datain, ram_dataout, ram_address: std_logic_vector(31 downto 0);
begin
	riscv_core: core
		port map (
			clk => clk,
			rst => rst,
			
			wb_data_out => wb_data_out,
			
			-- ROM interface
			rom_instr => rom_instr,
			rom_address => rom_address,
			
			-- RAM interface
			ram_wr => ram_wr,
			ram_datain => ram_datain,
			ram_dataout => ram_dataout,
			ram_address => ram_address
		);

	imem: rom
		generic map (
		 	N => 32,
			A => A_ROM-2,
			W => W_ROM,
			F => F_ROM
		)
		port map (
			rst => rst,
			address => rom_address(A_ROM-1 downto 2),
			data => rom_instr
		);

	dmem: ram
		generic map (
			N => 32,
			A => A_RAM,
			W => W_RAM,
			F => F_RAM,
		    D => D_RAM
		)
		port map (
			clk => clk,
			rst => rst,
			address => ram_address(A_RAM-1 downto 0),
			wr => ram_wr,
			datain => ram_dataout,
			dataout => ram_datain
		);
end structural;
