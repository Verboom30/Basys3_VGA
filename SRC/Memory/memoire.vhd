library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity screen_memory is
 port (
      CLK       : in  std_logic;
      RST       : in  std_logic;
      EN_MEN    : in  std_logic;
      R_WN      : in  std_logic;
      ADDR      : in  std_logic_vector(18 downto 0);
      DATA_IN   : in  std_logic_vector(7 downto 0);
      DATA_OUT  : out std_logic_vector(7 downto 0)
    );
        
end screen_memory

architecture rtl of screen_memory is

type GRAM is array (0 to 307199) of std_logic_vector(2 downto 0);
signal memory : GRAM := (others => (others => '1'));

begin
  ram : process(CLK)
  begin
    if( RST ='1') then
      memory <= (others => (others => '1'));
    elsif (rising_edge(CLK)) then
      if(EN_MEN = '1') then
        if(R_WN = '1') then
            DATA_OUT <= memory(to_integer(unsigned(ADDR)));
        else
            memory(to_integer(unsigned(ADDR)))<= DATA_IN;
        end if;
      end if;
    end if;
  end process ram;
end rtl;