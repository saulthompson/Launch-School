class DNA
  def initialize(strand)
    @strand = strand
  end
  
  def hamming_distance(distance)
    result = 0
    
    if @strand.size < distance.size
      zipped = @strand.chars.zip(distance.chars)
      zipped.each { |first, second| result += 1 unless first == second } 
    else
      zipped = distance.chars.zip(@strand.chars)
      zipped.each { |first, second| result += 1 unless first == second } 
    end
    result
  end
end