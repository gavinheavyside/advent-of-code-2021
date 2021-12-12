#!/usr/bin/env ruby

def tick_neighbourhood(grid, x, y)
  min_x = [0, x-1].max
  min_y = [0, y-1].max
  max_x = [grid.first.size-1, x+1].min
  max_y = [grid.size-1, y+1].min

  (min_x..max_x).each do |x|
    (min_y..max_y).each do |y|
      grid[y][x][:value] += 1
      if grid[y][x][:value] > 9 && !grid[y][x][:flashed]
        grid[y][x][:flashed] = true
        tick_neighbourhood(grid, x, y)
      end
    end
  end
end

def tick(grid)
  grid.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      grid[y][x][:value] += 1
      if grid[y][x][:value] > 9 && !grid[y][x][:flashed]
        grid[y][x][:flashed] = true
        tick_neighbourhood(grid, x, y)
      end
    end
  end

  flashes = 0
  grid.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      if cell[:flashed]
        flashes += 1
        grid[y][x][:value] = 0
        grid[y][x][:flashed] = false
      end
    end
  end

  flashes
end

grid = $stdin.readlines.map do |r|
  r.chomp.chars.map{ |c| { flashed: false, value: c.to_i } }
end

tick = 0
tick_flashes = 0
total_flashes = 0

while tick_flashes != (grid.size * grid.first.size) do
  tick_flashes = tick(grid)
  total_flashes += tick_flashes
  tick += 1
  break if tick_flashes == grid.size * grid.first.size
end

puts "All flashed on tick #{tick}"
puts total_flashes
