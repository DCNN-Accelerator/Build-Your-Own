----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/29/2020 01:08:39 PM
-- Design Name: 
-- Module Name: img_window_v2 - rtl
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

entity img_window_v2 is
    PORT    (
                clk                 : in    std_logic;
                rst                 : in    std_logic;
                
                --used to determine when data has been
                --sent from UART_RX
                uart_sopu_rts       : in    std_logic;
                uart_sopu_rtr       : in    std_logic;
                uart_sopu_data      : in    std_logic_vector(7 downto 0);
                --fake uart_sopu_rts signal used to continue convolution
                --after entire image has been sent. Needed due to delay
                --before convolution valid
                fake_sopu_rts       : in    std_logic;
                
                --used to determine when data has been 
                --sent from ILB
                ilb_sopu_rts        : in    std_logic;
                ilb_sopu_data0      : in    std_logic_vector(7 downto 0);
                ilb_sopu_data1      : in    std_logic_vector(7 downto 0);
                ilb_sopu_data2      : in    std_logic_vector(7 downto 0);
                ilb_sopu_data3      : in    std_logic_vector(7 downto 0);
                ilb_sopu_data4      : in    std_logic_vector(7 downto 0);
                ilb_sopu_data5      : in    std_logic_vector(7 downto 0);
                
                --used to know when kernel is full
                kernel_full         : in    std_logic;
                
                --full image window output
                img_wd_reg0         : out   std_logic_vector(7 downto 0);
                img_wd_reg1         : out   std_logic_vector(7 downto 0);
                img_wd_reg2         : out   std_logic_vector(7 downto 0);
                img_wd_reg3         : out   std_logic_vector(7 downto 0);
                img_wd_reg4         : out   std_logic_vector(7 downto 0);
                img_wd_reg5         : out   std_logic_vector(7 downto 0);
                img_wd_reg6         : out   std_logic_vector(7 downto 0);
                img_wd_reg7         : out   std_logic_vector(7 downto 0);
                img_wd_reg8         : out   std_logic_vector(7 downto 0);
                img_wd_reg9         : out   std_logic_vector(7 downto 0);
                img_wd_reg10        : out   std_logic_vector(7 downto 0);
                img_wd_reg11        : out   std_logic_vector(7 downto 0);
                img_wd_reg12        : out   std_logic_vector(7 downto 0);
                img_wd_reg13        : out   std_logic_vector(7 downto 0);
                img_wd_reg14        : out   std_logic_vector(7 downto 0);
                img_wd_reg15        : out   std_logic_vector(7 downto 0);
                img_wd_reg16        : out   std_logic_vector(7 downto 0);
                img_wd_reg17        : out   std_logic_vector(7 downto 0);
                img_wd_reg18        : out   std_logic_vector(7 downto 0);
                img_wd_reg19        : out   std_logic_vector(7 downto 0);
                img_wd_reg20        : out   std_logic_vector(7 downto 0);
                img_wd_reg21        : out   std_logic_vector(7 downto 0);
                img_wd_reg22        : out   std_logic_vector(7 downto 0);
                img_wd_reg23        : out   std_logic_vector(7 downto 0);
                img_wd_reg24        : out   std_logic_vector(7 downto 0);
                img_wd_reg25        : out   std_logic_vector(7 downto 0);
                img_wd_reg26        : out   std_logic_vector(7 downto 0);
                img_wd_reg27        : out   std_logic_vector(7 downto 0);
                img_wd_reg28        : out   std_logic_vector(7 downto 0);
                img_wd_reg29        : out   std_logic_vector(7 downto 0);
                img_wd_reg30        : out   std_logic_vector(7 downto 0);
                img_wd_reg31        : out   std_logic_vector(7 downto 0);
                img_wd_reg32        : out   std_logic_vector(7 downto 0);
                img_wd_reg33        : out   std_logic_vector(7 downto 0);
                img_wd_reg34        : out   std_logic_vector(7 downto 0);
                img_wd_reg35        : out   std_logic_vector(7 downto 0);
                img_wd_reg36        : out   std_logic_vector(7 downto 0);
                img_wd_reg37        : out   std_logic_vector(7 downto 0);
                img_wd_reg38        : out   std_logic_vector(7 downto 0);
                img_wd_reg39        : out   std_logic_vector(7 downto 0);
                img_wd_reg40        : out   std_logic_vector(7 downto 0);
                img_wd_reg41        : out   std_logic_vector(7 downto 0);
                img_wd_reg42        : out   std_logic_vector(7 downto 0);
                img_wd_reg43        : out   std_logic_vector(7 downto 0);
                img_wd_reg44        : out   std_logic_vector(7 downto 0);
                img_wd_reg45        : out   std_logic_vector(7 downto 0);
                img_wd_reg46        : out   std_logic_vector(7 downto 0);
                img_wd_reg47        : out   std_logic_vector(7 downto 0);
                img_wd_reg48        : out   std_logic_vector(7 downto 0)
            );
end img_window_v2;

architecture rtl of img_window_v2 is

type byte_array is array(48 downto 0) of std_logic_vector(7 downto 0);

--holds internal image window 
signal img_array            : byte_array;
--needs 1 clock delay to read from uart
signal delay_uart           : std_logic;
--needs 1 clock delay to read from ilb
signal delay_ilb           : std_logic;

