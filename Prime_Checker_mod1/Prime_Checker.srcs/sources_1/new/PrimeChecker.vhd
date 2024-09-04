library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;
USE IEEE.numeric_std.ALL;

entity PrimeChecker is
    Port (
        clk : in STD_LOGIC; -- Clock signal
        reset : in STD_LOGIC; -- Reset input (slider "7")
        user_guess : in STD_LOGIC; -- User's guess on primality (slider "6")
        sliders : in STD_LOGIC_VECTOR(5 downto 0); -- Sliders "0"..."5" representing the number
        number_leds : out STD_LOGIC_VECTOR(3 downto 0); -- Number LEDs output
        user_guess_led : out STD_LOGIC; -- User guess LED output
        prime_result_led : out STD_LOGIC; -- Prime result LED output
        guess_result_led : out STD_LOGIC -- Guess result LED output

    );
end PrimeChecker;

architecture Behavioral of PrimeChecker is
    constant IDLE : STD_LOGIC_VECTOR(3 downto 0) := "0001";
    constant CHECK_PRIME : STD_LOGIC_VECTOR(3 downto 0) := "0010";
    constant EVALUATE_GUESS : STD_LOGIC_VECTOR(3 downto 0) := "0100";
    constant DONE : STD_LOGIC_VECTOR(3 downto 0) := "1000";
    signal state : STD_LOGIC_VECTOR(3 downto 0) ;
    signal is_prime : STD_LOGIC ; -- Default to prime until proven otherwise
    signal input_number : unsigned(5 downto 0); -- 6-bit input number
    signal divisor : unsigned(3 downto 0); 
begin
    process(clk, reset)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                -- Reset logic
                state <= IDLE;
                number_leds <= (others => '0'); -- Turn off number LEDs
                prime_result_led <= '1'; -- Assert prime LED
                guess_result_led <= '1'; -- Assert guess LED
                user_guess_led <='1';
                divisor <= "0010"; -- Reset to start with 2
            else
                case state is
                
                    when IDLE =>
                        -- Wait for the user to input the number and guess
                        -- Store the number from sliders input
                        input_number <= unsigned(sliders);
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
                            -- Check if the number is 2, 3, 5, or 7 directly
                            if input_number = divisor then
                                is_prime <= '1'; -- Is a prime
                                state <= EVALUATE_GUESS;
                            elsif input_number = "000000" or input_number = "000001" then
                                -- 0 and 1 are not considered as prime numbers
                                is_prime <= '0'; -- Not a prime
                                state <= EVALUATE_GUESS;
                            else
                                -- For other numbers, use the original prime checking logic
                                if divisor < input_number then
                                    if to_integer(input_number) mod to_integer(divisor) = 0 then
                                        is_prime <= '0'; -- Not a prime
                                        state <= EVALUATE_GUESS;
                                    else
                                        -- Increment the divisor to check next possible factors
                                        if divisor = "0010" then -- After 2, check 3
                                            divisor <= "0011";
                                        elsif divisor = "0011" then -- After 3, check 5
                                            divisor <= "0101";
                                        elsif divisor = "0101" then -- After 5, check 7
                                            divisor <= "0111";
                                        else
                                            is_prime <= '1'; -- Is a prime
                                            state <= EVALUATE_GUESS;
                                        end if;
                                    end if;
                                else
                                    is_prime <= '1'; -- Numbers less than the smallest divisor considered as prime
                                    state <= EVALUATE_GUESS;
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
                                number_leds <= std_logic_vector(divisor);
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