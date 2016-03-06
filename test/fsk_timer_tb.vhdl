library ieee;
    use ieee.numeric_std.all;
    use ieee.std_logic_1164.all;

library OSVVM ;
    use OSVVM.TbUtilPkg.all;
    use OSVVM.CoveragePkg.all;
    use OSVVM.AlertLogPkg.all;
    use OSVVM.TranscriptPkg.all;

library std;
    use std.env.all;

--  A testbench has no ports.
entity fsk_timer_tb is
end fsk_timer_tb;

architecture behav of fsk_timer_tb is
-- Constants
    constant TB_CLK_PERIOD      : time                          := 50 ns;

-- Signals
    signal clk                  : std_logic                     := '0';
    signal reset_n              : std_logic                     := '0';
    signal timer0_start         : std_logic;
    signal timer0_cc            : integer_vector(1 downto 0);
    signal timer0_event         : std_logic_vector(1 downto 0);

begin
    -- Clock generator:
    clk <= not clk after TB_CLK_PERIOD/2;

    --  Component instantiation.
    c_dut: entity work.fsk_timer
        port map (
            clk         => clk,
            reset_n     => reset_n,
            start       => timer0_start,
            cc          => timer0_cc,
            event       => timer0_event
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
        wait for 30 ns ;

        -- Reset
        wait until rising_edge(clk);
        reset_n <= '0';
        wait until rising_edge(clk);
        reset_n <= '1';
        Log(ALERTLOG_BASE_ID, "deassert reset_n", FINAL);

        -- Verify event is not asserted before starting
        wait until rising_edge(clk);
        assert timer0_event(0) = '0' report "Was not expecting event" severity error;

        -- Start timer wait for event
        timer0_cc(0)    <= 500;
        timer0_start    <= '1';
        wait until rising_edge(clk);
        wait until timer0_event(0) = '1' for 10000 ms;
        assert timer0_event(0) = '1' report "Was expecting event" severity error;

        wait until rising_edge(clk);
        Log(ALERTLOG_BASE_ID, "TCR-done", FINAL);

        TranscriptClose;
        std.env.stop(0);
        wait;
    end process;
end behav;
