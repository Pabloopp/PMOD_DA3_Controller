library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity pmod_da3_controller is
    Port(
        --Inputs
        clk: in std_logic; --100Mhz board clock
        reset: in std_logic; --clears any internal state
        enable: in std_logic; --enables data transfer if possible
        data: in std_logic_vector(15 downto 0); --Data to be converted into an analog signal
        --Outputs
        CS: out std_logic; --Chip Select
        DIN: out std_logic; --serial data transfer pin 
        SCLK: out std_logic; --serial clock
        LDAC: out std_logic; --load DAC 
        ready: out std_logic --high if DAC is ready to convert
     );
end pmod_da3_controller;

architecture arc of pmod_da3_controller is
    --Signal definitions
    type state_t is (idle, send, convert);--state type definition
    type sync_array is array (1 downto 0) of std_logic_vector (15 downto 0); --defined for simplifying the data sync
    signal state : state_t := idle; --signal used to manage the states, initially idle
    signal enable_sync : std_logic_vector(1 downto 0);--signal used to synchronize 'enable' input, just to avoid metastability
    signal data_sync : sync_array;--signal used to synchronize the data input, just to avoid metastability
    signal clk_divider: std_logic := '0'; --signal used to divide the clock by 2
    signal clk50: std_logic;--clock to be used with the da3, obtained dividing by 2 the 100MHz clock provided by the board
    signal count16: std_logic_vector(3 downto 0) := (others => '0');-- 4 bit counter used for the data transfer, initially 0
    signal ready_reg : std_logic := '0'; --signal for the ready output, initially 0
    signal load_reg : std_logic := '1'; --signal for the LDAC output, initially 1
    signal data_reg : std_logic_vector(15 downto 0) := (others => '0'); --signal used for "freezing" the data when its called to send it, initial value 1
    signal cs_reg : std_logic := '1'; --signal for the CS output, initial value 1
    
    begin    
    daq_control : process(clk, reset)
    begin
        if reset = '1' then --if there is a reset, set everything at its initial
                state <= idle;
                count16 <= (others => '0');
                ready_reg <= '0';
                load_reg <= '1';                
                data_reg <= (others => '0');
                cs_reg <= '1';                
            end if; 
            
        if clk'event and clk = '1' then
            --Sync inputs
            enable_sync <= enable_sync(0) & enable;
            data_sync(0) <= data;
            data_sync(1) <= data_sync(0);
            
            --Generate 50MHz clock
            if clk_divider = '0' then 
                clk50 <= '1';
            elsif clk_divider = '1' then
                clk50 <= '0';
            end if;
            clk_divider <= not clk_divider;
            
            --controller 
            case state is  
                when idle =>
                    if clk50 = '1' then
                        ready_reg <= '1';
                        cs_reg <= '1';
                        load_reg <= '1';
                        count16 <= (others => '0');
                        if enable_sync(1) = '1' then
                            state <= send;
                            data_reg <= data_sync(1)(15 downto 0);
                            cs_reg <= '0';
                            ready_reg <= '0';
                        end if;
                    end if;
                    
                when send =>
                    if clk50 = '1' then
                        data_reg <= data_reg(14 downto 0) & '0';                        
                        count16 <= count16 + 1;
                        if count16 = 15 then
                            state <= convert;
                            cs_reg <= '1';
                        end if;
                    end if;                   
                when convert => 
                    if clk50 = '1' then
                        load_reg <= '0';
                        state <= idle;
                    end if;
                                     
            end case;
           
        end if;
    end process;
    CS <= cs_reg;
    DIN <= data_reg(15);
    SCLK <= clk50;
    LDAC <= load_reg;
    ready <= ready_reg;
end arc;
