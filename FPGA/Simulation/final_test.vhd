----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/01/2020 05:09:16 PM
-- Design Name: 
-- Module Name: final_test - rt;
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
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE STD.TEXTIO.all;


entity final_test is
--  Port ( );
end final_test;

architecture rtl of final_test is

--general signals
signal clock            : std_logic := '0';
signal reset            : std_logic := '0';
--connect "pc" to phy ilb tester
signal pc_fpga_TX       : std_logic;
signal pc_fpga_cts      : std_logic;
signal pc_fpga_RX       : std_logic;
signal pc_fpga_rts      : std_logic;
--"pc" write data
signal pc_uart_data     : std_logic_vector(7 downto 0) := (others => '0');
signal pc_uart_rts      : std_logic := '0';
signal pc_uart_rtr      : std_logic ;
--"pc" read data        
signal uart_pc_data     : std_logic_vector(7 downto 0);
signal uart_pc_rts      : std_logic;
signal uart_pc_rtr      : std_logic := '1';

signal counter          : integer := 0;
signal prev_uart_pc_rts : std_logic := '0';
signal index            : integer := 1;
signal receive_counter  : integer := 0;

    component uart is
        GENERIC (   
                    CLK_SPEED               : integer;
                    BAUD_RATE               : integer
                );
        PORT    (   
                    clk                     : in    std_logic;
                    rst                     : in    std_logic;
                    
                    --used to read data from RX FIFO
                    uart_x_rtr              : in    std_logic;
                    uart_x_data             : out   std_logic_vector(7 downto 0);
                    uart_x_rts              : out   std_logic;
                    
                    --used to write data to TX FIFO
                    x_uart_rts              : in    std_logic;
                    x_uart_data             : in    std_logic_vector(7 downto 0);
                    x_uart_rtr              : out   std_logic;
                    
                    --physical ports for UART
                    RX                      : in    std_logic;
                    rts                     : out   std_logic;
                    TX                      : out   std_logic;
                    cts                     : in    std_logic
                );
    end component;
    
    component top_wrapper is
        PORT    (
                    RX                      : in    std_logic;
                    TX                      : out   std_logic;
                    cts                     : in    std_logic;
                    reset                   : in    std_logic;
                    rts                     : out   std_logic;
                    sys_clock               : in    std_logic
            );
    end component;

begin

    fpga : component top_wrapper
        PORT MAP    (  
                        sys_clock       => clock,
                        reset           => reset,
                        RX              => pc_fpga_TX,
                        TX              => pc_fpga_RX,
                        cts             => pc_fpga_rts,
                        rts             => pc_fpga_cts
                    );

    pc : component uart
        GENERIC MAP (
                        CLK_SPEED       => 100000000,
                        BAUD_RATE       => 6000000
                    )
        PORT MAP    (
                        clk             => clock,
                        rst             => reset,
                        uart_x_data     => uart_pc_data,
                        uart_x_rts      => uart_pc_rts,
                        uart_x_rtr      => uart_pc_rtr,
                        x_uart_data     => pc_uart_data,
                        x_uart_rts      => pc_uart_rts,
                        x_uart_rtr      => pc_uart_rtr,
                        RX              => pc_fpga_RX,
                        TX              => pc_fpga_TX,
                        rts             => pc_fpga_rts,
                        cts             => pc_fpga_cts
                    );
                    
    --generates 100MHz Clock
    process 
    begin
            wait for 5 ns;
            clock <= not clock;
    end process;

    --generates 1 time reset
    process 
    begin
        wait until clock = '1';
        
        if (reset = '0') then
            reset <= '1';
        end if;
    end process;

    --writes values over UART and checks to make sure that the values 
    --received are as expected
    process
        --used to open files
        file file_read          : text;
        file file_check         : text;
        --holds a line from the file_read
        variable line_read      : line;
        variable line_check     : line;
        --holds a value to read from the file
        variable temp_read      : std_logic_vector(7 downto 0);
        --used to read in a space character in between values in line_check
        variable space          : character;
        --current file status
        variable readstatus     : file_open_status;
        variable checkstatus    : file_open_status;
        variable read_delay_1   : std_logic := '0';
        variable read_delay_2   : std_logic := '0';
    begin
        if(receive_counter /= 518 * 518 * 2) then
            --opens the text files
            file_open(readstatus, file_read, "C:/Users/ryanm/Downloads/testing/BUILD/matlab/uart_input_bytes.txt", READ_MODE);
            file_open(checkstatus, file_check, "C:/Users/ryanm/Desktop/checkFile.txt", WRITE_MODE);
            --continues to process until  all bytes have been written back
            while (receive_counter < 518*518*2) loop
                wait until clock = '1';
                
                --not in reset
                if (reset = '1') then
                    prev_uart_pc_rts <= uart_pc_rts;
                
                    --checks to see if TX FIFO is full
                    if (pc_uart_rtr = '1' and read_delay_1 = '0' and read_delay_2 = '0') then
                        counter <= counter + 1;
                        read_delay_1 := '1';
                        read_delay_2 := '1';
                        --checks to see if it file_write is not used completely
                        if not ENDFILE(file_read) then
                            --reads in a value from the file
                            readline(file_read, line_read);
                            hread(line_read, temp_read);
                            --set the data to match that in the file
                            pc_uart_data <= std_logic_vector(temp_read);
                        else
                            --read file is empty, set data to 0's
                            pc_uart_data <= (others => '0');
                        end if;
                        --set rts to high
                        pc_uart_rts <= '1';
                        
                    else
                        if(read_delay_1 = '0') then
                            read_delay_2 := '0';
                        end if;
                        read_delay_1 := '0';
                        --fifo is full, set rts to low
                        pc_uart_rts <= '0';
                    end if;
                    
                    --checks the values read back to make sure they match
                    if (uart_pc_rts = '1' and prev_uart_pc_rts = '1') then
                        receive_counter <= receive_counter + 1;
                        hwrite(line_check,uart_pc_data, left, 15);
                        writeline(file_check,line_check);
                    end if;
                end if;
            end loop;
        end if;
            
    end process;


end rtl;
