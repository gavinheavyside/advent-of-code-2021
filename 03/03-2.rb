#!/usr/bin/env ruby

def partition(working_set, column_number, type)
  return working_set if working_set.size == 1

  group1, group0 = working_set.partition { |row| row[column_number] == '1' }

  if type == :o2
    group0.size > group1.size ? group0 : group1
  else
    group1.size < group0.size ? group1 : group0
  end
end

def rating(working_set, type)
  (0..working_set.first.size).each do |i|
    working_set = partition(working_set, i, type)
  end
  working_set.first.join.to_i(2)
end

working_set = $stdin.readlines.map{ |row| row.chomp.chars }

o2_rating = rating(working_set.dup, :o2)
co2_rating = rating(working_set.dup, :co2)

puts o2_rating * co2_rating
