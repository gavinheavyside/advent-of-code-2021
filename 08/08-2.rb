#!/usr/bin/env ruby

require 'set'

# lengths 2  3  4  5      6      7
# numbers 1  7  4  2,3,5  0,6,9  8

def decode_segments(patterns)
  p1 = patterns[0]
  p7 = patterns[1]
  p4 = patterns[2]
  p8 = patterns[9]

  p2 = patterns[3..5].find { |p| (p - p4).size == 3 }
  p3 = patterns[3..5].find { |p| (p - p7).size == 2 }
  p5 = patterns[3..5].find { |p| ![p2,p3].include? p }
  p9 = p3 | p5
  p6 = p8 - p9 + p5

  mapping = {
    '1' => p1,
    '2' => p2,
    '3' => p3,
    '4' => p4,
    '5' => p5,
    '6' => p6,
    '7' => p7,
    '8' => p8,
    '9' => p9
  }
  mapping['0'] = patterns.find { |p| !mapping.values.include? p }

  mapping.invert
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
