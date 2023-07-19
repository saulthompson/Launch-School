require 'pry'
require 'pry-byebug'

def sum_nested(lst)
  lst.reduce(0) do |sum, item|
    if item.class == Integer
      sum + item
    elsif item.class == Array
      sum + iterate_again(item)
    end
  end
end

  def iterate_again(array, subtotal = 0)
    binding.pry
    for item in array
      if item.class == Integer
        subtotal += item
      else
        subtotal += iterate_again(item, subtotal)
      end
    end
    subtotal
  end

puts sum_nested([1, [1], [1, [1]], [1, [1], [1, [1]]]])
=begin

sum of 0, 1, 2 == 3

algo:
  reduce the array to its sum
    in each iteration
      if item is an integer
        add to sum
      elsif item is an array
        for each el in item
          if el is an integer
            add to sum
          elsif item is an array...
  end
  return sum
  
  iterate_again(array) method
  
  iterate_again([1, [2, 3]]) == 6
  
    if item is an array
      iterate_again(item)
        if item is an integer
          add to sum
        elsif item is an array
          iterate_again(item)
=end
      