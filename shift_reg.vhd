library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ShiftRegister is
    Port ( clk      : in STD_LOGIC;
           reset    : in STD_LOGIC;
           load     : in STD_LOGIC;
           enable   : in STD_LOGIC;
           data_in  : in STD_LOGIC_VECTOR(7 downto 0);
           data_out : out STD_LOGIC_VECTOR(7 downto 0));
end ShiftRegister;

architecture Behavioral of ShiftRegister is
    signal internal_data : STD_LOGIC_VECTOR(7 downto 0);
begin
    process (clk, reset)
    begin
        if reset = '1' then
            internal_data <= (others => '0');
        elsif rising_edge(clk) then
            if load = '1' then
                internal_data <= data_in;
            elsif enable = '1' then
                internal_data <= '0' & internal_data(7 downto 1);
            end if;
        end if;
    end process;
    
    data_out <= internal_data;
end Behavioral;

