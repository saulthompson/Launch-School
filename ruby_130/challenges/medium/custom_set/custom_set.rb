class CustomSet
  attr_reader :contents
  
  def initialize(arr=nil)
    @contents = arr ? arr : nil
  end
  
  def empty?
    !contents
  end
  
  def contains?(num)
    return false unless contents
    contents.contains?(num)
  end
  
  def subset?(other)
    return false unless contents && other.contents
    contents.all? { |item| other.contains?(item) }
  end
  
  def eql?(other)
    contents.sort == other.contents.sort
  end
  
  def add(arr)
    return self unless arr && contents
    contents = (contents + arr).uniq
  end
  
  def intersection(other)
    return CustomSet.new unless contents
    CustomSet.new(contents.select { |el| other.contains?(el) })
  end
  
  def disjoint?(other)
    !intersection(other)
  end
  
  def difference(other)
    return self unless other.contents
    CustomSet.new(contents - other.contents)
  end
  
  def union(other)
    CustomSet.new((contents + other.contents).uniq)
  end
  
  def ==(other)
    return false unless contents
    contents.sort == other.contents.sort
  end
end