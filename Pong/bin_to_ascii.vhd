library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity bin_to_ascii is port (
    bin: in STD_LOGIC_VECTOR(6 downto 0);
    dec: out STD_LOGIC_VECTOR(15 downto 0)
); end bin_to_ascii;

architecture bin_to_ascii_impl of bin_to_ascii is
    signal decade, unit: STD_LOGIC_VECTOR(7 downto 0);
    -- ASCII code of 0
    constant ASCII_0: STD_LOGIC_VECTOR(7 downto 0) := "00110000";
begin
    decade <=
        "00001001" + ASCII_0 when bin >= "01011010" else  -- 90
        "00001000" + ASCII_0 when bin >= "01010000" else  -- 80
        "00000111" + ASCII_0 when bin >= "01000110" else  -- 70
        "00000110" + ASCII_0 when bin >= "00111100" else  -- 60
        "00000101" + ASCII_0 when bin >= "00110010" else  -- 50
        "00000100" + ASCII_0 when bin >= "00101000" else  -- 40
        "00000011" + ASCII_0 when bin >= "00011110" else  -- 30
        "00000010" + ASCII_0 when bin >= "00010100" else  -- 20
        "00000001" + ASCII_0 when bin >= "00001010" else  -- 10
        "00000000" + ASCII_0;

    unit <=
        bin - "01011010" + ASCII_0 when bin >= "01011010" else  -- 90;
        bin - "01010000" + ASCII_0 when bin >= "01010000" else  -- 80;
        bin - "01000110" + ASCII_0 when bin >= "01000110" else  -- 70;
        bin - "00111100" + ASCII_0 when bin >= "00111100" else  -- 60;
        bin - "00110010" + ASCII_0 when bin >= "00110010" else  -- 50;
        bin - "00101000" + ASCII_0 when bin >= "00101000" else  -- 40;
        bin - "00011110" + ASCII_0 when bin >= "00011110" else  -- 30;
        bin - "00010100" + ASCII_0 when bin >= "00010100" else  -- 20;
        bin - "00001010" + ASCII_0 when bin >= "00001010" else  -- 10;
        bin + ASCII_0 ;

    dec <= decade & unit;
end bin_to_ascii_impl;
