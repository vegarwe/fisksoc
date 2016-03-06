library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity fsk_gpio is
    port (
        reset_n     : in    std_logic;
        clk         : in    std_logic;
        cnf_load    : in    std_logic                       := '0';
        cnf_dir_set : in    std_logic_vector(3 downto 0)    := "0000";
        cnf_out_set : in    std_logic_vector(3 downto 0)    := "0000";
        pin_port    : out   std_logic_vector(3 downto 0)
    );
end fsk_gpio;

architecture behaviour of fsk_gpio is

-- Constants

-- Signals
    signal port_cnf : std_logic_vector(3 downto 0)  := "0000";
    signal port_out : std_logic_vector(3 downto 0)  := "0000";

begin

    pin_port(0) <= port_out(0) when (port_cnf(0) = '1') else '0';
    pin_port(1) <= port_out(1) when (port_cnf(1) = '1') else '0';
    pin_port(2) <= port_out(2) when (port_cnf(2) = '1') else '0';
    pin_port(3) <= port_out(3) when (port_cnf(3) = '1') else '0';

    config : process (reset_n, clk) is
    begin
        if (reset_n = '0') then
            port_cnf <= "0000";
            port_out <= "0000";
        elsif rising_edge(clk) then
            if (cnf_load = '1') then
                port_cnf <= cnf_dir_set;
            end if;
            port_out <= cnf_out_set;
        end if;
    end process config;

end architecture behaviour;
