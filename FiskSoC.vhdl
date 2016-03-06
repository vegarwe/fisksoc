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

    signal timer0_start         : std_logic;
    signal timer0_cc            : integer_vector(1 downto 0);
    signal timer0_event         : std_logic_vector(1 downto 0);

    signal timed_event          : std_logic := '0';

begin
-- {ALTERA_INSTANTIATION_BEGIN} DO NOT REMOVE THIS LINE!
-- {ALTERA_INSTANTIATION_END} DO NOT REMOVE THIS LINE!

    c_gpio0 : entity work.fsk_gpio
        port map (
            reset_n     => reset_n,
            clk         => clk,
            cnf_load    => gpio1_cnf_load,
            cnf_dir_set => gpio1_cnf_dir_set,
            cnf_out_set => gpio1_cnf_out_set,
            pin_port    => LEDR(0 to 3)
        );

    c_timer0 : entity work.fsk_timer
        port map (
            reset_n     => reset_n,
            clk         => clk,
            start       => timer0_start,
            cc          => timer0_cc,
            event       => timer0_event
        );

    initial : process (reset_n, clk) is
        variable setup : std_logic := '0';
    begin
        if (reset_n = '0') then
            setup := '0';
            timed_event <= '0';
        elsif rising_edge(clk) then
            if (setup = '0') then
                setup := '1';

                gpio1_cnf_load      <= '1';
                gpio1_cnf_dir_set   <= "0010";
                gpio1_cnf_out_set   <= "0010";

                timer0_start <= '1';
                timer0_cc(0) <= 50000000;
            end if;

            if (timer0_event(0) = '1') then
                timed_event <= '1';
            end if;
        end if;
    end process initial;

    clk <= CLOCK_50;
    reset_n <= KEY;
    LEDR(4) <= '1';
    LEDR(5) <= timed_event;
end;

