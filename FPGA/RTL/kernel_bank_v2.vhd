----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/29/2020 12:24:27 PM
-- Design Name: 
-- Module Name: kernel_bank_v2 - rtl
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

entity kernel_bank_v2 is
    PORT    (
                clk                 : in    std_logic;
                rst                 : in    std_logic;
                
                --used to determine when data has been
                --sent from UART_RX
                uart_sopu_rts       : in    std_logic;
                uart_sopu_rtr       : in    std_logic;
                uart_sopu_data      : in    std_logic_vector(7 downto 0);
                
                --used to let master controller know when kernel is full
                kernel_full         : out   std_logic;
                
                --full kernel output
                kernel_reg0         : out   std_logic_vector(7 downto 0);
                kernel_reg1         : out   std_logic_vector(7 downto 0);
                kernel_reg2         : out   std_logic_vector(7 downto 0);
                kernel_reg3         : out   std_logic_vector(7 downto 0);
                kernel_reg4         : out   std_logic_vector(7 downto 0);
                kernel_reg5         : out   std_logic_vector(7 downto 0);
                kernel_reg6         : out   std_logic_vector(7 downto 0);
                kernel_reg7         : out   std_logic_vector(7 downto 0);
                kernel_reg8         : out   std_logic_vector(7 downto 0);
                kernel_reg9         : out   std_logic_vector(7 downto 0);
                kernel_reg10         : out   std_logic_vector(7 downto 0);
                kernel_reg11        : out   std_logic_vector(7 downto 0);
                kernel_reg12        : out   std_logic_vector(7 downto 0);
                kernel_reg13        : out   std_logic_vector(7 downto 0);
                kernel_reg14        : out   std_logic_vector(7 downto 0);
                kernel_reg15        : out   std_logic_vector(7 downto 0);
                kernel_reg16        : out   std_logic_vector(7 downto 0);
                kernel_reg17        : out   std_logic_vector(7 downto 0);
                kernel_reg18        : out   std_logic_vector(7 downto 0);
                kernel_reg19        : out   std_logic_vector(7 downto 0);
                kernel_reg20        : out   std_logic_vector(7 downto 0);
                kernel_reg21        : out   std_logic_vector(7 downto 0);
                kernel_reg22        : out   std_logic_vector(7 downto 0);
                kernel_reg23        : out   std_logic_vector(7 downto 0);
                kernel_reg24        : out   std_logic_vector(7 downto 0);
                kernel_reg25        : out   std_logic_vector(7 downto 0);
                kernel_reg26        : out   std_logic_vector(7 downto 0);
                kernel_reg27        : out   std_logic_vector(7 downto 0);
                kernel_reg28        : out   std_logic_vector(7 downto 0);
                kernel_reg29        : out   std_logic_vector(7 downto 0);
                kernel_reg30        : out   std_logic_vector(7 downto 0);
                kernel_reg31        : out   std_logic_vector(7 downto 0);
                kernel_reg32        : out   std_logic_vector(7 downto 0);
                kernel_reg33        : out   std_logic_vector(7 downto 0);
                kernel_reg34        : out   std_logic_vector(7 downto 0);
                kernel_reg35        : out   std_logic_vector(7 downto 0);
                kernel_reg36        : out   std_logic_vector(7 downto 0);
                kernel_reg37        : out   std_logic_vector(7 downto 0);
                kernel_reg38        : out   std_logic_vector(7 downto 0);
                kernel_reg39        : out   std_logic_vector(7 downto 0);
                kernel_reg40        : out   std_logic_vector(7 downto 0);
                kernel_reg41        : out   std_logic_vector(7 downto 0);
                kernel_reg42        : out   std_logic_vector(7 downto 0);
                kernel_reg43        : out   std_logic_vector(7 downto 0);
                kernel_reg44        : out   std_logic_vector(7 downto 0);
                kernel_reg45        : out   std_logic_vector(7 downto 0);
                kernel_reg46        : out   std_logic_vector(7 downto 0);
                kernel_reg47        : out   std_logic_vector(7 downto 0);
                kernel_reg48        : out   std_logic_vector(7 downto 0)
            );
end kernel_bank_v2;

architecture rtl of kernel_bank_v2 is

type byte_array is array(48 downto 0) of std_logic_vector(7 downto 0);

