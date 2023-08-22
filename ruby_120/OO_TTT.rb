require "pry"
require "pry-byebug"

module Displayable
  def self.display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    puts ""
    puts "Get ready for your match - first to five wins!"
    puts ""
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe, #{human.name}! Goodbye!"
  end

  def display_current_round
    clear
    puts "Round #{@round_counter}"
    puts ""
  end

  def display_score
    display_current_round
    puts "The score is #{human.name}: #{human.score} " \
         "- #{computer.name}: #{computer.score}"
    puts ""
  end

  def display_board
    display_current_round
    display_score
    puts ""
    board.draw
    puts ""
  end

  def clear_screen_and_display_board
    clear
    if first_round?
      puts "You're a #{human.marker}. #{computer.name} is a" +
           computer.marker
    end
    puts ""
    display_score
    board.draw
    puts ""
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ""
  end

  def display_result
    clear_screen_and_display_board
    sleep(2)

    case board.winning_marker
    when human.marker
      puts "You won! The final score was #{human.score}:#{computer.score}"
    when computer.marker
      puts "#{computer.name} won! " \
           "The final score was #{human.score}:#{computer.score}"
    else
      puts "It's a tie!"
    end
    sleep(2)
  end

  def joinor(arr, delimiter=",", final_delimiter="or")
    return "#{arr[0]} #{final_delimiter} #{arr[-1]}" if arr.size == 2
    return arr[-1] if arr.size == 1
    arr[0..-2].join("#{delimiter} ") +
      "#{delimiter} #{final_delimiter} #{arr[-1]}"
  end

  def clear
    system('clear')
  end
end

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  attr_reader :squares

  def initialize
    @squares = {}
    reset
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def draw
    puts "     |     |"
    puts "  #{@squares[1]}  |  #{@squares[2]}  |  #{@squares[3]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[4]}  |  #{@squares[5]}  |  #{@squares[6]}"
    puts "     |     |"
    puts "-----+-----+-----"
    puts "     |     |"
    puts "  #{@squares[7]}  |  #{@squares[8]}  |  #{@squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def [](num)
    @squares[num]
  end

  def []=(num, marker)
    @squares[num].marker = marker
  end

  def unmarked_keys
    @squares.keys.select { |key| @squares[key].unmarked? }
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def potential_winning_square(marker)
    WINNING_LINES.each do |line|
      player_squares = line.select { |sq| squares[sq].marker == marker }
      if player_squares.size == 2 && single_empty_square_in_line(line,
                                                                 player_squares)
        return single_empty_square_in_line(line, player_squares)
      end
    end
    nil
  end

  # returns winning marker or nil
  def winning_marker
    WINNING_LINES.each do |line|
      squares = @squares.values_at(*line)
      if three_same_squares?(squares)
        return squares.first.marker
      end
    end
    nil
  end

  def reset
    (1..9).each { |key| @squares[key] = Square.new }
  end

  private

  def three_same_squares?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3

    markers.uniq.size == 1
  end

  def single_empty_square_in_line(line, player_squares)
    if squares[(line - player_squares)[0]].unmarked?
      return (line - player_squares)[0]
    end
    nil
  end
end

class Square
  INITIAL_MARKER = " "

  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    @marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def marked?
    marker != INITIAL_MARKER
  end
end

