library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_ns is
	generic(
		WIDTH : positive := 16
	);
	port (
		input1 : in std_logic_vector(WIDTH-1 downto 0);
		input2 : in std_logic_vector(WIDTH-1 downto 0);
		sel : in std_logic_vector(3 downto 0);
		output : out std_logic_vector(WIDTH-1 downto 0);
		overflow : out std_logic
	);
end alu_ns;

architecture ALU of alu_ns is 
begin

	process(input1, input2, sel)
		variable temp_mult : unsigned(2*width downto 0);
		variable temp : unsigned(width downto 0);
	begin
		--output <= (others => '0');
		overflow <= '0';
		
	case sel is
		when "0000" =>
			temp := unsigned(input1) + unsigned(input2);
			overflow <= temp(width);
		when "0001" =>
			temp := unsigned(input1) - unsigned(input2);
		when "0010" =>
			temp_mult := unsigned(input1) * unsigned(input2);
			temp := temp_mult(width-1 downto 0);
			if (temp_mult>temp) then 
				overflow <= '1';
			end if;
		when "0011" =>
			temp := unsigned(input1 and input2);
		when "0100" =>
			temp := unsigned(input1 or input2);
		when "0101" =>
			temp := unsigned(input1 xor input2);
		when "0110" =>
			temp := unsigned(input1 nor input2);
		when "0111" =>
			temp := unsigned(not input1);
		when "1000" =>
			overflow <= input1(width);
			temp := SHIFT_LEFT(unsigned(input1),1); 
		when "1001" =>
			temp := shift_right(unsigned(input1), 1);
		when "1010" => 
			temp := rotate_left(unsigned(input1), width/2);
		when "1011" => 
			for i in 0 to width-1 loop
				for j in width-1 downto 0 loop
				temp(i) := input1(j);
				end loop;
			end loop;
		when others =>
			temp:= (others => '0');
	end case;
	output <= std_logic_vector(temp(width-1 downto 0));
	end process;
end ALU;