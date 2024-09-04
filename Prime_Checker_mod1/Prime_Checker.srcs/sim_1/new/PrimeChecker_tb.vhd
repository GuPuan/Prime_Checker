library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity PrimeChecker_tb is
end;

architecture bench of PrimeChecker_tb is

  component PrimeChecker
      Port (
          clk : in STD_LOGIC;
          reset : in STD_LOGIC;
          user_guess : in STD_LOGIC;
          sliders : in STD_LOGIC_VECTOR(5 downto 0);
          number_leds : out STD_LOGIC_VECTOR(3 downto 0);
          user_guess_led : out STD_LOGIC;
          prime_result_led : out STD_LOGIC;
          guess_result_led : out STD_LOGIC
      );
  end component;

  signal clk: STD_LOGIC;
  signal reset: STD_LOGIC;
  signal user_guess: STD_LOGIC;
  signal sliders: STD_LOGIC_VECTOR(5 downto 0);
  signal number_leds: STD_LOGIC_VECTOR(3 downto 0);
  signal user_guess_led: STD_LOGIC;
  signal prime_result_led: STD_LOGIC;
  signal guess_result_led: STD_LOGIC ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: PrimeChecker port map ( clk              => clk,
                               reset            => reset,
                               user_guess       => user_guess,
                               sliders          => sliders,
                               number_leds      => number_leds,
                               user_guess_led   => user_guess_led,
                               prime_result_led => prime_result_led,
                               guess_result_led => guess_result_led );

  stimulus: process
  begin
  
    -- Put initialisation code here
        reset <= '1';        
        wait for 10 ns;     
        sliders <= "110001"; 
        user_guess <= '1'; 
        reset <= '0'; 
        wait for 100 ns; 
    -- Put test bench stimulus code here

    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;