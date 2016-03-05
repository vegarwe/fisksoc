library ieee;
    use ieee.numeric_std.all;
    use ieee.std_logic_1164.all;

library OSVVM ;
    use OSVVM.TbUtilPkg.all;
    use OSVVM.CoveragePkg.all;
    use OSVVM.AlertLogPkg.all;
    use OSVVM.TranscriptPkg.all;

library std;
    use std.textio.all;
    use std.env.all;

--  A testbench has no ports.
entity fsk_gpio_tb is
end fsk_gpio_tb;

architecture behav of fsk_gpio_tb is
    constant TB_CLK_PERIOD  : time  := 50 ns;

    signal clk      : std_logic := '0';
    signal reset_n  : std_logic := '1';
    signal port0    : std_logic := '0';
    signal port1    : std_logic := '0';
    signal port2    : std_logic := '0';
    signal port3    : std_logic := '0';
begin
    -- Clock generator:
    clk <= not clk after TB_CLK_PERIOD/2;

    --  Component instantiation.
    c_dut: entity work.fsk_gpio
        port map (
          clk       => clk,
          reset_n   => reset_n,
          port0     => port0,
          port1     => port1,
          port2     => port2,
          port3     => port3
        );

    process
    begin
        TranscriptOpen("transript");
        SetTranscriptMirror;
        SetAlertLogJustify;
        SetLogEnable(AlertLogId => ALERTLOG_BASE_ID, Level => DEBUG,  Enable => TRUE, DescendHierarchy => TRUE);
        SetLogEnable(AlertLogId => ALERTLOG_BASE_ID, Level => INFO ,  Enable => TRUE, DescendHierarchy => TRUE);
        SetLogEnable(AlertLogId => ALERTLOG_BASE_ID, Level => FINAL,  Enable => TRUE, DescendHierarchy => TRUE);
        SetLogEnable(AlertLogId => ALERTLOG_BASE_ID, Level => PASSED, Enable => TRUE, DescendHierarchy => TRUE);

        Log(ALERTLOG_BASE_ID, "TCR-start", FINAL);
        wait for 1 us ;

        -- Reset
        wait until rising_edge(clk);
        reset_n <= '1';
        wait until rising_edge(clk);
        reset_n <= '0';


        Log(ALERTLOG_BASE_ID, "TCR-done", FINAL);

        TranscriptClose;
        std.env.stop(0);
        wait;
    end process;
end behav;
