#!/usr/bin/ruby -w

require 'pry'

lines = File.readlines('input/10_input.txt')
input = lines.collect { |line| line.strip }

matches = {
	'(' => ')',
	'[' => ']',
	'{' => '}',
	'<' => '>',
}

mistake_points = {
	')' => 3,
	']' => 57,
	'}' => 1197,
	'>' => 25137,
}

fix_points = {
	'(' => 1,
	'[' => 2,
	'{' => 3,
	'<' => 4,
}

scoreA = 0
scores = []

# find corrupted lines
input.each do |line|
  stack  = []
	errors = []

	line.split(//).each do |c|
		if matches.keys.include?(c)
			stack << c
		else
			v = stack.pop 
			errors << c unless c == matches[v]
		end
	end

	if errors.length > 0
		scoreA += mistake_points[errors.first] 
	else
	  scores << stack.reverse.collect { |c| fix_points[c] }.inject(0) { |r,i| (r* 5) + i}
	end
end

scores.sort!

puts "A: #{scoreA}"
puts "A: #{scores[scores.length / 2]}"
