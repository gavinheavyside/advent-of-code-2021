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

counts = Hash.new(0)
template.each_cons(2) { |a, b| counts[[a,b]] += 1 }

40.times do
  counts.dup.each do |key, count|
    mid = rules[key]
    counts[[key.first, mid]] += count
    counts[[mid, key.last]] += count
    counts[key] -= count
  end
end

single_counts = Hash.new(0)
counts.each do |(a, b), value|
  single_counts[b] += value
end
single_counts[template.first] += 1

puts single_counts.values.max - single_counts.values.min
