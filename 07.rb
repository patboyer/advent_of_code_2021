#!/usr/bin/ruby -w

def calculate_fuelA(input, pos)
  input.collect { |i| (i - pos).abs }.sum
end

def calculate_fuelB(input, pos)
  input.collect { |i| 1.upto((i - pos).abs).to_a.sum }.sum
end

def find_pos(f, input)
	guess = (input.sum / input.count).floor
	found = false
	mid   = 0

	while (not found)
		left  = method(f).call(input, guess - 1)
		mid   = method(f).call(input, guess)
		right = method(f).call(input, guess + 1)

		if left < mid 
			guess -= 1
		elsif right < mid
			guess += 1
		else 
			found = true 
		end
	end

	mid
end

input = File.read('input/07_input.txt').strip.split(',').collect { |s| s.to_i }
puts "A: #{find_pos(:calculate_fuelA, input)}"
puts "B: #{find_pos(:calculate_fuelB, input)}"
