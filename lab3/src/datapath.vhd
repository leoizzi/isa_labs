library ieee;
use ieee.std_logic_1164.all;

entity datapath is
	port (
		clk: in std_logic;
		rst: in std_logic;

		-- CU interface

		-- IF stage
		if_pc_enable: in std_logic;

		-- IF/ID
		ifid_pc_reg_en: in std_logic;
		ifid_npc_reg_en: in std_logic;
		ifid_instr_reg_en: in std_logic;

		-- ID stage
		id_instr_type_sel: in std_logic_vector(2 downto 0);
		id_rs1: out std_logic_vector(4 downto 0);
		id_rs2: out std_logic_vector(4 downto 0);

		-- ID/EXE
		idexe_pc_reg_en: in std_logic;
		idexe_npc_reg_en: in std_logic;
		idexe_a_en: in std_logic;
		idexe_b_en: in std_logic;
		idexe_imm_en: in std_logic;
		idexe_rd_en: in std_logic;

		-- EXE stage
		exe_a_sel: in std_logic; -- 0 to select a, 1 to select NPC
		exe_b_sel: in std_logic; -- 0 to select b, 1 to select imm
		-- 00 to select adder
		-- 01 to select logicals
		-- 10 to select set less than
		-- 11 to select shifter
		exe_ctrl: in std_logic_vector(1 downto 0);
		exe_log_type: in std_logic; -- if 0 and is selected, if 1 xor
		exe_jmp_enable: in std_logic; -- if set to 1 enables the possibility to jump

		-- EXE/MEM
		exemem_alu_data_en: in std_logic;
		exemem_reg_data_en: in std_logic;
		exemem_rd_en: in std_logic;

		-- MEM stage


		-- MEM/WB
		memwb_load_data_en: in std_logic;
		memwb_alu_data_en: in std_logic;
		memwb_rd_en: in std_logic;

		-- WB stage
		wb_en: in std_logic;
		wb_data_sel: in std_logic;

		-- ROM interface
		rom_address: out std_logic_vector(31 downto 0);
		rom_instr: in std_logic_vector(31 downto 0);

		-- RAM interface
		ram_datain: in std_logic_vector(31 downto 0);
		ram_dataout: out std_logic_vector(31 downto 0);
		ram_address: out std_logic_vector(31 downto 0)
	);
end datapath;

