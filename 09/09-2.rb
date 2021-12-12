#!/usr/bin/env ruby


def flood_neighbourhood(heights, x, y, count)
  return 0 if heights[y][x] == 9

  min_x = [0, x-1].max
  min_y = [0, y-1].max
  max_x = [heights.first.size-1, x+1].min
  max_y = [heights.size-1, y+1].min

  heights[y][x] = 9
  count += 1

  to_explore = [[min_y, x], [y, min_x], [y, max_x], [max_y, x]].uniq - [[y,x]]
  to_explore.map do |(y,x)|
    count += flood_neighbourhood(heights, x, y, 0)
  end

  count
end

heights = $stdin.readlines.map{ |r| r.chomp.chars.map(&:to_i) }

basins = []

0.upto(heights.size-1).each do |y|
  0.upto(heights.first.size-1).each do |x|
    basins << flood_neighbourhood(heights, x, y, 0)
  end
end

puts basins.select(&:positive?).sort.reverse.take(3).reduce(:*)
