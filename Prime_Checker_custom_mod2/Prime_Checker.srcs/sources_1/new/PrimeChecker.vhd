
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

entity PrimeChecker is
    Port (
        clk : in STD_LOGIC; -- Clock signal
        reset : in STD_LOGIC; -- Reset input (slider "7")
        user_guess : in STD_LOGIC; -- User's guess on primality (slider "6")
        sliders : in STD_LOGIC_VECTOR(5 downto 0); -- Sliders "0"..."5" representing the number
        --temp_output : out INTEGER; -- Sliders "0"..."5" representing the number
        number_leds : out STD_LOGIC_VECTOR(3 downto 0); -- Number LEDs output
        user_guess_led : out STD_LOGIC; -- User guess LED output
        prime_result_led : out STD_LOGIC; -- Prime result LED output
        guess_result_led : out STD_LOGIC -- Guess result LED output
    );
end PrimeChecker;

architecture Behavioral of PrimeChecker is
    --type State_Type is (IDLE, CHECK_PRIME, EVALUATE_GUESS, DONE);
    --signal state : State_Type;
    signal is_prime : STD_LOGIC ; -- Default to prime until proven otherwise
    constant IDLE : STD_LOGIC_VECTOR(3 downto 0) := "0001";
    constant CHECK_PRIME : STD_LOGIC_VECTOR(3 downto 0) := "0010";
    constant EVALUATE_GUESS : STD_LOGIC_VECTOR(3 downto 0) := "0100";
    constant DONE : STD_LOGIC_VECTOR(3 downto 0) := "1000";
    signal state : STD_LOGIC_VECTOR(3 downto 0) ;
    signal divisor : integer range 2 to 7 := 2; -- Start with 2
    signal temp_input :integer range 0 to 63 := 0;
    
begin
    process(clk, reset)
    variable input_temp :integer range 0 to 63;
    begin
        if rising_edge(clk) then
            if reset = '1' then
                -- Reset logic
                state <= IDLE;
                number_leds <= (others => '0'); -- Turn off number LEDs
                prime_result_led <= '1'; -- Assert prime LED
                guess_result_led <= '1'; -- Assert guess LED
                user_guess_led <='1';
                -- More reset logic if necessary
                divisor <= 2; -- Reset to start with 2
            else
                case state is
                
                    when IDLE =>
                        -- Wait for the user to input the number and guess
                        -- Store the number from sliders input
                       temp_input <= to_integer(unsigned(sliders));
                        -- Light the user_guess_led
           
                        if  user_guess = '0' then 
                            user_guess_led <= '0';
                        else 
                            user_guess_led <= '1';
                         end if;                 
                        -- Transition to the next state to start checking
                        if reset = '0' then -- Check if reset has been released
                            state <= CHECK_PRIME;
                        end if;

                    when CHECK_PRIME =>
                            input_temp := temp_input;
                            if  to_integer(unsigned(sliders)) =  0 or to_integer(unsigned(sliders)) = 1 then
                                -- 0 and 1 are not considered as prime numbers
                                is_prime <= '0'; -- Not a prime
                                state <= EVALUATE_GUESS;
                            elsif to_integer(unsigned(sliders))=2 or to_integer(unsigned(sliders))=3 or to_integer(unsigned(sliders))=5 or to_integer(unsigned(sliders))=7 then
                                is_prime <= '1'; --  a prime
                                state <= EVALUATE_GUESS;
                            elsif input_temp >= divisor then                               
                                    input_temp := input_temp - divisor; -- keep subtracting
                                    temp_input <= input_temp;
                                    if input_temp = 0 then
                                        is_prime <= '0'; -- Not a prime
                                        state <= EVALUATE_GUESS;
                                    elsif divisor > input_temp then 
                                            temp_input <= to_integer(unsigned(sliders));
                                            -- Increment the divisor to check next possible factors
                                            if divisor = 2 then -- After 2, check 3
                                                divisor <= 3;
                                            elsif divisor = 3 then -- After 3, check 5
                                                divisor <= 5;
                                            elsif divisor = 5 then -- After 5, check 7
                                                divisor <= 7;
                                            else
                                                is_prime <= '1'; -- Is a prime
                                                state <= EVALUATE_GUESS;
                                            end if;                                       
                                    end if;
                            end if;
                            
                    when EVALUATE_GUESS =>
                        -- Evaluate the user's guess
                        if user_guess = is_prime then
                            guess_result_led <= '1'; -- Correct guess
                        else
                            guess_result_led <= '0'; -- Incorrect guess
                        end if;
                        -- Transition to DONE
                        state <= DONE;

                    when DONE =>
                        -- Set the output LEDs
                        prime_result_led <= is_prime; -- Show prime result
                        -- Show the lowest prime divisor or indicate prime
                        if is_prime = '0' then
                            if  to_integer(unsigned(sliders)) =  0 or to_integer(unsigned(sliders)) = 1 then
                                number_leds <= "0000";
                            else
                                number_leds <= std_logic_vector(to_unsigned(divisor, number_leds'length));
                            end if; 
                        else
                            number_leds <= "0000"; -- Indicate prime number (no divisors)
                        end if;
                        -- Transition back to IDLE or wait for reset
                        if reset = '1' then
                            state <= IDLE;
                        end if;

                    when others =>
                        state <= IDLE;
                end case;
            end if;
        end if;
    end process;    
end Behavioral;