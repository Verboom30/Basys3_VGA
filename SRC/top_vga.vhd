----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.03.2021 14:06:28
-- Design Name: 
-- Module Name: top_vga - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_vga is
    port( reset : in std_logic ;
          clk100M : in std_logic;
          PS2Clk : in std_logic;
          PS2Data: in std_logic;
          VGA_red: out std_logic_vector(3 downto 0);
          VGA_green: out std_logic_vector(3 downto 0);
          VGA_blue: out std_logic_vector(3 downto 0);
          VGA_hs: out std_logic;
          VGA_vs: out std_logic;
          JA: out STD_LOGIC_VECTOR (7 downto 0);
          led :out STD_LOGIC_VECTOR (10 downto 0);
          seg : out STD_LOGIC_VECTOR (6 downto 0);
          an : out STD_LOGIC_VECTOR (3 downto 0)
          );
end top_vga;

architecture Behavioral of top_vga is
    signal ADDR_reg: std_logic_vector(18 downto 0);
    signal clk25M: std_logic;
    signal clk3K: std_logic;
    signal clk300H: std_logic;
    signal clk1H: std_logic;
    signal signot_Reset: std_logic;
    signal ADDR_affichage_R: std_logic_vector(18 downto 0);
    signal mire_video: std_logic_vector(3 downto 0):="0000";
    signal data_out: std_logic_vector(3 downto 0);
    signal Mouse_out:  std_logic_vector(10 downto 0);
    signal rx_done_tick:std_logic;
begin  

    clk_manager : entity  work.Clock_manager
    port map (
                H =>clk100M,
                RAZ=>reset,
                CEaff=>clk3K,
                CEseg=>clk300H,
                CEincrement=>clk1H,
                CETraitement=>clk25M
              ); 
 
              
              
    mouse : entity work.mouse
    port map( 
      
        clk=>clk100M,
        reset=>reset,
        mouse_data=>PS2Data,
        mouse_clk=>PS2Clk,
        data_out=>Mouse_out,
        button_left=> mire_video(0),
        button_right=> mire_video(3)
      
       
    );

    seven_seg_display : entity work.Module_Affichage
    port map (
           H =>clk3K,
           CEaff=>'1',
           RAZ =>reset,
           Valeur=>Mouse_out,
           seg =>seg,
           an =>an
    );      
 
    
    compteur : entity  work.compteur
      port map (
                CE =>'1',
                H=>clk25M,
                RST=>'0',
                en_cpt=>'1',
                init_cpt=>'0',
                dataout=>ADDR_affichage_R
                );  

--    generateur_de_mire : entity  work.mire_generator
--    port map (
--                CE =>'1',
--                H=>clk25M,
--                RST=>'0',
--                en_cpt=>'1',
--                init_cpt=>'0',
--                dataout=>mire_video
--                );
                       
                    
     VGA: entity  work.VGA_driver_640x480x60p
      port map (
       clk       =>clk25M,
       reset        =>'0',
       VGA_hs       =>VGA_hs,
       VGA_vs       =>VGA_vs,
       VGA_red      =>VGA_red,
       VGA_green    =>VGA_green,
       VGA_blue     =>VGA_blue,

       ADDR         =>ADDR_affichage_R,
       data_in      =>mire_video,
       --data_out =>data_out,
       data_write   =>'1'
                );
                
    signot_Reset <= not(reset);
    JA(0)<=PS2Clk;
    JA(1)<=PS2Data;
    led <=Mouse_out;
end Behavioral;

