module ManipulableCard
  # change the value of the first instance of ace card only
  def self.adjust_ace_value(hand)
    ace = hand.find { |card| card.type == 'A' }
    ace.value = 1
  end
end

module Displayable
  def welcome_message
    system('clear')
    puts "Welcome to Twenty-One!"
    puts ""
    sleep(1)
  end

  def goodbye_message
    sleep(1)
    puts ""
    puts "Thanks for playing Twenty-One. Goodbye!"
  end

  def show_initial_cards
    puts "Your hand is: #{joinor(player.card_types_in_hand)}"
    puts "The dealer's hand is: #{dealer.hand.sample.type} and *hidden*"
  end

  def show_cards_during_turn(participant)
    puts "#{participant.class.name}'s hand is: " +
         joinor(participant.card_types_in_hand)
  end

  def joinor(arr, delimiter=",", final_delimiter="and")
    return "#{arr[0]} #{final_delimiter} #{arr[-1]}" if arr.size == 2
    return arr[-1] if arr.size == 1
    arr[0..-2].join("#{delimiter} ") +
      "#{delimiter} #{final_delimiter} #{arr[-1]}"
  end

  def show_result
    if player.busted? || player.total < dealer.total
      puts "You lost! Your total was #{player.total}, the dealer's total " \
           "was #{dealer.total}"
    elsif dealer.busted? || player.total > dealer.total
      puts "You won! Your total was #{player.total}, the dealer's total " \
           "was #{dealer.total}"
    else
      puts "it was a tie!"
    end
  end
end

class Participant
  def initialize
    # state: name, hand total, busted?
    @hand = []
    @busted = false
  end

  attr_reader :hand, :busted

  def add_to_hand(cards)
    @hand += (cards)
  end

  def card_types_in_hand
    hand.map(&:type)
  end

  def stay; end

  def assess_ace_value
    loop do
      break unless busted? &&
                   @hand.any? { |card| card.type == 'A' && card.value == 11 }

      ManipulableCard.adjust_ace_value(@hand)
    end
  end

  def busted?
    @busted = true if total > 21
  end

  def total
    @hand.reduce(0) { |sum, card| sum + card.value }
  end
end

class Player < Participant
end

class Dealer < Participant
end

class Deck
  attr_reader :cards

  def initialize
    @cards = (cards_in_suite * 4).shuffle
  end

  def cards_in_suite
    cards = []
    (2..10).each { |num| cards.push(num) }
    cards += ['J', 'Q', 'K', 'A']

    cards.map! { |card_type| Card.new(card_type) }.shuffle!
  end

  def deal
    [@cards.pop, @cards.pop]
  end
end

class Card
  attr_reader :type
  attr_accessor :value

  def initialize(card_type)
    @type = card_type
    @value = card_value_in_game(card_type)
    # states: value
  end

  # default ace value is 11
  def card_value_in_game(card_type)
    case card_type
    when (2..10)
      card_type
    when 'J', 'Q', 'K'
      10
    when 'A'
      11
    end
  end
end

class Game
  include Displayable

  def initialize
    @deck = Deck.new
    @player = Player.new
    @dealer = Dealer.new
  end

  def play
    welcome_message
    deal
    show_initial_cards
    player_turn
    dealer_turn unless @player.busted?
    show_result
    goodbye_message
  end

  private

  attr_reader :player, :dealer

  def deal
    @player.add_to_hand(@deck.deal)
    @dealer.add_to_hand(@deck.deal)
  end

  def player_turn
    loop do
      break if choose_hit_or_stay == 'stay'
      hit(@player)
      show_cards_during_turn(@player)
      break if @player.busted?
    end
    stay(@player) unless @player.busted?
  end

  def choose_hit_or_stay
    loop do
      puts ""
      puts "Choose hit or stay:"
      choice = gets.chomp
      return choice if %w(hit stay).include?(choice.downcase)
      puts "Invalid choice. Please enter hit or stay"
    end
  end

  def dealer_turn
    loop do
      show_cards_during_turn(@dealer)
      break unless @dealer.total < 17
      hit(@dealer)
    end
    stay(@dealer)
  end

  def stay(participant)
    puts "#{participant.class.name} chose to stay at #{participant.total}."
  end

  def hit(participant)
    participant.add_to_hand([@deck.cards.pop])
    if participant.busted? && participant.card_types_in_hand.include?('A')
      participant.assess_ace_value
    end
  end
end

game = Game.new
game.play
