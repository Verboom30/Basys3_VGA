library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Clock_manager is
  Port (  
          CLK 	    : in  STD_LOGIC ;
          RESET     : in  STD_LOGIC ;
          CLK_50M   : out STD_LOGIC ;
          CLK_25M   : out STD_LOGIC ;
          CLK_3K    : out STD_LOGIC ;
          CLK_1H    : out STD_LOGIC
        );
end Clock_manager;

architecture rtl of Clock_manager is
	signal counter_3K : unsigned (14 downto 0);
  signal counter_1H : unsigned (23 downto 0);
begin

	proc_50M:process(RESET, CLK)
    begin
      if(RESET ='1') then
        CLK_50M <= '0';
      elsif (rising_edge(CLK)) then
        CLK_50M <= not CLK_50M;
      end if;
  end process proc_50M;

  proc_25M:process(RESET, CLK_50M)
  begin
    if(RESET ='1') then
      CLK_25M <= '0';
    elsif (rising_edge(CLK_50M)) then
      CLK_25M <= not CLK_25M;
    end if;
  end process proc_25M;

  proc_3K:process(RESET, CLK)
  begin
    if(RESET ='1') then
      CLK_3K <= '0';
      counter_3K <= (others => '0');
    elsif (rising_edge(CLK)) then
      if(counter_3K <= 33333-1) then
        counter_3K  <= counter_3K + 1;
        CLK_3K      <= not CLK_3K;
      else
        counter_3K <= (others => '0');
      end if;
    end if;
  end process proc_3K;

  proc_1H:process(RESET, CLK)
  begin
    if(RESET ='1') then
      CLK_1H <= '0';
      counter_1H <= (others => '0');
    elsif (rising_edge(CLK)) then
      if(counter_1H <= 25000000-1) then
        counter_1H  <= counter_1H + 1;
        CLK_1H      <= not CLK_1H;
      else
      counter_1H <= (others => '0');
      end if;
    end if;
  end process proc_1H;
  
end rtl;