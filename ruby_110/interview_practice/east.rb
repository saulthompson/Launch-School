=begin
You will be given an array of string `"east"` formatted differently every time. Create a function that returns `"west"` wherever there is `"east"`. Format the string according to the input.

The input will only be `"east"` in different formats.
=end

# direction(["east", "EAST", "eastEAST"]) == ["west", "WEST", "westWEST"]
# direction(["eAsT EaSt", "EaSt eAsT"]) == ["wEsT WeSt", "WeSt wEsT"]
# direction(["east EAST", "e a s t", "E A S T"]) == ["west WEST", "w e s t", "W E S T"]

=begin
PROBLEM---



Input:
    an array of string containing 'east' in various formats, including repetitions

Output:
    a new array of strings containing 'west' in formats that mirror the input, and with the same length

Explicit Rules:
    
  - 

Implicit Rules:
  
  - repetition is valid
  - adding spaces between characters is valid
  - mixed cases is valid
  
Questions/thoughts:

  -
    

Examples---

  # direction(["east", "EAST", "eastEAST"]) == ["west", "WEST", "westWEST"]
  # direction(["eAsT EaSt", "EaSt eAsT"]) == ["wEsT WeSt", "WeSt wEsT"]
  # direction(["east EAST", "e a s t", "E A S T"]) == ["west WEST", "w e s t", "W E S T"]


  # ["east EAST", "e a s t", "E A S T"] # => [['e', 'a', 's', 't', ' ', 'E', 'A', 'S', 'T'] ...]

  s.gsub(/(e|a)\i/) { |c| char.upcase if char == 'g' }
DS---

  

Algorithm--

  High-level:
  
    -  iterate through each input item
    - check the formatting
      - check if the characters are repeated
      - check spaces
      - check case of each character
    - return a transformation of the element based on the formatting
  
  Low-level:

  - initialize array results 
    - get the length of input
      results contents are 'west ' * length, split into an array


    - for each word with index (idx1)
      - initialize word_case to []
      - check if word is repeated
        - if each character downcased appears more than once
          - get the number of occurrences
          - multiply the corresponding string in results


    - check for spaces
      - if string includes space
        - get index of first space
        - insert a space in the corresponding index in results item
        - get the input string with the first space deleted
          - repeat until there are no more spaces in input string


      - check the case of each char
        - for each char 
          - call map and if it's lowercase
            - transform in 'l'
          - else
            - transform to 'u'
          
              - for char in result[idx1], with index (idx2)
               
                if cases[idx2] is lower
                  call downcase on char
                else
                  call upcase on char
                end


          

=end

  def direction(arr)
    results = []
    
    results.fill('west', 0, arr.length)
    arr.each_with_index do |word, idx1|
      repetition_count = word.count("eastEAST")
      results[idx1] *= (repetition_count / 4)
      

      temp_word = word.dup
      
      loop do
        break if !temp_word.include?(" ")
        space_idx = temp_word.index(" ")
        results[idx1].insert(space_idx, " ")
        temp_word.sub!(' ', 'g')
      end
      
      word.chars.each_with_index do |char, idx2|
        results[idx1][idx2] = results[idx1][idx2].upcase! if char =~ /[A-Z]/
      end
    end
    
    results
  end



p direction(["east", "EAST", "eastEAST"]) == ["west", "WEST", "westWEST"]
p direction(["eAsT EaSt", "EaSt eAsT"]) == ["wEsT WeSt", "WeSt wEsT"]
p direction(["east EAST", "e a s t", "E A S T"]) == ["west WEST", "w e s t", "W E S T"]
