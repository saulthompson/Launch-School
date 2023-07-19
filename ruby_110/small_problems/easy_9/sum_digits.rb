=begin
input: a positive integer

output: a positive integer, representing the sum of the input integer's digits

explicit rules:
  do not use `loop` or `while` or `until` or `each`
  
implicit rules:
  
  
Examples/test-cases:

puts sum(23) == 5
puts sum(496) == 19
puts sum(123_456_789) == 45
  
DS:
  input is an integer
  turn it into an array to work with digits with indices
  use a counting method that returns an integer
  
Algorithm:
   intialize parameter `int`
   turn `int` into an array `arr`
    - use the digits method
   get the sum of all elements in `arr`
    - use the sum method
   return the sum

=end

def sum(int)
  int.digits.sum
end


puts sum(23) == 5
puts sum(496) == 19
puts sum(123_456_789) == 45