architecture structural of datapath is
	component if_stage is
		generic (
			N: integer := 32  -- data bit width
		);
		port (
			clk: in std_logic;
			rst: in std_logic;

			target_pc: in std_logic_vector(N-1 downto 0); -- target address coming from the alu
			pc_sel: in std_logic; -- PC selector: 0 to choose PC+4, 1 to choose the target address
			pc_en: in std_logic;

			-- ROM interface
			address: out std_logic_vector(N-1 downto 0); -- address of the instruction to be loaded from the ROM

			-- output to be saved in the pipeline registers
			pc: out std_logic_vector(N-1 downto 0); -- current PC
			npc: out std_logic_vector(N-1 downto 0) -- PC+4

		);
	end component if_stage;

	component if_id_regs is
		port (
			clk: in std_logic;
			rst: in std_logic;

			pc_in: in std_logic_vector(31 downto 0); -- PC
			npc_in: in std_logic_vector(31 downto 0); -- PC+4 
			instr_in: in std_logic_vector(31 downto 0); -- instruction loaded from the ROM

			-- enable signals
			pc_reg_en: in std_logic;
			npc_reg_en: in std_logic;
			instr_reg_en: in std_logic;

			pc_out: out std_logic_vector(31 downto 0);
			npc_out: out std_logic_vector(31 downto 0);
			instr_out: out std_logic_vector(31 downto 0)
		);
	end component if_id_regs;

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

	component id_exe_regs is
		port (
			clk: in std_logic;
			rst: in std_logic;

			pc_in: in std_logic_vector(31 downto 0); -- PC
			npc_in: in std_logic_vector(31 downto 0); -- PC+4 
			a_in: in std_logic_vector(31 downto 0); -- rd1
			b_in: in std_logic_vector(31 downto 0); --rd2
			imm_in: in std_logic_vector(31 downto 0); -- immediate
			rd_in: in std_logic_vector(4 downto 0); -- destination register

			-- enable signals
			pc_reg_en: in std_logic;
			npc_reg_en: in std_logic;
			a_en: in std_logic;
			b_en: in std_logic;
			imm_en: in std_logic;
			rd_en: in std_logic;

			pc_out: out std_logic_vector(31 downto 0);
			npc_out: out std_logic_vector(31 downto 0);
			a_out: out std_logic_vector(31 downto 0);
			b_out: out std_logic_vector(31 downto 0);
			imm_out: out std_logic_vector(31 downto 0);
			rd_out: out std_logic_vector(4 downto 0)
		);
	end component id_exe_regs;

	component exe_stage is
		port (
			npc: in std_logic_vector(31 downto 0); -- pc+4
			pc: in std_logic_vector(31 downto 0); -- instruction's pc
			a: in std_logic_vector(31 downto 0);
			b: in std_logic_vector(31 downto 0);
			imm: in std_logic_vector(31 downto 0);

			a_sel: in std_logic; -- 0 to select a, 1 to select NPC
			b_sel: in std_logic; -- 0 to select b, 1 to select imm

			-- 00 to select adder
			-- 01 to select logicals
			-- 10 to select set less than
			-- 11 to select shifter
			ctrl: in std_logic_vector(1 downto 0);
			log_type: in std_logic; -- if 0 and is selected, if 1 xor
			jmp_enable: in std_logic; -- if set to 1 enables the possibility to jump

			res: out std_logic_vector(31 downto 0);
			reg_out: out std_logic_vector(31 downto 0);
			pc_out: out std_logic_vector(31 downto 0);
			pc_sel: out std_logic -- used by the IF stage to determine which PC must be used
		);
	end component exe_stage;

	component exe_mem_regs is
		port (
			clk: in std_logic;
			rst: in std_logic;

			alu_data_in: in std_logic_vector(31 downto 0);
			reg_data_in: in std_logic_vector(31 downto 0);
			rd_in: in std_logic_vector(4 downto 0);

			alu_data_en: in std_logic;
			reg_data_en: in std_logic;
			rd_en: in std_logic;

			alu_data_out: out std_logic_vector(31 downto 0);
			reg_data_out: out std_logic_vector(31 downto 0);
			rd_out: out std_logic_vector(4 downto 0)
		);
	end component exe_mem_regs;

	component mem_wb_regs is
		port (
			clk: in std_logic;
			rst: in std_logic;

			load_data_in: in std_logic_vector(31 downto 0);
			alu_data_in: in std_logic_vector(31 downto 0);
			rd_in: in std_logic_vector(4 downto 0);

			load_data_en: in std_logic;
			alu_data_en: in std_logic;
			rd_en: in std_logic;

			load_data_out: out std_logic_vector(31 downto 0);
			alu_data_out: out std_logic_vector(31 downto 0);
			rd_out: out std_logic_vector(4 downto 0)
		);
	end component mem_wb_regs;

	component wb_stage is
		port (
			alu_data: in std_logic_vector(31 downto 0);
			mem_data: in std_logic_vector(31 downto 0);
			rd_in: in std_logic_vector(4 downto 0);
			data_sel: in std_logic;
			write_data: out std_logic_vector(31 downto 0);
			rd_out: out std_logic_vector(4 downto 0)
		);
	end component wb_stage;

	-- IF signals
	signal if_pc_out, if_npc_out: std_logic_vector(31 downto 0);

	-- ID signals
	signal id_pc_in, id_npc_in, id_instr_in: std_logic_vector(31 downto 0);
	signal id_rd_out: std_logic_vector(4 downto 0);
	signal id_npc_out, id_pc_out, id_rp1_out, id_rp2_out, id_imm_out: std_logic_vector(31 downto 0);

	-- EXE signals
	signal exe_rd_in: std_logic_vector(4 downto 0);
	signal exe_npc_in, exe_pc_in, exe_a_in, exe_b_in, exe_imm_in: std_logic_vector(31 downto 0);
	signal exe_pc_sel_out: std_logic;
	signal exe_res_out, exe_reg_out, exe_target_pc_out: std_logic_vector(31 downto 0);

	-- MEM signals
	signal mem_alu_data_in, mem_reg_data_out: std_logic_vector(31 downto 0);
	signal mem_rd_in: std_logic_vector(4 downto 0);

	-- WB signals
	signal wb_load_data_in, wb_alu_data_in: std_logic_vector(31 downto 0);
	signal wb_rd_in: std_logic_vector(4 downto 0);
	signal wb_addr: std_logic_vector(4 downto 0);
	signal wb_data: std_logic_vector(31 downto 0);
