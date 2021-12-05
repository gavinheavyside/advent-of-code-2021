#!/usr/bin/env ruby

def interpolate(a, b)
  (a,b) = [a,b].sort
  (a..b).to_a
end

rows = $stdin.readlines.map{ |row| row.chomp.split }

coord_pairs = rows.map do |row|
  [row.first, row.last].map { |pair| pair.split(',').map(&:to_i) }
end.select do |(x1,y1), (x2,y2)|
  x1 == x2 || y1 == y2
end

coord_pairs.size 

vented = Hash.new { |k,v| k[v] = 0}

coord_pairs.each do |(x1,y1), (x2,y2)|
  interpolate(x1, x2).each do |x|
    interpolate(y1, y2).each do |y|
      vented[[x,y]] += 1
    end
  end
end

puts vented.select{ |k,v| v > 1 }.size
