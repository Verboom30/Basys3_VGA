library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity div_clk is
    port( --reset : in std_logic ;
          clk100 : in std_logic;
          clk25 : out std_logic
          );
end div_clk;

architecture Behavioral of div_clk is
    signal clk50M : std_logic :='0';
    signal clk25M : std_logic :='0';
begin
    clk_div1:process(clk100)
    begin
        if(clk100'event and clk100 ='1')then
            clk50M <= not clk50M;
        end if;
    end process;

    clk_div2:process(clk50M)
    begin
        if(clk50M'event and clk50M ='1')then
            clk25M <= not clk25M;
        end if;
    end process;
    clk25<=clk25M;
end Behavioral;