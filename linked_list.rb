# frozen_string_literal: true

# Node for linked lists
class Node
  attr_accessor :next_node
  attr_reader :key, :value

  private

  attr_writer :key, :value

  def initialize(key, value = nil, next_node = nil)
    self.key = key
    self.value = value
    self.next_node = next_node
  end
end

# Link List class
class LinkedList
  attr_accessor :head

  def initialize
    self.head = nil
  end

  def append(key, value)
    return self.head = Node.new(key, value) if head.nil?

    node = head
    node = node.next_node until node.next_node.nil?
    node.next_node = Node.new(key, value)
  end

  def prepend(key, value)
    old_head = head
    self.head = Node.new(key, value)
    head.next_node = old_head
  end

  def size
    count = 0
    node = head
    until node.nil?
      node = node.next_node
      count += 1
    end
    count
  end

  def tail
    node = head
    node = node.next_node until node.next_node.nil?
    node
  end

  def at(index)
    node = head
    index.times { node = node.next_node }
    node
  end

  def pop
    at(size - 2).next_node = nil
  end

  def contains?(key)
    node = head
    until node.nil?
      return true if node.key == key

      node = node.next_node
    end
    false
  end

  def find(key)
    i = 0
    node = head
    until node.nil?
      return i if node.key == key

      node = node.next_node
      i += 1
    end
    nil
  end

  def to_s
    str = ""
    node = head
    until node.nil?
      str += "( #{node.key}: #{node.value} ) -> "
      node = node.next_node
    end
    "#{str}nil"
  end

  def insert_at(key, value, index)
    return if index > size
    return prepend(key, value) if index.zero?

    node = at(index - 1)
    next_node = node.next_node
    node.next_node = Node.new(key, value)
    node.next_node.next_node = next_node
  end

  def remove_at(index)
    return if index >= size || index.nil?

    if index.zero?
      old_head = head
      self.head = head.next_node
      return old_head.value
    end

    old_node = at(index)
    node = at(index - 1)
    node.next_node = node.next_node.next_node
    old_node.value
  end

  def set(key, value)
    index = find(key)
    if index.nil?
      append(key, value)
    else
      remove_at(index)
      insert_at(key, value, index)
    end
  end

  def get(key)
    node = head
    until node.nil?
      return node if node.key == key

      node = node.next_node
    end
    nil
  end

  def remove(key)
    return if key.nil?

    return unless (index = find(key))

    remove_at(index)
  end

  def keys
    size.times.map { |i| at(i).key }
  end

  def values
    size.times.map { |i| at(i).value }
  end

  def entries
    size.times.map do |i|
      node = at(i)
      [node.key, node.value]
    end
  end
end
