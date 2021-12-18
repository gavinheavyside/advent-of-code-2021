#!/usr/bin/env ruby

def literal?(type_id)
  type_id == 4
end

def decode_literal(input)
  # puts "decoding #{input}"
  numbers = []
  read = 0
  input.chars.each_slice(5) do |slice|
    read += 5
    numbers += slice[1..4] if slice.size == 5
    break if slice[0] == '0'
  end
  { value: numbers.join.to_i(2), read: read, remainder: input[read..-1] }
end

def decode_bit_length(input)
  input.to_i(2)
end

def decode_packet(input)
  puts "decoding packet: #{input}"

  version = input[0..2].to_i(2)
  type_id = input[3..5].to_i(2)

  puts "version: #{version}"
  puts "type_id: #{type_id}"

  result = nil
  if literal? type_id
    result = decode_literal(input[6..-1])
  else
    # operator
    length_type = input[6]
    if length_type == '0'
      length_sub_packets = decode_bit_length(input[7..21])
      puts "operator; total sub-packets length: #{length_sub_packets}"

      processed = 0
      results = []
      to_process = input[21..21+length_sub_packets]
      while processed < length_sub_packets
        results << decode_packet(to_process)
        processed += results.last[:read]
      end
    else
      num_sub_packets = decode_bit_length(input[7..17])
      puts "operator; number of sub-packets: #{num_sub_packets}"
    end
  end
  puts
  result
end

input = gets.chomp.chars.map{ |c| sprintf("%04b", c.to_i(16)) }.join

result = decode_packet(input)

puts result.inspect 

