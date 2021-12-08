#!/usr/bin/env ruby

require 'set'

# lengths 2  3  4  5      6      7
# numbers 1  7  4  2,3,5  0,6,9  8

def decode_segments(patterns)
  p1 = patterns[0]
  p7 = patterns[1]
  p4 = patterns[2]
  p8 = patterns[9]

  horizontals = patterns[3..5].reduce(:&)

  p2 = patterns[3..5].find { |p| (p - horizontals - p4).size == 1 }
  p3 = patterns[3..5].find { |p| (p - p7).size == 2 }
  p5 = (patterns[3..5] - [p2,p3]).first

  e_segment = p2 - horizontals - p4 
  c_segment = p2 - horizontals - e_segment 
  g_segment = p8 - p7 - p4 -  e_segment
  d_segment = p3 - p7 - g_segment

  {
    '0' => p8 - d_segment,
    '1' => p1,
    '2' => p2,
    '3' => p3,
    '4' => p4,
    '5' => p5,
    '6' => p8 - c_segment,
    '7' => p7,
    '8' => p8,
    '9' => p8 - e_segment
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
