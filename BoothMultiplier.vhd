library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BoothMultiplier is
    Port (
        clk       : in STD_LOGIC;
        reset     : in STD_LOGIC;
        start     : in STD_LOGIC;                -- Semnal de pornire
        multiplicand : in STD_LOGIC_VECTOR(7 downto 0); -- Multiplicand
        multiplier   : in STD_LOGIC_VECTOR(7 downto 0); -- Multiplier
        done      : out STD_LOGIC;               -- Semnal de finalizare
        product   : out STD_LOGIC_VECTOR(15 downto 0)  -- Rezultatul final
    );
end BoothMultiplier;

architecture Behavioral of BoothMultiplier is
    signal alu_result    : STD_LOGIC_VECTOR(7 downto 0);
    signal shift_data1   : STD_LOGIC_VECTOR(7 downto 0);
    signal shift_data2   : STD_LOGIC_VECTOR(7 downto 0);
    signal alu_op        : STD_LOGIC;
    signal shift_enable  : STD_LOGIC;
    signal q_0           : STD_LOGIC;
    signal q_minus_1     : STD_LOGIC;
    signal internal_done : STD_LOGIC;

    -- Semnale pentru conectarea intern?
    signal internal_product : STD_LOGIC_VECTOR(15 downto 0);
    signal reg_multiplicand : STD_LOGIC_VECTOR(7 downto 0);
    signal reg_multiplier   : STD_LOGIC_VECTOR(7 downto 0);

begin

    -- Shift Register Module
    shift_register_inst: entity work.ShiftRegister
        Port map (
            clk       => clk,
            reset     => reset,
            load      => start,
            enable    => shift_enable,
            data_in   => multiplicand,
            data_in2  => multiplier,
            data_out1 => shift_data1,  -- Multiplicand partial (A)
            data_out2 => shift_data2   -- Multiplier partial (Q)
        );

    -- ALU Module
    alu_inst: entity work.ALU
        Port map (
            A       => shift_data1,    -- Multiplicand partial (A)
            M       => reg_multiplicand, -- Multiplicand original
            control => alu_op,         -- Aduna sau scade
            result  => alu_result      -- Rezultatul ALU
        );

    -- Booth Control Unit
    control_inst: entity work.BoothControl
        Port map (
            clk       => clk,
            reset     => reset,
            start     => start,
            q_0       => shift_data2(0), -- LSB din registrul multiplicator
            q_minus_1 => q_minus_1,      -- Bitul adiacent (Q-1)
            done      => internal_done,
            alu_op    => alu_op,
            shift     => shift_enable
        );

    -- Output Final
    process (clk, reset)
    begin
        if reset = '1' then
            internal_product <= (others => '0');
            q_minus_1 <= '0';
        elsif rising_edge(clk) then
            if start = '1' then
                reg_multiplicand <= multiplicand;
                reg_multiplier <= multiplier;
                internal_product(15 downto 8) <= (others => '0'); -- A = 0
                internal_product(7 downto 0) <= multiplier;      -- Q = multiplicand
            elsif shift_enable = '1' then
                q_minus_1 <= shift_data2(0); -- Actualizare Q-1
                internal_product(15 downto 8) <= alu_result;
                internal_product(7 downto 0) <= shift_data2;
            end if;
        end if;
    end process;

    -- Semnal done ?i rezultat final
    done <= internal_done;
    product <= internal_product;

end Behavioral;
