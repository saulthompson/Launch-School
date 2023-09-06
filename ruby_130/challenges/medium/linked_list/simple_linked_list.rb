# frozen_string_literal: true

class Element
  attr_reader :datum, :next

  def initialize(datum, next_el = nil)
    @datum = datum
    @next = next_el
  end

  def tail?
    !@next
  end
end

class SimpleLinkedList
  def initialize
    @data = []
  end

  def self.from_a(arr)
    list = new
    return list if arr.nil?

    arr.reverse.each { |item| list << item }
    list
  end

  def to_a
    @data.reverse.each_with_object([]) { |el, arr| arr << el.datum }
  end

  def reverse
    list = SimpleLinkedList.new
    @data.reverse.each { |el| list.push(el.datum) }
    list
  end

  def push(datum)
    @data << Element.new(datum, @data.last)
  end

  alias << push

  def pop
    @data.pop.datum
  end

  def head
    @data.last
  end

  def peek
    head&.datum
  end

  def size
    @data.size
  end

  def empty?
    @data.empty?
  end
end
