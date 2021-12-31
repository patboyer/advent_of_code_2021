#!/usr/bin/ruby -w

def find_inc(input)
	last = 999999999999999999999

	result = input.inject(0) do |num_inc, i| 
		n = (i > last) ? 1 : 0
		last = i 
		num_inc + n 
	end
end

input = File.readlines('input/01_input.txt').collect { |s| s.to_i }
puts "A: #{find_inc(input)}"

sums = (2..input.length-1).to_a.collect { |i| [ input[i], input[i-1], input[i-2] ].sum }
puts "B: #{find_inc(sums)}"
