# frozen_string_literal: true

# PROBLEM:
#
# Given a string, write a method `palindrome_substrings` which returns
# all the substrings from a given string which are palindromes. Consider
# palindrome words case sensitive.
# questions:
#
#   What should we do if the same palindrome occurs more than once?
#   What should happen if a non-string type object is passed to the method invocation?
#   Can the string have spaces?
#
# input: string
# output: array of strings that are substrings of the input string
#
# explicit requirements:
#   palindrome words are case sensitive (Mom is not a palindrome)
#
# implicit requirements:
#   There should be no change in case
#   the return object should be an array
#   if there is no palindrome in the input string, the return value should be an empty array
#   if the input is an empty string, the return value should be an empty array
#
# Algorithm:
#   Initialize an empty array, `results`;
#   make an array, `substrings` with all substrings with length >= 2 starting from index 0 up to str.size - 1
#   loop over `substrings` from index 0 to string.length - 2
#     if current substring is a palindrome, push it to `results`
#   return `results`
#
#
#   substrings problem:
#     substrings.push(str[index..str.length - starting_index])
#
#     substrings test-case
#     str = "palo" => "pa", "pal", "palo", "al", "alo", "lo"
#
#     substrings algorithm:
#       pass in the str object
#       intialize an empty array `result`
#       initialize a counter `starting_index` to 0
#       outer loop over starting_index while `starting_index` < `str.length`
#         initialize a counter `subarr_size` to 2
#         inner loop over `subarr_size` while `subarr_size` < str.length - starting_index
#           `result.push(str.slice(starting_index, subarr_size))`
#           increment subarr_size by 1
#         end inner loop
#         increment starting_index by 1
#       end outer loop
#       return result
#
#
#      palindrome? method algorithm:
#         pass in substr
#         initilize index_count to 0
#         if substr.length.even?
#           while index_count <= (substr.size/2) - 1
#             return false unless substr[index] == substring[-(index + 1)]
#             increment index by one
#             return true
#           end
#         else
#           while index_count < ((substr.size - 1) /2)
#             return false unless substr[index] == substr[-(index + 1)]
#             increment index by one
#           end
#           return true
#         end
#
#
def even_size_str_two_way_char_check(str,index)
    while index <= ((str.size / 2) - 1)
      return false unless str[index] == str[-(index + 1)]

      index += 1
    end
    true
end

def odd_size_str_two_way_char_check(str, index)
  while index < ((str.size - 1) / 2)
    return false unless str[index] == str[-(index + 1)]

    index += 1
  end
  true
end

def palindrome?(str)
  index = 0
  if str.length.even?
    return even_size_str_two_way_char_check(str, index)
  else
    return odd_size_str_two_way_char_check(str, index)
  end
  true
end

def palindrome_substrings(str)
  results = []
  substrings = substrings(str)

  substrings.each do |substr|
    results << substr if palindrome?(substr)
  end
  results
end

def substrings(str)
  result = []
  start_index = 0
  while start_index <= str.length - 2
    subarr_size = 2
    while subarr_size <= str.size - start_index
      result << str[start_index, subarr_size]
      subarr_size += 1
    end
    start_index += 1
  end
  result
end

p palindrome_substrings('momsiclces')
