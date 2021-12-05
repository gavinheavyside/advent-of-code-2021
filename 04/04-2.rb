#!/usr/bin/env ruby

class BingoCard
  def initialize(numbers)
    @numbers = numbers
    @last_call = -1
    @won = false
  end

  def call(called_number)
    return if @won

    @last_call = called_number
    @numbers.each do |row|
      row.each_with_index do |number, i|
        if number == called_number
          row[i] = -1
          @won = true if check_for_win
          return @won
        end
      end
    end
    nil
  end

  def check_for_win
    (@numbers + @numbers.transpose).detect do
      |line| line.all?(&:negative?)
    end
  end

  def score
    @numbers.flatten.reject(&:negative?).reduce(:+) * @last_call
  end

  def to_s
    @numbers.inspect
  end
end

input  = $stdin.readlines.map(&:chomp)
dirty_groups = input.chunk_while { |row| !row.empty? }

groups = dirty_groups.map { |group| group.reject { |row| row.empty? } }

number_calls = groups.first.first.split(',').map(&:to_i)

tables = groups.drop(1).map do |group|
  BingoCard.new(group.map { |row| row.chomp.split.map(&:to_i) })
end

found = 0

number_calls.each do |call|
  tables.each do |table|
    if table.call(call)
      found += 1
      if found == tables.size
        p table.score
        break
      end
    end
  end
  break if found == tables.size
end

