library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BoothControl_tb is
end BoothControl_tb;

architecture Behavioral of BoothControl_tb is
    signal clk       : STD_LOGIC := '0';
    signal reset     : STD_LOGIC := '0';
    signal start     : STD_LOGIC := '0';
    signal q_0       : STD_LOGIC := '0';
    signal q_minus_1 : STD_LOGIC := '0';
    signal done      : STD_LOGIC;
    signal alu_op    : STD_LOGIC;
    signal shift     : STD_LOGIC;

    constant clk_period : time := 10 ns;

begin
    uut: entity work.BoothControl
        port map (
            clk       => clk,
            reset     => reset,
            start     => start,
            q_0       => q_0,
            q_minus_1 => q_minus_1,
            done      => done,
            alu_op    => alu_op,
            shift     => shift
        );

    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    stimuli_process: process
    begin
        reset <= '1';
        wait for clk_period;
        reset <= '0';

        -- Test 1: Pornire cu semnal start
        start <= '1';
        wait for clk_period;
        start <= '0';

        -- Verificare tranzi?ie c?tre starea `Load`
        wait for clk_period;
        assert (done = '0' and alu_op = '0' and shift = '0') 
        report "Error: Unexpected output in Load state!" severity error;

        -- Test 2: Simulare AddSub
        q_0 <= '0';
        q_minus_1 <= '1'; -- Adunare
        wait for clk_period;
        assert (alu_op = '0') report "Error: ALU operation should be addition!" severity error;

        wait for clk_period;
        q_0 <= '1';
        q_minus_1 <= '0'; -- Scadere
        wait for clk_period;
        assert (alu_op = '1') report "Error: ALU operation should be subtraction!" severity error;

        -- Test 3: Simulare RShift
        wait for clk_period;
        assert (shift = '1') report "Error: Shift signal not asserted in RShift!" severity error;

        -- Test 4: Simulare Check
        wait for clk_period;
        wait for clk_period;
        assert (done = '1') report "Error: Done signal not asserted in Output state!" severity error;

        wait;
    end process;
end Behavioral;
