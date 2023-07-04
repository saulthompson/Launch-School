# frozen_string_literal: true

# Thoughts:
# 	methods:
# 		- prompt
# 		- get_user_name
# 		- valid_name?
# 		- get_numbers
# 		- get_operator
# 		- valid_number?
# 		- valid_operator?
# 		- calculate
# 		- display_calculation
# 		- display_result
# 		- again?
#
#
# 		Should there be clear separation of functionality between the display
# 		and prompt methods?
#
# PEDAC
#
# Problem:
# 	Get two numbers from the user, ask the user what operation they wish
# to perform, perform the operation, show the result, ask the user if they
# wish to perform another operation.
#
# Input:
# 	two numbers, from the user
#
# Output:
# 	One number, the result of an artithmetic operation peformed on
# the two input numbers
#
# Rules:
# 	The operation to be selected and performed must be one of: add, subtract,
# 	multiply, or divide
# 	(follow all variable and method naming conventions)
# 	(keep length of all methods under 15 lines)
#
# Examples: ...
#
# DS: ...
#
# Algorithm:
# 	Get two numbers; validate
# 	Get operator by associating with numbers 1..4; validate
# 	perform operation
# 	display operation return value
#

require 'yaml'
require 'pry'

MESSAGES = YAML.load_file('calculator_messages.yml')

OPERATORS = {
  '1' => '/',
  '2' => '*',
  '3' => '+',
  '4' => '-'
}.freeze

# Methods
def prompt(message, options = {})
  Kernel.puts("=> #{format(MESSAGES[message], options)}")
end

def display(message)
  Kernel.system('clear')
  Kernel.puts("=> #{message}")
end

def get_user_name
  loop do
    prompt('get_user_name')
    user_name = Kernel.gets.chomp
    Kernel.system('clear')
    valid_user_name?(user_name) ? (return user_name) : next
  end
end

def valid_user_name?(name)
  return true unless name.strip.empty?

  prompt('invalid_entry')
  false
end

def get_num
  loop do
    prompt('get_num')
    num = Kernel.gets.chomp
    Kernel.system('clear')
    return num if valid_num?(num)
  end
end

def valid_num?(num)
  return true if /^-?\d+$/.match?(num)

  prompt('invalid_entry')
end

def get_operator
  loop do
    prompt('get_operator')
    operator = Kernel.gets.chomp
    return OPERATORS[operator] if %w[1 2 3 4].include?(operator)

    prompt('invalid_entry')
  end
end

def calculate(num1, num2, operator)
  case operator
  when '/'
    division_calculator(num1, num2)
  when '*'
    format_decimal_places!(num1.to_f * num2.to_f)
  when '+'
    format_decimal_places!(num1.to_f + num2.to_f)
  when '-'
    format_decimal_places!(num1.to_f - num2.to_f)
  end
end

def division_calculator(num1, num2)
  return format_decimal_places!(num1.to_f() / num2) if num2.to_f != 0

  'zero_div'
end

def format_decimal_places!(num)
  /\.\d*0\z/.match?(num.to_s) ? num.round : num.round(1)
end

def continue?
  prompt('continue?')
  user_choice = Kernel.gets.chomp
  user_choice.start_with?('y') ? true : false
end

# main code

# welcome
system('clear')
prompt('welcome')
user_name = get_user_name

prompt('user_name', name: user_name)

# main calculator loop
loop do
  num1 = get_num
  display(num1)
  operator = get_operator
  display("#{num1} #{operator} ...")
  num2 = get_num

  calculation = calculate(num1, num2, operator)

  if calculation == 'zero_div'
    prompt('zero_div', name: user_name)
    next
  else
    display('Calculating...')
    Kernel.sleep(0.8)
    system('clear')
    prompt('result', {
             res: calculation,
             num1: num1,
             op: operator,
             num2: num2
           })
  end
  next if continue?

  prompt('goodbye', name: user_name)

  break
end
