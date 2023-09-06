# frozen_string_literal: true

class Octal
  def initialize(str)
    @number = str
  end

  def to_decimal
    return 0 unless valid_octal?

    @number.to_i.digits.map.with_index do |dgt, exponent|
      dgt * (8**exponent)
    end.sum
  end

  private

  def valid_octal?
    return false unless @number.to_i.digits.all? { |dgt| dgt < 8 } && !@number.match?(/[a-z]/i)

    true
  end
end
