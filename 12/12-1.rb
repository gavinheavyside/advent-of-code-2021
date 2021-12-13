#!/usr/bin/env ruby

require 'rgl/adjacency'
require 'rgl/path'
require 'rgl/dijkstra'

graph = RGL::DirectedAdjacencyGraph.new

$stdin.readlines.each do |line|
  from, to = line.chomp.split('-')
  graph.add_edge(from, to)
  if !(from == 'start' || to == 'end')
    graph.add_edge(to, from)
  end
end

puts graph.to_s

def explore_from(graph, root, paths, path, visited)
  path << root
  if root == 'end'
    paths << path
    return
  end
  visited << root if root =~ /[a-z]/

  graph.adjacent_vertices(root).each do |v|
    explore_from(graph, v, paths, path.dup, visited.dup) unless visited.include? v
  end
end

paths = []
path = []
visited = []

explore_from(graph, 'start', paths, path, visited)

#puts paths.inspect
puts paths.size
