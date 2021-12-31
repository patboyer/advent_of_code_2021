#!/usr/bin/ruby -w

def navigate(input, include_aim=false)
	forward = depth = aim = depth_with_aim = 0

	input.each do |i|
		direction, n = i[0].strip, i[1].to_i

		case
		when direction == 'forward' then forward += n; depth_with_aim += aim * n
		when direction == 'up'      then depth   -= n; aim -= n
		when direction == 'down'    then depth   += n; aim += n
		end
	end

	return (include_aim) ? (forward * depth_with_aim) : (forward * depth)
end

input = File.readlines('input/02_input.txt').collect { |s| s.strip.split(/\s+/) }

puts "A: #{navigate(input)}"
puts "B: #{navigate(input, include_aim=true)}"
