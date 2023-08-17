class Move
  attr_reader :value
  include Comparable
  
  @@move_number = 0
  @@tracker = {}
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']
  
  # def initialize(value)
  #   @value = value
  # end
  
  # def <=>(other_move)
  #   if value == 'rock'
  #     return 1 if other_move == 'scissors' || other_move == 'lizard'
  #     return -1 if other_move == 'paper' || other_move == 'spock'
  #     return 0 if other_move == value
  #   elsif value == 'paper'
  #     return 1 if other_move == 'rock' || other_move == 'spock'
  #     return -1 if other_move == 'scissors' || other_move == 'lizard'
  #     return 0 if other_move == value
  #   elsif value == 'scissors'
  #     return 1 if other_move == 'paper' || other_move == 'lizard'
  #     return -1 if other_move == 'rock' || other_move == 'spock'
  #     return 0 if other_move == value
  #   elsif value == 'lizard'
  #     return 1 if other_move == 'paper' || other_move == 'spock'
  #     return -1 if other_move == 'rock' || other_move == 'scissors'
  #     return 0 if other_move == value
  #   elsif value == 'spock'
  #     return 1 if other_move == 'rock' || other_move == 'scissors'
  #     return -1 if other_move == 'paper' || other_move == 'lizard'
  #     return 0 if other_move == value
  #   end
  # end
  
  def self.increment_move_number
    @@move_number += 1
  end
  
  def to_s
    self.class.name.downcase
  end
  
  def self.track(player, move)
    @@tracker[player.name] = ({@@move_number => move.to_s}) unless @@tracker[player.name]
    @@tracker[player.name].merge!({@@move_number => move.to_s})
  end
  
  def self.tracker
    @@tracker
  end
end

class Rock < Move
  
  def <=>(other_move)
    return 1 if other_move.to_s == 'scissors' || other_move.to_s == 'lizard'
    return -1 if other_move.to_s == 'paper' || other_move.to_s == 'spock'
    return 0 if other_move.to_s == self.to_s
  end
end

class Paper < Move
  
  def <=>(other_move)
    return 1 if other_move.to_s == 'rock' || other_move.to_s == 'spock'
    return -1 if other_move.to_s == 'scissors' || other_move.to_s == 'lizard'
    return 0 if other_move.to_s == self.to_s
  end
end

class Scissors < Move
  
  def <=>(other_move)
    return 1 if other_move.to_s == 'paper' || other_move.to_s == 'lizard'
    return -1 if other_move.to_s == 'rock' || other_move.to_s == 'spock'
    return 0 if other_move.to_s == self.to_s
  end
end

class Lizard < Move

  def <=>(other_move)
    return 1 if other_move.to_s == 'spock' || other_move.to_s == 'paper'
    return -1 if other_move.to_s == 'rock' || other_move.to_s == 'scissors'
    return 0 if other_move.to_s == self.to_s
  end
end

class Spock < Move
  
  def <=>(other_move)
    return 1 if other_move.to_s == 'rock' || other_move.to_s == 'scissors'
    return -1 if other_move.to_s == 'paper' || other_move.to_s == 'lizard'
    return 0 if other_move.to_s == self.to_s
  end
end

class Player
  attr_accessor :move, :name
  attr_reader :score
  
  def initialize
    set_name
    @score = 0
  end
  
  def increment_score
    self.score += 1
  end
  
  private
  
  attr_writer :score
end

class Human < Player
  def set_name
    n = ''
      loop do
        puts "Please enter your name:"
        n = gets.chomp
        break unless n.empty?
        puts "Sorry, must enter a value."
      end
      @name = n
  end
  
  def choose
     choice = nil
      loop do
        puts "Please choose rock, paper, scissors, lizard, or spock:"
        choice = gets.chomp
        break if Move::VALUES.include?(choice)
        puts "Sorry. Invalid choice..."
      end
      self.move = Object.const_get(choice.capitalize).new
      Move.increment_move_number
      Move.track(self, self.move)
  end
end

class Computer < Player
  NAMES = ['R2D2', 'C3P0', 'Hal', 'Chappie']
  
  def choose
    self.move = Object.const_get((Move::VALUES.sample).capitalize).new
    Move.track(self, self.move)
  end
end

class R2D2 < Computer
  def set_name
    @name = self.class.name
  end
  
  def choose
    Move.track(self, self.move)
    self.move = 'rock'
  end
  
  def to_s
    @name
  end
end

class C3P0 < Computer
  def set_name
    @name = self.class.name
  end
  
  def choose
    Move.track(self, self.move)
    self.move = ['paper', 'paper', 'paper', 'spock', 'spock'].sample
  end
  
  def to_s
    @name
  end
end

class Hal < Computer
  def set_name
    @name = self.class.name
  end
  
  def choose
    Move.track(self, self.move)
    self.move = ['scissors', 'scissors', 'scissors', 'scissors', 'rock'].sample
  end
  
  def to_s
    @name
  end
end

class Chappie < Computer
  def set_name
    @name = self.class.name
  end
  
  def choose
    Move.track(self, self.move)
    self.move = 'lizard'
  end
  
  def to_s
    @name
  end
end


class RPSGame
  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Object.const_get(Computer::NAMES.sample).new()
  end
  
  def display_welcome_message
    puts "Welcome to Rock, Paper, Scissors, lizard, spock!"
  end
  
  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors, lizard, spock, #{human.name}. Goodbye!"
  end
  
  def winner
    if human.move > computer.move
      return human
    elsif human.move < computer.move
      return computer
    end
    'tie'
  end
  
  def display_winner
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
    
    if winner == human
      puts "#{human.name} won!"
    elsif winner == computer
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
    
    # case human.move
    # when 'rock'
    #   puts "It's a tie!" if computer.move == 'rock'
    #   puts "#{human.name} won!" if computer.move == 'scissors'
    #   puts "#{computer.name} won!" if computer.move == 'paper'
    # when 'paper'
    #   puts "It's a tie!" if computer.move == 'paper'
    #   puts "#{human.name} won!" if computer.move == 'rock'
    #   puts "#{computer.name} won!" if computer.move == 'scissors'
    # when 'scissors'
    #   puts "It's a tie!" if computer.move == 'scissors'
    #   puts "#{human.name} won!" if computer.move == 'paper'
    #   puts "#{computer.name} won!" if computer.move == 'rock'
    # end
  end
  
  def update_score
    if winner == human
      human.increment_score
    elsif winner == computer
      computer.increment_score
    end
  end
  
  def display_final_winner
    if human.score == 5
      puts "#{human.name} won in first to 5! The score was 5:#{computer.score}."
    elsif computer.score == 5
      puts "#{computer.name} won in first to 5! The score was 5:#{human.score}."
    end
    puts Move::tracker
  end
  
  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include?(answer)
      puts "Sorry, must be y or n..."
    end
    return true if answer.downcase == 'y'
    false
  end
  
  def play
    loop do
      display_welcome_message
      loop do
        human.choose
        computer.choose
        display_winner
        update_score
        break if human.score == 5 || computer.score == 5
      end
      display_final_winner
      break unless play_again?
    end
    display_goodbye_message
  end
end

RPSGame.new.play