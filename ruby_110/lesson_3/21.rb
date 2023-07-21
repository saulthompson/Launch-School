# frozen_string_literal: true

# input => a deck of 52 cards, in randomized order
# output => a boolean value => either player wins, or player busts
#
# explicit rules:
#   Card	Value
# 2 - 10	            face value
# jack, queen, king	  10
# ace	                1 or 11
#
# - the goal is to get as close as possible to 21, without going over
# - both players are initially dealt 2 cards
# - player has first turn
# - player has two choices, hit or stay.
# - hit adds another card to player's hand
# - stay means player's turn is over, dealer's turn starts
# - dealer must choose hit, unless his total is >= 17
# - after the dealer stays, the hands are compared, highest values wins
#
# implicit rules:
#   if the player or dealer's cards' value exceeds 21, they lose and game shortcircuits
#   an ace already in a hand can change value depending on the value of a newly added card
#
#
# Examples:
#   Dealer has: Ace and unknown card
#   You have: 2 and 8
#
#   player should hit
#
# DS:
#   CARDS are in a hash of hashes: first level is suites, second level is cards and values
#   `deck` is an array formed from the hashes, each elemnent is concatenation of suite and card key from CARDS hash
#   player's and dealer's hands are both hashes formed from a random selection from `deck`, with the values obtained from CARDS
#   the ace's value is a variable
#
# Algorithm:
#
# 1. Initialize deck
# 2. Deal cards to player and dealer
# 3. Player turn: hit or stay
#   - repeat until bust or "stay"
# 4. If player bust, dealer wins.
# 5. Dealer turn: hit or stay
#   - repeat until total >= 17
# 6. If dealer bust, player wins.
# 7. Compare cards and declare winner.
#
#
# Subprocesses:
#
#   1. CARDS = {
#     hearts => {1 => 1 ... k => 10, a => 1}
#     diamonds =>
#     spades =>
#     clubs =>
#   }
#     initialize deck, a randomized array formed from CARDS
#
#
#   2.
#       draw(deck) method
#         deck.delete(deck.sample)
#       end
#
#       deal(deck) method
#         first = draw(deck)
#         second = draw(deck)
#         hand = {first => CARDS[spades][first], second =>...}
#         hand = first.merge(second)
#         if hand.key?(ace)
#           hand[ace] = ace_value(hand)
#         return hand
#
#       player_hand, dealer_hand = deal(deck), deal(deck)
#
#   3. player turn
#       display player_hand and one, random card from dealer_hand
#       prompt hit or stay
#         if hit
#           hand = hit(deck, hand)
#           return player_lost if bust?(hand)
#           display new hand
#         - repeat until bust? or "stay"
#
#         if player bust, return dealer wins
#
#   4. dealer turn
#
#       unless value of dealer_hand >= 17
#         dealer chooses hit
#           dealer_hand.merge(deal(deck))
#           determine value of aces, if any present
#           - repeat
#         else dealer stays
#         if dealer busts, return player wins, else..
#
#   5. compare cards
#         get value of each hand
#           value = hand.values.sum
#         whichever is closest to 21 wins
#           if (21 - player_value) <= (21 - dealer_value)
#             player wins
#           else
#             dealer wins
#           end
#
#   6. display result
#
#
#   Methods:
#
#     def ace_value(hand)
#       ace = 11 if 11 + (each value in hand) <= 21
#     else ace = 1
#     end
#
#     def hit(deck, hand)
#       hand = hand.merge(draw(deck))
#     end
#
#
#
#     def display_hands(player_hand, dealer_hand)
#       player_value = player_hand.map {|key, val| "#{val}" }
#       ...
#       dealer_value = dealer_hand.map... .sample
#       puts "Dealer has => #{dealer_value} and an unknown card"
#       puts "You have => player_value.join(' and ')"
#     end
#
#     def bust?(hand)
#       hand.values.sum > 21 ? bust  => not bust
#     end
#
#

require 'pry'
require 'pry-byebug'

CARD_VALUES =
  {
    :Ace => 0,
    2 => 2,
    3 => 3,
    4 => 4,
    5 => 5,
    6 => 6,
    7 => 7,
    8 => 8,
    9 => 9,
    10 => 10,
    :Jack => 10,
    :Queen => 10,
    :King => 10
  }.freeze

TARGET = 21

# methods

def prompt(msg)
  puts "=> #{msg}"
end

def welcome_message
  system('clear')
  prompt "Hello, and welcome to #{TARGET}!"
  sleep(0.5)
  system('clear')
  sleep(0.5)
  prompt "Step right this way, #{TARGET} and under over here!"
  prompt 'Best of 5 rounds'
  sleep(1)
end

def draw(deck)
  # destructively get a random number from the deck, without deleting other instances of the number
  card = deck.sample
  deck.delete(card)
