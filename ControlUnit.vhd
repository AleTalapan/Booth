library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BoothControl is
    Port (
        clk       : in STD_LOGIC;
        reset     : in STD_LOGIC;
        start     : in STD_LOGIC;                -- Semnal de pornire
        q_0       : in STD_LOGIC;                -- Ultimul bit al registrului
        q_minus_1 : in STD_LOGIC;                -- Bitul adiacent (Q-1)
        counter   : in STD_LOGIC_VECTOR(2 downto 0); -- Contorul pentru cicluri
        done      : out STD_LOGIC;               -- Semnal de finalizare
        alu_op    : out STD_LOGIC;               -- Semnal pentru opera?ia ALU
        shift     : out STD_LOGIC                -- Semnal pentru deplasare
    );
end BoothControl;
architecture Behavioral of BoothControl is
    type state_type is (Idle, Load, AddSub, RShift, Check, Output);
    signal current_state, next_state : state_type;
begin
    process (clk, reset)
    begin
        if reset = '1' then
            current_state <= Idle;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    process (current_state, start, q_0, q_minus_1, counter)
    begin
        done <= '0';
        alu_op <= '0';
        shift <= '0';
        case current_state is
            when Idle =>
                if start = '1' then
                    next_state <= Load;
                else
                    next_state <= Idle;
                end if;

            when Load =>
                next_state <= AddSub;

            when AddSub =>
                if (q_0 = '1' and q_minus_1 = '0') then
                    alu_op <= '1'; -- Scade
                elsif (q_0 = '0' and q_minus_1 = '1') then
                    alu_op <= '0'; -- Adun?
                end if;
                next_state <= RShift;

            when RShift =>
                shift <= '1';
                next_state <= Check;

            when Check =>
                if counter = "000" then -- Toate ciclurile complete
                    next_state <= Output;
                else
                    next_state <= AddSub;
                end if;

            when Output =>
                done <= '1';
                next_state <= Idle;

            when others =>
                next_state <= Idle;
        end case;
    end process;
end Behavioral;




