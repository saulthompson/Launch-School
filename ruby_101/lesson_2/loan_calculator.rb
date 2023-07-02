require 'yaml'
MESSAGES = YAML.load_file('messages.yml')

def prompt(message)
  puts "=> #{message}"
end
monthly_interest = 0
loan_amount = 0
months = 0
loan_currency = ""

loop do
  loop do
    prompt(<<-MSG)
Welcome to the loan calculator!
=> Enter the total loan amount:#{' '}
MSG

    loan_amount_string = gets.chomp

    if loan_amount_string[0].to_i == 0
      loan_currency = loan_amount_string[0]
      loan_amount_string[0] = ""
      if loan_amount_string.to_i.to_s != loan_amount_string
        prompt(MESSAGES['invalid'])
        next
      end
    end

    if loan_amount_string.to_i.to_s == loan_amount_string
      loan_amount = loan_amount_string.to_i
      puts "Your loan is for #{loan_currency}#{loan_amount}."
      break
    end
  end

  loop do
    prompt("Enter the repayment period, in months:")
    months_string = gets.chomp
    if months_string.to_i.to_s == months_string
      months = months_string.to_i
      puts "Your repayment period is #{months} months."
      break
    end
    prompt(MESSAGES['invalid'])
  end

  loop do
    prompt("Enter the APR percentage for your loan:")

    monthly_interest = (gets.chomp.to_f) / 12

    if monthly_interest > 0
      puts "Your monthly interest rate is #{format('%.2f', monthly_interest)}%"
      break
    end
    prompt(MESSAGES['invalid'])
  end

  monthly_payment =
    loan_amount * (monthly_interest / (1 - ((1 + monthly_interest)**(-months))))

  puts "your monthly payment will be
  #{loan_currency}#{format('%.2f', monthly_payment)}."
  prompt("Would you like to make another calculation? (y/n)")
  answer = gets.chomp

  if answer.downcase[0] != "y"
    prompt("Thank you for using Loan Calculator!")
    break
  end
end
