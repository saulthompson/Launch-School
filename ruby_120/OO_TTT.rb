require "pry"
require "pry-byebug"

module Displayable
  def self.display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    puts ""
  end
  
  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe, #{@human_name}! Goodbye!"
  end

  def display_score
    puts "The score is #{@human_name}: #{human.score} " \
         "- #{@computer_name}: #{computer.score}"
    puts ""
  end

  def display_board
    display_score
    puts ""
    board.draw
    puts ""
  end

  def clear_screen_and_display_board
    clear
    if first_round?
      puts "You're a #{@human_marker}. #{@computer_name} is a" +
           @computer_marker
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

    case board.winning_marker
    when @human_marker
      puts "You won! The final score was #{human.score}:#{computer.score}"
    when @computer_marker
      puts "#{@computer_name} won! " \
           "The final score was #{human.score}:#{computer.score}"
    else
      puts "It's a tie!"
    end
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

  def three_same_squares?(squares)
    markers = squares.select(&:marked?).collect(&:marker)
    return false if markers.size != 3

    markers.uniq.size == 1
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
  @@all_instances = []
  attr_reader :marker, :score, :name

  def initialize
    @name = choose_name
    @score = 0
    @marker = choose_marker
    @@all_instances << self
  end

  def choose_name
    loop do
      puts "Choose a name for " \
           "#{instance_of?(Human) ? 'yourself' : 'the computer'}:"

      name = gets.chomp
      return name unless name.empty?
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
    choice.size == 1 && !@@all_instances.any? { |inst| inst.marker == choice }
  end

  def increment_score
    @score += 1
  end

  def reset_score
    @score = 0
  end
end

class Human < Player; end

class Computer < Player; end

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
    @human_name = @human.name
    @human_marker = @human.marker
    @computer_name = @computer.name
    @computer_marker = @computer.marker
    @current_marker = nil
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
      player_move
      update_score
      break if human.score == 5 || computer.score == 5
      reset
    end
  end

  def player_move
    loop do
      choose_first_move_settings if first_round?
      @round_counter += 1
      current_player_moves

      break if board.someone_won? || board.full?

      clear_screen_and_display_board
    end
  end

  def first_round?
    @round_counter == 1
  end

  def choose_first_move_settings
    @first_move_marker = set_who_chooses_first_move
    @current_marker = @first_move_marker
  end

  def set_who_chooses_first_move
    answer = nil
    loop do
      puts "Who should choose who goes first, #{@human_name} " \
           "or #{@computer_name}?"
      answer = gets.chomp.downcase
      break if [@human_name.downcase, @computer_name.downcase].include?(answer)
      puts "Invalid choice. Please enter #{@human_name} or #{@computer_name}"
    end
    answer == @human_name.downcase ? human_decides : computer_decides
  end

  def human_decides
    answer = nil
    loop do
      puts "Who gets first turn, #{@human_name} or #{@computer_name}?"
      answer = gets.chomp
      break if [@human_name, @computer_name].include?(answer)
      puts "Invalid choice, please enter #{@human_name} or #{@computer_name}"
    end
    answer == @human_name ? @human_marker : computer.marker
  end

  def computer_decides
    answer = %w(human computer).sample
    answer == human ? @human_marker : computer.marker
  end

  def current_player_moves
    if human_turn?
      human_moves
      @current_marker = @computer.marker
    else
      computer_moves
      @current_marker = @human_marker
    end
  end

  def human_turn?
    @current_marker == @human_marker
  end

  def potential_winning_square(marker)
    Board::WINNING_LINES.each do |line|
      player_squares = line.select { |sq| @squares[sq].marker == marker }
      if player_squares.size == 2 && board[(line - player_squares)[0]].unmarked?
        return (line - player_squares).first
      end
    end
    nil
  end

  def human_moves
    puts "Choose a square (#{joinor(board.unmarked_keys)}):"
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end

    board[square] = @human_marker
  end

  def computer_moves
    human_winnable = potential_winning_square(@human_marker)
    computer_winnable = potential_winning_square(computer.marker)
    calculate_optimal_computer_move(human_winnable, computer_winnable)
  end

  def calculate_optimal_computer_move(human_winnable, computer_winnable)
    if @squares[5].unmarked?
      board[5] = @computer_marker
    elsif computer_winnable
      board[computer_winnable] = @computer_marker
    elsif human_winnable
      board[human_winnable] = @computer_marker
    else
      board[board.unmarked_keys.sample] = @computer_marker
    end
  end

  def update_score
    case board.winning_marker
    when @human_marker
      human.increment_score
    when computer.marker
      computer.increment_score
    end
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
    @current_marker = @first_move_marker
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
