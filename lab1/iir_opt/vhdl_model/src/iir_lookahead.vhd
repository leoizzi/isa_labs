library ieee;
use ieee.std_logic_1164.all;

entity iir_lookahead is
	port (
		clk: in std_logic;
		rst_n: in std_logic;
		vin: in std_logic;
		din: in std_logic_vector(11 downto 0);
		b0: in std_logic_vector(11 downto 0);
		b1: in std_logic_vector(11 downto 0);
		b2: in std_logic_vector(11 downto 0);
		a1: in std_logic_vector(11 downto 0);
		a2: in std_logic_vector(11 downto 0);
		a0a1: in std_logic_vector(11 downto 0);
		a1a1: in std_logic_vector(11 downto 0);
		a1a2: in std_logic_vector(11 downto 0);
		a1b0: in std_logic_vector(11 downto 0);
		a1b1: in std_logic_vector(11 downto 0);
		a1b2: in std_logic_vector(11 downto 0);
		vout: out std_logic;
		dout: out std_logic_vector(11 downto 0)
	);
end iir_lookahead;

architecture structural of iir_lookahead is
	component adder is
		generic (
			N: integer := 12
		);
		port (
			a: in std_logic_vector(N-1 downto 0);
			b: in std_logic_vector(N-1 downto 0);
			sum: out std_logic_vector(N-1 downto 0)
		);
	end component adder;

	component subtractor is
		generic (
			N: integer := 12
		);
		port (
			a: in std_logic_vector(N-1 downto 0);
			b: in std_logic_vector(N-1 downto 0);
			sub: out std_logic_vector(N-1 downto 0)
		);
	end component subtractor;

	component multiplier is
		generic (
			N: integer := 12
		);
		port (
			a: in std_logic_vector(N-1 downto 0);
			b: in std_logic_vector(N-1 downto 0);
			res: out std_logic_vector(N-1 downto 0)
		);
	end component multiplier;

	component reg is
		generic (
			N: integer := 12
		);
		port (
			clk: in std_logic;
			rst_n: in std_logic;
			en: in std_logic;
			d: in std_logic_vector(N-1 downto 0);
			q: out std_logic_vector(N-1 downto 0)
		);
	end component reg;

	type fb_mul_arr is array (0 to 3) of std_logic_vector(11 downto 0);
	type sw_arr is array (0 to 3) of std_logic_vector(11 downto 0);
	type fb_add_arr is array (0 to 2) of std_logic_vector(11 downto 0);
	type ff_mul_arr is array (0 to 5) of std_logic_vector(11 downto 0);
	type ff_add_arr is array (0 to 3) of std_logic_vector(11 downto 0);
	type vin_arr is array (0 to 2) of std_logic;

	signal sw: sw_arr;
	signal fb_mul: fb_mul_arr;
	signal fb_add: fb_add_arr;
	signal ff_mul: ff_mul_arr;
	signal ff_add: ff_add_arr;
	signal x_s, y_s: std_logic_vector(11 downto 0);
	signal vin_i: vin_arr;

	signal ret_fb_mul, ret_fb_add: std_logic_vector(11 downto 0); -- output of retiming registers in the feedback network
	signal ret_ff_add: std_logic_vector(11 downto 0); -- output of retiming register in the feed-forward network
	signal pp_ff_mul: ff_mul_arr; -- output of pipelining registers in the feed-forward network
