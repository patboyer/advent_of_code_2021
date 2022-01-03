#!/usr/bin/ruby -w

require 'pp'
require 'pry'

def find_pathA(caves, cave, path)
	newpath = path.clone 

	if cave == 'end'
		return 1
	elsif (not path.include?(cave)) or (cave == cave.upcase)
		newpath << cave
		return caves[cave].collect { |c| find_pathA(caves, c, newpath) }.sum
	else 
		return 0
	end
end

def find_pathB(caves, cave, path)
	newpath = path.clone 

	if cave == 'start' and path.include?('start')
		return 0
	elsif cave == 'end'
		return 1
	elsif cave == cave.upcase
		newpath << cave
		return caves[cave].collect { |c| find_pathB(caves, c, newpath) }.sum
	else
		newpath << cave 
		repeated_caves = newpath.select { |c| c == c.downcase }.tally 
	  
		if repeated_caves.select { |k, v| v > 2 }.count > 0
		  return 0
		elsif repeated_caves.select { |k, v| v == 2 }.count < 2
			return caves[cave].collect { |c| find_pathB(caves, c, newpath) }.sum
		else
			return 0
		end
	end
end

input = File.readlines('input/12_input.txt').collect { |line| line.strip }

caves = Hash.new([])

input.collect { |line| line.split(/-/) }.each do |k, v|
	caves[k] = (caves.has_key?(k)) ? caves[k].concat([ v ]).uniq : [ v ]
	caves[v] = (caves.has_key?(v)) ? caves[v].concat([ k ]).uniq : [ k ]
end

puts "A: #{find_pathA(caves, 'start', [])}"
puts "B: #{find_pathB(caves, 'start', [])}"
