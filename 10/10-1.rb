#!/usr/bin/env ruby

PAIRS = {
  '(' => ')',
  '[' => ']',
  '{' => '}',
  '<' => '>'
}

SCORES = {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25137
}

def opener?(char)
  PAIRS.key? char
end

def closer?(char)
  PAIRS.value? char
end

def corrupted?(row)
  stack = []
  row.each do |char|
    if opener?(char)
      stack.push(char)
    else
      return char if (PAIRS[stack.pop] != char)
    end
  end
  nil
end

input_rows = $stdin.readlines.map{ |r| r.chomp.chars }

corrupted = input_rows.map { |r| corrupted? r }.compact

puts corrupted.map{ |c| SCORES[c] }.reduce(:+)
