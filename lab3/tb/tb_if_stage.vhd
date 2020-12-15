library ieee;
use ieee.std_logic_1164.all;

entity tb_if_stage is
end tb_if_stage;

architecture tb of tb_if_stage is

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
			pc: out std_logic_vector(N-1 downto 0);
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

	constant N: integer := 32;
	constant A: integer := 5;
	constant W: integer := 32;
	constant F: string := "C:\Users\Nicole\Desktop\Vivado\if_stage\if_stage.srcs\sim_1\new\samples.txt";

	constant period: time := 10 ns;

	signal clk, rst: std_logic;

	-- internal signals
	signal instr_int, pc_int, npc_int, address_int: std_logic_vector(N-1 downto 0);

	-- signals coming from the CU
	signal target_pc: std_logic_vector(N-1 downto 0);
	signal pc_sel, pc_en, pc_reg_en, npc_reg_en, instr_reg_en: std_logic;

	-- signals going to the id stage
	signal pc_id, npc_id, instr_id: std_logic_vector(N-1 downto 0);

begin

	if_stg: if_stage
		generic map (
			N => N
		)
		port map (
			clk => clk,
			rst => rst,
			target_pc => target_pc,
			pc_sel => pc_sel,
			pc_en => pc_en,
			address => address_int,
			pc => pc_int,
			npc => npc_int
		);

	regs: if_id_regs
		port map(
			clk => clk,
			rst => rst,
			pc_in => pc_int,
			npc_in => npc_int,
			instr_in => instr_int,
			pc_reg_en => pc_reg_en,
			npc_reg_en => npc_reg_en,
			instr_reg_en => instr_reg_en,
			pc_out => pc_id,
			npc_out => npc_id,
			instr_out => instr_id
	);

	irom: rom
		generic map (
			N => N,
			A => A,
			W  => W,
			F => F
		)
		port map (
			rst => rst,
			address => address_int(A+1 downto 2),
			data => instr_int
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


		target_pc <= X"55555555";
		pc_sel <= '0'; -- select the PC+4
		pc_en <= '1';
		pc_reg_en <= '1';
		npc_reg_en <= '1';
		instr_reg_en <= '1';

		wait_loop : for i in 0 to 5 loop
			wait for period;
		end loop wait_loop;

		target_pc <= X"00000028"; -- jump to the 10th instruction
		pc_sel <= '1'; -- select the target address instead of the PC+4
		wait for period;
		pc_sel <= '0';
		
		wait_loop2 : for i in 0 to 5 loop
			wait for period;
		end loop wait_loop2;

		wait;
	end process test_p;

end tb;
