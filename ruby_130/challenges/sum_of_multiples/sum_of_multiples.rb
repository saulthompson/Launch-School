# frozen_string_literal: true

class SumOfMultiples
  def initialize(multiple1: 3, multiple2: 5, others: [])
    @multiples_arr = [
      @multiple1 = multiple1,
      @multiple2 = multiple2,
      @others = others
    ].flatten.sort
  end

  def to(max_num)
    (@multiple1...max_num).to_a.select do |multiple|
      @multiples_arr.any? { |divisor| (multiple % divisor).zero? }
    end.sum
  end

  def self.to(num)
    pseudo_instance = new

    pseudo_instance.to(num)
  end
end
