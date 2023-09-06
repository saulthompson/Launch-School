=begin
Problem:
  - write a class that takes an arabic numeral as an input, and in the 
    a method called to_roman converts it into a Roman numeral

Examples:
  - def test_48
    skip
    number = RomanNumeral.new(48)
    assert_equal 'XLVIII', number.to_roman
  end
  
  def test_59
    skip
    number = RomanNumeral.new(59)
    assert_equal 'LIX', number.to_roman
  end
  
DS:
  - 
  
Algo:
  - digits reversed
  - skip zeroes
  
=end

class RomanNumeral
  def initializer(num)
    @num = num
  end
  
  def to_roman
    case @num_arr.size
    when 1 then single_digit(@num_arr.last)
    when 2 then two_digits(@num.digits.reverse)
    when 3 then three_digits
    when 4 then four_digits
    end
  end
  
  def single_digit(num)
    case num
    when 1..3 then "I" * num
    when 4 then "IV"
    when 5 then "V"
    when 6..8 then "V" + ('I' * (num - 5))
    when 9 then 'IX'
    end
  end
  
  def two_digits(num_arr)
    case num_arr[-2]
    when 1..3 then 'X' * num_arr[-2]
    when 4 then 'XL'
    when 5 then 'L'
    when 6..8 then 'L' + ('X' * (num_arr[-2] - 5))
    when 9 then 'XC'
    end
  end
end