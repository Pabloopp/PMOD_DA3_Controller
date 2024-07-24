library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_pmod_da3_controller is
end tb_pmod_da3_controller;

architecture test of tb_pmod_da3_controller is

    -- Component Declaration
    component pmod_da3_controller
    Port(
        clk: in std_logic;
        reset: in std_logic;
        enable: in std_logic;
        data: in std_logic_vector(15 downto 0);
        CS: out std_logic;
        DIN: out std_logic;
        SCLK: out std_logic;
        LDAC: out std_logic;
        ready: out std_logic
     );
    end component;

    -- Inputs
    signal clk : std_logic := '0';
    signal reset : std_logic := '0';
    signal enable : std_logic := '0';
    signal data : std_logic_vector(15 downto 0) := (others => '0');
    -- Outputs
    signal CS : std_logic;
    signal DIN : std_logic;
    signal SCLK : std_logic;
    signal LDAC : std_logic;
    signal ready : std_logic;
    -- Clock period definition
    constant clk_period : time := 10 ns;

begin

    -- Instantiate and map the unit
    uut: pmod_da3_controller port map (
          clk => clk,
          reset => reset,
          enable => enable,
          data => data,
          CS => CS,
          DIN => DIN,
          SCLK => SCLK,
          LDAC => LDAC,
          ready => ready
        );

    -- Clock process
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Inputs process
    input_proc: process
    begin 
        --wait for 10 clock periods
        wait for clk_period*10;
        
        -- Test 1: Enable signal and data input
        data <= "1001000101100001";
        wait for clk_period*5;
        enable <= '1';
        wait for clk_period*5;
        enable <= '0';
        wait for clk_period*35;
        
        -- Test case 2: Another data input, now changing the data input after enable
        data <= "0000000000000010";
        wait for clk_period*20;
        enable <= '1';
        wait for clk_period*10;
        data <= "0001111110001111";
        wait for clk_period*10;
        enable <= '0';
        wait for clk_period*20;
        
        
        -- Test case 3: Reset during operation
        enable <= '1';
        wait for clk_period*10;
        
        reset <= '1';
        wait for 5 ns;
        
        reset <= '0';
        wait for clk_period*20;
        enable <= '0';
        
        wait;
    end process;

end test;