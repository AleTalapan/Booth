library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BoothMultiplier_tb is
end BoothMultiplier_tb;

architecture Behavioral of BoothMultiplier_tb is
    signal clk            : STD_LOGIC := '0';
    signal reset          : STD_LOGIC := '0';
    signal start          : STD_LOGIC := '0';
    signal multiplicand   : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal multiplier     : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal done           : STD_LOGIC;
    signal product        : STD_LOGIC_VECTOR(15 downto 0);

    constant clk_period : time := 10 ns;

begin
    -- Instantiate the BoothMultiplier Unit Under Test (UUT)
    uut: entity work.BoothMultiplier
        Port map (
            clk            => clk,
            reset          => reset,
            start          => start,
            multiplicand   => multiplicand,
            multiplier     => multiplier,
            done           => done,
            product        => product
        );

    -- Clock generation process
    clk_process : process
    begin
        while True loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Test: Multiply 3 x 2
        reset <= '1';
        wait for clk_period;
        reset <= '0';
        
        multiplicand <= "10000001"; -- 7
        multiplier <= "00000010";   -- 2
        start <= '1';
        wait for clk_period;
        start <= '0';

        wait until done = '1';
        assert product = "0001000000001110" -- Expected result: 6
        report "Test failed " severity error;

        -- Simulation complete
        wait;
    end process;

end Behavioral;

