library ieee;
use ieee.std_logic_1164.all;

use work.constants.all;
use work.cw.all;
use work.opcodes.all;

entity cu is
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
		exe_ctrl: out std_logic_vector(1 downto 0);
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
end cu;

architecture behavioral of cu is
	--signal curr_if: std_logic_vector(IF_REG-ID_REG-1 downto 0);
	signal curr_id, next_id: std_logic_vector(ID_REG-1 downto 0);
	signal curr_exe, next_exe: std_logic_vector(EXE_REG-1 downto 0);
	signal curr_mem, next_mem: std_logic_vector(MEM_REG-1 downto 0);
	signal curr_wb, next_wb: std_logic_vector(WB_REG-1 downto 0);

	signal flush_if: std_logic;
	signal flush_jmp: std_logic;
	signal ifid_stall, idexe_stall, exemem_stall, memwb_stall: std_logic; -- 0 -> stall, 1 -> keep going
	signal cu_ifid_rst, cu_idexe_rst: std_logic;
begin
	if_pc_enable <= ifid_stall;
	ifid_pc_reg_en <= ifid_stall;
	ifid_npc_reg_en <= ifid_stall;
	ifid_instr_reg_en <= ifid_stall;

	idexe_pc_reg_en <= idexe_stall;
	idexe_npc_reg_en <= idexe_stall;
	idexe_a_en <= idexe_stall;
	idexe_b_en <= idexe_stall;
	idexe_imm_en <= idexe_stall;
	idexe_rd_en <= idexe_stall;

	exemem_alu_data_en <= exemem_stall;
	exemem_reg_data_en <= exemem_stall;
	exemem_rd_en <= exemem_stall;

	memwb_load_data_en <= memwb_stall;
	memwb_alu_data_en <= memwb_stall;
	memwb_rd_en <= memwb_stall;

	ifid_rst <= cu_ifid_rst;
	idexe_rst <= cu_idexe_rst;

	state_reg: process(clk)
	begin
		if (clk = '1' and clk'event) then
			if (rst = '0') then
				curr_id <= NOP_CW(ID_REG-1 downto 0);
				curr_exe <= NOP_CW(EXE_REG-1 downto 0);
				curr_mem <= NOP_CW(MEM_REG-1 downto 0);
				curr_wb <= NOP_CW(WB_REG-1 downto 0);
			else
				if (cu_ifid_rst = '0') then
					curr_id <= NOP_CW(ID_REG-1 downto 0);
				else
					curr_id <= next_id;
				end if;

				if (cu_idexe_rst = '0') then
					curr_exe <= NOP_CW(EXE_REG-1 downto 0);
				else
					curr_exe <= next_exe;
				end if;

				curr_mem <= next_mem;
				curr_wb <= next_wb;
			end if;
		end if;
	end process state_reg;

	if_stage: process(rom_instr, exe_taken, ifid_stall)
	begin
		flush_if <= '0';
		flush_jmp <= '0';

		case (rom_instr(6 downto 0)) is
			when RTYPE_OPC =>
				case (rom_instr(14 downto 12)) is
					when ADD_OPC =>
						--curr_if <= ADD_CW(IF_REG-1 downto ID_REG);
						next_id <= ADD_CW(ID_REG-1 downto 0);
					when XOR_OPC => 
						--curr_if <= XOR_CW(IF_REG-1 downto ID_REG);
						next_id <= XOR_CW(ID_REG-1 downto 0);
					when SLT_OPC => 
						--curr_if <= SLT_CW(IF_REG-1 downto ID_REG);
						next_id <= SLT_CW(ID_REG-1 downto 0);
					when others =>
						--curr_if <= NOP_CW(IF_REG-1 downto ID_REG);
						next_id <= NOP_CW(ID_REG-1 downto 0);
						flush_if <= '1';
				end case;

			when ITYPE_OPC => 
				case (rom_instr(14 downto 12)) is
					when ADDI_OPC =>
						--curr_if <= ADDI_CW(IF_REG-1 downto ID_REG);
						next_id <= ADDI_CW(ID_REG-1 downto 0);
					when ANDI_OPC => 
						--curr_if <= ANDI_CW(IF_REG-1 downto ID_REG);
						next_id <= ANDI_CW(ID_REG-1 downto 0);
					when SRAI_OPC => 
						--curr_if <= SRAI_CW(IF_REG-1 downto ID_REG);
						next_id <= SRAI_CW(ID_REG-1 downto 0);
					when others =>
						--curr_if <= NOP_CW(IF_REG-1 downto ID_REG);
						next_id <= NOP_CW(ID_REG-1 downto 0);
						flush_if <= '1';
				end case;

			when AUIPC_OPC => 
				--curr_if <= AUIPC_CW(IF_REG-1 downto ID_REG);
				next_id <= AUIPC_CW(ID_REG-1 downto 0);

			when LUI_OPC => 
				--curr_if <= LUI_CW(IF_REG-1 downto ID_REG);
				next_id <= LUI_CW(ID_REG-1 downto 0);

			when BEQ_OPC => 
				--curr_if <= BEQ_CW(IF_REG-1 downto ID_REG);
				next_id <= BEQ_CW(ID_REG-1 downto 0);

			when LW_OPC => 
				--curr_if <= LW_CW(IF_REG-1 downto ID_REG);
				next_id <= LW_CW(ID_REG-1 downto 0);

			when JAL_OPC => 
				--curr_if <= JAL_CW(IF_REG-1 downto ID_REG);
				next_id <= JAL_CW(ID_REG-1 downto 0);

			when SW_OPC => 
				--curr_if <= SW_CW(IF_REG-1 downto ID_REG);
				next_id <= SW_CW(ID_REG-1 downto 0);

			when others =>
				--curr_if <= NOP_CW(IF_REG-1 downto ID_REG);
				next_id <= NOP_CW(ID_REG-1 downto 0);
				flush_if <= '1';
		end case;

		if (exe_taken = '1') then
			flush_jmp <= '1';
		end if;

		if (ifid_stall = '0') then
			next_id <= curr_id;
		end if;
	end process if_stage;

	id_stage: process(curr_id, idexe_stall)
	begin
		id_instr_type_sel <= curr_id(ID_REG-1 downto ID_REG-3);
		if (idexe_stall = '0') then
			next_exe <= curr_exe;
		else
			next_exe <= curr_id(EXE_REG-1 downto 0);
		end if;
	end process id_stage;

	exe_stage: process(curr_exe)
	begin
		exe_a_sel <= curr_exe(EXE_REG-1 downto EXE_REG-2);
		exe_b_sel <= curr_exe(EXE_REG-3 downto EXE_REG-4);
		exe_ctrl <= curr_exe(EXE_REG-5 downto EXE_REG-6);
		exe_log_type <= curr_exe(EXE_REG-7);
		exe_jmp_enable <= curr_exe(EXE_REG-8);
		next_mem <= curr_exe(MEM_REG-1 downto 0);
	end process exe_stage;

	mem_stage: process(curr_mem)
	begin
		ram_wr <= curr_mem(MEM_REG-1);
		next_wb <= curr_mem(WB_REG-1 downto 0);
	end process mem_stage;

	wb_stage: process(curr_wb)
	begin
		wb_en <= curr_wb(WB_REG-1);
		wb_data_sel <= curr_wb(WB_REG-2);
	end process wb_stage;

	stall_unit: process(flush_if, flush_jmp, id_rs1, id_rs2, idexe_rd, exemem_rd, curr_id, rst, exe_taken)
	begin
		cu_ifid_rst <= '1';
		cu_idexe_rst <= '1';
		exemem_rst <= '1';
		memwb_rst <= '1';

		ifid_stall <= '1';
		idexe_stall <= '1';
		exemem_stall <= '1';
		memwb_stall <= '1';

		if (flush_if = '1') then -- unknown instruction has been fetched
			cu_ifid_rst <= '0';
		end if;

		if (flush_jmp = '1') then -- a jump has been taken
			cu_ifid_rst <= '0';
			cu_idexe_rst <= '0';
		end if;

		-- R type: 2 source registers
		-- I type: 1 source register (rs1)
		-- S type: 2 source registers
		-- B type: 2 source registers
		-- U, J: no source registers

		if (curr_id(ID_REG-1 downto ID_REG-3) = R_TYPE or curr_id(ID_REG-1 downto ID_REG-3) = S_TYPE or curr_id(ID_REG-1 downto ID_REG-3) = B_TYPE) then -- instruction uses both registers
			--if ((id_rs1 = idexe_rd or id_rs2 = idexe_rd or id_rs1 = exemem_rd or id_rs2 = exemem_rd) and (idexe_rd /= "00000" or exemem_rd /= "00000")) then
			if (((id_rs1 = idexe_rd and idexe_rd /= "00000") or (id_rs1 = exemem_rd and exemem_rd /= "00000") or (id_rs2 = idexe_rd and idexe_rd /= "00000") or (id_rs2 = exemem_rd and exemem_rd /= "00000")) and exe_taken = '0') then
				ifid_stall <= '0';
				idexe_stall <= '0';
				cu_idexe_rst <= '0'; -- force NOP
			end if;
		elsif (curr_id(ID_REG-1 downto ID_REG-3) = I_TYPE) then
			if (((id_rs1 = idexe_rd and idexe_rd /= "00000") or (id_rs1 = exemem_rd and exemem_rd /= "00000")) and exe_taken = '0') then
				ifid_stall <= '0';
				idexe_stall <= '0';
				cu_idexe_rst <= '0'; -- force NOP
			end if;
		end if;
	end process stall_unit;
end behavioral;
