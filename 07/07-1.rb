#!/usr/bin/env ruby

positions = $stdin.read.chomp.split(',').map(&:to_i).sort


costs = (positions.first..positions.last).to_a.map do |x|
  [x, positions.map{ |p| (p-x).abs }.reduce(:+)]
end

puts costs.sort_by { |position, cost| cost }.first


