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
    Port ( H : in STD_LOGIC;
           RAZ : in STD_LOGIC;
           CEaff : out STD_LOGIC;
		   CEseg : out STD_LOGIC;
           CEincrement : out STD_LOGIC;
           CETraitement : out STD_LOGIC);
end Clock_manager;

architecture Behavioral of Clock_manager is
	signal clk25M 	 :std_logic :='0';
	signal Cpt3k 	: unsigned (15 downto 0);
	signal Cpt300 	: unsigned (18 downto 0);
	signal Cpt1 	: unsigned (26 downto 0);
	signal clk50M : std_logic :='0';
begin

	clk_clk50M:process(H)
    begin
        if(H'event and H ='1')then
            clk50M <= not clk50M;
        end if;
    end process;

    clk_clk25M:process(clk50M)
    begin
        if(clk50M'event and clk50M ='1')then
            clk25M <= not clk25M;
        end if;
    end process;
	CETraitement<=clk25M;
	
	clock_3kHz : process (H, RAZ)
	begin
		if (RAZ = '1') then
			Cpt3k <= "0000000000000000";
			CEaff <= '0';
		elsif rising_edge(H) then
			if (Cpt3k = 33333) then
				CEaff <= '1';
				Cpt3k <= "0000000000000000";
			else
				Cpt3k <= Cpt3k + 1;
				CEaff <= '0';
			end if;
		end if;
	
	end process;

	clock_300 : process (H, RAZ)
	begin
		if (RAZ = '1') then
			Cpt300 <= (others => '0');
			CEseg <= '0';
		elsif rising_edge(H) then

			if (Cpt300 = 333333) then
				Cpt300 <= (others => '0');
				CEseg <= '1';
			else
			    Cpt300 <= Cpt300 + 1;
				CEseg <= '0';
			end if;
		end if;
	end process;
	
	clock_1Hz : process (H, RAZ)
	begin
		if (RAZ = '1') then
			Cpt1 <= "000000000000000000000000000";
			CEIncrement <= '0';
		elsif rising_edge(H) then

			if (Cpt1 = 100000000-1) then
				Cpt1 <= "000000000000000000000000000";
				CEIncrement <= '1';
			else
				Cpt1 <= Cpt1 + 1;
				CEIncrement <= '0';
			end if;
		end if;
	end process;

end Behavioral;