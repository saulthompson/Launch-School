=begin

Problem: Build a ToDoList class that can collect ToDo objects

Explicit requirements:
  - has a 'add' method that only takes Todo objects
  - has a << method that behaves the same way as add
  - has a done? method that returns true if all todos are done
  - item_at(index) method
  - to_a method
  - mark_done_at(index) method (custom setter method?) that raises 
    an IndexError if the index is out of range (use fetch?). Include a
    undone_at method
  - done! method marks all items as done
  - shift, pop, remove_at(index)
  - to_s method calls the to_s method of each todo object in the list

=end
# This class represents a todo item and its associated
# data: name and description. There's also a "done"
# flag to show whether this todo item is done.

class Todo
  DONE_MARKER = 'X'
  UNDONE_MARKER = ' '

  attr_accessor :title, :description, :done

  def initialize(title, description='')
    @title = title
    @description = description
    @done = false
  end

  def done!
    self.done = true
  end

  def done?
    done
  end

  def undone!
    self.done = false
  end

  def to_s
    "[#{done? ? DONE_MARKER : UNDONE_MARKER}] #{title}"
  end

  def ==(otherTodo)
    title == otherTodo.title &&
      description == otherTodo.description &&
      done == otherTodo.done
  end
end


# This class represents a collection of Todo objects.
# You can perform typical collection-oriented actions
# on a TodoList object, including iteration and selection.

class TodoList
  attr_accessor :title

  def initialize(title)
    @title = title
    @todos = []
  end
  
  def add(item)
    item.class == Todo ? (todos << item) : (raise TypeError, "Can only add Todo objects.")
  end
  
  alias_method :<<, :add
  
  def done?
    todos.all? { |todo| todo.done? }
  end
  
  def item_at(index)
    todos.fetch(index)
  end
  
  def size
    todos.size
  end
  
  def first
    todos.first
  end
  
  def last
    todos.last
  end
  
  def to_a
    todos.clone
  end
  
  def mark_done_at(index)
    todos[index] ? todos[index].done! : (raise IndexError)
  end
  
  def mark_undone_at(index)
    todos[index] ? todos[index].undone! : (raise IndexError)
  end
  
  def done!
    todos.map { |todo| todo.done! }
  end
  
  def shift
    todos.shift
  end
  
  def pop
    todos.pop
  end
  
  def remove_at(index)
    todos[index] ? todos.delete_at(index) : (raise IndexError)
  end
  
  def each
    todos.each { |todo| yield(todo) }
    self
  end
  
  def select
    results = []
    todos.each {|todo| results << todo if yield(todo) }
    TodoList.new(title).add(*results)
  end
  
  def find_by_title(str)
    todos.select {|todo| todo.title == str }.first
  end
  
  def all_done
    todos.select { |todo| todo.done? }
  end
  
  def all_not_done
    todos.select { |todo| !todo.done? }
  end
  
  def mark_done(str)
    todos.select { |todo| todo.title == str || todo.description == str }[0].done!
  end
  
  def mark_all_done
    each { |todo| todo.done! }
  end
  
  def mark_all_undone
    each { |todo| todo.undone! }
  end
  
  def to_s
    text = "---- Today's Todos ----\n"
    todos.each { |todo| text += (todo.to_s) + "\n" }
    text
  end
  
  private
  
  attr_accessor :todos
end




# todo1 = Todo.new("Buy milk")
# todo2 = Todo.new("Clean room")
# todo3 = Todo.new("Go to gym")

# list = TodoList.new("Today's Todos")
# list.add(todo1)
# list.add(todo2)
# list.add(todo3)

# list.item_at(1).done!

# # p (list.each do |todo|
# #   puts todo                   # calls Todo#to_s
# # end)

# p list.mark_all_done    # you need to implement this method
