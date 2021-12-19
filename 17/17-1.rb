#!/usr/bin/env ruby

def on_target_x?(location, target)
  location[:x] >= target[:min_x] && location[:x] <= target[:max_x]
end

def on_target_y?(location, target)
  location[:y] >= target[:min_y] && location[:y] <= target[:max_y]
end

def on_target?(location, target)
  on_target_x?(location, target) && on_target_y?(location, target)
end

def could_make_it?(location, target, v_init, tick)
  y_possible = on_target_x?(location, target) && location[:y] >= target[:min_y]
  x_possible = location[:x] <= target[:max_x] && v_init[:x] > tick

  x_possible || y_possible
end

def x_at_t(vx0, tick)
  tx = [tick, vx0].min
  (tx * vx0) - (tx * (tx - 1) / 2)
end

def y_at_t(vy0, tick)
  (tick * vy0) - (tick * (tick - 1) / 2)
end

def solve_init_x_for(min_x)
  ((1 + Math.sqrt(8 * min_x + 1)) / 2).floor
end

def solve_init_y_for(max_x, min_y)
  ((min_y + (max_x * (max_x - 1) / 2)) / max_x).ceil
end

gets.chomp =~ /^target area: x=([-]?\d+)..([-]?\d+), y=([-]?\d+)..([-]?\d+)$/

x1, x2, y1, y2 = (1..4).map { |i| Regexp.last_match(i).to_i }

target = { min_x: x1, max_x: x2, min_y: y1, max_y: y2 }

min_init_x = solve_init_x_for(target[:min_x])
max_init_x = target[:max_x] # if it overshoots on step 1, too far

min_init_y = target[:min_y]
max_init_y = solve_init_y_for(target[:max_x], target[:min_y])

max_init_y *= 10 # ugly brute force because my clever limit didn't work :(

puts [min_init_x, max_init_x, min_init_y, max_init_y].inspect

peaks = []
(min_init_x..max_init_x).to_a.each do |init_x|
  (min_init_y..max_init_y).to_a.each do |init_y|
    tick = 0
    position = { x: 0, y: 0 }
    v0 = { x: init_x, y: init_y }

    peak = target[:min_y]
    while !on_target?(position, target) && could_make_it?(position, target, v0, tick)
      tick += 1
      position = { x: x_at_t(v0[:x], tick), y: y_at_t(v0[:y], tick) }

      peak = [peak, position[:y]].max
      peaks << peak if on_target?(position, target)
    end
  end
end

puts peaks.max
puts peaks.count
