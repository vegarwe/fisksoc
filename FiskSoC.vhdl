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
    signal clk                  : std_logic;
    signal reset_n              : std_logic;
    signal gpio1_cnf_load       : std_logic;
    signal gpio1_cnf_dir_set    : std_logic_vector(3 downto 0);
    signal gpio1_cnf_out_set    : std_logic_vector(3 downto 0);
    signal gpio1_pin_port       : std_logic_vector(3 downto 0);

begin
-- {ALTERA_INSTANTIATION_BEGIN} DO NOT REMOVE THIS LINE!
-- {ALTERA_INSTANTIATION_END} DO NOT REMOVE THIS LINE!

    c_gpio1 : entity work.fsk_gpio
    port map (
        reset_n     => reset_n,
        clk         => clk,
        cnf_load    => gpio1_cnf_load,
        cnf_dir_set => gpio1_cnf_dir_set,
        cnf_out_set => gpio1_cnf_out_set,
        pin_port    => LEDR(0 to 3)
    );

    c_timer1 : entity work.fsk_timer
    port map (
        reset_n     => reset_n,
        clk         => clk
    );

    initial : process (reset_n, clk) is
        variable setup : std_logic := '0';
    begin
        if (reset_n = '0') then
            setup := '0';
        elsif rising_edge(clk) then
            if (setup = '0') then
                setup := '1';
                gpio1_cnf_load      <= '1';
                gpio1_cnf_dir_set   <= "0010";
                gpio1_cnf_out_set   <= "0010";
            end if;
        end if;
    end process initial;

    clk <= CLOCK_50;
    reset_n <= KEY;
end;

