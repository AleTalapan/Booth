library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU is
    Port (
    A:in STD_LOGIC_VECTOR(7 downto 0);
    M:in STD_LOGIC_VECTOR(7 downto 0);
    control:in STD_LOGIC;
    result:out STD_LOGIC_VECTOR(7 downto 0)
    );
end ALU;

architecture Behavioral of ALU is
begin
  process(A, M, control)
  begin
    if control = '0' then
      result<= A + M;
    else
      result <= A - M;
    end if;
  end process;
end Behavioral;
