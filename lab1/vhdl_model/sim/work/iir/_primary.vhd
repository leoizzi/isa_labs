library verilog;
use verilog.vl_types.all;
entity iir is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        vin             : in     vl_logic;
        din             : in     vl_logic_vector(11 downto 0);
        b0              : in     vl_logic_vector(11 downto 0);
        b1              : in     vl_logic_vector(11 downto 0);
        b2              : in     vl_logic_vector(11 downto 0);
        a1              : in     vl_logic_vector(11 downto 0);
        a2              : in     vl_logic_vector(11 downto 0);
        vout            : out    vl_logic;
        dout            : out    vl_logic_vector(11 downto 0)
    );
end iir;
