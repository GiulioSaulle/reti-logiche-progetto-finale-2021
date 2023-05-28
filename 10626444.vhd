library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity project_reti_logiche is
    port (
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_start : in std_logic;
        i_data : in std_logic_vector(7 downto 0);
        o_address : out std_logic_vector(15 downto 0);
        o_done : out std_logic;
        o_en : out std_logic;
        o_we : out std_logic;
        o_data : out std_logic_vector (7 downto 0)
    );
end project_reti_logiche;

architecture Behavioral of project_reti_logiche is
type state_type is(
    START,
    DONE,
    COLUMN,
    ROWS,
    SEARCH_MAX_MIN,
    DELTA_VALUE,
    --SHIFT_LEVEL (inglobato in DELTA_VALUE)
    OLD_PIXEL,
    NEW_PIXEL,
    MEMORY
);

signal STATE, P_STATE: state_type; 
signal MAX: std_logic_vector (7 downto 0); 
signal MIN: std_logic_vector (7 downto 0);
signal DELTA: std_logic_vector (7 downto 0);
signal  shift_level: integer range 0 to 8; 


begin
    process (i_clk, i_rst)
    variable count: std_logic_vector (15 downto 0);
    variable prev_count: std_logic_vector (15 downto 0); 
    variable  temp_pixel: std_logic_vector (15 downto 0);
    variable  temp_pixel_lesser: std_logic_vector (7 downto 0);
    variable  MAX_SIZE: unsigned  (15 downto 0);
    variable  COL: unsigned  (7 downto 0);
    variable  ROW: unsigned  (7 downto 0);
    
    begin
    
    if(i_rst = '1') then --se vi ? un reset devo tenere conto anche dello start
        o_en <= '0';
        o_we <= '0';
        o_done <= '0';
        o_data <= "00000000";
        o_address <= "0000000000000000";
        COL := "00000000";
        ROW := "00000000";
        MAX_SIZE := "0000000000000000";
        MAX <= "00000000";
        MIN <= "11111111";
        DELTA <= "00000000";
        count := "0000000000000000";
        prev_count := "0000000000000000";
        temp_pixel := "0000000000000000";
        STATE <= START;
        P_STATE <= START;
    elsif (rising_edge (i_clk)) then -- AND i_rst = '0'
        case STATE is 
            when START =>
                if (i_start = '1' ) then --AND i_rst = '0'
                    o_en <= '1';
                    o_data <= "00000000";
                    o_address <= "0000000000000000";
                    COL := "00000000";
                    ROW := "00000000";
                    MAX_SIZE := "0000000000000000";
                    MAX <= "00000000";
                    MIN <= "11111111";
                    DELTA <= "00000000";
                    count := "0000000000000000";
                    prev_count := "0000000000000000";
                    temp_pixel := "0000000000000000";
                    P_STATE <= START;
                    STATE <= MEMORY;
                end if;
                
            when COLUMN =>
                COL := unsigned(i_data);
                o_en <= '1';
                o_address <= "0000000000000001"; 
                P_STATE <= COLUMN;
                STATE <= MEMORY;
                
            when ROWS =>
                if(COL <= "00000000") then
                    o_done <= '1';
                    STATE <= DONE;
                else
                ROW := unsigned(i_data);
                P_STATE <= ROWS;
                STATE <= MEMORY;
                o_address <= "0000000000000010";
                end if;
                
            when SEARCH_MAX_MIN =>
                if not(count = std_logic_vector (MAX_SIZE+2)) then
                    if (i_data < MIN) then
                        MIN <= i_data;
                    end if;               
                    if (i_data > MAX) then
                        MAX <= i_data;                  
                    end if;
                    o_en <= '1';
                    prev_count := count;
                    o_address <= prev_count + 1;
                    count := prev_count + 1;
                    -- poiche' devo leggere o_address
                    -- serve lo stato intermedio memory per leggere il nuovo address
                    P_STATE <= SEARCH_MAX_MIN;
                    STATE <= MEMORY;
                 else
                -- calcolo delta
                    DELTA <= std_logic_vector(unsigned(MAX) - unsigned(MIN)) + 1;
                    P_STATE <= DELTA_VALUE;
                    STATE <= MEMORY;
                 end if;  
                 
                 when DELTA_VALUE => 
                -- 8 - floor(log2(delta))
                -- essendo delta maggiorato di 1, 
                -- i confronti risultano corretti               
                    if (MAX = 0 AND MIN = 255) then
                        shift_level <= 0;
                        count := "0000000000000010";
                        P_STATE <= NEW_PIXEL;
                        STATE <= MEMORY;
                    end if;   
                    if DELTA(7) = '1' then 
                        shift_level <= 1;
                    elsif DELTA(6) = '1' then 
                        shift_level <= 2;
                    elsif DELTA(5) = '1' then 
                        shift_level <= 3;
                    elsif DELTA(4) = '1' then 
                        shift_level <= 4;
                    elsif DELTA(3) = '1' then 
                        shift_level <= 5;
                    elsif DELTA(2) = '1' then 
                        shift_level <= 6;
                    elsif DELTA(1) = '1' then 
                        shift_level <= 7;
                    else
                        shift_level <= 0;
                    end if;
                    count := "0000000000000010";
                    P_STATE <= NEW_PIXEL;
                    STATE <= MEMORY;        
                
                       
            when OLD_PIXEL =>
                o_en <= '1';
                o_we <= '0';
                o_address <= count;
                P_STATE <= OLD_PIXEL;
                STATE <= MEMORY;
             
            when NEW_PIXEL => 
            if not(count = std_logic_vector (MAX_SIZE+2)) then
                o_en <= '1';
                o_we <= '1';
                prev_count := count;   
                temp_pixel := std_logic_vector(shift_left("00000000" & (unsigned(i_data - MIN)), shift_level)); 
                temp_pixel_lesser := std_logic_vector(temp_pixel(7 downto 0));                             
                if (to_integer(unsigned(temp_pixel)) > 255) then
                    o_data <= "11111111";
                else
                    o_data <= temp_pixel_lesser;
                end if;
                count := prev_count + 1;
                P_STATE <= NEW_PIXEL;
                STATE <= MEMORY;     
            else
                STATE <= DONE;
            end if;
            
            when DONE =>
                if (i_start = '1') then 
                    o_en <= '0';
                    o_we <= '0';
                    o_done <= '1';
                    STATE <= DONE;
                else
                    o_done <= '0';
                    STATE <= START;
                end if;
                
            when MEMORY =>
                if(P_STATE = START) then
                    STATE <= COLUMN;
                elsif(P_STATE = COLUMN) then                   
                    STATE <= ROWS;
                elsif(P_STATE = ROWS) then
                    if(ROW <= "00000000") then
                        o_done <= '1';
                        STATE <= DONE;
                    else
                        MAX_SIZE := ROW * COL;
                        --inizializzo search max e min (se lo facessi dentro lo stato lo reinizializzerei ogni volta)
                        count := "0000000000000010";
                        STATE <= SEARCH_MAX_MIN; 
                    end if;
                elsif(P_STATE = SEARCH_MAX_MIN) then   
                    STATE <= SEARCH_MAX_MIN;
                elsif (P_STATE = DELTA_VALUE) then
                    STATE <= DELTA_VALUE;
                elsif(P_STATE = OLD_PIXEL) then 
                    o_address <= std_logic_vector (MAX_SIZE) + count;
                    STATE <= NEW_PIXEL;
                elsif(P_STATE = NEW_PIXEL) then
                    STATE <= OLD_PIXEL;
                end if;
            end case;
        end if;
    end process;
end Behavioral;