--internal kernel bank
signal kernel_array     : byte_array;
--needs one clock delay to read from uart
signal delay            : std_logic;
--counter to determine if kernel_bank is full
signal counter          : integer range 0 to 49;

begin
    
    --shifts values into kernel bank if not full
    process
    begin
        wait until clk = '1';
        
        if(rst = '0') then
            kernel_full <= '0';
            kernel_array <= (others => (others => '0'));
            counter <= 0;
            delay <= '0';
        else
            --checks to see if it is full
            if(counter = 49) then
                --kernel bank full, keep old values
                kernel_array(0) <= kernel_array(0);
                kernel_array(1) <= kernel_array(1);
                kernel_array(2) <= kernel_array(2);
                kernel_array(3) <= kernel_array(3);
                kernel_array(4) <= kernel_array(4);
                kernel_array(5) <= kernel_array(5);
                kernel_array(6) <= kernel_array(6);
                kernel_array(7) <= kernel_array(7);
                kernel_array(8) <= kernel_array(8);
                kernel_array(9) <= kernel_array(9);
                kernel_array(10) <= kernel_array(10);
                kernel_array(11) <= kernel_array(11);
                kernel_array(12) <= kernel_array(12);
                kernel_array(13) <= kernel_array(13);
                kernel_array(14) <= kernel_array(14);
                kernel_array(15) <= kernel_array(15);
                kernel_array(16) <= kernel_array(16);
                kernel_array(17) <= kernel_array(17);
                kernel_array(18) <= kernel_array(18);
                kernel_array(19) <= kernel_array(19);
                kernel_array(20) <= kernel_array(20);
                kernel_array(21) <= kernel_array(21);
                kernel_array(22) <= kernel_array(22);
                kernel_array(23) <= kernel_array(23);
                kernel_array(24) <= kernel_array(24);
                kernel_array(25) <= kernel_array(25);
                kernel_array(26) <= kernel_array(26);
                kernel_array(27) <= kernel_array(27);
                kernel_array(28) <= kernel_array(28);
                kernel_array(29) <= kernel_array(29);
                kernel_array(30) <= kernel_array(30);
                kernel_array(31) <= kernel_array(31);
                kernel_array(32) <= kernel_array(32);
                kernel_array(33) <= kernel_array(33);
                kernel_array(34) <= kernel_array(34);
                kernel_array(35) <= kernel_array(35);
                kernel_array(36) <= kernel_array(36);
                kernel_array(37) <= kernel_array(37);
                kernel_array(38) <= kernel_array(38);
                kernel_array(39) <= kernel_array(39);
                kernel_array(40) <= kernel_array(40);
                kernel_array(41) <= kernel_array(41);
                kernel_array(42) <= kernel_array(42);
                kernel_array(43) <= kernel_array(43);
                kernel_array(44) <= kernel_array(44);
                kernel_array(45) <= kernel_array(45);
                kernel_array(46) <= kernel_array(46);
                kernel_array(47) <= kernel_array(47);
                kernel_array(48) <= kernel_array(48);
                
                --set kernel full
                kernel_full <= '1';
            else
                if(delay = '0') then
                    --checks to see if new data has been sent from UART_RX
                    if(uart_sopu_rtr = '1' and uart_sopu_rts = '1') then
                        delay <= '1';
                    end if;
                else
                    --turn off delay
                    delay <= '0';
                    
                    --shift old data
                    kernel_array(0) <= kernel_array(1);
                    kernel_array(1) <= kernel_array(2);
                    kernel_array(2) <= kernel_array(3);
                    kernel_array(3) <= kernel_array(4);
                    kernel_array(4) <= kernel_array(5);
                    kernel_array(5) <= kernel_array(6);
                    kernel_array(6) <= kernel_array(7);
                    kernel_array(7) <= kernel_array(8);
                    kernel_array(8) <= kernel_array(9);
                    kernel_array(9) <= kernel_array(10);
                    kernel_array(10) <= kernel_array(11);
                    kernel_array(11) <= kernel_array(12);
                    kernel_array(12) <= kernel_array(13);
                    kernel_array(13) <= kernel_array(14);
                    kernel_array(14) <= kernel_array(15);
                    kernel_array(15) <= kernel_array(16);
                    kernel_array(16) <= kernel_array(17);
                    kernel_array(17) <= kernel_array(18);
                    kernel_array(18) <= kernel_array(19);
                    kernel_array(19) <= kernel_array(20);
                    kernel_array(20) <= kernel_array(21);
                    kernel_array(21) <= kernel_array(22);
                    kernel_array(22) <= kernel_array(23);
                    kernel_array(23) <= kernel_array(24);
                    kernel_array(24) <= kernel_array(25);
                    kernel_array(25) <= kernel_array(26);
                    kernel_array(26) <= kernel_array(27);
                    kernel_array(27) <= kernel_array(28);
                    kernel_array(28) <= kernel_array(29);
                    kernel_array(29) <= kernel_array(30);
                    kernel_array(30) <= kernel_array(31);
                    kernel_array(31) <= kernel_array(32);
                    kernel_array(32) <= kernel_array(33);
                    kernel_array(33) <= kernel_array(34);
                    kernel_array(34) <= kernel_array(35);
                    kernel_array(35) <= kernel_array(36);
                    kernel_array(36) <= kernel_array(37);
                    kernel_array(37) <= kernel_array(38);
                    kernel_array(38) <= kernel_array(39);
                    kernel_array(39) <= kernel_array(40);
                    kernel_array(40) <= kernel_array(41);
                    kernel_array(41) <= kernel_array(42);
                    kernel_array(42) <= kernel_array(43);
                    kernel_array(43) <= kernel_array(44);
                    kernel_array(44) <= kernel_array(45);
                    kernel_array(45) <= kernel_array(46);
                    kernel_array(46) <= kernel_array(47);
                    kernel_array(47) <= kernel_array(48);
                    --save new value
                    kernel_array(48) <= uart_sopu_data;
                    
                    --increase counter 
                    counter <= counter + 1;
                end if;
            end if;
        end if;
    end process;
    
    --sets kernel_reg equal to kernel_array
    kernel_reg0 <= kernel_array(0);
    kernel_reg1 <= kernel_array(1);
    kernel_reg2 <= kernel_array(2);
    kernel_reg3 <= kernel_array(3);
    kernel_reg4 <= kernel_array(4);
    kernel_reg5 <= kernel_array(5);
    kernel_reg6 <= kernel_array(6);
    kernel_reg7 <= kernel_array(7);
    kernel_reg8 <= kernel_array(8);
    kernel_reg9 <= kernel_array(9);
    kernel_reg10 <= kernel_array(10);
    kernel_reg11 <= kernel_array(11);
    kernel_reg12 <= kernel_array(12);
    kernel_reg13 <= kernel_array(13);
    kernel_reg14 <= kernel_array(14);
    kernel_reg15 <= kernel_array(15);
    kernel_reg16 <= kernel_array(16);
    kernel_reg17 <= kernel_array(17);
    kernel_reg18 <= kernel_array(18);
    kernel_reg19 <= kernel_array(19);
    kernel_reg20 <= kernel_array(20);
    kernel_reg21 <= kernel_array(21);
    kernel_reg22 <= kernel_array(22);
    kernel_reg23 <= kernel_array(23);
    kernel_reg24 <= kernel_array(24);
    kernel_reg25 <= kernel_array(25);
    kernel_reg26 <= kernel_array(26);
    kernel_reg27 <= kernel_array(27);
    kernel_reg28 <= kernel_array(28);
    kernel_reg29 <= kernel_array(29);
    kernel_reg30 <= kernel_array(30);
    kernel_reg31 <= kernel_array(31);
    kernel_reg32 <= kernel_array(32);
    kernel_reg33 <= kernel_array(33);
    kernel_reg34 <= kernel_array(34);
    kernel_reg35 <= kernel_array(35);
    kernel_reg36 <= kernel_array(36);
    kernel_reg37 <= kernel_array(37);
    kernel_reg38 <= kernel_array(38);
    kernel_reg39 <= kernel_array(39);
    kernel_reg40 <= kernel_array(40);
    kernel_reg41 <= kernel_array(41);
    kernel_reg42 <= kernel_array(42);
    kernel_reg43 <= kernel_array(43);
    kernel_reg44 <= kernel_array(44);
    kernel_reg45 <= kernel_array(45);
    kernel_reg46 <= kernel_array(46);
    kernel_reg47 <= kernel_array(47);
    kernel_reg48 <= kernel_array(48);
    
end rtl;
