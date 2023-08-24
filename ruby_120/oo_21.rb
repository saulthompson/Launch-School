module ManipulableCard
  # change the value of the first instance of ace card in the hand only
  def self.adjust_ace_value(hand)
    ace = hand.find { |card| card.type == 'Ace' }
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
    puts "#{participant}'s hand is: " +
         joinor(participant.card_types_in_hand)
  end

  def joinor(arr, delimiter=",", final_delimiter="and")
    return "#{arr[0]} #{final_delimiter} #{arr[-1]}" if arr.size == 2
    return arr[-1] if arr.size == 1
    arr[0..-2].join("#{delimiter} ") +
      "#{delimiter} #{final_delimiter} #{arr[-1]}"
  end

  def hit_message(participant)
    puts ""
    puts "#{participant} hit!"
  end

  def stay_message(participant)
    puts ""
    puts "#{participant} chose to stay at #{total}."
    puts ""
  end

  def busted_message(participant)
    puts "#{participant.class} busted!"
  end

  def show_result
    sleep(1)
    if player.busted? || (!dealer.busted? && player.total < dealer.total)
      puts "You lost! Your total was #{player.total}, the dealer's total " \
           "was #{dealer.total}"
    elsif dealer.busted? || (player.total > dealer.total && !dealer.busted?)
      puts "You won! Your total was #{player.total}, the dealer's total " \
           "was #{dealer.total}"
    else
      puts "it was a tie!"
    end
  end
  sleep(1.5)
end

class Participant
  include Displayable
  attr_reader :hand

  def initialize
    @hand = []
  end

  def add_to_hand(cards)
    @hand += cards
  end

  def busted?
    true if total > 21
  end

  def card_types_in_hand
    hand.map(&:type)
  end

  def total
    @hand.reduce(0) { |sum, card| sum + card.value }
  end

  private

  def hit(deck)
    hit_message(self)
    add_to_hand([deck.cards.pop])
    return unless busted? && card_types_in_hand.include?('Ace')
    assess_ace_value
  end

  def stay
    stay_message
  end

  def assess_ace_value
    loop do
      break unless busted? &&
                   @hand.any? { |card| card.type == 'Ace' && card.value == 11 }

      ManipulableCard.adjust_ace_value(@hand)
    end
  end

  def to_s
    self.class.name
  end
end

class Player < Participant
  def take_turn(deck)
    loop do
      break if choose_hit_or_stay == 'stay'
      hit(deck)
      show_cards_during_turn(self)
      break if busted?
    end
    busted? ? busted_message(self) : stay
  end

  private

  def choose_hit_or_stay
    loop do
      puts ""
      puts "Choose hit or stay:"
      choice = gets.chomp
      return choice if %w(hit stay).include?(choice.downcase)
      puts "Invalid choice. Please enter hit or stay"
    end
  end
end

class Dealer < Participant
  def take_turn(deck)
    loop do
      show_cards_during_turn(self)
      sleep(2)
      break unless total < 17
      hit(deck)
    end
    busted? ? busted_message(self) : stay
  end
end

class Deck
  attr_reader :cards

  def initialize
    @cards = (cards_in_suite * 4).shuffle
  end

  def deal
    [@cards.pop, @cards.pop]
  end

  private

  def cards_in_suite
    cards = []
    (2..10).each { |num| cards << num }
    cards += ['Jack', 'Queen', 'King', 'Ace']

    cards.map! { |card_type| Card.new(card_type) }.shuffle!
  end
end

class Card
  attr_reader :type
  attr_accessor :value

  def initialize(card_type)
    @type = card_type
    @value = card_value_in_game(card_type)
  end

  # default ace value is 11
  def card_value_in_game(card_type)
    case card_type
    when (2..10)
      card_type
    when 'Jack', 'Queen', 'King'
      10
    when 'Ace'
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
    @player.take_turn(@deck)
    @dealer.take_turn(@deck) unless @player.busted?
    show_result
    goodbye_message
  end

  private

  attr_reader :player, :dealer

  def deal
    @player.add_to_hand(@deck.deal)
    @dealer.add_to_hand(@deck.deal)
  end
end

game = Game.new
game.play
