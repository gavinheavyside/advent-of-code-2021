#!/usr/bin/env ruby

timers = Hash.new{ |k,v| k[v] = 0 }

$stdin.read.chomp.split(',').each{ |t| timers[t.to_i] += 1 }

#puts timers.inspect

256.times do |j|
  0.upto(8) do |i|
    timers[i-1] = timers[i]
  end
  timers[6] += timers[-1]
  timers[8]  = timers[-1]

#  puts "tick #{j}"
#  puts timers.inspect
end

puts timers.select{ |k,v| !k.negative? }.map{ |k,v| v}.reduce(:+)
