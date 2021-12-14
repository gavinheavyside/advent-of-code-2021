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

puts template.inspect
puts rules.inspect

10.times do
  polymer = template.take(1)

  template.each_cons(2) do |a, b|
    polymer << rules[[a, b]]
    polymer << b
  end

#  puts polymer.join
  template = polymer
end

counts = template.tally

puts counts.values.max - counts.values.min
