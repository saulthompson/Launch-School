require 'simplecov'
require 'minitest/autorun'
require "minitest/reporters"
SimpleCov.start
Minitest::Reporters.use!

require_relative 'todo'

class TodoListTest < Minitest::Test

  def setup
    @todo1 = Todo.new("Buy milk")
    @todo2 = Todo.new("Clean room")
    @todo3 = Todo.new("Go to gym")
    @todos = [@todo1, @todo2, @todo3]

    @list = TodoList.new("Today's Todos")
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
  end

  def test_to_a
    assert(@list.to_a == [@todo1, @todo2, @todo3])
  end
  
  def test_size
    assert_equal(@todos.size, @list.size)
  end
  
  def test_first
    assert_equal(@todo1, @list.first)
  end
  
  def test_last
    assert_equal(@todo3, @list.last)
  end
  
  def test_shift
    todo = @list.shift
    assert_equal([@todo2, @todo3], @list.to_a)
    assert_equal(@todo1, todo)
  end
  
  def test_pop
    todo = @list.pop
    refute_includes(@list.to_a, todo)
    assert_equal(@todo3, todo)
  end
  
  def test_done_question
    assert_equal(false, @list.done?)
  end
  
  def test_add_raise_error
    assert_raises(TypeError) {@list.add('item')}
  end
  
  def test_shovel_method
    scream = Todo.new('scream')
    @list << scream
    assert_includes(@list.to_a, scream)
  end
  
  def test_add_alias_method
    scream = Todo.new('scream')
    @list << scream
    assert_includes(@list.to_a, scream)
  end
  
  def test_item_at
    assert_equal(@todo1, @list.item_at(0))
    assert_raises(IndexError) {@list.item_at(6)}
  end
  
  def test_mark_done_at
    assert_raises(IndexError) {@list.mark_done_at(100) }
    
    @list.mark_done_at(2)
    assert_equal(true, @todo3.done?)
    assert_equal(false, @todo2.done?)
  end
  
  def test_mark_undone_at
    @todo1.done!
    @todo2.done!
    @todo3.done!
    
    assert_raises(IndexError) {@list.mark_undone_at(100) }
    
    @list.mark_undone_at(2)
    
    assert_equal(false, @todo3.done?)
  end
  
  def test_done_bang
    @list.done!
    
    assert_equal(true, @todo1.done?)
    assert_equal(true, @todo2.done?)
    assert_equal(true, @todo3.done?)
    assert_equal(true, @list.done?)
  end
  
  def test_remove_at
    @list.remove_at(1)
    
    assert_raises(IndexError) {@list.remove_at(100)}
    assert_equal([@todo1, @todo3], @list.to_a)
  end
  
  def test_to_s
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [ ] Buy milk
    [ ] Clean room
    [ ] Go to gym
    
    OUTPUT
  
    assert_equal(output, @list.to_s)
  end
  
  def test_to_s_2
    @todo2.done!
    
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [ ] Buy milk
    [X] Clean room
    [ ] Go to gym
    
    OUTPUT
    
    assert_equal(output, @list.to_s)
  end
  
  def test_to_s_3
    @list.done!
    
    output = <<~OUTPUT.chomp
    ---- Today's Todos ----
    [X] Buy milk
    [X] Clean room
    [X] Go to gym
    
    OUTPUT
    assert_equal(output, @list.to_s)
  end
  
  def test_each
    @list.each { |todo| todo.done! }
    assert_equal(true,  @list.done?)
  end
  
  def test_each_returns_caller
    assert_equal(@list.each {|item| nil}, @list)
  end
  
  def test_select
    @todo1.done!
    
    assert_equal([@todo1], @list.select { |todo| todo.done? }.to_a)
  end
  
  def test_find_by_title
    str = 'Go to gym'
    assert_equal(@todo3, @list.find_by_title(str))
  end
  
  def test_all_done
    @todo1.done!
    @todo2.done!
    @todo3.done!
    
    assert_equal([@todo1, @todo2, @todo3], @list.all_done.to_a)
  end
  
  def test_all_not_done
    assert_equal([@todo1, @todo2, @todo3], @list.all_not_done.to_a)
  end
  
  def test_mark_done
    @list.mark_done('Go to gym')
    
    assert_equal(true, @todo3.done?)
  end
  
  def test_mark_all_done
    @list.mark_all_done
    
    assert_equal(true, @list.done?)
  end
  
  def test_mark_all_undone
    @todo1.done!
    @todo2.done!
    @todo3.done!
    
    @list.mark_all_undone
    
    assert_equal([@todo1, @todo2, @todo3], @list.all_not_done)
  end
end