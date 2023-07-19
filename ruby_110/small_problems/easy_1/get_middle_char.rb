=begin
input: a non-empty string
output: one, or two characters

explicit requirements:
  if the string length is even, return the middle two characters
  if the string length is odd, return a single character (middle char)

implicit requirements: 
  the return value should be a string
  if the middle character is a space, return a space character
  if the argument is a one character string, return that character (should it be the same string object?)
  
questions:
  what happens for invalid input?


Examples:

  
Algorithm:
  
  get string length
  determine if string length is odd or even
    use .even? method
  if even
    get the middle two chars
      get chars at indices of half string length minus one, and half string length 
    return those chars
  elsif odd
    get the middle one char
      get char at half string length minus one
    return that char
  else
    return argument string
  end
  
=end
  
  def center_of(str)
    len = str.length
    if len.even?
      return (str[(len / 2) - 1] + str[(len / 2)])
    elsif len.odd?
      return str[(len - 1) / 2]
    else
      return str
    end
  end
  
puts center_of('I love ruby') == 'e'
puts center_of('Launch School') == ' '
puts center_of('Launch') == 'un'
puts center_of('Launchschool') == 'hs'
puts center_of('x') == 'x'