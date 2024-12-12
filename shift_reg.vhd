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
           data_in2 : in STD_LOGIC_VECTOR(7 downto 0);
           data_out1 : out STD_LOGIC_VECTOR(7 downto 0);
           data_out2 : out STD_LOGIC_VECTOR(7 downto 0));
end ShiftRegister;

architecture Behavioral of ShiftRegister is
    signal internal_data1 : STD_LOGIC_VECTOR(7 downto 0);
    signal internal_data2 : STD_LOGIC_VECTOR(7 downto 0);
begin
    process (clk, reset)
    begin
        if reset = '1' then
            internal_data1 <= (others => '0');
            internal_data2 <= (others => '0');
        elsif rising_edge(clk) then
            if load = '1' then
                internal_data1 <= data_in;
                internal_data2 <= data_in2;
            elsif enable = '1' then
                internal_data1 <= '0' & internal_data1(7 downto 1);
                internal_data2 <= internal_data1(0) & internal_data2(7 downto 1);
            end if;
        end if;
    end process;
    
    data_out1 <= internal_data1;
    data_out2 <= internal_data2;
end Behavioral;

