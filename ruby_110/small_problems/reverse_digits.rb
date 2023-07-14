=begin
input: positive integer

output: the input integer, with its digits reversed


explicit rules:
  the input integer is positive
  the return value should not have leading 0s
  
implicit rules:
  no mutating operations involved
  a single-digit input returns self
  
questions:
  Will the integer always be input in standard format (most significant digit first)?
  

Examples/test-cases:

reversed_number(12345) == 54321
reversed_number(12213) == 31221
reversed_number(456) == 654
reversed_number(12000) == 21 # No leading zeros in return value!
reversed_number(12003) == 30021
reversed_number(1) == 1


DS:
  Take in an integer
  turn it into an array to maniuplate digits in an indexed manner
  turn array into an integer (via intermediary string)
  return integer
  
Algorithm:

  initialize parameter `int`
  get array from `int`
  reverse the array
  join the array into string
  turn string into integer
  return the integer
  
=end

def reversed_number(int)
  int.digits.join.to_i
end

p reversed_number(12345) == 54321
p reversed_number(12213) == 31221
p reversed_number(456) == 654
p reversed_number(12000) == 21 # No leading zeros in return value!
p reversed_number(12003) == 30021
p reversed_number(1) == 1