=begin
Given an array of integers, return the integer that appears an odd number of times. There will always be only one integer that appears an odd number of times.

You may assume that every given array will contain at least one integer.

input: an array of integers

output: a single Integer
t
implicit rules: 
  0 is also considered an integer


# p find_odd([7]) == 7
# p find_odd([0]) == 0
# p find_odd([1, 1, 2]) == 2
# p find_odd([0, 1, 0, 1, 0]) == 0
# p find_odd([1, 2, 2, 3, 3, 3, 4, 3, 2, 2, 1]) == 4


DS:
  Array
  hash

Saul's algo:

  

  get the array element that appears an odd number of times
    create an empty hash
      iterate over the array
        if the element is not already a hash Key
          add the element as a hash Key
          set the value to 1
        elsif the element is already a hash Key
          increment hash value by 1
        end
      end
          iterate over the hash to select pair with odd value
            return the key as an integer
    
  
  Esther's algo:
  
  create a new array containing only unique integers
  iterate over the new Array
    for each iteration
      count the number of the integer in that iteration in the original Array
        if the count is odd
          return the integer
=end

# def find_odd(arr_of_num)
#   arr_of_num.uniq.each do |num|
#     return num if (arr_of_num.count(num)).odd?
#   end
# end

def find_odd(num_arr)
  num_arr.count {|num| num.odd?}
end

# p find_odd([7]) == 7
# p find_odd([0]) == 0
# p find_odd([1, 1, 2]) == 2
# p find_odd([0, 1, 0, 1, 0]) == 0
p find_odd([1, 2, 2, 3, 3, 3, 4, 3, 2, 2, 1]) #== 4
