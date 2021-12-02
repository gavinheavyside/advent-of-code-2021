#!/usr/bin/env ruby

input = $stdin.readlines.map{ |row| row.chomp.split }

mapping = {
  "forward" => [:x, 1],
  "up"      => [:y, -1],
  "down"    => [:y, 1]
}

travel = input.reduce({x: 0, y:0}) do |memo, (direction, distance)|
  memo[mapping[direction].first] += mapping[direction].last * Integer(distance)
  memo
end

puts travel[:x] * travel[:y]