begin
	-- registers instantiation
	xreg: reg
		generic map (
			N => 12
		)
		port map (
			clk => clk,
			rst_n => rst_n,
			en => vin,
			d => din,
			q => x_s
		);

	yreg: reg
		generic map (
			N => 12
		)
		port map (
			clk => clk,
			rst_n => rst_n,
			en => vin_i(1),
			d => y_s,
			q => dout
		);

	vout <= vin_i(2);

	reg1: reg
		generic map (
			N => 12
		)
		port map (
			clk => clk,
			rst_n => rst_n,
			en => vin,
			d => sw(0),
			q => sw(1)
		);

	reg2: reg
		generic map (
			N => 12
		)
		port map (
			clk => clk,
			rst_n => rst_n,
			en => vin,
			d => sw(1),
			q => sw(2)
		);

	vin0_reg: reg
		generic map (
			N => 1
		)
		port map (
			clk => clk,
			rst_n => rst_n,
			en => '1',
			d(0) => vin,
			q(0) => vin_i(0)
		);

	vin1_reg: reg
		generic map (
			N => 1
		)
		port map (
			clk => clk,
			rst_n => rst_n,
			en => '1',
			d(0) => vin_i(0),
			q(0) => vin_i(1)
		);

	vin2_reg: reg
		generic map (
			N => 1
		)
		port map (
			clk => clk,
			rst_n => rst_n,
			en => '1',
			d(0) => vin_i(1),
			q(0) => vin_i(2)
		);

	-- feedback network

	fb_mul0: multiplier
		generic map (
			N => 12
		)
		port map (
			a => sw(0),
			b => a0a1,
			res => fb_mul(0)
		);

	ret_fb_mul_reg: reg
		generic map (
			N => 12
		)
		port map (
			clk => clk,
			rst_n => rst_n,
			en => vin_i(0),
			d => fb_mul(0),
			q => ret_fb_mul
		);

	fb_mul1: multiplier
		generic map (
			N => 12
		)
		port map (
			a => sw(1),
			b => a1a1,
			res => fb_mul(1)
		);

	fb_mul2: multiplier
		generic map (
			N => 12
		)
		port map (
			a => sw(1),
			b => a2,
			res => fb_mul(2)
		);

	fb_mul3: multiplier
		generic map (
			N => 12
		)
		port map (
			a => sw(2),
			b => a1a2,
			res => fb_mul(3)
		);

	fb_sub: subtractor
		generic map (
			N => 12
		)
		port map (
			a => x_s,
			b => fb_add(0),
			sub => sw(0)
		);

	fb_add0: adder
		generic map (
			N => 12
		)
		port map (
			a => ret_fb_mul,
			b => ret_fb_add,
			sum => fb_add(0)
		);

	fb_add1: adder
		generic map (
			N => 12
		)
		port map (
			a => fb_mul(1),
			b => fb_add(2),
			sum => fb_add(1)
		);

	ret_fb_add_reg: reg
		generic map (
			N => 12
		)
		port map (
			clk => clk,
			rst_n => rst_n,
			en => vin_i(0),
			d => fb_add(1),
			q => ret_fb_add
		);

	fb_add2: adder
		generic map (
			N => 12
		)
		port map (
			a => fb_mul(2),
			b => fb_mul(3),
			sum => fb_add(2)
		);

	-- feed-forward network

	pp_ff_mul_reg0: reg
		generic map (
			N => 12
		)
		port map (
			clk => clk,
			rst_n => rst_n,
			en => vin_i(0),
			d => sw(0),
			q => pp_ff_mul(0)
		);

	ff_mul0: multiplier
		generic map (
			N => 12
		)
		port map (
			a => pp_ff_mul(0),
			b => b0,
			res => ff_mul(0)
		);

	pp_ff_mul_reg1: reg
		generic map (
			N => 12
		)
		port map (
			clk => clk,
			rst_n => rst_n,
			en => vin_i(0),
			d => sw(0),
			q => pp_ff_mul(1)
		);

	ff_mul1: multiplier
		generic map (
			N => 12
		)
		port map (
			a => pp_ff_mul(1),
			b => a1b0,
			res => ff_mul(1)
		);

	pp_ff_mul_reg2: reg
		generic map (
			N => 12
		)
		port map (
			clk => clk,
			rst_n => rst_n,
			en => vin_i(0),
			d => sw(0),
			q => pp_ff_mul(2)
		);

	ff_mul2: multiplier
		generic map (
			N => 12
		)
		port map (
			a => pp_ff_mul(2),
			b => b1,
			res => ff_mul(2)
		);

	pp_ff_mul_reg3: reg
		generic map (
			N => 12
		)
		port map (
			clk => clk,
			rst_n => rst_n,
			en => vin_i(0),
			d => sw(1),
			q => pp_ff_mul(3)
		);

	ff_mul3: multiplier
		generic map (
			N => 12
		)
		port map (
			a => pp_ff_mul(3),
			b => a1b1,
			res => ff_mul(3)
		);

	pp_ff_mul_reg4: reg
		generic map (
			N => 12
		)
		port map (
			clk => clk,
			rst_n => rst_n,
			en => vin_i(0),
			d => sw(1),
			q => pp_ff_mul(4)
		);

	ff_mul4: multiplier
		generic map (
			N => 12
		)
		port map (
			a => pp_ff_mul(4),
			b => b2,
			res => ff_mul(4)
		);

	pp_ff_mul_reg5: reg
		generic map (
			N => 12
		)
		port map (
			clk => clk,
			rst_n => rst_n,
			en => vin_i(0),
			d => sw(2),
			q => pp_ff_mul(5)
		);

	ff_mul5: multiplier
		generic map (
			N => 12
		)
		port map (
			a => pp_ff_mul(5),
			b => a1b2,
			res => ff_mul(5)
		);

	ff_add0: adder
		generic map (
			N => 12
		)
		port map (
			a => ff_mul(0),
			b => ret_ff_add,
			sum => y_s
		);

	ff_add1: adder
		generic map (
			N => 12
		)
		port map (
			a => ff_mul(1),
			b => ff_add(1),
			sum => ff_add(0)
		);

	ret_ff_add_reg: reg
		generic map (
			N => 12
		)
		port map (
			clk => clk,
			rst_n => rst_n,
			en => vin_i(0),
			d => ff_add(0),
			q => ret_ff_add
		);

	ff_add2: adder
		generic map (
			N => 12
		)
		port map (
			a => ff_mul(2),
			b => ff_add(2),
			sum => ff_add(1)
		);

	ff_add3: adder
		generic map (
			N => 12
		)
		port map (
			a => ff_mul(3),
			b => ff_add(3),
			sum => ff_add(2)
		);

	ff_add4: adder
		generic map (
			N => 12
		)
		port map (
			a => ff_mul(4),
			b => ff_mul(5),
			sum => ff_add(3)
		);
end structural;