end

def deal(deck)
  first = draw(deck)
  second = draw(deck)
  hand = { first => CARD_VALUES[first], second => CARD_VALUES[second] }
  hand[:Ace] = ace_value(hand) if hand.key?(:Ace)
  hand
end

def choose_hit?
  loop do
    prompt 'Do you want to hit? (y/n)'
    answer = gets.chomp
    if answer.downcase.start_with?('y')
      return true
    elsif answer.downcase.start_with?('n')
      return false
    else
      prompt("Please enter 'y' or 'n'")
    end
  end
end

def hit(deck, player_hand)
  card = draw(deck)
  hand = player_hand.merge({ card => CARD_VALUES[card] })
  hand[:Ace] = ace_value(hand) if hand.key?(:Ace)

  hand
end

def ace_value(hand)
  hand.values.sum <= (TARGET - 11) ? 11 : 1
end

def player_turn(deck, player_hand)
  prompt 'Do you want to hit? (y/n)'
  return player_hand unless gets.chomp.downcase.start_with?('y')

  hit(deck, player_hand)
end

def dealer_turn(deck, dealer_hand)
  prompt 'Dealer turn...'
  while dealer_hand.values.sum < (TARGET - 4)
    dealer_hand = hit(deck, dealer_hand)
    prompt 'Dealer hit!'
    sleep(2)
    prompt "Dealer now has #{dealer_hand.values.sum} total (#{dealer_hand.keys.join(' and ')})"
    sleep(2)
  end
  dealer_hand
end

def display_hands(player_hand, dealer_hand, score)
  system('clear')
  prompt "player #{score['player']} : #{score['dealer']} dealer"
  player_cards = player_hand.map { |key, _| key }
  dealer_cards = dealer_hand.map { |key, _| key }

  prompt "Dealer has: at least #{dealer_hand.values[0]} (#{dealer_cards[0]} and unknown)"
  prompt "You have: #{player_hand.values.sum} total (#{player_cards.join(' and ')})"
  sleep(2)
end

def bust?(hand)
  hand.values.sum > TARGET
end

def increment_score(score, winner)
  return if winner == 'tie'

  score[winner] += 1
  score['round'] += 1
  sleep(1.5)
end

def match_over?(score)
  score['round'] == 5 || score['player'] == 3 || score['dealer'] == 3
end

def compare_results(player_hand, dealer_hand)
  if player_hand.values.sum > dealer_hand.values.sum
    'player'
  elsif dealer_hand.values.sum > player_hand.values.sum
    'dealer'
  else
    'tie'
  end
end

def display_winner(winner, player_hand, dealer_hand)
  if winner == 'tie'
    prompt 'It was a tie!'
  else
    prompt("#{winner} wins!")
  end
  prompt("You got #{player_hand.values.sum}, dealer got #{dealer_hand.values.sum}")
  sleep(3)
end

def play_again?
  prompt 'Would you like to play again? (y/n)'
  gets.chomp.downcase.start_with?('y')
end

def display_summary(score)
  system('clear')
  prompt 'You played best of five against the dealer'

  if score['player'] == score['dealer']
    prompt "It's a tie!"
  elsif score['player'] > score['dealer']
    prompt "You won #{score['player']} - #{score['dealer']}!"
  else
    prompt "You lost #{score['player']} - #{score['dealer']}!"
  end
end
# main program code

# welcome messages
welcome_message

loop do
  score = {
    'player' => 0,
    'dealer' => 0,
    'round' => 0
  }

  # main loop
  loop do
    system('clear')

    # initialize deck
    deck = [].fill(CARD_VALUES.keys, 0..3).flatten.shuffle

    # initial deal
    player_hand = deal(deck)
    dealer_hand = deal(deck)

    # player turn
    loop do
      display_hands(player_hand, dealer_hand, score)
      break unless choose_hit?

      player_hand = hit(deck, player_hand)

      display_hands(player_hand, dealer_hand, score)
      next unless bust?(player_hand)

      prompt('Busted! You lose')
      increment_score(score, 'dealer')
      break
    end
    if match_over?(score)
      display_summary(score)
      break
    end
    next if bust?(player_hand)

    # dealer turn
    dealer_hand = dealer_turn(deck, dealer_hand)

    if bust?(dealer_hand)
      prompt('The dealer busted. You win!')
      increment_score(score, 'player')
      if match_over?(score)
        display_summary(score)
        break
      end
      next
    end
    prompt('dealer stayed')

    # player and dealer stay - now compare and display results
    winner = compare_results(player_hand, dealer_hand)
    display_winner(winner, player_hand, dealer_hand)
    increment_score(score, winner)
    if match_over?(score)
      display_summary(score)
      break
    end
  end

  # let player choose
  play_again? ? next : break
end
prompt("Thanks for playing #{TARGET}!")
