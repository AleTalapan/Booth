library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU_tb is
end ALU_tb;

architecture sim of ALU_tb is
    signal A, M     : std_logic_vector(7 downto 0) := (others => '0');
    signal control  : std_logic;
    signal result   : std_logic_vector(7 downto 0);

begin
   uut: entity work.ALU port map (
        A => A,
        M => M,
        control => control,
        result => result
    );


    stim_proc: process
    begin
        A <= "00000010"; M <= "00000001"; control <= '0'; 
        wait for 100 ns;
        
        assert result = "00000011"
        report "Adunare incorecta!" severity error;

        A <= "00000010"; M <= "00000001"; control <= '1'; 
        wait for 100 ns;
        
        assert result = "00000001"
        report "Scadere incorecta!" severity error;

        wait;
    end process stim_proc;

end sim;
