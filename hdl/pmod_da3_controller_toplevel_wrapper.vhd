--Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
--Date        : Tue Jul 23 16:02:33 2024
--Host        : DESKTOP-NJIR8P3 running 64-bit major release  (build 9200)
--Command     : generate_target pmod_da3_controller_toplevel_wrapper.bd
--Design      : pmod_da3_controller_toplevel_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity pmod_da3_controller_toplevel_wrapper is
  port (
    CS : out STD_LOGIC;
    DIN : out STD_LOGIC;
    LDAC : out STD_LOGIC;
    SCLK : out STD_LOGIC;
    clk : in STD_LOGIC;
    enable : in STD_LOGIC;
    ready : out STD_LOGIC;
    reset : in STD_LOGIC;
    sw : in STD_LOGIC_VECTOR ( 15 downto 0 )
  );
end pmod_da3_controller_toplevel_wrapper;

architecture STRUCTURE of pmod_da3_controller_toplevel_wrapper is
  component pmod_da3_controller_toplevel is
  port (
    clk : in STD_LOGIC;
    reset : in STD_LOGIC;
    enable : in STD_LOGIC;
    sw : in STD_LOGIC_VECTOR ( 15 downto 0 );
    ready : out STD_LOGIC;
    LDAC : out STD_LOGIC;
    SCLK : out STD_LOGIC;
    DIN : out STD_LOGIC;
    CS : out STD_LOGIC
  );
  end component pmod_da3_controller_toplevel;
begin
pmod_da3_controller_toplevel_i: component pmod_da3_controller_toplevel
     port map (
      CS => CS,
      DIN => DIN,
      LDAC => LDAC,
      SCLK => SCLK,
      clk => clk,
      enable => enable,
      ready => ready,
      reset => reset,
      sw(15 downto 0) => sw(15 downto 0)
    );
end STRUCTURE;
