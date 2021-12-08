#!/usr/bin/env ruby

# lengths 2  3  4  5      6      7
# numbers 1  7  4  2,3,5  0,6,9  8


def decode_segments(patterns)
  p1 = patterns[0]
  p7 = patterns[1]
  p4 = patterns[2]
  p8 = patterns[9]

  mapping = {}
  mapping['a'] = p7 - p1

  horizontals = patterns[3].intersection(patterns[4]).intersection(patterns[5])
  mapping['e'] = patterns[3..5].map{ |i| i - horizontals - p4 }.flatten.compact

  mapping['g'] = p8 - p7 - p4 - mapping['e']

  n3 = patterns[3..5].select{ |p| (p - p7).size == 2 }.flatten
  mapping['d'] = n3 - p7 - mapping['g']

  n5 = patterns[3..5].select do |p|
    (p - horizontals - p1 - mapping['e']).size == 1
  end.flatten
  mapping['b'] = n5 - horizontals - p1 - mapping['e']

  n2 = patterns[3..5].select do |p|
    (p - horizontals - mapping['e']).size == 1
  end.flatten
  mapping['c'] = n2 - horizontals - mapping['e']

  mapping['f'] = p1 - mapping['c']

  all = mapping.values.flatten
  {
    '0' => (all - mapping['d']).sort,
    '1' => (mapping['c'] + mapping['f']).sort,
    '2' => (all - mapping['b'] - mapping['f']).sort,
    '3' => (all - mapping['b'] - mapping['e']).sort,
    '4' => (mapping['b'] + mapping['c'] + mapping['d'] + mapping['f']).sort,
    '5' => (all - mapping['c'] - mapping['e']).sort,
    '6' => (all - mapping['c']).sort,
    '7' => (mapping['c'] + mapping['f'] + mapping['a']).sort,
    '8' => all.sort,
    '9' => (all - mapping['e']).sort
  }.invert
end

input = $stdin.readlines.map do |row|
  patterns, digits = row.chomp.split(' | ')
  {
    patterns: patterns.split.map{ |p| p.chars.sort }.sort_by{ |p| p.size },
    digits: digits.split.map{ |p| p.chars.sort }
  }
end

readouts = input.map do |row|
  mapping = decode_segments(row[:patterns])
  row[:digits].map{ |d| mapping[d] }.join.to_i
end

puts readouts.reduce(:+)
