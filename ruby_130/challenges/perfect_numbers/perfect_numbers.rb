=begin
Problem:
  - return one of three string results, or reaise a StandardError
  
  - cannot accept negative numbers
  - compares sum of positive divisors with number
    - if equal then perfect
    - if less than then deficient
    - if greater than then abundant
    
  - prime numbers are always deficient (require prime)
    
Example:
  - number = 13 ; only positive divisor is 1 => deficient
  - number = 28 ; divisors: 1, 2, 4, 7 14
  
  
DS:
  - integer, and brute force iteration
  
Algo:
  - method classify, class method
  
  - get all divisors for 1 up to number /  OR number
    - 
=end

require 'prime'

class PerfectNumber
  def self.classify(number)
    raise StandardError if number <= 0
    
    return 'deficient' if Prime.prime?(number)
    
    divisors_sum = (2..(number / 2)).to_a.reduce(1) do |acc, cur|
      number % cur == 0 ? (acc + cur) : acc
    end
    get_classification(number, divisors_sum)
  end
  
  private
  
  def self.get_classification(num, sum)
    if sum < num
      "deficient"
    elsif sum == num
      "perfect"
    else
      "abundant"
    end
  end
end