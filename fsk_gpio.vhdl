library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;

entity fsk_gpio is
    port (
        reset_n     : in    std_logic;
        clk         : in    std_logic;
        port0       : out   std_logic;
        port1       : out   std_logic;
        port2       : out   std_logic;
        port3       : out   std_logic
    );
end fsk_gpio;

architecture struct of fsk_gpio is

-- Constants

-- Signals

begin

    port0 <= '1';
    port1 <= '0';
    port2 <= '1';
    port3 <= '0';

end architecture struct;
