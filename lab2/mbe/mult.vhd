library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mult is
	port (
		a: in std_logic_vector(31 downto 0);
		b: in std_logic_vector(31 downto 0);
		prod: out std_logic_vector(63 downto 0)
	);
end mult;

architecture structural of mult is
	component mbe is
		port (
			b: in std_logic_vector(2 downto 0); -- contains b_2j-1, b_2j and b_2j+1
			a: in std_logic_vector(31 downto 0);
			pj: out std_logic_vector(32 downto 0); -- partial product
			s: out std_logic -- used to perform sign extension
		);
	end component mbe;

	component dadda is
		port (
			pp0: in std_logic_vector(63 downto 0);
			pp1: in std_logic_vector(63 downto 0);
			pp2: in std_logic_vector(63 downto 0);
			pp3: in std_logic_vector(63 downto 0);
			pp4: in std_logic_vector(63 downto 0);
			pp5: in std_logic_vector(63 downto 0);
			pp6: in std_logic_vector(63 downto 0);
			pp7: in std_logic_vector(63 downto 0);
			pp8: in std_logic_vector(63 downto 0);
			pp9: in std_logic_vector(63 downto 0);
			pp10: in std_logic_vector(63 downto 0);
			pp11: in std_logic_vector(63 downto 0);
			pp12: in std_logic_vector(63 downto 0);
			pp13: in std_logic_vector(63 downto 0);
			pp14: in std_logic_vector(63 downto 0);
			pp15: in std_logic_vector(63 downto 0);
			pp16: in std_logic_vector(63 downto 0);
			res: out std_logic_vector(63 downto 0)
		);
	end component dadda;

	type pp_arr is array(0 to 16) of std_logic_vector(63 downto 0);

	signal pp: pp_arr;
	signal s, not_s: std_logic_vector(15 downto 0);
	signal b_ext: std_logic_vector(34 downto 0);
	signal p16: std_logic_vector(32 downto 0);
begin
	-- extend b
	b_ext <= "00"&b&'0';

	-- negate s
	not_s <= not s;

	-- the first and last two cases must be instantiated by hand
	mbe0: mbe
		port map (
		 	b => b_ext(2 downto 0),
		 	a => a,
		 	pj => pp(0)(32 downto 0),
		 	s => s(0)
		 );

	pp(0)(33) <= s(0);
	pp(0)(34) <= s(0);
	pp(0)(35) <= not_s(0);
	pp(1)(0) <= s(0);

	mbe15: mbe 
		port map (
		 	b => b_ext(32 downto 30),
		 	a => a,
		 	pj => pp(15)(62 downto 30),
		 	s => s(15)
		 );

	pp(15)(63) <= not_s(15);
	pp(16)(30) <= s(15);

	mbe16: mbe
		port map (
		 	b => b_ext(34 downto 32),
		 	a => a,
		 	pj => p16,
		 	s => open
		 );

	pp(16)(63 downto 32) <= p16(31 downto 0);	

	-- generate the others partial products
	mbe_gen: for i in 1 to 14 generate
		mbe_i: mbe
			port map (
				b => b((i*2)+1 downto (i*2)-1),
				a => a,
				pj => pp(i)((2*i)+32 downto 2*i),
				s => s(i)
			);

		pp(i)((2*i)+33) <= not_s(i);
		pp(i)((2*i)+34) <= '1';

		--lab: if i /= 1 generate
			--pprova(i)(2*i-3 downto 0) <= (others => '1');
		--end generate lab;
		pp(i+1)(2*i) <= s(i);
	end generate mbe_gen;

	-- Dadda tree

	dadda_tree: dadda
		port map (
			pp0 => pp(0),
			pp1 => pp(1),
			pp2 => pp(2),
			pp3 => pp(3),
			pp4 => pp(4),
			pp5 => pp(5),
			pp6 => pp(6),
			pp7 => pp(7),
			pp8 => pp(8),
			pp9 => pp(9),
			pp10 => pp(10),
			pp11 => pp(11),
			pp12 => pp(12),
			pp13 => pp(13),
			pp14 => pp(14),
			pp15 => pp(15),
			pp16 => pp(16),
			res => prod
		);
	 
end structural;
