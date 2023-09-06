=begin
Problem

- write a program to determine what type of triangle a given triangle is,
  or if it is not a valid triangle
- one isntane method, Triange::kind
- negative number for any input raises ArgumentError
- 0 for any input raises ArgumentError
- if sum of any 2 sides.values is not greater than the third, raise ArgumentError

input:
  - length of three sides

output:
  - invalid, or one of three types of triangles


Examples:

  - Triangle.new(2, 2, 2) => equilateral
  
  
DS:
  - integers and floats
  
  
Algorithm:

  - 


=end
require 'pry'
require 'pry-byebug'

class Triangle
  def initialize(l1, l2, l3)
    @sides = [l1, l2, l3]
    
    if @sides.any? do |side| 
      side <= 0 || 
        @sides.combination(2).any? do |combo|
          side >= combo.sum
        end
      end
        raise ArgumentError
    end
  end
  
  def kind
    if @sides.uniq.size == 1
      'equilateral'
    elsif @sides.uniq.size == 2
      'isosceles'
    elsif @sides.uniq.size == 3
      'scalene'
    end
  end
end