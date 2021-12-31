#!/usr/bin/ruby -w

lines = File.readlines('input/08_input.txt')

input = lines.collect { |s| s.strip }
						 .collect do |line|
							 {
								 :patterns => line.split(/\|/).first.strip.split(/\s+/).collect {|s| s.split(//).sort.join('') },
								 :output   => line.split(/\|/).last.strip.split(/\s+/).collect {|s| s.split(//).sort.join('') }
							 }
						 end

resultA = 0
resultB = 0

input.each do |line|
	signals = []
	signals[1] = line[:patterns].select { |s| s.length == 2 }.first 
	signals[4] = line[:patterns].select { |s| s.length == 4 }.first
	signals[7] = line[:patterns].select { |s| s.length == 3 }.first
	signals[8] = line[:patterns].select { |s| s.length == 7 }.first

	segments = line[:patterns].select { |s| s.length == 6 }
	signals[6] = segments.select { |s| s.split(//).intersection(signals[1].split(//)).count == 1 }.first
	segments.delete(signals[6])
	signals[0] = segments.select { |s| s.split(//).intersection(signals[4].split(//)).count == 3 }.first
	segments.delete(signals[0])
	signals[9] = segments.first

	segments = line[:patterns].select { |s| s.length == 5 }
	signals[3] = segments.select { |s| s.split(//).intersection(signals[1].split(//)).count == 2 }.first
	segments.delete(signals[3])
	signals[2] = segments.select { |s| s.split(//).intersection(signals[4].split(//)).count == 2 }.first
	segments.delete(signals[2])
	signals[5] = segments.first

	resultA += line[:output].select { |s| s == signals[1] }.count
	resultA += line[:output].select { |s| s == signals[4] }.count
	resultA += line[:output].select { |s| s == signals[7] }.count
	resultA += line[:output].select { |s| s == signals[8] }.count

	resultB += line[:output].collect { |s| signals.index(s)}.join('').to_i
end

puts "A: #{resultA}"
puts "B: #{resultB}"

