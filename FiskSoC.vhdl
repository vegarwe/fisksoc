library ieee;
use ieee.std_logic_1164.all;
library altera;
use altera.altera_syn_attributes.all;

entity FiskSoC is
    port
    (
-- {ALTERA_IO_BEGIN} DO NOT REMOVE THIS LINE!

        CLOCK_50 : in std_logic;
        KEY : in std_logic;
        LEDR : out std_logic_vector(0 to 7)
-- {ALTERA_IO_END} DO NOT REMOVE THIS LINE!

    );

-- {ALTERA_ATTRIBUTE_BEGIN} DO NOT REMOVE THIS LINE!
-- {ALTERA_ATTRIBUTE_END} DO NOT REMOVE THIS LINE!
end FiskSoC;

architecture ppl_type of FiskSoC is

-- {ALTERA_COMPONENTS_BEGIN} DO NOT REMOVE THIS LINE!
-- {ALTERA_COMPONENTS_END} DO NOT REMOVE THIS LINE!

-- Constants

-- Signals
    signal clk          : std_logic;
    signal reset_n      : std_logic;
    signal gpio1_input  : std_logic_vector(1 downto 0)  := "00";
    signal gpio1_enable : std_logic                     := '0';

begin
-- {ALTERA_INSTANTIATION_BEGIN} DO NOT REMOVE THIS LINE!
-- {ALTERA_INSTANTIATION_END} DO NOT REMOVE THIS LINE!

    c_gpio1 : entity work.fsk_gpio
    port map (
        reset_n     => reset_n,
        clk         => clk,
        input       => gpio1_input,
        enable      => gpio1_enable,
        port0       => LEDR(0),
        port1       => LEDR(1),
        port2       => LEDR(2),
        port3       => LEDR(3)
    );

    c_timer1 : entity work.fsk_timer
    port map (
        reset_n     => reset_n,
        clk         => clk
    );

    clk <= CLOCK_50;
    reset_n <= KEY;
end;

