# frozen_string_literal: true

#
# Problem:
#   - case insensitive
#   - doesn't return subsets
#   - doesn't return the same word
#
#
# Anagrams are case-insensitive, do not include subsets of the word itself,
# and do not include the same word.
class Anagram
  def initialize(word)
    @word = word.downcase
  end

  def match(arr)
    arr.select do |ana|
      ana.downcase != @word &&
        anagram?(@word, ana.downcase)
    end
  end
  
  def anagram?(word, ana)
    word.chars.sort == ana.chars.sort
  end
end
