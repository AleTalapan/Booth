library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU_tb is
end ALU_tb;

architecture sim of ALU_tb is
    signal clk      : std_logic := '0';
    signal A, M     : std_logic_vector(7 downto 0) := (others => '0');
    signal control  : std_logic;
    signal result   : std_logic_vector(7 downto 0);

    -- Frecven?a semnalului de ceas (perioad? de 50 ns => frecven?? de 20 MHz)
    constant clk_period : time := 50 ns;

begin
   uut: entity work.ALU port map (
        clk => clk,
        A => A,
        M => M,
        control => control,
        result => result
    );

    clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process clk_process;

    stim_proc: process
    begin
        A <= "00000010"; M <= "00000001"; control <= '0'; 
        wait for 2*clk_period;
        
        assert result = "00000011"
        report "Adunare incorect?!" severity error;

        A <= "00000010"; M <= "00000001"; control <= '1'; 
        wait for 2*clk_period;
        
        assert result = "00000001"
        report "Sc?dere incorect?!" severity error;

        wait;
    end process stim_proc;

end sim;
