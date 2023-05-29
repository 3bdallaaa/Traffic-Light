-- Listing 2: Arbiter TestBench

library ieee;
use ieee.std_logic_1164.all;
 
entity TF is

port(sensor,clk,rst:in std_logic;
	 way1,way2:out std_logic_vector(2 downto 0));

end TF;
 
architecture TF_arch of TF is 
	
	type tf_states is(s0,s1,s2,s3,s4);
	signal ps,ns:tf_states; 
	constant GREEN : std_logic_vector(2 downto 0) := "100";
    constant YELLOW : std_logic_vector(2 downto 0) := "010";
    constant RED : std_logic_vector(2 downto 0) := "001";
	
	signal timer : std_logic_vector(4 downto 0);
	constant sec30 : std_logic_vector(4 downto 0) := "11110";
	constant sec5 : std_logic_vector(4 downto 0) := "00101";


	process (rst, clk)
	
	begin
	
	IF (rst='1') THEN
	ps <= s0;
	timer<=x"0";
	ELSIF (clk'EVENT AND clk='1') THEN
	ps <= ns;
	END IF;
	
	END PROCESS;
 
 
	process(ps,sensor)
	   
	begin
	case ps is
	
	when S0 =>
	IF(sensor<='0' and timer<sec30)then
		ns<=s0;
		way1=GREEN;
		way2=RED;
		timer<=(timer+1);
	ELSE
		ns<=s1;
		timer<=x"0";
	END IF;
	
	when S1 =>
	IF( timer<sec5)then
		ns<=s1;
		way1=YELLOW;
		way2=RED;
		timer<=(timer+1);
	ELSE
		ns<=s2;
		timer<=x"0";
	END IF;
	
	
	when S2 =>
	IF( sensor<='0' and timer<sec30)then
		ns<=s2;
		way1=RED;
		way2=GREEN;
		timer<=(timer+1);
	ELSE
		ns<=s3;
		timer<=x"0";
	END IF;
	
	
	when s3 =>
	IF( timer<sec5)then
		ns<=s2;
		way1=Red;
		way2=YELLOW;
		timer<=(timer+1);
	ELSE
		ns<=s4;
		timer<=x"0";
	END IF;	
		
		when s4 =>
	IF( sensor<='0' and timer<sec30)then
		ns<=s2;
		way1=GREEN;
		way2=RED;
		timer<=(timer+1);
	ELSE
		ns<=s0;
		timer<=x"0";
	END IF;	
	
	when others =>
		ns<=s0;
	
	end case;
   end process;

end behavior;