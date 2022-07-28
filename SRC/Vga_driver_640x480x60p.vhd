library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity VGA_driver_640x480x60p is
    generic(bit_per_pixel : integer range 1 to 12:=3);    -- number of bits per pixel
    port( clk100M : in  std_logic; --100MHz
          reset : in std_logic;
          VGA_hs : out std_logic;
          VGA_vs : out std_logic;
          VGA_red      : out std_logic_vector(3 downto 0);   -- red output
          VGA_green    : out std_logic_vector(3 downto 0);   -- green output
          VGA_blue     : out std_logic_vector(3 downto 0));   -- blue output
          --ADDR         : in  std_logic_vector(13 downto 0);
          --data_write   : in  std_logic;
          --data_in      : in  std_logic_vector(bit_per_pixel - 1 downto 0));
    
end VGA_driver_640x480x60p;

architecture Behavioral of VGA_driver_640x480x60p is

    signal clk50M : std_logic :='0';
    signal clk25M : std_logic :='0';
    signal video_on : std_logic :='0';

    constant HD  : integer :=639; --Horizontal Display 640 Pixels
    constant HFP : integer :=16; --Horizontal Front Proch 
    constant HSP : integer :=96; --Horizontal Sync Pluse
    constant HBP : integer :=48; --Horizontal Back Proch
    constant HWL : integer :=HD + HFP + HSP + HBP; --Horizontal Whole line

    constant VD  : integer :=480; --Vertical Display 640 Pixels
    constant VFP : integer :=10; --Vertical Front Proch 
    constant VSP : integer :=2; --Vertical Sync Pluse
    constant VBP : integer :=33; --Vertical Back Proch 
    constant VWL : integer :=VD + VFP + VSP + VBP; --Vertical Whole line

    signal hPos : integer range 0 to HWL:=0;
    signal vPos : integer range 0 to VWL:=0;


begin
    clk_div1:process(clk100M)
    begin
        if(clk100M'event and clk100M ='1')then
            clk50M <= not clk50M;
        end if;
    end process;

    clk_div2:process(clk50M)
    begin
        if(clk50M'event and clk50M ='1')then
            clk25M <= not clk25M;
        end if;
    end process;

    Horizontal_position_counter:process(clk25M,reset)
    begin
        if(reset ='1')then
            hPos <=0;
        elsif(clk25M'event and clk25M ='1')then
            if(hpos = HWL) then
                hPos <=0;
            else
                hpos <= hpos +1;
            end if;
        end if;
    end process;

    Vertical_position_counter:process(clk25M,reset,hPos)
    begin
        if(reset ='1')then
            vPos <=0;
        elsif(clk25M'event and clk25M ='1')then
            if(hpos = HWL)then
                if(vpos = VWL) then
                    vPos <=0;
                else
                    vpos <= vpos +1;
                end if;
            end if;
        end if;
    end process;

    Horizontal_synchronisation:process(clk25M,reset, hPos)
    begin
         if(reset='1')then
            VGA_hs <='0';
         elsif(clk25M'event and clk25M ='1')then
            if((hPos <= (HD + HFP)) OR (hPos > (HD + HFP + HSP)))then
                VGA_hs <='1';
            else
                VGA_hs <='0';
            end if;
         end if;
    end process;

    Vertical_synchronisation:process(clk25M,reset, vPos)
    begin
         if(reset='1')then
            VGA_vs <='0';
         elsif(clk25M'event and clk25M ='1')then
            if((vPos <= (VD + VFP)) OR (vPos > (VD + VFP + VSP)))then
                VGA_vs <='1';
            else
                VGA_vs <='0';
            end if;
         end if;
    end process;

    process_video_on:process(clk25M,reset,hPos,vPos)
    begin
        if(reset='1')then
            video_on <='0';
        elsif(clk25M'event and clk25M ='1')then
          if(hPos <=HD and vPos <=VD)then
            video_on <='1';
          else
            video_on <='0';
          end if;
        end if;
    end process;
     
    draw:process(clk25M,reset,hPos,vPos,video_on)
    begin
        if(reset='1')then
            VGA_red   <="0000";
            VGA_green <="0000";
            VGA_blue  <="0000";
        elsif(clk25M'event and clk25M ='1')then
            if(video_on = '1')then
                if((hpos >=10 and hpos <=60) and (vpos>=10 and vPos <=60))then
                    VGA_red   <="1111";
                    VGA_green <="1111";
                    VGA_blue  <="1111";
                else
                    VGA_red   <="0000";
                    VGA_green <="0000";
                    VGA_blue  <="0000";
                end if;
            else
                VGA_red   <="0000";
                VGA_green <="0000";
                VGA_blue  <="0000";
            end if;
        end if;
    end process;
end Behavioral;



