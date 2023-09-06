require 'pry'
require 'pry-byebug'

class Series
  def initialize(str)
    @number_str = str
  end
  
  def slices(length)
    raise ArgumentError if length > @number_str.length
    
    integer_arr = @number_str.chars.map(&:to_i)
    
    integer_arr.combination(length).select do |combo|
      integer_arr.each_cons(length).to_a.include?(combo)
    end.uniq
    
  end
end


=begin

Problem:
  - get all consecutive combinations of certain length
  - raise an error if the length > the string length
  

Algo:
  
  - get all combinations of certain length
  - convert all strings to integers
  - select only those included in the each_cons(length) array

=end