#!/usr/bin/env ruby

require 'rgl/adjacency'
require 'rgl/dijkstra'

def bump_tile(tile)
  tile.map do |row|
    row.map { |entry| [(entry + 1) % 10, 1].max }
  end
end

tile = $stdin.readlines.map{|row| row.chomp.chars.map(&:to_i) }

row = [tile]
4.times do
  row << bump_tile(row.last)
end

grid = [row]
4.times do
  grid << grid.last.map { |tile| bump_tile(tile) }
end

input = grid.map do |row|
  super_rows = row.reduce(&:zip).map(&:flatten)
end.reduce(:+)

graph = RGL::DirectedAdjacencyGraph.new
edge_weights_map = Hash.new

(0...input.size).each do |y|
  (0...input.first.size).each do |x|
    min_x = [0, x-1].max 
    min_y = [0, y-1].max 
    max_x = [input.first.size-1, x+1].min
    max_y = [input.size-1, y+1].min

    ([[min_x, y], [max_x, y], [x, min_y], [x, max_y]].uniq - [[x,y]]).each do |(x2,y2)|
      graph.add_edge([x,y], [x2, y2])
      edge_weights_map[[[x,y], [x2, y2]]] = input[y2][x2]
    end
  end
end

shortest_path = graph.dijkstra_shortest_path(edge_weights_map, [0,0], [input.first.size-1,input.size-1])

puts shortest_path.each_cons(2).map{ |c1, c2| edge_weights_map[[c1, c2]] }.reduce(:+)
