library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ShiftRegister_tb is
end ShiftRegister_tb;

architecture Behavioral of ShiftRegister_tb is
    signal clk      : STD_LOGIC := '0';
    signal reset    : STD_LOGIC := '0';
    signal load     : STD_LOGIC := '0';
    signal enable   : STD_LOGIC := '0';
    signal data_in  : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal data_out : STD_LOGIC_VECTOR(7 downto 0);

    constant clk_period : time := 10 ns;
begin
    -- Instan?ierea direct? a entit??ii ShiftRegister
    uut: entity work.ShiftRegister
        Port map (
            clk => clk,
            reset => reset,
            load => load,
            enable => enable,
            data_in  => data_in,
            data_out => data_out
        );

    -- Proces pentru generarea semnalului de ceas
    clk_process : process
    begin
        while True loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Proces pentru generarea semnalelor de test
    stim_proc: process
    begin
        -- Testare reset
        reset <= '1';
        wait for clk_period;
        reset <= '0';
        wait for clk_period;
        
        -- Introducem o valoare în registru
        data_in <= "10101010";
        load <= '1';
        wait for clk_period;
        load <= '0';
        wait for clk_period;

        -- Activ?m shiftarea la dreapta
        enable <= '1';
        
        -- Continu?m shiftarea la dreapta pentru câteva cicluri de ceas
        wait for clk_period;
        wait for clk_period;
        wait for clk_period;

        -- Reset?m registrul pentru a verifica resetarea din nou
        reset <= '1';
        wait for clk_period;
        reset <= '0';
        
        -- Oprim simularea
        wait;
    end process;
end Behavioral;

