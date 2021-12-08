#!/usr/bin/env ruby

input = $stdin.readlines.map do |row|
  patterns, digits = row.chomp.split(' | ')
  { patterns: patterns.split, digits: digits.split }
end

puts input.map{ |v| v[:digits].select { |d| [2,3,4,7].any? { |i| d.size == i } } }.flatten.compact.size

