=begin
PROBLEM---

Complete this class so that the test cases shown below work as intended

class Banner
  def initialize(message)
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
  end

  private

  def horizontal_rule
    
  end

  def empty_line
  end

  def message_line
    "| #{@message} |"
  end
end

Input: an instantiation of the Banner class, with or without an argument,
where the argument is a string
    

Output: a printout of a box, with or without a message contained inside
    

Explicit Rules:
    
  - add any instance methods or variables, as needed
  - do not make the implementation details public
  - can assume the output will always fit inside the terminal window

Implicit Rules:
  
  - If there is a message, it should be prefixed and suffixed with one 
  space character
  - the minimum height of the banner is 3 rows
  - the banner should have an empty row above and below the message
  - the minimum width is 4 columns
  
Questions/thoughts:

  -
    

Examples---

  banner = Banner.new('To boldly go where no one has gone before.')
puts banner
+--------------------------------------------+
|                                            |
| To boldly go where no one has gone before. |
|                                            |
+--------------------------------------------+


banner = Banner.new('')
puts banner
+--+
|  |
|  |
|  |
+--+

DS---

  

Algorithm--

  High-level:
  
    -  
  
  Low-level:
  
    - 
    
=end

class Banner
  def initialize(message, width=message.size + 4)
    @message = message
    @width = width
    raise ArgumentError, 'Invalid width. Width must be greater than message size.' if width < message.size
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
  end

  private

  def horizontal_rule
    "+#{"-" * (@width - 2)}+"
  end

  def empty_line
    "|#{" "*(@width - 2)}|"
  end

  def message_line
    "|#{@message.center(@width - 2)}|"
  end
end

banner = Banner.new('', 60)
puts banner