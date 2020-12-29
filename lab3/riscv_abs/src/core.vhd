library ieee;
use ieee.std_logic_1164.all;

entity core is
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
end core;

architecture structural of core is
	component cu is
		port (
			clk: in std_logic;
			rst: in std_logic;

			-- CU interface

			-- IF stage
			if_pc_enable: out std_logic;

			-- IF/ID
			ifid_rst: out std_logic;
			ifid_pc_reg_en: out std_logic;
			ifid_npc_reg_en: out std_logic;
			ifid_instr_reg_en: out std_logic;

			-- ID stage
			id_instr_type_sel: out std_logic_vector(2 downto 0);
			id_rs1: in std_logic_vector(4 downto 0);
			id_rs2: in std_logic_vector(4 downto 0);

			-- ID/EXE
			idexe_rst: out std_logic;
			idexe_pc_reg_en: out std_logic;
			idexe_npc_reg_en: out std_logic;
			idexe_a_en: out std_logic;
			idexe_b_en: out std_logic;
			idexe_imm_en: out std_logic;
			idexe_rd_en: out std_logic;
			idexe_rd: in std_logic_vector(4 downto 0);

			-- EXE stage
			-- 00 to select a
			-- 01 to select NPC
			-- 10 to select PC
			-- 11 to select all 0s
			exe_a_sel: out std_logic_vector(1 downto 0);
			-- 00 to select b
			-- 01 to select imm
			-- 10 to select all 0s
			-- 11 to select all 0s
			exe_b_sel: out std_logic_vector(1 downto 0);
			-- 00 to select adder
			-- 01 to select logicals
			-- 10 to select set less than
			-- 11 to select shifter
			-- 100 to select ABS unit
			exe_ctrl: out std_logic_vector(2 downto 0);
			exe_log_type: out std_logic; -- if 0 and is selected, if 1 xor
			exe_jmp_enable: out std_logic; -- if set to 1 enables the possibility to jump
			exe_taken: in std_logic; -- 1 if taken, 0 if not

			-- EXE/MEM
			exemem_rst: out std_logic;
			exemem_alu_data_en: out std_logic;
			exemem_reg_data_en: out std_logic;
			exemem_rd_en: out std_logic;
			exemem_rd: in std_logic_vector(4 downto 0);

			-- MEM stage


			-- MEM/WB
			memwb_rst: out std_logic;
			memwb_load_data_en: out std_logic;
			memwb_alu_data_en: out std_logic;
			memwb_rd_en: out std_logic;

			-- WB stage
			wb_en: out std_logic;
			wb_data_sel: out std_logic;

			-- ROM interface
			rom_instr: in std_logic_vector(31 downto 0);

			-- RAM interface
			ram_wr: out std_logic -- 1 for write, 0 for read
		);
	end component cu;

	component datapath is
		port (
			clk: in std_logic;
			rst: in std_logic;

			-- CU interface

			-- IF stage
			if_pc_enable: in std_logic;

			-- IF/ID
			ifid_rst: in std_logic;
			ifid_pc_reg_en: in std_logic;
			ifid_npc_reg_en: in std_logic;
			ifid_instr_reg_en: in std_logic;

			-- ID stage
			id_instr_type_sel: in std_logic_vector(2 downto 0);
			id_rs1: out std_logic_vector(4 downto 0);
			id_rs2: out std_logic_vector(4 downto 0);

			-- ID/EXE
			idexe_rst: in std_logic;
			idexe_pc_reg_en: in std_logic;
			idexe_npc_reg_en: in std_logic;
			idexe_a_en: in std_logic;
			idexe_b_en: in std_logic;
			idexe_imm_en: in std_logic;
			idexe_rd_en: in std_logic;
			idexe_rd: out std_logic_vector(4 downto 0);

			-- EXE stage
			-- 00 to select a
			-- 01 to select NPC
			-- 10 to select PC
			-- 11 to select all 0s
			exe_a_sel: in std_logic_vector(1 downto 0);
			-- 00 to select b
			-- 01 to select imm
			-- 10 to select all 0s
			-- 11 to select all 0s
			exe_b_sel: in std_logic_vector(1 downto 0);
			-- 000 to select adder
			-- 001 to select logicals
			-- 010 to select set less than
			-- 011 to select shifter
			-- 100 to select ABS unit
			exe_ctrl: in std_logic_vector(2 downto 0);
			exe_log_type: in std_logic; -- if 0 and is selected, if 1 xor
			exe_jmp_enable: in std_logic; -- if set to 1 enables the possibility to jump
			exe_taken: out std_logic; -- 1 if taken, 0 if not

			-- EXE/MEM
			exemem_rst: in std_logic;
			exemem_alu_data_en: in std_logic;
			exemem_reg_data_en: in std_logic;
			exemem_rd_en: in std_logic;
			exemem_rd: out std_logic_vector(4 downto 0);

			-- MEM stage


			-- MEM/WB
			memwb_rst: in std_logic;
			memwb_load_data_en: in std_logic;
			memwb_alu_data_en: in std_logic;
			memwb_rd_en: in std_logic;

			-- WB stage
			wb_en: in std_logic;
			wb_data_sel: in std_logic;

			-- Output
			wb_data_out: out std_logic_vector(31 downto 0);

			-- ROM interface
			rom_address: out std_logic_vector(31 downto 0);
			rom_instr: in std_logic_vector(31 downto 0);

			-- RAM interface
			ram_datain: in std_logic_vector(31 downto 0);
			ram_dataout: out std_logic_vector(31 downto 0);
			ram_address: out std_logic_vector(31 downto 0)
		);
	end component datapath;

	-- IF stage
	signal if_pc_enable: std_logic;

	-- IF/ID
	signal ifid_rst, ifid_pc_reg_en, ifid_npc_reg_en, ifid_instr_reg_en: std_logic;

	-- ID stage
	signal id_instr_type_sel: std_logic_vector(2 downto 0);
	signal id_rs1, id_rs2: std_logic_vector(4 downto 0);

	-- ID/EXE
	signal idexe_rst, idexe_pc_reg_en, idexe_npc_reg_en, idexe_a_en, idexe_b_en, idexe_imm_en, idexe_rd_en: std_logic;
	signal idexe_rd: std_logic_vector(4 downto 0);

	-- EXE stage
	signal exe_log_type, exe_jmp_enable, exe_taken: std_logic;
	signal exe_a_sel, exe_b_sel: std_logic_vector(1 downto 0);
	signal exe_ctrl: std_logic_vector(2 downto 0);

	-- EXE/MEM
	signal exemem_rst, exemem_alu_data_en, exemem_reg_data_en, exemem_rd_en: std_logic;
	signal exemem_rd: std_logic_vector(4 downto 0);

	-- MEM stage

	-- MEM/WB
	signal memwb_rst, memwb_load_data_en, memwb_alu_data_en, memwb_rd_en: std_logic;

	-- WB stage
	signal wb_en, wb_data_sel: std_logic;
