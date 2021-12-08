#!/usr/bin/env ruby

# lengths 2  3  4  5      6      7
# numbers 1  7  4  2,3,5  0,6,9  8


require 'set'

def decode_segments(patterns)
  p1 = patterns[0]
  p7 = patterns[1]
  p4 = patterns[2]
  p8 = patterns[9]

  mapping = {}
  mapping['a'] = p7 - p1

  horizontals = patterns[3..5].reduce(:&)
  mapping['e'] = patterns[3..5].select do |p|
    (p - horizontals - p4).size == 1
  end.flatten.first - horizontals - p4 

  mapping['g'] = p8 - p7 - p4 - mapping['e']

  n3 = patterns[3..5].select{ |p| (p - p7).size == 2 }.flatten.first
  mapping['d'] = n3 - p7 - mapping['g']

  n5 = patterns[3..5].select do |p|
    (p - horizontals - p1 - mapping['e']).size == 1
  end.flatten.first
  mapping['b'] = n5 - horizontals - p1 - mapping['e']

  n2 = patterns[3..5].select do |p|
    (p - horizontals - mapping['e']).size == 1
  end.flatten.first

  mapping['c'] = n2 - horizontals - mapping['e']

  mapping['f'] = p1 - mapping['c']

  all = mapping.values.reduce(:+)
  {
    '0' => (all - mapping['d']),
    '1' => (mapping['c'] + mapping['f']),
    '2' => (all - mapping['b'] - mapping['f']),
    '3' => (all - mapping['b'] - mapping['e']),
    '4' => (mapping['b'] + mapping['c'] + mapping['d'] + mapping['f']),
    '5' => (all - mapping['c'] - mapping['e']),
    '6' => (all - mapping['c']),
    '7' => (mapping['c'] + mapping['f'] + mapping['a']),
    '8' => all,
    '9' => (all - mapping['e'])
  }.invert
end

input = $stdin.readlines.map do |row|
  patterns, digits = row.chomp.split(' | ')
  {
    patterns: patterns.split.map{ |p| Set.new(p.chars) }.sort_by{ |p| p.size },
    digits: digits.split.map{ |p| Set.new(p.chars) }
  }
end

readouts = input.map do |row|
  mapping = decode_segments(row[:patterns])
  row[:digits].map{ |d| mapping[d] }.join.to_i
end

puts readouts.reduce(:+)
