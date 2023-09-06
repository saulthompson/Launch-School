class Robot
  attr_reader :name
  @@names = []
  
  def initialize
    loop do
      @name = ''
      2.times { @name += (rand(26) + 65).chr }
      3.times { @name += rand(9).to_s }
      break unless @@names.include? @name
    end
    @@names << @name
  end
  
  def reset
    @name = Robot.new.name
  end
end