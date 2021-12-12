#!/usr/bin/env ruby

PAIRS = {
  '(' => ')',
  '[' => ']',
  '{' => '}',
  '<' => '>'
}

COMPLETION_SCORES = {
  ')' => 1,
  ']' => 2,
  '}' => 3,
  '>' => 4
}

def opener?(char)
  PAIRS.key? char
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

def completion(row)
  stack = []
  row.each do |char|
    if opener?(char)
      stack.push(char)
    else
      stack.pop
    end
  end
  stack.reverse.map{ |c| PAIRS[c] }
end

input_rows = $stdin.readlines.map{ |r| r.chomp.chars }

incomplete = input_rows.reject { |r| corrupted? r }.compact

completions = incomplete.map{ |r| completion(r) }

completion_scores = completions.map do |completion|
  completion.map { |c| COMPLETION_SCORES[c] }.reduce(0) do |memo, score|
    score + (memo * 5)
  end
end

puts completion_scores.sort[completion_scores.size/2]
