#!/usr/bin/ruby -w


input = File.readlines('input/03_input.txt').collect { |s| s.strip }

max_idx = input[0].length - 1
result = (0..max_idx).to_a.collect do |i|
  n = input.collect {|line| line[i] }.filter {|b| b == '1'}.count
	(n >= input.length / 2) ? '1' : '0'
end

result  = result.join('')
gamma   = result.to_i(2)
epsilon = gamma ^ (1 << result.length) - 1

puts "A: #{gamma * epsilon}"

idx = 0
arr = input

while arr.count > 1 
	n = arr.collect {|line| line[idx] }.filter {|b| b == '1'}.count
	freq_bit = (n >= arr.length.to_f / 2) ? '1' : '0'
	arr = arr.filter { |line| line[idx] == freq_bit }
	idx += 1
end

o2_rating = arr.first.to_i(2)

idx = 0
arr = input

while arr.count > 1 
	n = arr.collect {|line| line[idx] }.filter {|b| b == '1'}.count
	freq_bit = (n < arr.length.to_f / 2) ? '1' : '0'
	arr = arr.filter { |line| line[idx] == freq_bit }
	idx += 1
end

co2_rating = arr.first.to_i(2)

puts "B: #{o2_rating * co2_rating}"
