
  
---------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.02.2021 08:33:14
-- Design Name: 
-- Module Name: compteur - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity compteur is
    Port ( CE : in STD_LOGIC;   -- Signal g�n�rique
           H : in STD_LOGIC;    -- Signal g�n�rique
           RST : in STD_LOGIC;  -- Signal g�n�rique
           en_cpt : in STD_LOGIC;   -- Signal FSM
           init_cpt : in STD_LOGIC; -- Signal FSM
           dataout : out STD_LOGIC_VECTOR (18 downto 0));
end compteur;

architecture Behavioral of compteur is

begin

    process(H,RST)
    variable cpt_value: integer range 0 to 307199;
    begin
        if(RST = '1') then
            cpt_value := 0;
            dataout <= (others => '0');
        elsif (H'event and H ='1') then
            if (CE = '1') then
                if(init_cpt = '1') then
                    cpt_value := 0;
                elsif(en_cpt = '1') then
                    if(cpt_value<307200) then
                        cpt_value := cpt_value + 1;
                    else
                        cpt_value:=0;
                    end if;
                end if;
                dataout <= std_logic_vector(to_unsigned(cpt_value, 19));
            end if;
        end if;
        
    end process;


end Behavioral;

