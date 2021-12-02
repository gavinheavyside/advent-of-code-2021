#!/usr/bin/env ruby

input = $stdin.readlines.map{ |row| row.chomp.split }

MAPPING = {
  "forward" => [:x, 1],
  "up"      => [:aim, -1],
  "down"    => [:aim, 1]
}

travel = input.reduce({x: 0, y: 0, aim: 0}) do |memo, (direction, distance)|
  mapping = MAPPING[direction]

  memo[mapping.first] += mapping.last * Integer(distance)

  memo[:y] += memo[:aim] * Integer(distance) if mapping.first == :x

  memo
end

puts travel[:x] * travel[:y]
