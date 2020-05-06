----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/08/2019 01:45:55 PM
-- Design Name: 
-- Module Name: uart_tx - rtl
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

entity uart_tx is
    GENERIC (
                CLK_SPEED                   :   integer;
                BAUD_RATE                   :   integer
            );
    PORT    (
                clk                         : in    std_logic;
                rst                         : in    std_logic;
           
                --data sent over uart
                tx                          : out   std_logic;
                --external flag for PC requesting data
                cts                         : in   std_logic;
           
                --transfers data from fifo to uart_tx
                fifo_uart_rts               : in    std_logic;
                fifo_uart_rtr               : out   std_logic;
                fifo_uart_data              : in    std_logic_vector(7 downto 0)
            );
end uart_tx;

architecture rtl of uart_tx is

--state machine
type my_states is (idle, temp, save, start, running, stop, delay);

--current state of the machine
signal state            : my_states;
--counter used for clocks per bit
signal counter          : integer range 0 to CLK_SPEED / BAUD_RATE - 1;
--counts amount of bits sent
signal bits             : integer range 0 to 7;
--signal that latches in data when enable goes high
signal latch            : std_logic_vector(7 downto 0);
--saves previous state of cts
signal cts_prev         : std_logic;
--mimics fifo_uart_rtr
signal uart_rtr         : std_logic;

begin

    --process handles states
    process
    begin
        --waits for rising edge
        wait until clk = '1';
        
        if(rst = '0') then
            tx <= '1';
            fifo_uart_rtr <= '1';
            uart_rtr <= '1';
            state <= idle;
            counter <= 0;
            bits <= 0;
            latch <= (others => '0');
            cts_prev <= '0';
        else
            cts_prev <= cts;
            
            if(cts = '1') then
                case(state) is
                    --waits for enable to be set
                    when idle =>
                        --checks to see if enable is set
                        if(fifo_uart_rts = '1') then
                        --set flag for data sent to false
                        fifo_uart_rtr <= '1';
                        uart_rtr <= '0';
                            --checks to make sure that the cts and fifo_uart_rtr were set
                            if(cts_prev = '1' and uart_rtr = '1') then
                                --move to save in data bit
                                state <= temp; --was state save
                            else
                                --moves to temp so it has a clock period delay before saving data
                                state <= temp;
                            end if;

                            counter <= 0;
                            bits <= 0;
                        else
                            --set flag for data sent to false
                            fifo_uart_rtr <= '1';
                            uart_rtr <= '1';
                            --not enabled, reset values
                            tx <= '1';
                            counter <= 0;
                            bits <= 0;
                        end if;
                        
                    --moves to save the data 
                    when temp =>
                        state <= save;
                        --turns of rtr
                        fifo_uart_rtr <= '0';
                        uart_rtr <= '0';
                    
                    --saves in the data from the data_in line
                    when save =>
                        state <= start;
                        --latch in data
                        latch <= fifo_uart_data;
                        --turns off rtr
                        fifo_uart_rtr <= '0';
                        uart_rtr <= '0';
                    
                    --sends out start bit
                    when start =>
                        --checks to see if it waited long enough
                        if(counter = (CLK_SPEED / BAUD_RATE) - 1) then
                            --reset counter and move to send out data
                            counter <= 0;
                            state <= running;
                        else
                            --wait for counter to finish
                            counter <= counter + 1;
                            --set the tx line to low 
                            tx <= '0';
                        end if;
                        
                    --sends out byte over uart
                    when running =>
                        --outputs data LSB first 
                        tx <= latch(0);
                        
                        --waits for data to be ready to update
                        if(counter = (CLK_SPEED / BAUD_RATE) - 1) then
                            --reset counter
                            counter <= 0;
                            --checks to see if all data has been sent
                            if(bits = 7) then
                                --moves to stop bit
                                state <= stop;
                            else
                                --increase bits read
                                bits <= bits + 1;
                                --shift latch 
                                latch(6 downto 0) <= latch(7 downto 1);
                            end if;
                        else    
                            --continue to count 
                            counter <= counter + 1;
                        end if;
                    
                    --waits until stop bit is done  
                    when stop =>
                        --sets stop bit
                        tx <= '1';
                        if(counter = (CLK_SPEED / BAUD_RATE) - 1) then
                            --move to delay by 1 clock 
                            state <= delay;
                            counter <= 0;
                        else    
                            counter <= counter + 1;
                            state <= stop;
                        end if;
                        
                    --delay 
                    when delay =>
                        if(counter = (CLK_SPEED / BAUD_RATE) - 1) then
                            --move to delay by 1 clock 
                            state <= idle;
                            counter <= 0;
                            --set flag for data sent to false
                            fifo_uart_rtr <= '0';
                            uart_rtr <= '1';
                        else    
                            counter <= counter + 1;
                            state <= delay;
                        end if;
                    
                    --state is unknown, should not occur
                    when others =>
                        state <= idle;
                end case;
            else
                --cts is low so move to idle and dont request any datas
                --state <= idle;
                fifo_uart_rtr <= '0';
                uart_rtr <= '0';
            end if;
        end if;
    end process;

end rtl;
