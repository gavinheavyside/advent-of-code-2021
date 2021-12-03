#!/usr/bin/env ruby

def partition(working_set, column_number, type)
  return working_set if working_set.size == 1

  groups = working_set.partition { |row| row[column_number] == '1' }

  if type == :o2
    partition(groups.max_by(&:size), column_number + 1, type)
  else
    partition(groups.reverse.min_by(&:size), column_number + 1, type)
  end
end

def rating(working_set, type)
  rating_set = partition(working_set.dup, 0, type)
  rating_set.first.join.to_i(2)
end

working_set = $stdin.readlines.map{ |row| row.chomp.chars }

o2_rating = rating(working_set, :o2)
co2_rating = rating(working_set, :co2)

puts o2_rating * co2_rating
