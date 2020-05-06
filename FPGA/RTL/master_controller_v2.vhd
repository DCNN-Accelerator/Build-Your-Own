----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/29/2020 12:15:18 PM
-- Design Name: 
-- Module Name: master_controller_v2 - rtl
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


entity master_controller_v2 is
    PORT    (
                clk                     : in    std_logic;
                rst                     : in    std_logic;
                
                --data transfer from UART_RX to SoPU
                uart_sopu_rts           : in    std_logic;
                --fake version of uart_sopu_rts so convolution
                --continues after entire image has been sent
                fake_sopu_rts           : out   std_logic;
                uart_sopu_rtr           : out   std_logic;
                uart_sopu_data          : in    std_logic_vector(7 downto 0);
                --data transfer from SoPU to UART_TX
                sopu_uart_rts           : out   std_logic;
                sopu_uart_rtr           : in    std_logic;
                sopu_uart_data          : out   std_logic_vector(7 downto 0);
                
                --data transfer from SoPU to ILB
                sopu_ilb_rts            : out   std_logic;
                sopu_ilb_rtr            : in    std_logic;
                sopu_ilb_data           : out   std_logic_vector(7 downto 0);
                --data transfer from ILB to SoPU (no rtr from SoPU required)
                ilb_sopu_rts            : in    std_logic;
                ilb_sopu_data0          : in    std_logic_vector(7 downto 0);
                ilb_sopu_data1          : in    std_logic_vector(7 downto 0);
                ilb_sopu_data2          : in    std_logic_vector(7 downto 0);
                ilb_sopu_data3          : in    std_logic_vector(7 downto 0);
                ilb_sopu_data4          : in    std_logic_vector(7 downto 0);
                ilb_sopu_data5          : in    std_logic_vector(7 downto 0);
                
                --kernel_bank is full
                kernel_full             : in    std_logic;
                
                --enable fp_sopu
                fp_enable               : out   std_logic;
                --read data from fp_sopu
                fp_out_valid            : in    std_logic;
                fp_out_data             : in    std_logic_vector(15 downto 0)
            );
end master_controller_v2;

architecture rtl of master_controller_v2 is

type my_states is (wait4kernel, wait4rx, send_ilb, wait4ilb, wait4fp, wait4tx);

--current state in controller
signal state                : my_states;
--mimics uart_sopu_rtr so value can be known internally
signal uart_sopu_rtr_int    : std_logic;
--mimics sopu_uart_rts so value can be known internally
signal sopu_uart_rts_int    : std_logic;
--used to latch in value from fp_sop
signal fp_sop_data          : std_logic_vector(15 downto 0);
--counter to determine which byte of fp_sop_data to send
signal fp_sop_counter       : std_logic;
--used to delay a clock cycle between each byte in fp_sop_data
signal delay                : std_logic;
--counter to determine how many bytes have been received
signal rx_counter           : integer range 0 to (518 * 518 - 1);
--counter to determine how many bytes have been sent
signal tx_counter           : integer range 0 to (518 * 518 - 1);

