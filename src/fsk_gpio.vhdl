library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--library OSVVM ;
--    use OSVVM.AlertLogPkg.all;

library work;

entity fsk_gpio is
    port (
        reset_n     : in    std_logic;
        clk         : in    std_logic;
        input       : in    std_logic_vector(1 downto 0);
        enable      : in    std_logic;
        port0       : out   std_logic;
        port1       : out   std_logic;
        port2       : out   std_logic;
        port3       : out   std_logic
    );
end fsk_gpio;

architecture behaviour of fsk_gpio is

-- Constants

-- Signals
	signal output_en    : std_logic := '0';

begin

    port0 <= '1' when (output_en = '1') else '1';
    port1 <= '1' when (output_en = '1') else '0';
    port2 <= '0' when (output_en = '1') else '0';
    port3 <= '0' when (output_en = '1') else '0';

	config : process (reset_n, clk) is
	begin
		if (reset_n = '0') then
			output_en <= '0';
            --Log(ALERTLOG_BASE_ID, "Reset", FINAL);
		elsif rising_edge(clk) then
            --Log(ALERTLOG_BASE_ID, "Rising clk", FINAL);
			if (enable = '1') then
                output_en <= '1';
			end if;
		end if;
	end process config;

	--output : process is
    --begin
    --    if output_en = '1' then
    --        port0 <= '1';
    --        port1 <= '0';
    --        port2 <= '1';
    --        port3 <= '0';
    --    else
    --        port0 <= '0';
    --        port1 <= '0';
    --        port2 <= '0';
    --        port3 <= '0';
    --    end if;
	--end process output;

end architecture behaviour;
