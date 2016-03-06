library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

library work;

entity fsk_timer is
    port (
        reset_n     : in    std_logic;
        clk         : in    std_logic;
        start       : in    std_logic;
        cc          : inout integer_vector(1 downto 0);
        event       : out   std_logic_vector(1 downto 0)    := "00"
    );
end fsk_timer;

architecture behaviour of fsk_timer is

-- Constants

-- Signals

begin
    tick : process (reset_n, clk) is
        variable count : integer := 0; -- TODO(vw): Switch to unsigned int
    begin
        if (reset_n = '0') then
            -- TODO
        elsif rising_edge(clk) then
            if (cc(0) = count) then
                event(0) <= '1';
            else
                event(0) <= '0';
            end if;
            count := count + 1;
        end if;
    end process tick;

end architecture behaviour;
