library ieee;
use ieee.std_logic_1164.all;

-- Control signals constants values
package constants is
	-- ID stage
	constant I_TYPE: std_logic_vector(2 downto 0) := "001";
	constant S_TYPE: std_logic_vector(2 downto 0) := "010";
	constant B_TYPE: std_logic_vector(2 downto 0) := "011";
	constant U_TYPE: std_logic_vector(2 downto 0) := "100";
	constant J_TYPE: std_logic_vector(2 downto 0) := "101";
	
	-- EXE stage
	constant ADD_CTRL : std_logic_vector(1 downto 0) := "00";
	constant LOG_CTRL : std_logic_vector(1 downto 0) := "01";
	constant SLT_CTRL : std_logic_vector(1 downto 0) := "10";
	constant SHT_CTRL : std_logic_vector(1 downto 0) := "11";

	constant AND_LOG : std_logic := '0';
	constant XOR_LOG : std_logic := '1';

	constant MUX_A_SEL_REG : std_logic := '0';
	constant MUX_A_SEL_NPC : std_logic := '1';

	constant MUX_B_SEL_REG : std_logic := '0';
	constant MUX_B_SEL_IMM : std_logic := '1';

	constant NO_JMP_ENABLE : std_logic := '0';
	constant YES_JMP_ENABLE : std_logic := '1';
end package constants;
