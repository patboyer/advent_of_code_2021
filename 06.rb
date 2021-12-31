#!/usr/bin/ruby -w

input = File.read('input/06_input.txt').strip.split(',').collect { |s| s.to_i }

GROWTH_PERIOD   = 2
GESTATION_START = 6
MAX_DAY_A       = 80
MAX_DAY_B       = 256

fish = Array.new(GESTATION_START + GROWTH_PERIOD + 1, 0)
input.each { |idx| fish[idx] += 1 }

day = 1
while day <= MAX_DAY_B
	new_fish = fish.shift
	fish[GESTATION_START + GROWTH_PERIOD] = new_fish
	fish[GESTATION_START] += new_fish
  puts "A: #{fish.sum}" if day == MAX_DAY_A
	day += 1
end

puts "B: #{fish.sum}" 

