# Find the longest substring in alphabetical order.
# Example: the longest alphabetical substring in "asdfaaaabbbbcttavvfffffdf" is "aaaabbbbctt".
# The input will only consist of lowercase characters and will be at least one letter long.
# If there are multiple solutions, return the one that appears first.

=begin
input: string of varying length

output: string, specifically the longest alphabetical substring

explicit rules:
  the input will only be lowercase letters
  input will be at least one letter long
  in case of multiple solutions, return the first one

DS:
  intermediary stage - array

algorithm:
  initialize empty array `substr`
  initilize empty array `new_substr`
    turn the `input` into an array, `arr`
      for each char in input
        if it's the same as preceding char, or greater than preceding char
          add to `substr`
        else
          continue iterating starting from current char
            if char >= preceding char, push to `new_substr`
              if `new_substring`'s size > `substr` size
                reassign `substr` to array referenced by `new_substr`
                reassign `new_substr` to empty array
              end
            end
        end
        return substr if current char is the last char
      end
      
          
  start new substring
  add first alphabetical substring into new array
  after iterations are complete, get the longest substr array
  return longest substring array

  
  for each character except the first one, 
    if it comes later in the alphabet than preceding char
      push to `subarr`
    else
      initalize new substring array
    end


=end

def longest(str)
  substr = []
  new_substr = []
  
  input_arr = str.chars
  input_arr.each_with_index do |char, index|
    substr.push(char) if char == input_arr.first
    if char >= input_arr[index - 1]
      substr.push(char)
    end
  end
  puts substr
end

p longest('asd') #== 'as'
# p longest('nab') == 'ab'
# p longest('abcdeapbcdef') ==  'abcde'
# p longest('asdfaaaabbbbcttavvfffffdf') == 'aaaabbbbctt'
# p longest('asdfbyfgiklag') == 'fgikl'
# p longest('z') == 'z'
# p longest('zyba') == 'z'