begin

    process
    begin
        wait until clk = '1';
        
        if(rst = '0') then
            img_array <= (others => (others => '0'));
            delay_uart <= '0';
            delay_ilb <= '0';
        else
            --checks to make sure the kernel is full first
            if(kernel_full = '1') then
                if(delay_uart = '0') then
                    --checks to see if it should shift old values since 
                    --UART_RX got a new value
                    if((fake_sopu_rts = '1' or uart_sopu_rts = '1') and uart_sopu_rtr = '1') then
                        delay_uart <= '1';
                    end if;
                else
                    --reset delay
                    delay_uart <= '0';
                    img_array(0) <= img_array(1);
                    img_array(1) <= img_array(2);
                    img_array(2) <= img_array(3);
                    img_array(3) <= img_array(4);
                    img_array(4) <= img_array(5);
                    img_array(5) <= img_array(6);
                    --img_array(6) comes from ILB
                    img_array(7) <= img_array(8);
                    img_array(8) <= img_array(9);
                    img_array(9) <= img_array(10);
                    img_array(10) <= img_array(11);
                    img_array(11) <= img_array(12);
                    img_array(12) <= img_array(13);
                    --img_array(13) comes from ILB
                    img_array(14) <= img_array(15);
                    img_array(15) <= img_array(16);
                    img_array(16) <= img_array(17);
                    img_array(17) <= img_array(18);
                    img_array(18) <= img_array(19);
                    img_array(19) <= img_array(20);
                    --img_array(20) comes from ILB
                    img_array(21) <= img_array(22);
                    img_array(22) <= img_array(23);
                    img_array(23) <= img_array(24);
                    img_array(24) <= img_array(25);
                    img_array(25) <= img_array(26);
                    img_array(26) <= img_array(27);
                    --img_array(27) comes from ILB
                    img_array(28) <= img_array(29);
                    img_array(29) <= img_array(30);
                    img_array(30) <= img_array(31);
                    img_array(31) <= img_array(32);
                    img_array(32) <= img_array(33);
                    img_array(33) <= img_array(34);
                    --img_array(34) comes from ILB
                    img_array(35) <= img_array(36);
                    img_array(36) <= img_array(37);
                    img_array(37) <= img_array(38);
                    img_array(38) <= img_array(39);
                    img_array(39) <= img_array(40);
                    img_array(40) <= img_array(41);
                    --img_array(41) comes from ILB
                    img_array(42) <= img_array(43);
                    img_array(43) <= img_array(44);
                    img_array(44) <= img_array(45);
                    img_array(45) <= img_array(46);
                    img_array(46) <= img_array(47);
                    img_array(47) <= img_array(48);
                    --img_array(48) comes from UART_RX
                    img_array(48) <= uart_sopu_data;
                end if;
                    
                if(delay_ilb = '0') then
                    --checks to see if value came from ILB
                    if(ilb_sopu_rts = '1') then
                            delay_ilb <= '1';
                    end if;
                else
                    --reset delay 
                    delay_ilb <= '0';
                    
                    --save in new values
                    img_array(6) <= ilb_sopu_data0;
                    img_array(13) <= ilb_sopu_data1;
                    img_array(20) <= ilb_sopu_data2;
                    img_array(27) <= ilb_sopu_data3;
                    img_array(34) <= ilb_sopu_data4;
                    img_array(41) <= ilb_sopu_data5;
                end if;
            end if;
        end if;
    end process;

    --sets img_wd_reg equal to img_array
    img_wd_reg0 <= img_array(0);
    img_wd_reg1 <= img_array(1);
    img_wd_reg2 <= img_array(2);
    img_wd_reg3 <= img_array(3);
    img_wd_reg4 <= img_array(4);
    img_wd_reg5 <= img_array(5);
    img_wd_reg6 <= img_array(6);
    img_wd_reg7 <= img_array(7);
    img_wd_reg8 <= img_array(8);
    img_wd_reg9 <= img_array(9);
    img_wd_reg10 <= img_array(10);
    img_wd_reg11 <= img_array(11);
    img_wd_reg12 <= img_array(12);
    img_wd_reg13 <= img_array(13);
    img_wd_reg14 <= img_array(14);
    img_wd_reg15 <= img_array(15);
    img_wd_reg16 <= img_array(16);
    img_wd_reg17 <= img_array(17);
    img_wd_reg18 <= img_array(18);
    img_wd_reg19 <= img_array(19);
    img_wd_reg20 <= img_array(20);
    img_wd_reg21 <= img_array(21);
    img_wd_reg22 <= img_array(22);
    img_wd_reg23 <= img_array(23);
    img_wd_reg24 <= img_array(24);
    img_wd_reg25 <= img_array(25);
    img_wd_reg26 <= img_array(26);
    img_wd_reg27 <= img_array(27);
    img_wd_reg28 <= img_array(28);
    img_wd_reg29 <= img_array(29);
    img_wd_reg30 <= img_array(30);
    img_wd_reg31 <= img_array(31);
    img_wd_reg32 <= img_array(32);
    img_wd_reg33 <= img_array(33);
    img_wd_reg34 <= img_array(34);
    img_wd_reg35 <= img_array(35);
    img_wd_reg36 <= img_array(36);
    img_wd_reg37 <= img_array(37);
    img_wd_reg38 <= img_array(38);
    img_wd_reg39 <= img_array(39);
    img_wd_reg40 <= img_array(40);
    img_wd_reg41 <= img_array(41);
    img_wd_reg42 <= img_array(42);
    img_wd_reg43 <= img_array(43);
    img_wd_reg44 <= img_array(44);
    img_wd_reg45 <= img_array(45);
    img_wd_reg46 <= img_array(46);
    img_wd_reg47 <= img_array(47);
    img_wd_reg48 <= img_array(48);

end rtl;
