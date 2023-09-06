# frozen_string_literal: true

# Clock object which can correctly format integer arguments into a 24-hour clock
# display. Subtraction and iteration of time in minutes can be performed.

class Clock
  attr_reader :time

  def initialize(hours, mins = '00')
    @time = handle_formatting([hours, mins])
  end

  class << self
    alias at new
  end

  def integerize
    @time.split(':').map(&:to_i)
  end

  def handle_formatting(hours_and_mins)
    hours_and_mins.map(&:to_s)
                  .each { |str| str.prepend('0') if str.size == 1 }.join(':')
  end

  def -(other)
    time_as_array = integerize
    difference = other.divmod(60) # format the argument into hours and minutes

    operand_arr = time_as_array.zip(difference) # put sets of hours and mins together
    hours, mins = operand_arr.map { |operands| operands.reduce(:-) }
    hours %= 24
    if mins.negative?
      hours = (hours - 1) % 24
      mins %= 60
    end

    Clock.new(hours, mins)
  end

  def +(other)
    time_as_array = integerize
    difference = other.divmod(60)

    operand_arr = time_as_array.zip(difference)
    hours, mins = operand_arr.map { |operands| operands.reduce(:+) }
    hours %= 24

    if mins >= 60
      hours = (hours + 1) % 24
      mins %= 60
    end

    Clock.new(hours, mins)
  end

  def ==(other)
    integerize == other.integerize
  end

  def to_s
    @time
  end
end
