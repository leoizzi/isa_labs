library ieee;
use ieee.std_logic_1164.all;

package opcodes is
	constant OPC_SIZE 	: integer := 7;
	constant FUN_SIZE 	: integer := 3;

	constant RTYPE_OPC 	: std_logic_vector(OPC_SIZE-1 downto 0) := "0110011";
	constant ADD_OPC 	: std_logic_vector(FUN_SIZE-1 downto 0) := "000";
	constant XOR_OPC 	: std_logic_vector(FUN_SIZE-1 downto 0) := "100";
	constant SLT_OPC 	: std_logic_vector(FUN_SIZE-1 downto 0) := "010";
	constant ABS_OPC 	: std_logic_vector(FUN_SIZE-1 downto 0) := "001"; 

	constant ITYPE_OPC 	: std_logic_vector(OPC_SIZE-1 downto 0) := "0010011"; 
	constant ADDI_OPC 	: std_logic_vector(FUN_SIZE-1 downto 0) := "000";
	constant ANDI_OPC 	: std_logic_vector(FUN_SIZE-1 downto 0) := "111";
	constant SRAI_OPC 	: std_logic_vector(FUN_SIZE-1 downto 0) := "101";

	constant AUIPC_OPC	: std_logic_vector(OPC_SIZE-1 downto 0) := "0010111";
	constant LUI_OPC 	: std_logic_vector(OPC_SIZE-1 downto 0) := "0110111";
	constant BEQ_OPC	: std_logic_vector(OPC_SIZE-1 downto 0) := "1100011";
	constant LW_OPC 	: std_logic_vector(OPC_SIZE-1 downto 0) := "0000011";
	constant JAL_OPC 	: std_logic_vector(OPC_SIZE-1 downto 0) := "1101111";
	constant SW_OPC		: std_logic_vector(OPC_SIZE-1 downto 0) := "0100011";
end package opcodes;
