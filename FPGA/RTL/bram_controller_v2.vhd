----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/30/2019 06:29:58 PM
-- Design Name: 
-- Module Name: bram_controller_v2 - rtl
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

entity bram_controller_v2 is
    PORT    (
                clk                 : in    std_logic;
                rst                 : in    std_logic;
                
                conv_bram_data      : in    std_logic_vector(7 downto 0);
                --bram requesting more data from conv
                conv_bram_rtr       : out   std_logic;
                --conv sent data
                conv_bram_rts       : in    std_logic;
                
                --data sent to image window
                bram_conv_data_0    : out   std_logic_vector(7 downto 0);
                bram_conv_data_1    : out   std_logic_vector(7 downto 0);
                bram_conv_data_2    : out   std_logic_vector(7 downto 0);
                bram_conv_data_3    : out   std_logic_vector(7 downto 0);
                bram_conv_data_4    : out   std_logic_vector(7 downto 0);
                bram_conv_data_5    : out   std_logic_vector(7 downto 0);
                --bram sent data
                bram_conv_rts       : out   std_logic;
                
                --connections to each bram block
                bram_write_data     : out std_logic_vector(7 downto 0);
                --address sent to the bram
                addr                : out std_logic_vector(9 downto 0);
                --enable for each BRAM block
                ena_0               : out std_logic;
                ena_1               : out std_logic;
                ena_2               : out std_logic;
                ena_3               : out std_logic;
                ena_4               : out std_logic;
                ena_5               : out std_logic;
                --write enable for each BRAM block
                wena_0              : out std_logic_vector(0 downto 0);
                wena_1              : out std_logic_vector(0 downto 0);
                wena_2              : out std_logic_vector(0 downto 0);
                wena_3              : out std_logic_vector(0 downto 0);
                wena_4              : out std_logic_vector(0 downto 0);
                wena_5              : out std_logic_vector(0 downto 0);
                --data read from each bram block
                data_0              : in std_logic_vector(7 downto 0);
                data_1              : in std_logic_vector(7 downto 0);
                data_2              : in std_logic_vector(7 downto 0);
                data_3              : in std_logic_vector(7 downto 0);
                data_4              : in std_logic_vector(7 downto 0);
                data_5              : in std_logic_vector(7 downto 0)
            );
end bram_controller_v2;

architecture rtl of bram_controller_v2 is

type my_states is (idle, delay1, delay2, read);

signal bram_addr        : integer range 0 to 517;
signal bram_counter     : integer range 0 to 5;
signal state            : my_states;

