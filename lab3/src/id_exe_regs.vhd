library ieee;
use ieee.std_logic_1164.all;

-- ID/EXE pipeline registers
entity id_exe_regs is
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
end id_exe_regs;

architecture behavioral of id_exe_regs is
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
begin
	pc_reg: reg_en
		generic map (
			N => 32
		)
		port map (
			d => pc_in,
			en => pc_reg_en,
			clk => clk,
			rst => rst,
			q => pc_out
		);

	npc_reg: reg_en
		generic map (
			N => 32
		)
		port map (
			d => npc_in,
			en => npc_reg_en,
			clk => clk,
			rst => rst,
			q => npc_out
		);

	a_reg: reg_en
	generic map (
		N => 32
	)
	port map (
		d => a_in,
		en => a_en,
		clk => clk,
		rst => rst,
		q => a_out
	);

	b_reg: reg_en
		generic map (
			N => 32
		)
		port map (
			d => b_in,
			en => b_en,
			clk => clk,
			rst => rst,
			q => b_out
		);

	imm_reg: reg_en
		generic map (
			N => 32
		)
		port map (
			d => imm_in,
			en => imm_en,
			clk => clk,
			rst => rst,
			q => imm_out
		);

	rd_reg: reg_en
		generic map (
			N => 5
		)
		port map (
			d => rd_in,
			en => rd_en,
			clk => clk,
			rst => rst,
			q => rd_out
		);
end behavioral;
