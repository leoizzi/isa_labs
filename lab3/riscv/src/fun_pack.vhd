library ieee;
use ieee.math_real.all;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

package fun_pack is
	-- compute the number of bits needed to encode a generic N
	function n_width (
		n: integer
	) return integer;
end package fun_pack;

package body fun_pack is 
	function n_width (
		n: integer
	) return integer is
	begin
		return integer(ceil(log2(real(n))));
	end function n_width;
end package body fun_pack;