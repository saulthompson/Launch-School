require 'pry'
require 'pry-byebug'

INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

=begin
input: an array, an optional delimiter string char, and an optional connector word string
output: a string resulting from joining the array, with custom joining before the final element

implicit rules:
  there should be a space after the delimiter
  there is a default of ', ' for the second parameter
  there is a default of 'or' for the third parameter
  there is no additional space char in the third parameter
  the space needs to be handled elsewhere in the algorithm
  if there are only two elements, there should be no comma
  
examples:

p joinor([1, 2])                   # => "1 or 2"
p joinor([1, 2, 3])                # => "1, 2, or 3"
p joinor([1, 2, 3], '; ')          # => "1; 2; or 3"
p joinor([1, 2, 3], ', ', 'and')   # => "1, 2, and 3"


DS:
  array
  string
  
Algorithm:
  if arr.size == 2
    join with ' or ' delimiter
  else
    cause all except the last element to join with second parameter
      cause the last element to join with with third paramete
  end

  use array slice to join all but the last element
    use string concatenation
      
  
=end
=begin
defensive AI algo:
  if PLAYER_MARKER is the value of any two of three elements in WINNING_LINES
    -iterate over WINNING_LINES with `each`
      get the values of board for the line
        initialize `empty` and `non_empty` for split assignment
        partition the array based on if value is ' '
          if the `empty` has size of 1
            assign `square` to the key in brd where computer should place its piece
              - empty_squares.index()
            with `square` as the `brd` key / brd[square] = COMPUTER_MARKER
            break
      end
    computer places piece at the remaining element of that line
  else
    computer selects `square` randomly from `empty_squares`
  end
=end


def joinor(arr, delim = ", ", final_delim = 'or')
  if arr.size == 1
    return arr.first
  elsif arr.size == 2
    return arr.join(" or ")
  else
    return arr.slice(0..-2).join(delim) + "#{delim}#{final_delim} #{arr[-1]}"
  end
end


def prompt(msg)
  puts "=> #{msg}"
end

def display_board(brd, player_score, computer_score)
  system('clear')
  puts ""
  puts "Player: #{player_score} : Computer: #{computer_score}"
  puts ""
  puts "       |       |"
  puts "   #{brd[1]}   |   #{brd[2]}   |  #{brd[3]}"
  puts "       |       |"
  puts "------ +------ +----"
  puts "       |       |"
  puts "   #{brd[4]}   |   #{brd[5]}   |  #{brd[6]}"
  puts "       |       |"
  puts "------ +------ +-----"
  puts "       |       |"
  puts "   #{brd[7]}   |   #{brd[8]}   |  #{brd[9]}"
  puts "       |       |"
  puts ""
end

def initialize_board
    new_board = {}
    (1..9).each {|num| new_board[num] = INITIAL_MARKER}
    new_board
end

def empty_squares(brd)
  brd.keys.select{|num| brd[num] == INITIAL_MARKER}
end

def player_places_piece!(brd)
  square = INITIAL_MARKER
  loop do
    prompt "choose a square (#{joinor(empty_squares(brd))}):"
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt("sorry, that's not a valid choice")
  end
  brd[square] = PLAYER_MARKER
end

def at_risk_square(brd)
  WINNING_LINES.each do |line|
    values = brd.values_at(*line)
    player_pieces, other = values.partition {|el| el == PLAYER_MARKER}
    if player_pieces.size == 2 && !other.include?(COMPUTER_MARKER)
      square = line[values.index(" ")]
      return square
    end
  end
  nil
end

def winning_square(brd)
  WINNING_LINES.each do |line|
    values = brd.values_at(*line)
    other = values.partition {|el| el == PLAYER_MARKER}[1]
    if other.size == 3 && other.partition {|el| el == COMPUTER_MARKER}[0].size == 2
      square = line[values.index(" ")]
      return square
    end
  end
  nil
end

def computer_places_piece!(brd)
  if winning_square(brd)
    brd[winning_square(brd)] = COMPUTER_MARKER
  elsif at_risk_square(brd)
    brd[at_risk_square(brd)] = COMPUTER_MARKER
  elsif brd[5] == " "
    brd[5] = COMPUTER_MARKER
  else
    square = empty_squares(brd).sample
    brd[square] = COMPUTER_MARKER
  end
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    return 'Player' if brd.values_at(*line).all? {|val| val == PLAYER_MARKER}
    return 'Computer' if brd.values_at(*line).all? {|val| val == COMPUTER_MARKER}
  end
  nil
end

def place_piece!(board, current_player)
  if current_player == "Computer"
    computer_places_piece!(board)
  else
    player_places_piece!(board)
  end
end

def alternate_player(current_player)
  current_player == "Player" ? "Computer" : "Player"
end


loop do
  board = initialize_board
  player_score = 0
  computer_score = 0
  
  loop do
    prompt("Let the computer randomly choose who goes first? (y/n)")
    if gets.chomp.downcase.start_with?('y')
      answer = [true, false].sample
    else
      prompt("Should the player take the first turn? (y/n)")
      if gets.chomp.downcase.start_with?("y")
        answer = true
      end
    end
    current_player = (answer ? "Player" : "Computer")

    loop do
    
      display_board(board, player_score, computer_score)
    
        place_piece!(board, current_player)
        current_player = alternate_player(current_player)
        break if someone_won?(board) || board_full?(board)
      end
      
    display_board(board, player_score, computer_score)

    if someone_won?(board)
      prompt "#{detect_winner(board)} won!"
      sleep(1.5)
      if detect_winner(board) == "Player"
        player_score += 1
      elsif detect_winner(board) == "Computer"
        computer_score += 1
      end
    else
      prompt "It's a tie!"
      sleep(1.5)
    end
    break if player_score == 5 || computer_score == 5
    display_board(board, player_score, computer_score)
    prompt("Continue to next round? (y/n)")
    answer = gets.chomp
    break if answer.downcase.start_with?('n')
    board = initialize_board
  end
  prompt("The #{detect_winner(board)} won this series of best of 5 games!")
  prompt("Would you like to play again? (y/n)")
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end
prompt("Thanks for playing tic-tac-toe! Goodbye.")


=begin
keep score of how many times the computer and player each win

input: 'computer' or 'player' - string
output: mutates the `score`, eventually breaks the loop

explicit rules: 
  break the loop when player_score or computer_score reaches 5
implicit rules: 
  will need `player_score` and `computer_score` variables
  need to display the score and adjust it after each round
  will need to work in tandem with `detect_winner`
  
  
examples:
.............................................................
  
  


problem: let the user decide if the computer chooses who's turn is first

prompt let the computer choose who goes first?
get user answer
if computer should choose
  let computer choose
    `computer_choice` = [1, 2].sample
    if `computer_choice` == 1
      computer_choice == false
    else
      computer_choice == 'self'
    end
  
  if `computer_choice`
if not computer should choose
  prompt user for who should go first
    get `answer` from user
      answer = false unless user chooses yes
       
        if answer is true
          execute player move
        end
          execute computer move
            if answer is false
              execute player move
            end
            
=end
  