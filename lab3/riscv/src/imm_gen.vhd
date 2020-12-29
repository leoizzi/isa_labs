library ieee;
use ieee.std_logic_1164.all;
use work.constants.all;


entity imm_gen is
	port(
		instr: in std_logic_vector(31 downto 0);
		instr_type_sel: in std_logic_vector(2 downto 0);
		imm_out: out std_logic_vector(31 downto 0)
		);
end imm_gen;

architecture beh of imm_gen is

	constant zeros: std_logic_vector(11 downto 0) := (others => '0');

	signal msb: std_logic_vector(19 downto 0);

begin
	
	msb <= (others => instr(31));

	imm_out <= 	msb(19 downto 0)&instr(31 downto 20) when instr_type_sel = I_TYPE else
				msb(19 downto 0)&instr(31 downto 25)&instr(11 downto 7) when instr_type_sel = S_TYPE else
				msb(19 downto 0)&instr(31)&instr(7)&instr(30 downto 25)&instr(11 downto 8) when instr_type_sel = B_TYPE else
				instr(31 downto 12)&zeros when instr_type_sel = U_TYPE else
				msb(11 downto 0)&instr(31)&instr(19 downto 12)&instr(20)&instr(30 downto 21) when instr_type_sel = J_TYPE else
				(others => '0');


end beh;
