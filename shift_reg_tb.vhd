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
    signal data_in2  : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal data_out1 : STD_LOGIC_VECTOR(7 downto 0);
    signal data_out2 : STD_LOGIC_VECTOR(7 downto 0);

    constant clk_period : time := 10 ns;
begin
    uut: entity work.ShiftRegister
        Port map (
            clk => clk,
            reset => reset,
            load => load,
            enable => enable,
            data_in  => data_in,
            data_in2  => data_in2,
            data_out1 => data_out1,
            data_out2 => data_out2
        );

    clk_process : process
    begin
        while True loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    stim_proc: process
    begin
        -- Testare reset
        reset <= '1';
        wait for clk_period;
        reset <= '0';
        wait for clk_period;
        
        -- Introducem o valoare în registru
        data_in <= "10101011";
        data_in2 <= "01101011";
        load <= '1';
        wait for clk_period;
        load <= '0';
        wait for clk_period;

        -- Activam shiftarea la dreapta
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

