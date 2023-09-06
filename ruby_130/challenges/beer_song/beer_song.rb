=begin

can accept either one argument for a verse number, or 2 arguments where 
the first is the starting verse, and the second is the end limit of a range
down from the value of the first argument, where each verse in between the two 
argument numbers is played

has a lyrics class method that plays all verses down from 99

verse class method with one argument for the verse number

=end

class BeerSong
  def self.verse(start, finish=start) # *finish?
    raise ArgumentError if start < 0 || finish < 0
    song = ""
    start.downto(finish) do |number|
      if number > 2
      song += "#{number} bottles of beer on the wall, #{number} bottles of beer.\n" \
        "Take one down and pass it around, #{number - 1} bottles of beer on the wall.\n" \
      elsif number == 2
        song += "2 bottles of beer on the wall, 2 bottles of beer.\n" \
        "Take one down and pass it around, 1 bottle of beer on the wall.\n"
      elsif number == 1
        song += "1 bottle of beer on the wall, 1 bottle of beer.\n" \
          "Take it down and pass it around, no more bottles of beer on the wall.\n" \
      elsif number == 0
        song +=  "No more bottles of beer on the wall, no more bottles of beer.\n" \
          "Go to the store and buy some more, 99 bottles of beer on the wall.\n" 
      end
    end
    song
  end
  
  def self.verses(start, finish=start)
    song = ""
    start.downto(finish) do |number|
      if number > 2
      song += "#{number} bottles of beer on the wall, #{number} bottles of beer.\n" \
        "Take one down and pass it around, #{number - 1} bottles of beer on the wall.\n" \
        "\n"
      elsif number == 2
        song += "2 bottles of beer on the wall, 2 bottles of beer.\n" \
        "Take one down and pass it around, 1 bottle of beer on the wall.\n\n"
      elsif number == 1
        song += "1 bottle of beer on the wall, 1 bottle of beer.\n" \
          "Take it down and pass it around, no more bottles of beer on the wall.\n\n" \
      elsif number == 0
        song +=  "No more bottles of beer on the wall, no more bottles of beer.\n" \
          "Go to the store and buy some more, 99 bottles of beer on the wall.\n\n" 
      end
    end
    song.chomp
  end
  
  def self.lyrics
    verses(99, 0) + "\n"
  end
end


puts BeerSong.verses(2, 0)