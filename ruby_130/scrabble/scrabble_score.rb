# frozen_string_literal: true

#
# Problem:
#   Rules:
#     - doesn't count escaped characters/whitespace
#     - nil returns 0
#     - case insensitive
#
#
# algo:
#   - Methods: initialize(word), score
#
require 'pry'
require 'pry-byebug'

# Scrabble class has a word attribute and a score method which calculates the
# score value of each word, via a helper method
class Scrabble
  SCORES = {
    1 => %w[A E I O U L N R S T],
    2 => %w[D G],
    3 => %w[B C M P],
    4 => %w[F H V W Y],
    5 => %w[K],
    8 => %w[J X],
    10 => %w[Q Z]
  }.freeze

  def initialize(word)
    @word = word.upcase.strip
  rescue StandardError => e
    puts e
  end

  def score
    return 0 unless @word

    score = 0

    @word.each_char do |char|
      score += compare_with_values(char)
    end
    score
  end

  def compare_with_values(char)
    score = 0
    SCORES.each_value do |arr|
      if arr.include?(char)
        score += SCORES.key(arr)
        break
      end
    end
    score
  end

  def self.score(word)
    instance = new(word)
    instance.score
  end
end
