#!/usr/bin/env ruby


def list_neighbourhood(heights, x, y)
  min_x = [0, x-1].max
  min_y = [0, y-1].max
  max_x = [heights.first.size-1, x+1].min
  max_y = [heights.size-1, y+1].min

  [[min_y, x], [y, min_x], [y, x], [y, max_x], [max_y, x]].uniq.map do |(y,x)|
    heights[y][x]
  end
end

heights = $stdin.readlines.map{ |r| r.chomp.chars.map(&:to_i) }

minimums = heights.each_with_index.map do |row, y|
  row.each_with_index.select do |height, x|
    neighbourhood = list_neighbourhood(heights, x, y)
    is_min = (height == neighbourhood.min) && (neighbourhood.count(height) == 1)
#    puts [x, y, height, neighbourhood, neighbourhood.count(height), is_min].inspect
    is_min
  end.map(&:first)
end.compact.flatten

#puts minimums.inspect
puts minimums.map{ |m| m + 1 }.reduce(:+)
