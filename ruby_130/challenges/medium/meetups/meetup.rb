# frozen_string_literal: true

#
# first, last, teenth
#
# day method:
#   - returns a date in same format as Date#civil
#   - use Date#wday
#   - iterate through numbers 1..31
#   - use a counter with case statement for first, second, etc.
#
#
require 'date'
require 'pry'
require 'pry-byebug'

class Meetup
  SCHEDULE = {
    'first' => 1,
    'second' => 2,
    'third' => 3,
    'fourth' => 4,
    'fifth' => 5,
    'teenth' => 'teenth',
    'last' => 'last'
  }.freeze

  WEEKDAY = {
    'sunday' => 1,
    'monday' => 2,
    'tuesday' => 3,
    'wednesday' => 4,
    'thursday' => 5,
    'friday' => 6,
    'saturday' => 7
  }.freeze

  def initialize(year, month)
    @month = month
    @year = year
  end

  def days_in_month
    case @month
    when 4, 6, 9, 11 then @days_in_month = 30
    when 1, 3, 5, 7, 8, 10, 12 then @days_in_month = 31
    when 2 then @days_in_month = @date.leap? ? 29 : 28
    end
  end

  def teenth(weekday)
    1.upto(days_in_month) do |dy|
      date = Date.civil(@year, @month, dy)
      return date if (date.wday + 1) == WEEKDAY[weekday.downcase] && (13..19).cover?(date.day)
    end
  end

  def last(weekday)
    1.upto(days_in_month) do |dy|
      date = Date.civil(@year, @month, dy)
      return date if (date + 7).month != date.month && WEEKDAY[weekday.downcase] == date.wday + 1
    end
  end

  def day(weekday, schedule)
    return teenth(weekday) if SCHEDULE[schedule.downcase] == 'teenth'
    return last(weekday) if SCHEDULE[schedule.downcase] == 'last'

    schedule_counter = 0
    1.upto(days_in_month) do |dy|
      date = Date.civil(@year, @month, dy)
      schedule_counter += 1 if (date.wday + 1) == WEEKDAY[weekday.downcase]
      return date if schedule_counter == SCHEDULE[schedule.downcase]
    end
    nil
  end
end
