#!/usr/bin/env ruby

template = ''
rules = {}

while line = gets
  if line =~ /^([A-Z]+)$/
    template = $1.chars
  elsif line =~ /^([A-Z]{2}) -> ([A-Z])$/
    rules[$1.chars] = $2
  end
end

pair_counts = template.each_cons(2).reduce(Hash.new(0)) do |memo, key|
  memo[key] += 1
  memo
end

40.times do
  pair_counts.dup.each do |key, count|
    mid = rules[key]
    pair_counts[[key.first, mid]] += count
    pair_counts[[mid, key.last]] += count
    pair_counts[key] -= count
  end
end

single_counts = pair_counts.reduce(Hash.new(0)) do |memo, ((a,b), value)|
  memo[b] += value
  memo
end

single_counts[template.first] += 1

puts single_counts.values.max - single_counts.values.min
