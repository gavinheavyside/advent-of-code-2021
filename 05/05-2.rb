#!/usr/bin/env ruby

def interpolate(a, b)
  (a > b) ? (b..a).to_a.reverse : (a..b).to_a
end

rows = $stdin.readlines.map{ |row| row.chomp.split }

coord_pairs = rows.map do |row|
  [row.first, row.last].map { |pair| pair.split(',').map(&:to_i) }
end

vented = Hash.new { |k,v| k[v] = 0}

coord_pairs.each do |(x1,y1), (x2,y2)|
  x_coords = interpolate(x1, x2)
  y_coords = interpolate(y1, y2)

  x_coords *= y_coords.size if x_coords.size == 1
  y_coords *= x_coords.size if y_coords.size == 1

  x_coords.zip(y_coords).each do |(x,y)|
    vented[[x,y]] += 1
  end
end

puts vented.select{ |k,v| v > 1 }.size
