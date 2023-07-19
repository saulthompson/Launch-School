=begin
Given an array of n positive integers and a positive integer, find the minimal length of a contiguous subarray for which the sum >= integer.

p minSubLength([2, 3, 1, 2, 4, 3], 7) == 2
p minSubLength([1, 10, 5, 2, 7], 9) == 1
p minSubLength([1, 11, 100, 1, 0, 200, 3, 2, 1, 250], 280) == 4
p minSubLength([1, 2, 4], 8) == 0
=end



=begin

PROBLEM
---------------- 
INPUT: an array of positive integers, and a positive integer
OUTPUT: an integer, representing the minimum length of a subarray for which the sum >= the input integer

RULES:
  the array is only going to have positive integers
  the second argument is also positive

  implicit:
    0 is a valid output
    1 is a valid output
- ...



EXAMPLES/ MODELLING
-------------------
el + el == 7
number of els is 2
output is 2

minSubLength([4, 6, 3, 2] 8) == 2


[1, 10, 5, 2, 7], 9 

1

DATA STRUCTURES
array

----------------


ALGORITHM
Q: How am i going to find the minimal length?
A:

Q: How am I going to obtain all the subarrays?
A: for each el
    for each sub-el
      if the next sub-el + current sub-el >= int
        get the number of sub-els
        all_subs array 
        0 through array size - 1  # [4, 6, 3, 2]
          idx1 through array size idx2 # start at 4 (index 0)...
           
          #  next iteration start at 6 (index 1)...

          all_subs << [idx1..idx2]
