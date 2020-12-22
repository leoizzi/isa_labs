library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;

entity tb_imm_gen is
end tb_imm_gen;

architecture tb of tb_imm_gen is
	
	component imm_gen is
		port (
			instr: in std_logic_vector(31 downto 0);
			instr_type_sel: in std_logic_vector(2 downto 0);
			imm_out: out std_logic_vector(31 downto 0)
		);
	end component imm_gen;

	signal instr, imm_out: std_logic_vector(31 downto 0);
	signal instr_type_sel: std_logic_vector(2 downto 0);

	constant period: time := 10 ns;

begin

	dut: imm_gen
		port map (
			instr => instr,
			instr_type_sel => instr_type_sel,
			imm_out => imm_out
		);

	test_p: process
	begin
		instr <= X"00700813"; -- addi
		instr_type_sel <= I_type;
		wait for period;

		instr <= X"0fc10217"; -- auipc 
		instr_type_sel <= U_type;
		wait for period;
		
		instr <= X"ffc20213"; -- addi
		instr_type_sel <= I_type;
		wait for period;
		
		instr <= X"0fc10297"; -- auipc
		instr_type_sel <= U_type;
		wait for period;
		
		instr <= X"01028293"; -- addi
		instr_type_sel <= I_type;
		wait for period;
		
		instr <= X"400006b7"; -- lui
		instr_type_sel <= U_type;
		wait for period;
		
		instr <= X"fff68693"; -- addi
		instr_type_sel <= I_type;
		wait for period;
		
		instr <= X"41f45493"; -- srai
		instr_type_sel <= I_type;
		wait for period;
		
		instr <= X"0014f493"; -- andi
		instr_type_sel <= I_type;
		wait for period;
		
		instr <= X"00420213"; -- addi
		instr_type_sel <= I_type;
		wait for period;

		instr <= X"00d2a023"; -- sw
		instr_type_sel <= S_type;
		wait for period;

		instr <= X"02080863"; -- beq
		instr_type_sel <= B_type;
		wait for period;

		instr <= X"fd5ff0ef"; -- jal
		instr_type_sel <= J_type;
		wait for period;

		instr <= X"000000ef"; -- jal
		instr_type_sel <= J_type;
		wait for period;

		wait;
	end process test_p;

end tb;
