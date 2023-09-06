require 'minitest/autorun'
require 'minitest/reporters'

require_relative 'text'

Minitest::Reporters.use!

class TextTest < Minitest::Test
  def setup
    @f = File.open('sample_text.txt', 'r')
    @text_swapper = Text.new(@f.read)
  end
  
  def test_swap
    a_count = @text_swapper.text.count('a')
    e_count = @text_swapper.text.count('e')
    
    @text_swapper.swap('a', 'e')
    
    assert(!@text_swapper.text.include?('a'))
    assert_equal(a_count + e_count, @text_swapper.text.count('e'))
  end
  
  def test_word_count
    assert_equal(@text_swapper.text.count)
  end
  
  def teardown
    @f.close
  end
end