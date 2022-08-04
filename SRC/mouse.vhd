library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity mouse is
  port (
    clk :in std_logic;
    reset :in std_logic;
    mouse_data :in std_logic;
    mouse_clk :in std_logic;
    data_out :out std_logic_vector(10 downto 0);
    button_left:out std_logic;
    button_right : out std_logic
  ) ;
end mouse ; 

architecture arch of mouse is
    --signal cpt_mouse: integer range 0 to 33:=0;
    --signal mouse_clk_old: std_logic;
    --signal init_cpt: std_logic :='0';
    signal d :std_logic_vector(44 downto 0);
    signal byte1 : std_logic_vector(10 downto 0);
    signal byte2 : std_logic_vector(10 downto 0);
    signal byte3 : std_logic_vector(10 downto 0);
    signal byte4 : std_logic_vector(10 downto 0);
    signal index : integer range 0 to 43 :=43;
begin

    mouse :process(mouse_clk, reset)
    begin
        if(reset='1')then
            d<=(others=>'0');
            byte1<=(others=>'0');
            byte2<=(others=>'0');
            byte3<=(others=>'0');
            byte4<=(others=>'0');
            data_out<=(others=>'0');
        elsif(falling_edge(mouse_clk))then
            d(index)<=mouse_data;
            if(index>0)then
                index<=index-1;
            else
                index<=43;
                byte1<=d(43 downto 33);
                byte2<=d(32 downto 22);
                byte3<=d(21 downto 11);
                byte4<=d(10 downto 0);
                data_out<=byte1;
            end if;
        end if;
    end process;

    button:process(clk, reset)
    begin
        if(reset='1')then
            button_left<='0';
            button_right<='0';
        elsif rising_edge(clk) then
            if(byte1(9)='1')then
                button_left<='1';
            elsif (byte1(8)='1') then
                button_right<='1';
            else
                button_left<='0';
                button_right<='0';
            end if;
        end if;
    end process;
end architecture ;