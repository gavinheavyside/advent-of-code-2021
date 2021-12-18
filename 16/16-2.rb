#!/usr/bin/env ruby

def literal?(type_id)
  type_id == 4
end

def decode_literal(input)
end

def decode_packet(input)
  # puts 
  # puts "decoding packet: #{input.join} length #{input.size}"

  version = input.shift(3).join.to_i(2)
  type_id = input.shift(3).join.to_i(2)

  # puts "version: #{version}"
  # puts "type_id: #{type_id}"

  if literal? type_id
    message = []
    while input.shift == '1'
      message.append(*input.shift(4))
    end
    message.append(*input.shift(4))

    # puts "literal: #{message.join.to_i(2)}"
    [version, message.join.to_i(2), input]

  else # operator
    results = []
    versions = [version]

    if input.shift == '0'
      packet_length = input.shift(15).join.to_i(2)

      contents = input.shift(packet_length)
      until contents.empty?
        sub_version, sub_result, contents = decode_packet(contents)
        results << sub_result
        versions << sub_version
      end
    else
      packet_count = input.shift(11).join.to_i(2)

      packet_count.times do
        sub_version, sub_result, input = decode_packet(input)
        results << sub_result
        versions << sub_version
      end
    end

    result = case type_id
             when 0
               results.sum
             when 1
               results.reduce(&:*)
             when 2
               results.min
             when 3
               results.max
             when 5
               results.reduce(&:>) ? 1 : 0
             when 6
               results.reduce(&:<) ? 1 : 0
             when 7
               results.reduce(&:==) ? 1 : 0
             end

    [versions.reduce(:+), result, input]
  end
end

input = gets.chomp.chars.map{ |c| format('%04b', c.hex).chars }.flatten

result = decode_packet(input)

puts result.inspect
puts result.first

