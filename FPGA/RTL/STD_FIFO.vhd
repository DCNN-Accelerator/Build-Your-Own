--code provided at http://www.deathbylogic.com/2013/07/vhdl-standard-fifo/
--was modified for synthesis

library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity STD_FIFO is
    GENERIC (
                constant DATA_WIDTH     : positive := 8;
                constant FIFO_DEPTH	    : positive := 64
            );
    PORT    ( 
                clk		                : in  std_logic;
                rst		                : in  std_logic;
                
                --rtl wants to send data to fifo
                x_fifo_rts              : in  std_logic;
                --fifo can accept data
                x_fifo_rtr              : out std_logic;
                --new data to write
                x_fifo_data             : in  std_logic_vector (DATA_WIDTH - 1 downto 0);
                
                --fifo wants to send data to rtl
                fifo_x_rts              : out std_logic;
                --rtl can accept data
                fifo_x_rtr              : in  std_logic;
                --data out of fifo
                fifo_x_data	            : out std_logic_vector (DATA_WIDTH - 1 downto 0)
            );
end STD_FIFO;

architecture rtl of STD_FIFO is

type FIFO_Memory is array (FIFO_DEPTH - 1 downto 0) of std_logic_vector (DATA_WIDTH - 1 downto 0);
--flip flop memory
signal memory           : FIFO_Memory;
--position to write in FIFO
signal head             : integer range 0 to FIFO_DEPTH - 1;
--position to read in FIFO
signal tail             : integer range 0 to FIFO_DEPTH - 1;
--determines if writing has looped back to read
signal looped           : std_logic;

--signals mimic fifo_x_rts and x_fifo_rtr so they can
--be watched in if statements
signal fifo_rts         : std_logic;
signal fifo_rtr         : std_logic;

--used to prevent accidental double reads
signal delay            : std_logic;

begin

	process
	begin
		wait until clk = '1';
		
        if (rst = '0') then
            head <= 0;
            tail <= 0;
            looped <= '0';
            fifo_x_data <= (others => '0');
            memory <= (others => (others => '0'));
            fifo_rts <= '0';
            fifo_x_rts <= '0';
            fifo_rtr <= '0';
            x_fifo_rtr <= '0';
            delay <= '0';
        else
            --checks to see if it can send out data
            if (fifo_x_rtr = '1' and fifo_rts = '1' and delay = '0') then
                --makes sure that there is data to read
                if ((looped = '1') or (head /= tail)) then
                    delay <= '1';
                    --read the memory position
                    fifo_x_data <= memory(tail);
                    --checks to see if last position in FIFO
                    if (tail = FIFO_DEPTH - 1) then
                        --reset back to 0
                        tail <= 0;
                        --turn off looped 
                        looped <= '0';
                    else
                        --increase read position
                        tail <= tail + 1;
                    end if;
                else 
                    --no data in FIFO, send out 0's
--                    fifo_x_data <= (others => '0');
                    delay <= '0';
                end if;
            else 
                --no data in FIFO, send out 0's
                --fifo_x_data <= (others => '0');
                delay <= '0';
            end if;
            
            --checks to see data is being written to fifo
            if (x_fifo_rts = '1' and fifo_rtr = '1') then
                --makes sure that there is still space to write
                if ((looped = '0') or (head /= tail)) then
                    --write in data into FIFO
                    memory(head) <= x_fifo_data;
                    --checks to see if last index in FIFO
                    if (head = FIFO_DEPTH - 1) then
                        --reset write position
                        head <= 0;
                        --set looped to true
                        looped <= '1';
                    else
                        --increase write position
                        head <= head + 1;
                    end if;
                end if;
            end if;
            
            --checks to see if read and write position match
            if (head = tail) then
                --checks to see if it is looped
                if (looped = '1')then
                    --looped therefor FIFO is full
                    --can send data
                    fifo_rts <= '1';
                    fifo_x_rts <= '1';
                    fifo_rtr <= '0';
                    x_fifo_rtr <= '0';
                else
                    --not looped therefor FIFO is empty
                    --cant send data
                    fifo_rts <= '0';
                    fifo_x_rts <= '0';
                    fifo_rtr <= '1';
                    x_fifo_rtr <= '1';
                end if;
            else
                --read and write dont match therefor data exist
                --but not full
                fifo_rts<= '1';
                fifo_x_rts <= '1';
                fifo_rtr <= '1';
                x_fifo_rtr <= '1';
            end if;
        end if;
	end process;
		
end rtl;