begin
    process
    begin
        --waits for rising edge
        wait until clk = '1';
        
        if(rst = '0') then
            ena_0 <= '0';
            ena_1 <= '0';
            ena_2 <= '0';
            ena_3 <= '0';
            ena_4 <= '0';
            ena_5 <= '0';
            wena_0 <= (others => '0');
            wena_1 <= (others => '0');
            wena_2 <= (others => '0');
            wena_3 <= (others => '0');
            wena_4 <= (others => '0');
            wena_5 <= (others => '0');
            bram_conv_data_0 <= (others => '0');
            bram_conv_data_1 <= (others => '0');
            bram_conv_data_2 <= (others => '0');
            bram_conv_data_3 <= (others => '0');
            bram_conv_data_4 <= (others => '0');
            bram_conv_data_5 <= (others => '0');
            conv_bram_rtr <= '1';
            bram_conv_rts <= '0';
            bram_addr <= 0;
            addr <= (others => '0');
            bram_counter <= 0;
            state <= idle;
            bram_write_data <= (others => '0');
        else
            case(state) is
                when idle =>
                    --set data written to false
                    bram_conv_rts <= '0';
                    --checks to see if SOP sent any data
                    if(conv_bram_rts = '1') then
                        --set the ready to receive data low
                        --conv_bram_rtr <= '0';
                        --puts the data on the line to write to the BRAM
                        bram_write_data <= conv_bram_data;
                        --enables all the brams
                        ena_0 <= '1';
                        ena_1 <= '1';
                        ena_2 <= '1';
                        ena_3 <= '1';
                        ena_4 <= '1';
                        ena_5 <= '1';
                        --outputs address to BRAM
                        addr <= std_logic_vector(to_unsigned(bram_addr, 10));
                        --determines which write enable to turn on
                        case(bram_counter) is
                            when 0 =>
                                wena_0 <= (others => '1');
                                wena_1 <= (others => '0');
                                wena_2 <= (others => '0');
                                wena_3 <= (others => '0');
                                wena_4 <= (others => '0');
                                wena_5 <= (others => '0');
                                
                            when 1 =>
                                wena_0 <= (others => '0');
                                wena_1 <= (others => '1');
                                wena_2 <= (others => '0');
                                wena_3 <= (others => '0');
                                wena_4 <= (others => '0');
                                wena_5 <= (others => '0');
                                
                            when 2 =>
                                wena_0 <= (others => '0');
                                wena_1 <= (others => '0');
                                wena_2 <= (others => '1');
                                wena_3 <= (others => '0');
                                wena_4 <= (others => '0');
                                wena_5 <= (others => '0');
                            
                            when 3 =>
                                wena_0 <= (others => '0');
                                wena_1 <= (others => '0');
                                wena_2 <= (others => '0');
                                wena_3 <= (others => '1');
                                wena_4 <= (others => '0');
                                wena_5 <= (others => '0');
                            
                            when 4 =>
                                wena_0 <= (others => '0');
                                wena_1 <= (others => '0');
                                wena_2 <= (others => '0');
                                wena_3 <= (others => '0');
                                wena_4 <= (others => '1');
                                wena_5 <= (others => '0');
                                
                            when 5 =>
                                wena_0 <= (others => '0');
                                wena_1 <= (others => '0');
                                wena_2 <= (others => '0');
                                wena_3 <= (others => '0');
                                wena_4 <= (others => '0');
                                wena_5 <= (others => '1');
                            
                            when others =>
                                wena_0 <= (others => '0');
                                wena_1 <= (others => '0');
                                wena_2 <= (others => '0');
                                wena_3 <= (others => '0');
                                wena_4 <= (others => '0');
                                wena_5 <= (others => '0');
                            
                        end case;
                        
                        
                        --changes to the write state
                        state <= delay1;
                    else
                        --set the ready to receive data high
                        --conv_bram_rtr <= '1';
                        --stay in idle state
                        state <= idle;
                    end if;
                
                when delay1 =>
                    state <= delay2;
                
                --in the process of waiting for BRAM to read
                when delay2 =>
                    --change state to read 
                    state <= read;
                    --set data sent to true
                    bram_conv_rts <= '1';
                
                --reads in the values from the BRAM and sets them to the correct output
                when read =>
                    --set the data
                    case(bram_counter) is
                        when 0 =>
                            bram_conv_data_0 <= data_0;
                            bram_conv_data_1 <= data_1;
                            bram_conv_data_2 <= data_2;
                            bram_conv_data_3 <= data_3;
                            bram_conv_data_4 <= data_4;
                            bram_conv_data_5 <= data_5;
            
                        when 1 =>
                            bram_conv_data_0 <= data_1;
                            bram_conv_data_1 <= data_2;
                            bram_conv_data_2 <= data_3;
                            bram_conv_data_3 <= data_4;
                            bram_conv_data_4 <= data_5;
                            bram_conv_data_5 <= data_0;
            
                        when 2 =>
                            bram_conv_data_0 <= data_2;
                            bram_conv_data_1 <= data_3;
                            bram_conv_data_2 <= data_4;
                            bram_conv_data_3 <= data_5;
                            bram_conv_data_4 <= data_0;
                            bram_conv_data_5 <= data_1;
            
                        when 3 =>
                            bram_conv_data_0 <= data_3;
                            bram_conv_data_1 <= data_4;
                            bram_conv_data_2 <= data_5;
                            bram_conv_data_3 <= data_0;
                            bram_conv_data_4 <= data_1;
                            bram_conv_data_5 <= data_2;
            
                        when 4 =>
                            bram_conv_data_0 <= data_4;
                            bram_conv_data_1 <= data_5;
                            bram_conv_data_2 <= data_0;
                            bram_conv_data_3 <= data_1;
                            bram_conv_data_4 <= data_2;
                            bram_conv_data_5 <= data_3;
            
                        when 5 =>
                            bram_conv_data_0 <= data_5;
                            bram_conv_data_1 <= data_0;
                            bram_conv_data_2 <= data_1;
                            bram_conv_data_3 <= data_2;
                            bram_conv_data_4 <= data_3;
                            bram_conv_data_5 <= data_4;
            
                        when others =>
                            bram_conv_data_0 <= data_0;
                            bram_conv_data_1 <= data_1;
                            bram_conv_data_2 <= data_2;
                            bram_conv_data_3 <= data_3;
                            bram_conv_data_4 <= data_4;
                            bram_conv_data_5 <= data_5;
                    end case;
                    
                    --turns off all enables
                    ena_0 <= '0';
                    ena_1 <= '0';
                    ena_2 <= '0';
                    ena_3 <= '0';
                    ena_4 <= '0';
                    ena_5 <= '0';
                    --ready to receive is true
                    --conv_bram_rtr <= '1';
                    --increase address 
                    if(bram_addr = 517) then
                        bram_addr <= 0;
                        --increases bram_counter
                        if(bram_counter = 5) then
                            bram_counter <= 0;
                        else
                            bram_counter <= bram_counter + 1;
                        end if;
                    else
                        bram_addr <= bram_addr + 1;
                    end if;
                    --move back to idle
                    state <= idle;
                    
                when others =>
                    state <= idle;
            end case;
        end if;
    end process;
end rtl;
