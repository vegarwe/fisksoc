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
    signal clk                  : std_logic                     := '0';
    signal reset_n              : std_logic                     := '0';
    signal gpio1_cnf_load       : std_logic;
    signal gpio1_cnf_dir_set    : std_logic_vector(3 downto 0);
    signal gpio1_cnf_out_set    : std_logic_vector(3 downto 0);
    signal gpio1_pin            : std_logic_vector(3 downto 0)  := "0000";

begin
    -- Clock generator:
    clk <= not clk after TB_CLK_PERIOD/2;

    --  Component instantiation.
    c_dut: entity work.fsk_gpio
        port map (
          clk           => clk,
          reset_n       => reset_n,
          cnf_load      => gpio1_cnf_load,
          cnf_dir_set   => gpio1_cnf_dir_set,
          cnf_out_set   => gpio1_cnf_out_set,
          pin_port      => gpio1_pin
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

        -- Verify all zeroes when all are input's
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        assert gpio1_pin(0) = '0' report "Output ports not enabled" severity error;
        assert gpio1_pin(1) = '0' report "Output ports not enabled" severity error;
        assert gpio1_pin(2) = '0' report "Output ports not enabled" severity error;
        assert gpio1_pin(3) = '0' report "Output ports not enabled" severity error;

        -- Verify all zeroes even when trying to set as long as all are input's
        gpio1_cnf_out_set   <= "1111";
        wait until rising_edge(clk);
        gpio1_cnf_out_set   <= "0000";
        wait until rising_edge(clk);
        assert gpio1_pin(0) = '0' report "Output ports should be enabled" severity error;
        assert gpio1_pin(1) = '0' report "Output ports should be enabled" severity error;
        assert gpio1_pin(2) = '0' report "Output ports should be enabled" severity error;
        assert gpio1_pin(3) = '0' report "Output ports should be enabled" severity error;

        -- Verify still zero after setting one port to output
        gpio1_cnf_load      <= '1';
        gpio1_cnf_dir_set   <= "0001";
        wait until rising_edge(clk);
        gpio1_cnf_load      <= '0';
        gpio1_cnf_dir_set   <= "0000";
        wait until rising_edge(clk);
        assert gpio1_pin(0) = '0' report "Output ports should be enabled" severity error;
        assert gpio1_pin(1) = '0' report "Output ports should be enabled" severity error;
        assert gpio1_pin(2) = '0' report "Output ports should be enabled" severity error;
        assert gpio1_pin(3) = '0' report "Output ports should be enabled" severity error;

        -- Verify one high after setting one port to output and high
        gpio1_cnf_out_set   <= "0001";
        wait until rising_edge(clk);
        gpio1_cnf_out_set   <= "0000";
        wait until rising_edge(clk);
        assert gpio1_pin(0) = '1' report "Output ports should be enabled" severity error;
        assert gpio1_pin(1) = '0' report "Output ports should be enabled" severity error;
        assert gpio1_pin(2) = '0' report "Output ports should be enabled" severity error;
        assert gpio1_pin(3) = '0' report "Output ports should be enabled" severity error;

        -- Verify all high after setting all to output and high
        gpio1_cnf_load      <= '1';
        gpio1_cnf_dir_set   <= "1111";
        gpio1_cnf_out_set   <= "1111";
        wait until rising_edge(clk);
        gpio1_cnf_load      <= '0';
        gpio1_cnf_dir_set   <= "0000";
        gpio1_cnf_out_set   <= "0000";
        wait until rising_edge(clk);
        assert gpio1_pin(0) = '1' report "Output ports should be enabled" severity error;
        assert gpio1_pin(1) = '1' report "Output ports should be enabled" severity error;
        assert gpio1_pin(2) = '1' report "Output ports should be enabled" severity error;
        assert gpio1_pin(3) = '1' report "Output ports should be enabled" severity error;

        wait until rising_edge(clk);
        Log(ALERTLOG_BASE_ID, "TCR-done", FINAL);

        TranscriptClose;
        std.env.stop(0);
        wait;
    end process;
end behav;
