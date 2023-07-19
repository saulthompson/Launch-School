# frozen_string_literal: true

#
# input: a positive integer, `n`, string `orientation`
#
# output:
#   print a right-angle triange whose sides have length of `n`
#
# explicit rules:
#   the sides should be made of the * character
#   the hypotenuse should have one end at the lower-left, one end at the upper-right
#   if `orientation` is `top-left`, the corner should be in the top-left...
#
#
# implicit rules:
#   default orientation is bottom-right
#
#
# Examples:
#
#   triangle(5)
#
#     *
#    **
#   ***
#  ****
# *****
#
# triangle(3, 'top-left')
#
# ***
# **
# *
#
# DS:
#   inputs are an integer and a string
#   string should be organized with case expression
#   each row will represent a nested array in an outer array
#   `reverse` operations on the outer array and/or inner array to rotate
#
# Algorithm:
#
#   initialize an empty array `outer`
#   push `n` empty sub-arrays to `outer`
#   populate the arrays from the default orientation
#     initialize `stars` to 1
#     initialize `spaces` to `n` - 1
#     for each sub-array populate with spaces and stars
#       `spaces` times
#         push " " to sub_arr
#       end
#       `stars` times
#         push "*" to sub_arr
#       end
#       increment `stars` by 1
#       decrement `spaces` by 1
#     end
#   rotate orientation depending on `orientation` using `case`
#     if `orientation` == 'bottom-left'
#       reverse each sub_array
#     elsif 'orientation' == 'top-left'
#       reverse each sub_array
#       reverse `outer`
#     elsif 'orientation' == 'top-right'
#       reverse `outer`
#     end
#   join each subarray
#   print `outer`
#
def triangle(num, orient = 'bottom-right')
  if num.class != Integer || num < 1
    puts "Please enter a valid number"
    return
  end
  outer = []
  num.times { outer.push([]) }

  populate_rows(outer, num)

  puts triangle_orientation(outer, orient)
end



def triangle_orientation(outer, orient)
  config =
    case orient
    when 'bottom-left'
      outer.map(&:reverse)
    when 'top-left'
      outer.map(&:reverse).reverse
    when 'top-right'
      outer.reverse
    else
      outer
    end

  config.map!(&:join)
end



def populate_rows(outer, num)
  stars = 1
  spaces = (num - 1)

  outer.each do |sub_arr|
    spaces.times { sub_arr.push(' ') }
    stars.times { sub_arr.push('*') }

    stars += 1
    spaces -= 1
  end
end



triangle(9)
