library ieee;
use ieee.std_logic_1164.all;

-- Control signals constants values
package constants is
	-- IF stage
	constant PC_DIS : std_logic := '0'; 
	constant PC_EN : std_logic := '1';

	-- IF/ID
	constant IFID_DIS : std_logic := '0'; 
	constant IFID_EN : std_logic := '1'; 

	-- ID stage
	constant I_TYPE: std_logic_vector(2 downto 0) := "001";
	constant S_TYPE: std_logic_vector(2 downto 0) := "010";
	constant B_TYPE: std_logic_vector(2 downto 0) := "011";
	constant U_TYPE: std_logic_vector(2 downto 0) := "100";
	constant J_TYPE: std_logic_vector(2 downto 0) := "101";

	-- ID/EXE
	constant IDEXE_DIS : std_logic := '0';
	constant IDEXE_EN : std_logic := '1';  
	
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

	constant JMP_DIS : std_logic := '0';
	constant JMP_EN : std_logic := '1';

	-- EXE/MEM
	constant EXEMEM_DIS : std_logic := '0';
	constant EXEMEM_EN : std_logic := '1';  

	-- MEM stage
	constant RAM_R : std_logic := '0';
	constant RAM_W : std_logic := '1';

	-- MEM/WB
	constant MEMWB_DIS : std_logic := '0';
	constant MEMWB_EN : std_logic := '1';    

	-- WB stage
	constant WB_DIS : std_logic := '0';
	constant WB_EN : std_logic := '1';

	constant SEL_ALU : std_logic := '0';
	constant SEL_MEM : std_logic := '1';    
end package constants;
