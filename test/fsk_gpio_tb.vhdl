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
entity fsk_gpio_tb is
end fsk_gpio_tb;

architecture behav of fsk_gpio_tb is
-- Constants
    constant TB_CLK_PERIOD  : time                          := 50 ns;

-- Signals
    signal clk              : std_logic                     := '0';
    signal reset_n          : std_logic                     := '1';
    signal gpio1_input      : std_logic_vector(1 downto 0)  := "00";
    signal gpio1_enable     : std_logic                     := '0';
    signal gpio1_port0      : std_logic                     := '0';
    signal gpio1_port1      : std_logic                     := '0';
    signal gpio1_port2      : std_logic                     := '0';
    signal gpio1_port3      : std_logic                     := '0';

begin
    -- Clock generator:
    clk <= not clk after TB_CLK_PERIOD/2;

    --  Component instantiation.
    c_dut: entity work.fsk_gpio
        port map (
          clk       => clk,
          reset_n   => reset_n,
          input     => gpio1_input,
          enable    => gpio1_enable,
          port0     => gpio1_port0,
          port1     => gpio1_port1,
          port2     => gpio1_port2,
          port3     => gpio1_port3
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
        Log(ALERTLOG_BASE_ID, "assert reset", FINAL);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        reset_n <= '0';
        Log(ALERTLOG_BASE_ID, "deassert reset", FINAL);
        wait until rising_edge(clk);

        wait until rising_edge(clk);
        assert gpio1_port0 = '0' report "Output ports not enabled" severity error;
        assert gpio1_port1 = '0' report "Output ports not enabled" severity error;
        assert gpio1_port2 = '0' report "Output ports not enabled" severity error;
        assert gpio1_port3 = '0' report "Output ports not enabled" severity error;

        gpio1_enable <= '1';
        Log(ALERTLOG_BASE_ID, "assert gpio1_enable", FINAL);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        gpio1_enable <= '0';
        Log(ALERTLOG_BASE_ID, "deassert gpio1_enable", FINAL);
        --assert gpio1_port0 = '1' report "Output ports should be enabled" severity error;
        --assert gpio1_port1 = '1' report "Output ports should be enabled" severity error;
        --assert gpio1_port2 = '0' report "Output ports should be enabled" severity error;
        --assert gpio1_port3 = '0' report "Output ports should be enabled" severity error;

        wait until rising_edge(clk);
        Log(ALERTLOG_BASE_ID, "TCR-done", FINAL);

        TranscriptClose;
        std.env.stop(0);
        wait;
    end process;
end behav;