begin
    
    process 
    begin
        wait until clk = '1';
        
        if(rst = '0') then
            fp_sop_counter <= '0';
            sopu_uart_rts_int <= '0';
            delay <= '0';
            fake_sopu_rts <= '0';
            uart_sopu_rtr <= '0';
            uart_sopu_rtr_int <= '0';
            sopu_uart_rts <= '0';
            sopu_uart_data <= (others => '0');
            sopu_ilb_rts <= '0';
            sopu_ilb_data <= (others => '0');
            fp_enable <= '0';
            state <= wait4kernel;
            fp_sop_data <= (others => '0');
            rx_counter <= 0;
            tx_counter <= 0;
        else
            case(state) is
                --waits until kernel is full using data
                when wait4kernel =>
                    if(kernel_full = '1') then
                        state <= wait4rx;
                    end if;
                    --controls the rtr for uart to sopu
                    if(uart_sopu_rts = '1' and uart_sopu_rtr_int = '1')then
                        --new data recieved, turn off rtr
                        uart_sopu_rtr <= '0';
                        uart_sopu_rtr_int <= '0';
                    else
                        --can still accept data, turn on rtr
                        uart_sopu_rtr <= '1';
                        uart_sopu_rtr_int <= '1';
                    end if;
                    
                --kernel is full, wait for new data to be received
                when wait4rx =>
                    --checks to see if all bytes have been received from 
                    --UART_RX and UART_TX is not done
                    if(rx_counter >= (518 * 518 - 1) and tx_counter /= (518 * 518 - 1)) then
                        --all bytes sent, toggle fake_sopu_rts
                        fake_sopu_rts <= '1';
                        uart_sopu_rtr <= '1';
                        
                        state <= send_ilb;
                    else
                        --still receving values from 
                        --controls the rtr for uart to sopu
                        if(uart_sopu_rts = '1' and uart_sopu_rtr_int = '1')then
                            --new data recieved, turn off rtr
                            uart_sopu_rtr <= '0';
                            uart_sopu_rtr_int <= '0';
                            
                            --increase rx_counter since another byte was read
                            rx_counter <= rx_counter + 1;
                            
                            --change state to send value to ILB
                            state <= send_ilb;
                        else
                            --can still accept data, turn on rtr
                            uart_sopu_rtr <= '1';
                            uart_sopu_rtr_int <= '1';
                        end if;
                        --stop sending data to uart
                        sopu_uart_rts <= '0';
                        sopu_uart_rts_int <= '0';
                        --reset counter
                        fp_sop_counter <= '0';
                        delay <= '0';
                    end if;
                
                --sends data to ilb
                when send_ilb =>
                    --turns off values incase fake_sopu_rts was used
                    fake_sopu_rts <= '0';
                    uart_sopu_rtr <= '0';
                    uart_sopu_rtr_int <= '0';
                    
                    --send data to ILB
                    sopu_ilb_data <= uart_sopu_data;
                    sopu_ilb_rts <= '1';
                    
                    --change state to wait for ILB to send values
                    state <= wait4ilb;
                
                --waiting for data to be sent back from ILB
                when wait4ilb =>
                    --turn off rts for ilb
                    sopu_ilb_rts <= '0';
                    --checks to see if ilb sent value back
                    if(ilb_sopu_rts = '1') then
                        --change to wait for value from fp_sop
                        state <= wait4fp;
                        --enable fp_sop to perform convolution
                        fp_enable <= '1';
                    end if;
                
                --waiting for data to be send back from sop
                when wait4fp =>
                    --turn off fp_sop enable
                    fp_enable <= '0';
                    --checks to see if valid data is out
                    if(fp_out_valid = '1') then
                        --saves the data
                        fp_sop_data <= fp_out_data;
                        --changes state to send values over UART_TX
                        state <= wait4tx;
                        delay <= '0';
                        fp_sop_counter <= '0';
                    end if;
                    
                --sends data to UART_TX
                when wait4tx =>
                    --checks to see if enough values have been read to make output valid
                    if(rx_counter >= (518*6 + 7)) then
                        --enough values sent, begin to send fp_sop_data out
                        --checks to see if it should send data out
                        if(sopu_uart_rts_int = '1' and sopu_uart_rtr = '1') then
                            --change so second byte can be written
                            fp_sop_counter <= '1';
                            --set values low so accidental writes dont happen
                            sopu_uart_rts_int <= '0';
                            sopu_uart_rts <= '0';
                            delay <= '0';
                            
                            --changes out of state back to wait4rx
                            if(fp_sop_counter = '1') then
                                state <= wait4rx;
                                --increase counter
                                tx_counter <= tx_counter + 1;
                            end if;
                        else
                            if(delay <= '0') then
                                delay <= '1';
                            else
                                --ensure sopu_uart_rts is high
                                sopu_uart_rts_int <= '1';
                                sopu_uart_rts <= '1';
                                --checks to see which byte to send of the fp_sop_value
                                if(fp_sop_counter = '0') then
                                    --set the value on uart_rts
                                    sopu_uart_data <= fp_sop_data(15 downto 8);
                                else
                                    sopu_uart_data <= fp_sop_data(7 downto 0);
                                end if;
                            end if;
                        end if;
                    else
                        --not enought pixels received
                        state <= wait4rx;
                    end if;
                
                when others =>
                    state <= wait4kernel;
            end case;
        end if;
    end process;

end rtl;
