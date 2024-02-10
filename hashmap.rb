# frozen_string_literal: true

require "./linked_list"

# My implementation of a HashMap
class HashMap
  attr_accessor :buckets, :load_factor

  def initialize
    clear
    self.load_factor = 0.75
  end

  def hash(key)
    hash_code = 0
    prime_number = 31

    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }

    hash_code % buckets.size
  end

  def set(key, value)
    i = hash(key)
    raise IndexError if i.negative? || i >= buckets.length

    buckets[i] = LinkedList.new if buckets[i].nil?
    buckets[i].set(key, value)
    grow_buckets
  end

  def get(key)
    i = hash key
    raise IndexError if i.negative? || i >= buckets.length

    buckets[i]&.get(key)&.value
  end

  def has(key)
    i = hash key
    raise IndexError if i.negative? || i >= buckets.length

    !buckets[i]&.get(key).nil?
  end

  def remove(key)
    i = hash key
    raise IndexError if i.negative? || i >= buckets.length

    return unless (bucket = buckets[i])

    bucket.remove(key)
  end

  def length
    buckets.reduce(0) { |sum, bucket| sum + (bucket&.size || 0) }
  end

  def clear
    self.buckets = Array.new(16)
  end

  def keys
    buckets.reduce([]) { |arr, bucket| arr.concat(bucket&.keys || []) }
  end

  def values
    buckets.reduce([]) { |arr, bucket| arr.concat(bucket&.values || []) }
  end

  def entries
    buckets.reduce([]) { |arr, bucket| arr.concat(bucket&.entries || []) }
  end

  def load
    1 - buckets.count(nil) / buckets.length.to_f
  end

  def grow_buckets
    return  if load_factor > load

    pairs = entries
    self.buckets = Array.new(buckets.length + 16)
    pairs.each { |pair| set(pair[0], pair[1]) }
  end

  def to_s
    buckets.each_with_index.reduce("") { |str, (bucket, i)| "#{str}#{i}. #{bucket || 'nil'}\n" }
  end
end