begin
	ifs: if_stage
		generic map (
			N => 32
		)
		port map (
			clk => clk,
			rst => rst,

			target_pc => exe_target_pc_out,
			pc_sel => exe_pc_sel_out,
			pc_en => if_pc_enable,

			-- ROM interface
			address => rom_address,

			-- output to be saved in the pipeline registers
			pc => if_pc_out,
			npc => if_npc_out
		);

	if_id_r: if_id_regs
		port map (
			clk => clk,
			rst => rst,

			pc_in => if_pc_out,
			npc_in => if_npc_out,
			instr_in => rom_instr,

			-- enable signals
			pc_reg_en => ifid_pc_reg_en,
			npc_reg_en => ifid_npc_reg_en,
			instr_reg_en => ifid_instr_reg_en,

			pc_out => id_pc_in,
			npc_out => id_npc_in,
			instr_out => id_instr_in
		);

	ids: id_stage
		port map (
			clk => clk,
			rst => rst,

			npc_in => id_npc_in,
			pc_in => id_pc_in,
			instr => id_instr_in,

			wp_addr => wb_addr,
			wp => wb_data,

			-- control signals
			wp_en => wb_en,
			instr_type_sel => id_instr_type_sel,

			npc_out => id_npc_out,
			pc_out => id_pc_out,
			rp1 => id_rp1_out,
			rp2 => id_rp2_out,
			rs1 => id_rs1,
			rs2 => id_rs2,
			rd => id_rd_out,
			imm => id_imm_out
		);

	idexe_r: id_exe_regs
		port map (
			clk => clk,
			rst => rst,

			pc_in => id_pc_out,
			npc_in => id_npc_out,
			a_in => id_rp1_out,
			b_in => id_rp2_out,
			imm_in => id_imm_out,
			rd_in => id_rd_out,

			-- enable signals
			pc_reg_en => idexe_pc_reg_en,
			npc_reg_en => idexe_npc_reg_en,
			a_en => idexe_a_en,
			b_en => idexe_b_en,
			imm_en => idexe_imm_en,
			rd_en => idexe_rd_en,

			pc_out => exe_pc_in,
			npc_out => exe_npc_in,
			a_out => exe_a_in,
			b_out => exe_b_in,
			imm_out => exe_imm_in,
			rd_out => exe_rd_in
		);

	exes: exe_stage
		port map (
			npc => exe_npc_in,
			pc => exe_pc_in,
			a => exe_a_in,
			b => exe_b_in,
			imm => exe_imm_in,

			a_sel => exe_a_sel,
			b_sel => exe_b_sel,

			ctrl => exe_ctrl,
			log_type => exe_log_type,
			jmp_enable => exe_jmp_enable,

			res => exe_res_out,
			reg_out => exe_reg_out,
			pc_out => exe_target_pc_out,
			pc_sel => exe_pc_sel_out
		);

	exemem_r: exe_mem_regs
		port map (
			clk => clk,
			rst => rst,

			alu_data_in => exe_res_out,
			reg_data_in => exe_reg_out,
			rd_in => exe_rd_in,

			alu_data_en => exemem_alu_data_en,
			reg_data_en => exemem_reg_data_en,
			rd_en => exemem_rd_en,

			alu_data_out => mem_alu_data_in,
			reg_data_out => mem_reg_data_out,
			rd_out => mem_rd_in
		);

	ram_dataout <= mem_reg_data_out;
	ram_address <= mem_alu_data_in;

	memwb_r: mem_wb_regs
		port map (
			clk => clk,
			rst => rst,

			load_data_in => ram_datain,
			alu_data_in => mem_alu_data_in,
			rd_in => mem_rd_in,

			load_data_en => memwb_load_data_en,
			alu_data_en => memwb_alu_data_en,
			rd_en => memwb_rd_en,

			load_data_out => wb_load_data_in,
			alu_data_out => wb_alu_data_in,
			rd_out => wb_rd_in
		);

	wbs: wb_stage
		port map (
			alu_data => wb_alu_data_in,
			mem_data => wb_load_data_in,
			rd_in => wb_rd_in,
			data_sel => wb_data_sel,
			write_data => wb_data,
			rd_out => wb_addr
		);
end structural;