class Player
  include Displayable

  @@all_instances = []
  attr_reader :marker, :score, :name

  def initialize
    @name = choose_name
    @score = 0
    @marker = choose_marker
    @@all_instances << self
  end

  def self.all_instances
    @@all_instances
  end

  def increment_score
    @score += 1
  end

  def reset_score
    @score = 0
  end

  def make_move(board)
    raise NotImplementedError, "Subclasses must implement this method."
  end

  def choose_human_or_computer_randomly
    answer = %w(human computer).sample
    answer == 'human' ? self : opponent
  end

  private

  def opponent
    self.class.superclass.all_instances.find { |plyr| plyr != self }
  end

  def choose_name
    loop do
      puts "Choose a name for " \
           "#{instance_of?(Human) ? 'yourself' : 'the computer'}:"

      name = gets.chomp
      return name unless name.strip.empty?
      puts "Invalid input. Please enter a name"
    end
  end

  def choose_marker
    loop do
      puts "Choose a custom marker for " \
           "#{instance_of?(Human) ? 'yourself' : 'the computer'}:"
      choice = gets.chomp
      return choice if valid_marker_choice?(choice)
      puts "Invalid choice. Please choose a single character. It cannot be " \
           "the same as the player's marker."
    end
  end

  def valid_marker_choice?(choice)
    choice.size == 1 && !choice.strip.empty? &&
      !@@all_instances.any? { |inst| inst.marker == choice }
  end
end

class Human < Player
  def make_move(board)
    puts "Choose a square (#{joinor(board.unmarked_keys)}):"
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end

    board[square] = marker
  end

  def choose_first_move_settings
    answer = nil
    loop do
      puts "Do you want to choose who goes first " \
           "or assign first move at random? (enter choose/random)"
      answer = gets.chomp.downcase
      break if ['choose', 'random'].include?(answer)
      puts "Invalid choice. Please enter choose or random"
    end
    return decide_first_move if answer == 'choose'
    choose_human_or_computer_randomly
  end

  private

  def decide_first_move
    answer = nil
    loop do
      puts "Who gets first turn, #{name} or #{opponent.name}?"
      answer = gets.chomp
      break if [name, opponent.name].include?(answer)
      puts "Invalid choice, please enter #{name} or #{opponent.name}"
    end
    answer == name ? self : opponent
  end
end

class Computer < Player
  def make_move(board)
    if board.squares[5].unmarked?
      board[5] = marker
    elsif computer_winnable(board)
      board[computer_winnable(board)] = marker
    elsif human_winnable(board)
      board[human_winnable(board)] = marker
    else
      board[board.unmarked_keys.sample] = marker
    end
  end

  def human_winnable(board)
    board.potential_winning_square(opponent.marker)
  end

  def computer_winnable(board)
    board.potential_winning_square(marker)
  end
end

class TTTGame
  include Displayable

  attr_reader :board, :human, :computer

  def play
    clear
    main_game
    display_goodbye_message
  end

  private

  attr_accessor :first_move_marker

  def initialize
    @board = Board.new
    @squares = @board.squares
    @human = Human.new
    @computer = Computer.new
    @current_player = nil
    @round_counter = 1
  end

  def main_game
    loop do
      play_first_to_five
      display_result
      break unless play_again?
      display_play_again_message
      hard_reset
    end
  end

  def play_first_to_five
    loop do
      clear_screen_and_display_board
      first_move_settings if first_round?
      player_move
      @round_counter += 1
      update_score
      break if Player.all_instances.any? { |inst| inst.score == 5 }
      reset
    end
  end

  def first_round?
    @round_counter == 1
  end

  def player_move
    loop do
      @current_player.make_move(board)
      alternate_current_player
      break if board.someone_won? || board.full?

      clear_screen_and_display_board
    end
  end

  def alternate_current_player
    @current_player = (@current_player == human ? computer : human)
  end

  def first_move_settings
    @first_move_player = human.choose_first_move_settings
    @current_player = @first_move_player
  end

  def update_score
    case board.winning_marker
    when human.marker
      human.increment_score
    when computer.marker
      computer.increment_score
    end
    display_board
    sleep(2)
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include? answer
      puts "Sorry, must be y or n"
    end

    answer == 'y'
  end

  def reset
    @current_player = @first_move_player
    board.reset
    clear
  end

  def hard_reset
    reset
    @round_counter = 1
    human.reset_score
    computer.reset_score
  end
end

Displayable.display_welcome_message
game = TTTGame.new
game.play
