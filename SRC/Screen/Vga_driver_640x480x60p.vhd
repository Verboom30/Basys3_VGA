library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity VGA_driver_640x480x60p is
    generic(bit_per_pixel : integer range 1 to 12:=4);    -- number of bits per pixel
    port( clk : in  std_logic; 
          reset : in std_logic;
          VGA_hs : out std_logic;
          VGA_vs : out std_logic;
          VGA_red      : out std_logic_vector(3 downto 0);   -- red output
          VGA_green    : out std_logic_vector(3 downto 0);   -- green output
          VGA_blue     : out std_logic_vector(3 downto 0);   -- blue output
          ADDR         : in  std_logic_vector(18 downto 0); 
          data_write   : in  std_logic;
          data_in      : in  std_logic_vector(bit_per_pixel - 1 downto 0));
        
end VGA_driver_640x480x60p;

architecture Behavioral of VGA_driver_640x480x60p is

   -- signal clk50M : std_logic :='0';
   -- signal clk : std_logic :='0';
    signal video_on : std_logic :='0';
    signal next_pixel : std_logic_vector(bit_per_pixel - 1 downto 0);  -- the data coding the value of the pixel to be displayed
    signal pix_read_addr : integer range 0 to 307199:=0; -- the address at which displayed data is read
    -- Graphic RAM type. this object is the content of the displayed image
    type GRAM is array (0 to 307199) of std_logic_vector(bit_per_pixel - 1 downto 0); 

    signal screen      : GRAM;                           -- the memory representation of the image
    
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

    signal TOP_line    : boolean := false;               -- this signal is true when the current pixel column is visible on the screen
    signal TOP_display : boolean := false;               -- this signal is true when the current pixel line is visible on the screen

    signal hPos : integer range 0 to HWL:=0;
    signal vPos : integer range 0 to VWL:=0;


begin

    Horizontal_position_counter:process(clk,reset)
    begin
        if(reset ='1')then
            hPos <=0;
        elsif(clk'event and clk ='1')then
            if(hpos = HWL) then
                hPos <=0;
            else
                hpos <= hpos +1;
            end if;
        end if;
    end process;

    Vertical_position_counter:process(clk,reset,hPos)
    begin
        if(reset ='1')then
            vPos <=0;
        elsif(clk'event and clk ='1')then
            if(hpos = HWL)then
                if(vpos = VWL) then
                    vPos <=0;
                else
                    vpos <= vpos +1;
                end if;
            end if;
        end if;
    end process;

    Horizontal_synchronisation:process(clk,reset, hPos)
    begin
         if(reset='1')then
            VGA_hs <='0';
         elsif(clk'event and clk ='1')then
            if((hPos <= (HD + HFP)) OR (hPos > (HD + HFP + HSP)))then
                VGA_hs <='1';
            else
                VGA_hs <='0';
            end if;
         end if;
    end process;

    Vertical_synchronisation:process(clk,reset, vPos)
    begin
         if(reset='1')then
            VGA_vs <='0';
         elsif(clk'event and clk ='1')then
            if((vPos <= (VD + VFP)) OR (vPos > (VD + VFP + VSP)))then
                VGA_vs <='1';
            else
                VGA_vs <='0';
            end if;
         end if;
    end process;

    process_video_on:process(clk,reset,hPos,vPos)
    begin
        if(reset='1')then
            video_on <='0';
        elsif(clk'event and clk ='1')then
          if(hPos <=HD and vPos <=VD)then
            video_on <='1';
          else
            video_on <='0';
          end if;
        end if;
    end process;

    memory_management : process(clk)
    begin
        if clk'event and clk='1' then
            next_pixel <= screen(pix_read_addr);
            if data_write = '1' then
                screen(to_integer(unsigned(ADDR))) <= data_in;
            end if;
        end if;
    end process;

    pixel_read_addr : process(clk,reset)
    begin
    if clk'event and clk='1' then
        if (reset = '1' or video_on='0')  then
            pix_read_addr <= 0;
        elsif (video_on ='1') then
            pix_read_addr <= pix_read_addr + 1;
        end if;
    end if;
    end process;
     
       draw:process(clk,reset,hPos,vPos,video_on)
    begin
        if(reset='1')then
            VGA_red   <="0000";
            VGA_green <="0000";
            VGA_blue  <="0000";
        elsif(clk'event and clk ='1')then
            if(video_on = '1')then
                case next_pixel is
                    when "0000" => --White
                       VGA_red   <= "1111";
                       VGA_green <= "1111";
                       VGA_blue  <= "1111";
                    when "0001" => --Light gray
                       VGA_red   <= "1011";
                       VGA_green <= "1011";
                       VGA_blue  <= "1011";
                    when "0010" => --Gray
                       VGA_red   <= "0011";
                       VGA_green <= "0011";
                       VGA_blue  <= "0011";
                    when "0011" => --Black
                       VGA_red   <= "0000";
                       VGA_green <= "0000";
                       VGA_blue  <= "0000";
                    when "0100" => --Brow
                       VGA_red   <= "0111";
                       VGA_green <= "0011";
                       VGA_blue  <= "0000";
                    when "0101" => --Red
                       VGA_red   <= "1111";
                       VGA_green <= "0000";
                       VGA_blue  <= "0000";
                    when "0110" => --Orange
                       VGA_red   <= "1111";
                       VGA_green <= "0110";
                       VGA_blue  <= "0000";
                    when "0111" => --Yellow
                       VGA_red   <= "1111";
                       VGA_green <= "1111";
                       VGA_blue  <= "0000";
                    when "1000" => --Line
                       VGA_red   <= "0000";
                       VGA_green <= "1111";
                       VGA_blue  <= "0000";
                    when "1001" => --Green
                       VGA_red   <= "0000";
                       VGA_green <= "0111";
                       VGA_blue  <= "0000";
                    when "1010" => --Cyan
                       VGA_red   <= "0000";
                       VGA_green <= "0110";
                       VGA_blue  <= "0110";
                    when "1011" => --Light Blue
                       VGA_red   <= "0000";
                       VGA_green <= "1111";
                       VGA_blue  <= "1111";
                    when "1100" => --Blue
                       VGA_red   <= "0000";
                       VGA_green <= "0000";
                       VGA_blue  <= "1111";
                    when "1101" => --Purple
                       VGA_red   <= "0011";
                       VGA_green <= "0000";
                       VGA_blue  <= "1001";
                    when "1110" => --Magenta
                       VGA_red   <= "0111";
                       VGA_green <= "0000";
                       VGA_blue  <= "1001";
                    when "1111" => --Pink
                       VGA_red   <= "1111";
                       VGA_green <= "0000";
                       VGA_blue  <= "1111";
                 end case ;
            else
                VGA_red   <="0000";
                VGA_green <="0000";
                VGA_blue  <="0000";
            end if;
        end if;
    end process;
end Behavioral;



