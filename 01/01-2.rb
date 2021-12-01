#!/usr/bin/env ruby

input = $stdin.readlines.map{ |row| Integer(row.chomp) }

threewise = input.each_cons(3).map { |a,b,c| a+b+c }

puts threewise.each_cons(2).filter { |a,b| b > a }.size
