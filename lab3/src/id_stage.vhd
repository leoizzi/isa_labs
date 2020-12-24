library ieee;
use ieee.std_logic_1164.all;

entity id_stage is
	port (
		clk: in std_logic;
		rst: in std_logic;

		npc_in: in std_logic_vector(31 downto 0);
		pc_in: in std_logic_vector(31 downto 0);
		instr: in std_logic_vector(31 downto 0);

		wp_addr: in std_logic_vector(4 downto 0); -- address where to write the data coming from the WB stage
		wp: in std_logic_vector(31 downto 0); -- data to be written in the rf coming from the WB stage 

		-- control signals
		wp_en: in std_logic;
		instr_type_sel: in std_logic_vector(2 downto 0);

		npc_out: out std_logic_vector(31 downto 0);
		pc_out: out std_logic_vector(31 downto 0);
		rs1: out std_logic_vector(31 downto 0);
		rs2: out std_logic_vector(31 downto 0);
		rd: out std_logic_vector(4 downto 0);
		imm: out std_logic_vector(31 downto 0)
	);
end id_stage;

architecture struct of id_stage is
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
			wp: in std_logic_vector(N-1 downto 0); -- data to be written
			rp1: out std_logic_vector(N-1 downto 0); -- read data on port 1
			rp2: out std_logic_vector(N-1 downto 0) -- read data on port 2
		);
	end component rf;

	component imm_gen is
		port(
			instr: in std_logic_vector(31 downto 0);
			instr_type_sel: in std_logic_vector(2 downto 0);
			imm_out: out std_logic_vector(31 downto 0)
		);
	end component imm_gen;

	constant N: integer := 32; 

begin

	rd <= instr(11 downto 7);
	npc_out <= npc_in;
	pc_out <= pc_in;


	reg_file: rf
		generic map(
			N => N
		)
		port map(
			clk => clk,
			rst => rst,
			rp1_addr => instr(19 downto 15),
			rp2_addr => instr(24 downto 20),
			wp_addr => wp_addr,
			wp_en => wp_en,
			wp => wp,
			rp1 => rs1,
			rp2 => rs2

		);

	immediate_gen: imm_gen
		port map (
			instr => instr,
			instr_type_sel => instr_type_sel,
			imm_out => imm
		);

end struct;
