#!/usr/bin/env ruby

input = $stdin.readlines.map{ |row| row.chomp.chars }

groups = input.transpose.map { |column| column.group_by{ |i| i } }

gamma = groups.map { |column| column['0'].size > column['1'].size ? 0 : 1 }
epsilon = gamma.map { |i| i^1 }

puts gamma.join.to_i(2) * epsilon.join.to_i(2)
