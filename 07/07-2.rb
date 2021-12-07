#!/usr/bin/env ruby

positions = $stdin.read.chomp.split(',').map(&:to_i).sort

def partial_sum(n)
  (n * (n+1))/2
end

costs = (positions.first..positions.last).to_a.map do |x|
  [x, positions.map{ |p| partial_sum((p-x).abs) }.reduce(:+)]
end

puts costs.sort_by { |position, cost| cost }.first


