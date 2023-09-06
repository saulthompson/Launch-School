require 'pry'
require 'pry-byebug'

class Diamond
  def self.make_diamond(top_letter)
    @string = ''
    @ascending = true
    letters = ('A'..top_letter).to_a + ('A'...top_letter).to_a.reverse
    @width = (top_letter.ord - 'A'.ord) * 2 + 1
    @space_counter = 3
    
    letters.each do |ltr|
      case ltr
      when 'A' then handle_a
      when 'B' then handle_b
      when top_letter then handle_top_letter(top_letter)
      else
        handle_letter(ltr)
      end
    end
    @string
  end
  
  def self.handle_a
    @string += 'A'.center(@width) + "\n"
  end
  
  def self.handle_b
    @string += 'B B'.center(@width) + "\n"
  end
  
  def self.handle_letter(letter)
    @string += "#{letter}#{' ' * @space_counter}#{letter}".center(@width) + "\n"
      
    @ascending ?( @space_counter += 2) : (@space_counter -= 2)
  end
  
  def self.handle_top_letter(top_letter)
    @string += top_letter + (' ' * (@width - 2) + top_letter) + "\n"
    @ascending = false
    @space_counter -= 2
  end
end

=begin
Problem:
  - the width and height are equal to the letter ord - 'a' ord * 2 (+ 1) for the middle line and the top and bottom lines
  - two veritcally symmetrical triangles
  - the top and bottom line will always be the same
  - the middle line is different depending on input letter

Thoughts/questions:
  - could use String#center
  - use a counter for the line numbers? 
  
  
Algo:
space_counter = 3

  - for each letter
    - if it's 'A' then center A in width
    - if it's 'B' then center 'B B' in width
    - else
      - if space_counter == width - 2 then letter.ljust width - 1 + letter
      - "letter" + space times space_counter + letter, centered in width
      - space_counter += 2
    
  
=end

puts Diamond.make_diamond('C')