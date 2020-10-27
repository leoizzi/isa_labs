library ieee;
use ieee.std_logic_1164.all;

entity iir is
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
		vout: out std_logic;
		dout: out std_logic_vector(11 downto 0)
	);
end iir;

architecture structural of iir is
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

	type arr_2x12 is array (0 to 1) of std_logic_vector(11 downto 0);
	type arr_3x12 is array (0 to 2) of std_logic_vector(11 downto 0);
	type arr_3x1 is array (0 to 2) of std_logic_vector(0 downto 0);

	-- feed-back signals
	signal fb: std_logic_vector(11 downto 0);
	signal mul_fb: arr_2x12;

	-- feed-forward signals
	signal mul_ff: arr_3x12;
	signal ff: std_logic_vector(11 downto 0);

	-- registers signals
	signal sw: arr_3x12;
	signal vin_s: arr_3x1;
	signal a_s: arr_2x12;
	signal b_s: arr_3x12;
	signal a: arr_2x12;
	signal b: arr_3x12;
	signal x_s, y: std_logic_vector(11 downto 0);


begin
	-- registers instantiation
	x_reg: reg
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

	vin_reg: reg
		generic map (
			N => 1
		)
		port map (
			clk => clk,
			rst_n => rst_n,
			en => vin,
			d(0) => vin,
			q => vin_s(0)
		);

	a(0) <= a1;
	a(1) <= a2;
	b(0) <= b0;
	b(1) <= b1;
	b(2) <= b2;

	reg_gen : for i in 0 to 1 generate
		ai_reg: reg
			generic map (
				N => 12
			)
			port map (
				clk => clk,
				rst_n => rst_n,
				en => vin,
				d => a(i),
				q => a_s(i)
			);

		bi_reg: reg
			generic map (
				N => 12
			)
			port map (
				clk => clk,
				rst_n => rst_n,
				en => vin,
				d => b(i),
				q => b_s(i)
			);

		swi_reg: reg
			generic map (
				N => 12
			)
			port map (
				clk => clk,
				rst_n => rst_n,
				en => vin,
				d => sw(i),
				q => sw(i+1)
			);

		vini_reg: reg
			generic map (
				N => 1
			)
			port map (
				clk => clk,
				rst_n => rst_n,
				en => vin_s(i)(0),
				d => vin_s(i),
				q => vin_s(i+1)
			);
	end generate reg_gen;

	b2_reg: reg
		generic map (
			N => 12
		)
		port map (
			clk => clk,
			rst_n => rst_n,
			en => vin,
			d => b(2),
			q => b_s(2)
		);

	vout <= vin_s(2)(0);

	-- feed-back network
	fb_gen : for i in 0 to 1 generate
		mul_fb_i: multiplier
			generic map (
				N => 12
			)
			port map (
				a => a_s(i),
				b => sw(i+1),
				res => mul_fb(i)
			);
	end generate fb_gen;

	sub_fb: subtractor
		generic map (
			N => 12
		)
		port map (
			a => mul_fb(0),
			b => mul_fb(1),
			sub => fb
		);

	add_fb: adder
		generic map (
			N => 12
		)
		port map (
			a => fb,
			b => x_s,
			sum => sw(0)
		);

	-- feed-forward network
	ff_gen : for i in 0 to 2 generate
		mul_ff_i: multiplier
			generic map (
				N => 12
			)
			port map (
				a => b_s(i),
				b => sw(i),
				res => mul_ff(i)
			);
	end generate ff_gen;

	add_ff_1: adder
		generic map (
			N => 12
		)
		port map (
			a => mul_ff(1),
			b => mul_ff(2),
			sum => ff
		);

	add_ff_2: adder
		generic map (
			N => 12
		)
		port map (
			a => ff,
			b => mul_ff(0),
			sum => y
		);

	-- output register

	y_reg: reg
		generic map (
			N => 12
		)
		port map (
			clk => clk,
			rst_n => rst_n,
			en => vin_s(2)(0),
			d => y,
			q => dout
		);
end structural;
