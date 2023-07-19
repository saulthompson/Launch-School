=begin
input: one integer, representing a row number

output: one integer, representing the sum of the row indicated by the input row number

explicit rules:
  - there is a sequence of integers
  - the integers are even
  - the integers are consecutive
  - the integers start from 2
  - each row is incrementally larger
  
implicit rules:
  - the input integer should be positive?
  - the input integer is equal to the length of the target row
    - row one has one element, row two has two elements, ...
  
  
Examples:
  
  2,
  4, 6,
  8, 10, 12
  14, 16, 18, 20
  22, 24, 26, 28, 30
  
  DS:
    an array of arrays
    
  