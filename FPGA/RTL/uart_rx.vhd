----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/08/2019 01:45:55 PM
-- Design Name: 
-- Module Name: uart_rx - rtl
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
use IEEE.NUMERIC_STD.ALL;


entity uart_rx is
    GENERIC (
                CLK_SPEED                   :   integer;
                BAUD_RATE                   :   integer
            );
    PORT    (
                clk                         : in    std_logic;
                rst                         : in    std_logic;
                
                --data from uart
                rx                          : in    std_logic;
                --flag used to show FPGA is requesting data from PC
                rts                         : out   std_logic;
                
                --transfers data out of uart_rx to a fifo
                uart_fifo_data              : out   std_logic_vector(7 downto 0);
                uart_fifo_rts               : out   std_logic;
                uart_fifo_rtr               : in    std_logic
            );
end uart_rx;

architecture rtl of uart_rx is

--state machine
type my_states is (idle, start, running, stop, send);

--current state of the machine
signal state            : my_states;
--counter used for clocks per bit
signal counter          : integer range 0 to CLK_SPEED / BAUD_RATE - 1;
--counts amount of bits received
signal bits             : integer range 0 to 7;
--holds all the data received
signal data_in          : std_logic_vector(7 downto 0);

begin


    --process handles the state machine
    process 
    begin   
        --waits until rising edge
        wait until clk = '1';
        
        if(rst = '0') then
            state <= idle;
            counter <= 0;
            bits <= 0;
            data_in <= (others => '0');
            uart_fifo_data <= (others => '0');
            uart_fifo_rts <= '0';
            rts <= '0';
        else
            --examines state to determine what to do 
            case(state) is
                --waits for start bit
                when idle =>
                    --in idle state so reset counter and bits read
                    counter <= 0;
                    bits <= 0;
                    data_in <= (others => '0');
                    
                    --checks to make sure that the fifo ready to receive
                    --before setting ready to send to true
                    if(uart_fifo_rtr = '1') then
                        rts <= '1';
                    else 
                        rts <= '0';
                    end if;
                    
                    --checks for start bit
                    if(rx = '0' and uart_fifo_rtr = '1') then
                        state <= start;
                    end if;
                
                --ensure start bit remains stable for half the clock cycles
                when start =>
                    --checks to ensure rx remains low
                    if(rx = '0')then
                        --checks to see if counter made it halfway
                        if(counter = (CLK_SPEED / BAUD_RATE) / 2) then
                            --start bit accepted, move to running
                            state <= running;
                            --reset counter
                            counter <= 0;
                        else
                            --increase counter 
                            counter <= counter + 1;
                        end if;
                    else
                        --rx was not stable, move to idle
                        state <= idle;
                    end if;
                    
                --saves in a byte of data. Data is considered stable in the middle of counter
                --when moved to this state, it was already middle of counter so wait full counter
                --before saving next bit
                when running =>
                    --waited for data to be ready
                    if(counter = (CLK_SPEED / BAUD_RATE) - 1) then
                        --checks to see if all bits have been read
                        if(bits = 7) then
                            --moves to stop bit
                            state <= stop;
                            counter <= 0;
                        else
                            --not all bits have been read,
                            bits <= bits + 1;
                            counter <= 0;
                        end if;
                        --save new data and shift old (LSB is sent first)
                        data_in(7) <= rx;
                        data_in(6 downto 0) <= data_in(7 downto 1);
                    else
                        --data not ready, continue to count
                        counter <= counter + 1;
                    end if;
                    
                --waits for stop bit and sets flag for data to be read
                when stop =>
                    --waits for counter to reach end of stop bit
                    if(counter = (CLK_SPEED / BAUD_RATE) - 1) then
                        state <= send;
                        --set rts to low since stop bit was sent
                        rts <= '0';
                        --set the data ready to send 
                        uart_fifo_rts <= '1'; 
                        --saves data read over rx to output
                        uart_fifo_data <= data_in;
                    else
                        --continue to wait
                        counter <= counter + 1;
                    end if;
                
                --waits in this state until uart_fifo_rtr is high
                when send =>
                    if(uart_fifo_rtr = '1') then
                        --reset back to idle to recieve more data
                        state <= idle;
                        --set rts to low since data was sent
                        uart_fifo_rts <= '0';
                    end if;
                
                --unknown state, should not occur
                when others =>
                    state <= idle;
            end case; 
        end if;
    end process;
    
end rtl;
