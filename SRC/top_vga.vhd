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
          VGA_red: out std_logic_vector(3 downto 0);
          VGA_green: out std_logic_vector(3 downto 0);
          VGA_blue: out std_logic_vector(3 downto 0);
          VGA_hs: out std_logic;
          VGA_vs: out std_logic
          );
end top_vga;

architecture Behavioral of top_vga is
    signal ADDR_reg: std_logic_vector(18 downto 0);
    signal clk25M: std_logic;
    signal signot_Reset: std_logic;
    signal ADDR_affichage_R: std_logic_vector(18 downto 0);
    signal mire_video: std_logic_vector(3 downto 0);
    signal data_out: std_logic_vector(3 downto 0);
begin

    div_clk : entity  work.div_clk
    port map (
                clk100 =>clk100M,
                clk25 =>clk25M
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

    generateur_de_mire : entity  work.mire_generator
    port map (
                CE =>'1',
                H=>clk25M,
                RST=>'0',
                en_cpt=>'1',
                init_cpt=>'0',
                dataout=>mire_video
                );
                       
                    
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
end Behavioral;