begin
	c: cu
		port map (
			clk => clk,
			rst => rst,
			if_pc_enable => if_pc_enable,
			ifid_rst => ifid_rst,
			ifid_pc_reg_en => ifid_pc_reg_en,
			ifid_npc_reg_en => ifid_npc_reg_en,
			ifid_instr_reg_en => ifid_instr_reg_en,
			id_instr_type_sel => id_instr_type_sel,
			id_rs1 => id_rs1,
			id_rs2 => id_rs2,
			idexe_rst => idexe_rst,
			idexe_pc_reg_en => idexe_pc_reg_en,
			idexe_npc_reg_en => idexe_npc_reg_en,
			idexe_a_en => idexe_a_en,
			idexe_b_en => idexe_b_en,
			idexe_imm_en => idexe_imm_en,
			idexe_rd_en => idexe_rd_en,
			idexe_rd => idexe_rd,
			exe_a_sel => exe_a_sel,
			exe_b_sel => exe_b_sel,
			exe_ctrl => exe_ctrl,
			exe_log_type => exe_log_type,
			exe_jmp_enable => exe_jmp_enable,
			exe_taken => exe_taken,
			exemem_rst => exemem_rst,
			exemem_alu_data_en => exemem_alu_data_en,
			exemem_reg_data_en => exemem_reg_data_en,
			exemem_rd_en => exemem_rd_en,
			exemem_rd => exemem_rd,
			memwb_rst => memwb_rst,
			memwb_load_data_en => memwb_load_data_en,
			memwb_alu_data_en => memwb_alu_data_en,
			memwb_rd_en => memwb_rd_en,
			wb_en => wb_en,
			wb_data_sel => wb_data_sel,
			rom_instr => rom_instr,
			ram_wr => ram_wr
		);

	d: datapath
		port map (
			clk => clk,
			rst => rst,
			if_pc_enable => if_pc_enable,
			ifid_rst => ifid_rst,
			ifid_pc_reg_en => ifid_pc_reg_en,
			ifid_npc_reg_en => ifid_npc_reg_en,
			ifid_instr_reg_en => ifid_instr_reg_en,
			id_instr_type_sel => id_instr_type_sel,
			id_rs1 => id_rs1,
			id_rs2 => id_rs2,
			idexe_rst => idexe_rst,
			idexe_pc_reg_en => idexe_pc_reg_en,
			idexe_npc_reg_en => idexe_npc_reg_en,
			idexe_a_en => idexe_a_en,
			idexe_b_en => idexe_b_en,
			idexe_imm_en => idexe_imm_en,
			idexe_rd_en => idexe_rd_en,
			idexe_rd => idexe_rd,
			exe_a_sel => exe_a_sel,
			exe_b_sel => exe_b_sel,
			exe_ctrl => exe_ctrl,
			exe_log_type => exe_log_type,
			exe_jmp_enable => exe_jmp_enable,
			exe_taken => exe_taken,
			exemem_rst => exemem_rst,
			exemem_alu_data_en => exemem_alu_data_en,
			exemem_reg_data_en => exemem_reg_data_en,
			exemem_rd_en => exemem_rd_en,
			exemem_rd => exemem_rd,
			memwb_rst => memwb_rst,
			memwb_load_data_en => memwb_load_data_en,
			memwb_alu_data_en => memwb_alu_data_en,
			memwb_rd_en => memwb_rd_en,
			wb_en => wb_en,
			wb_data_sel => wb_data_sel,
			rom_address => rom_address,
			rom_instr => rom_instr,
			ram_datain => ram_datain,
			ram_dataout => ram_dataout,
			ram_address => ram_address,
			wb_data_out => wb_data_out
		);

end structural;
