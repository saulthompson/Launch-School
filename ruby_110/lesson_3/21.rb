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

CARDS = {
  diamonds: {
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
  },
  hearts: {
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
  },
  spades: {
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
  },
  clubs: {
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
  }
}

TARGET = 21

#methods

def draw(deck)
  deck.delete(deck.sample)
end

def deal(deck)
  first = draw(deck)
  second = draw(deck)
  hand = { first => CARDS[:spades][first], second => CARDS[:spades][second] }
  hand.key?(:A) && hand[:A] = ace_value(hand)
  hand
end

def ace_value(hand)
  hand.values.sum <= (TARGET - 11) ? 11 : 1
end

def player_turn(deck, player_hand, dealer_hand, player_score, dealer_score)
  display_hands(player_hand, dealer_hand, player_score, dealer_score)
  loop do
    puts 'Do you want to hit? (y/n)'
    break unless gets.chomp.downcase.start_with?('y')

    player_hand = hit(deck, player_hand)
    display_hands(player_hand, dealer_hand, player_score, dealer_score)
    return 'player lost' if bust?(player_hand)
  end
  player_hand.values.sum
end

def dealer_turn(deck, dealer_hand)
  puts "Dealer turn..."
  while dealer_hand.values.sum < (TARGET - 4)
    dealer_hand = hit(deck, dealer_hand)
    puts 'Dealer hit!'
    sleep(1.3)
    puts "Dealer's cards are now #{dealer_hand.values.join(' and ')}"
    sleep(1.3)
  end
  return 'dealer lost' if dealer_hand.values.sum > TARGET

  dealer_hand.values.sum
end

def display_hands(player_hand, dealer_hand, player_score, dealer_score)
  system('clear')
  puts "player #{player_score} : #{dealer_score} dealer"
  player_cards = player_hand.map { |key, _val| key }
  dealer_cards = dealer_hand.map { |key, _val| key }

  puts "Dealer has: #{dealer_cards[0]} and unknown"
  puts "You have: #{player_cards.join(' and ')}"
end

def hit(deck, player_hand)
  hand = player_hand.merge({ a = draw(deck) => CARDS[:spades][a] })
  hand.key?(:Ace) && hand[:Ace] = ace_value(hand)
  hand
end

def bust?(hand)
  hand.values.sum > TARGET
end

def compare_results(player_hand, dealer_hand)
  player_hand >= dealer_hand ? 'player' : 'dealer'
end

def play_again?(player_score, dealer_score, round_counter)
  if round_counter == 5 || (player_score == 3 || dealer_score == 3)
      end_game(player_score, dealer_score)
      return false
  end
  puts 'Would you like to play again? (y/n)'
  gets.chomp.downcase.start_with?('y')
end

def end_game(player_score, dealer_score)
  puts "You played best of five against the dealer"
  if player_score > dealer_score
    puts "You won #{player_score} - #{dealer_score}!"
  elsif player_score < dealer_score
    puts "you lost #{player_score} - #{dealer_score}!"
  end
end
# main program code

#welcome messages
system('clear')
puts "How now, Jack Black?"
sleep(1)
system('clear')
sleep(1)
puts "Step right this way, #{TARGET} and under over here!"
puts "Best of 5 rounds"
sleep(1.5)


player_score = 0
dealer_score = 0
round_counter = 0

#main loop
loop do
  
  round_counter += 1
  if round_counter == 6
    end_game(player_score, dealer_score)
    break
  end
    
  system('clear')
  puts "player: #{player_score} : #{dealer_score} dealer"
  
  #initialize deck
  deck = CARDS.values.map { |hsh| hsh.map { |key, _val| key } }.flatten.shuffle!
  
  #initial deal
  player_hand = deal(deck)
  dealer_hand = deal(deck)

  #player turn
  player_hand = player_turn(deck, player_hand, dealer_hand, player_score, dealer_score)

  if player_hand == 'player lost'
    puts 'Busted. You lost!'
    dealer_score += 1
    sleep(1.3)
    play_again?(player_score, dealer_score, round_counter) ? next : break
  end
  
  #dealer turn
  dealer_hand = dealer_turn(deck, dealer_hand)

  if dealer_hand == 'dealer lost'
    player_score += 1
    puts 'The dealer busted. You win!'
    play_again?(player_score, dealer_score, round_counter) ? next : break
  end

  #player and dealer stay - now compare and display results
  if compare_results(player_hand, dealer_hand) == 'player'
    puts "You got #{player_hand}. The dealer got #{dealer_hand}. You win!"
    player_score += 1
    puts "player #{player_score} : #{dealer_score} dealer"
    sleep(1.3)
    play_again?(player_score, dealer_score, round_counter) ? next : break
  else
    puts "The dealer got #{dealer_hand}. You got #{player_hand}. Dealer wins!"
    dealer_score += 1
    sleep(1.3)
  end
  
    #let player choose unless best of 5 has been completed
    
    play_again?(player_score, dealer_score, round_counter) ? next : break 
end

puts "Thanks for playing #{TARGET}!"
