library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Module_Affichage is
    Port ( H : in STD_LOGIC;
           CEaff : in STD_LOGIC;
           RAZ : in STD_LOGIC;
           Valeur : in STD_LOGIC_VECTOR(10 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
    
end Module_Affichage;

architecture Behavioral of Module_Affichage is
	signal Value_sev_seg : std_logic_vector(3 downto 0);
begin
   
	Choix_du_digit_affiche: process (H, RAZ)
	variable CptNum 	: natural range 0 to 3 := 0;
	variable Value 		: integer := 0;
	variable Unite 		: integer := 0;
	variable Dizaine 	: integer := 0;
    variable Centaine 	: integer := 0;
    variable Millier 	: integer := 0;
	
	begin
		if (RAZ = '1') then
			an <= "0000";
			Value_sev_seg <= "0000";
			Value := 0;	
			CptNum := 0;
		elsif rising_edge(H) then
		    Value := to_integer(unsigned(Valeur));
		    Unite := Value MOD 10;
		    Dizaine := (Value/10) MOD 10;
            Centaine :=(Value/100) MOD 10;
            Millier :=(Value/1000);
		    if (CEaff ='1') then
				case CptNum is
					when 0 => an<="1110";	-- Afficheur le plus à droite
						  Value_sev_seg <= std_logic_vector(to_unsigned(Unite,4));
					when 1 => an<="1101";
						  Value_sev_seg <= std_logic_vector(to_unsigned(Dizaine,4));
					when 2 => an<="1011";
						  Value_sev_seg <= std_logic_vector(to_unsigned(Centaine,4));	-- Extinction de l'afficheur 2 car non utilisé 
					when 3 => an<="0111";	-- Afficheur le plus à gauche
						  Value_sev_seg <= std_logic_vector(to_unsigned(Millier,4));	-- Extinction de l'afficheur si mvt en cours
					when others => an<="1111";
						Value_sev_seg <= "0000";
				end case;
				
				if (CptNum < 3) then
					CptNum := CptNum+1;
				else
					CptNum := 0;
				end if;
           	end if;
		end if;
	end process;
	
	decodeur_7seg : entity work.seven_seg
		Port map(in_bin => Value_sev_seg, sev_seg => seg);

end Behavioral;