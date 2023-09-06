require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use!

require_relative 'cash_register'
require_relative 'transaction'

class CashRegisterTest < Minitest::Test
  def test_accept_money
    register = CashRegister.new(5000)
    transaction = Transaction.new(20)
    transaction.amount_paid = 20
    
    previous_amount = register.total_money
    register.accept_money(transaction)
    current_amount = register.total_money
    
    assert_equal previous_amount + 20, current_amount
  end
  
  def test_change
    register = CashRegister.new(5000)
    transaction = Transaction.new(50)
    transaction.amount_paid = 100
    
    assert_equal transaction.amount_paid - transaction.item_cost, register.change(transaction)
  end
  
  def test_give_receipt
    register = CashRegister.new(5000)
    transaction = Transaction.new(50)
    transaction.amount_paid = 100
    
    assert_output("You've paid $#{transaction.item_cost}.\n") { register.give_receipt(transaction) }
  end
  
  def test_prompt_for_payment_method
    transaction = Transaction.new(10)
    assert_equal(0, transaction.amount_paid)
    cost = transaction.item_cost
    test_input = StringIO.new("#{2.times.map { |i| cost - 1 + i }.join("\n")}")
    expected_output = <<~E_OUTPUT
      You owe $#{cost}.
      How much are you paying?
      That is not the correct amount. Please make sure to pay the full cost.
      You owe $#{cost}.
      How much are you paying?
      E_OUTPUT
    assert_output(expected_output) do
      transaction.prompt_for_payment(input: test_input)
    end
    assert_instance_of(Float, transaction.amount_paid)
    assert_equal(cost, transaction.amount_paid)
  end
end