----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/01/2019 01:28:34 PM
-- Design Name: 
-- Module Name: uart - rtl
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

entity uart is
    GENERIC (   
                CLK_SPEED               : integer   := 100_000_000;
                BAUD_RATE               : integer   := 6_000_000
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
end uart;

architecture rtl of uart is

signal uart_fifo_rts        : std_logic;
signal uart_fifo_rtr        : std_logic;
signal uart_fifo_data       : std_logic_vector(7 downto 0);

signal fifo_uart_rts        : std_logic;
signal fifo_uart_rtr        : std_logic;
signal fifo_uart_data       : std_logic_vector(7 downto 0);


    component uart_rx is
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
                    
                    uart_fifo_data              : out   std_logic_vector(7 downto 0);
                    uart_fifo_rts               : out   std_logic;
                    uart_fifo_rtr               : in    std_logic
                );
    end component;
    
    component uart_tx is
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
               
                    --enable line to send data
                    fifo_uart_rts               : in    std_logic;
                    --used to accept data from fifo
                    fifo_uart_rtr               : out   std_logic;
                    --data to send
                    fifo_uart_data              : in    std_logic_vector(7 downto 0)
                );
    end component;
    
    
    component STD_FIFO is
        GENERIC (
                    constant DATA_WIDTH         : positive := 8;
                    constant FIFO_DEPTH         : positive := 256
                );
        PORT    ( 
                    clk		                : in  std_logic;
                    rst                        : in  std_logic;
                    
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
                    fifo_x_data                : out std_logic_vector (DATA_WIDTH - 1 downto 0)
                );
    end component;
    
begin

    rx_fifo: STD_FIFO
        GENERIC MAP (
                        DATA_WIDTH      => 8,
                        FIFO_DEPTH      => 8
                    )
        PORT MAP    (
                        clk             => clk,
                        rst             => rst,
                        x_fifo_rts      => uart_fifo_rts,
                        x_fifo_rtr      => uart_fifo_rtr,
                        x_fifo_data     => uart_fifo_data,
                        fifo_x_rts      => uart_x_rts,
                        fifo_x_rtr      => uart_x_rtr,
                        fifo_x_data     => uart_x_data
                     );
    
    
    my_uart_rx: uart_rx
        GENERIC MAP (
                        CLK_SPEED       => CLK_SPEED,
                        BAUD_RATE       => BAUD_RATE
                    )
        PORT MAP    (
                        clk             => clk,
                        rst             => rst,
                        rx              => RX,
                        rts             => rts,
                        uart_fifo_data  => uart_fifo_data,
                        uart_fifo_rtr   => uart_fifo_rtr,
                        uart_fifo_rts   => uart_fifo_rts
                    );
                    
    tx_fifo: STD_FIFO
        GENERIC MAP (
                        DATA_WIDTH      => 8,
                        FIFO_DEPTH      => 8
                    )
        PORT MAP    (
                        clk             => clk,
                        rst             => rst,
                        x_fifo_rts      => x_uart_rts,
                        x_fifo_rtr      => x_uart_rtr,
                        x_fifo_data     => x_uart_data,
                        fifo_x_rts      => fifo_uart_rts,
                        fifo_x_rtr      => fifo_uart_rtr,
                        fifo_x_data     => fifo_uart_data
                    );
                    
    my_uart_tx: uart_tx
        GENERIC MAP (   
                        CLK_SPEED       => CLK_SPEED,
                        BAUD_RATE       => BAUD_RATE
                    )
        PORT MAP    (
                        clk             => clk,
                        rst             => rst,
                        tx              => TX,
                        cts             => cts,
                        fifo_uart_rts   => fifo_uart_rts,
                        fifo_uart_rtr   => fifo_uart_rtr,
                        fifo_uart_data  => fifo_uart_data
                    );

end rtl;
