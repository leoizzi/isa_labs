library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;

entity tb_id_stage is
end tb_id_stage;

architecture tb of tb_id_stage is

	component id_stage is
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
			rp1: out std_logic_vector(31 downto 0); -- read port data 1
			rp2: out std_logic_vector(31 downto 0); -- read port data 2
			rs1: out std_logic_vector(4 downto 0); -- resister surce 1
			rs2: out std_logic_vector(4 downto 0); -- register source 2
			rd: out std_logic_vector(4 downto 0);
			imm: out std_logic_vector(31 downto 0)
		);
	end component id_stage;

	constant period: time := 10 ns;

	signal clk, rst: std_logic;

	signal npc_in, npc_out, pc_in, pc_out: std_logic_vector(31 downto 0);
	signal instr: std_logic_vector(31 downto 0);
	signal wp_addr, rd, rs1, rs2: std_logic_vector(4 downto 0);
	signal wp,rp1, rp2, imm: std_logic_vector(31 downto 0);

	signal wp_en: std_logic;
	signal instr_type_sel: std_logic_vector(2 downto 0);

begin
	
	dut: id_stage
		port map (
			clk => clk,
			rst => rst,
			npc_in => npc_in,
			pc_in => pc_in,
			instr => instr,
			wp_addr  =>  wp_addr,
			wp => wp,
			wp_en => wp_en,
			instr_type_sel => instr_type_sel,
			npc_out => npc_out,
			pc_out => pc_out,
			rp1 => rp1,
			rp2 => rp2,
			rs1 => rs1,
			rs2 => rs2,
			rd => rd,
			imm => imm
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

		npc_in <= X"00400004";
		pc_in <= X"00400000";
		instr <= X"00700813";
		instr_type_sel <= I_TYPE;
		wait for period/2;
		wp_addr <= "00101";
		wp <= X"00000440";
		wp_en <= '1';
		wait for period/2;

		npc_in <= X"00400008";
		pc_in <= X"00400004";
		instr <= X"0fc10217";
		instr_type_sel <= U_TYPE;
		wait for period/2;
		wp_addr <= "00100";
		wp <= X"00011100";
		wp_en <= '1';
		wait for period/2;

		npc_in <= X"0040000C";
		pc_in <= X"00400008";
		instr <= X"ffc20213";
		instr_type_sel <= I_TYPE;
		wait for period/2;

		wp_addr <= "00001";
		wp <= X"00003333";
		wp_en <= '0';
		wait for period/2;

		npc_in <= X"00400010";
		pc_in <= X"0040000C";
		instr <= X"0fc10297";
		instr_type_sel <= U_TYPE;
		wait for period/2;
		wp_addr <= "00000";
		wp <= X"00001111";
		wp_en <= '0';
		wait for period/2;

		npc_in <= X"00400014";
		pc_in <= X"00400010";
		instr <= X"01028293";
		instr_type_sel <= I_TYPE;
		wait for period/2;
		wp_addr <= "00000";
		wp <= X"11111111";
		wp_en <= '1';
		wait for period/2;

		npc_in <= X"00400018";
		pc_in <= X"00400014";
		instr <= X"400006b7";
		instr_type_sel <= I_TYPE;
		wait for period/2;
		wp_addr <= "00100";
		wp <= X"aaaaaaaa";
		wp_en <= '1';
		wait for period/2;

		wait;
	end process test_p;

end tb;
