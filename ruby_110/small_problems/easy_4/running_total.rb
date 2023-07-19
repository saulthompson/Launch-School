=begin
input:
  an array of numbers

output:
  an array of numbers, where each number is a running total of all the numbers before it, including the current number


explicit rules:
  the output array should have the same number of elements as the input array

implicit rules:
  only integers, no floats (?)
  if the input is an empty array, the output is also an empty array
  if the input array has only one element, the output will be that same array with the same single element
  the first element of the input and output arrays is the same
  the last element of the output array is equal to the sum of the input array
  
  
examples/test-cases:
  

DS:
  input is an array of integer objects
  output is an array of integer objects
  
Algorithm:
  
  initialize input array variable `input`
  if `input` is empty or has length of one, return `input`
  initialize output array variable `output`
  get sum of each`input` element and the corresponding preceding element in `output`
    initialize a counter variable `index` and assign to 0
    for each input element
      if it is the first element, push the element to `output`, increment `index`, and proceed to next iteration
      push sum of element and `output` element at position (index - one) to `output`
      increment index by 1
    end
  return `output`

=end

def running_total(input_arr)
  return input_arr if input_arr.empty? || input_arr.size == 1
  
  output_arr = []
  index = 0
  
  input_arr.each do |el|
    if index == 0
      output_arr.push(el)
      index += 1
      next
    end
    output_arr.push(el + output_arr[index - 1])
    index += 1
  end
  output_arr
end


puts  running_total([2, 5, 13])
puts  running_total([14, 11, 7, 15, 20]) == [14, 25, 32, 47, 67]
puts  running_total([3]) == [3]
puts  running_total([]) == []
