#!/usr/bin/env ruby

def foldx(paper, coord)
  paper.reduce({}) do |memo, (y, row)|
    left, right = row.partition{ |x| x < coord }
    new_row = left + right.map { |x| 2*coord - x }
    memo[y] = new_row.uniq
    memo
  end
end

def foldy(paper, coord)
  low_rows = paper.select{ |y, row| y < coord}

  paper.each do |y, row|
    if y >= coord
      low_rows[2*coord - y] = (Array(low_rows[2*coord - y]) + row).uniq
    end
  end
  low_rows
end

coords = []
folds = []

while line = gets
  if line =~ /^(\d+),(\d+)$/
    coords << [$1.to_i, $2.to_i]
  elsif line =~ /^fold along ([xy])=(\d+)$/
    folds << [$1, $2.to_i]
  end
end

paper = coords.reduce(Hash.new{|h,k| h[k] = []}) do |memo, (x, y)|
  memo[y] << x
  memo
end

folds.each do |axis, coord|
  if axis == 'x'
    paper = foldx(paper, coord)
  elsif axis == 'y'
    paper = foldy(paper, coord)
  end
end

max_y = paper.keys.max
max_x = paper.values.flatten.max 

code = Array.new(max_y+1){ Array.new(max_x+1, '.') }

paper.each do |y, row|
  row.each do |x|
    code[y][x] = '#'
  end
end

puts code.map{ |row| row.join }
