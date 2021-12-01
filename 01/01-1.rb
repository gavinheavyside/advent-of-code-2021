#!/usr/bin/env ruby

input = $stdin.readlines.map{ |row| Integer(row.chomp) }

puts input.each_cons(2).filter { |a,b| b > a }.size
